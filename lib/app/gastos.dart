import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:voltrix/theme/theme_notifier.dart';
import 'package:voltrix/theme/app_gradients.dart';

// ================== CONFIG ==================
// Pode sobrescrever em build/run:
// --dart-define=BACKEND_BASE_URL=http://10.0.0.12:8000
// --dart-define=KWH_PRICE=0.95
const String kBackendBaseUrlEnv =
    String.fromEnvironment('BACKEND_BASE_URL', defaultValue: 'http://127.0.0.1:8000');
const double kDefaultKwhPrice = 0.95;

// ============================================

class GastosPage extends StatefulWidget {
  const GastosPage({super.key});

  @override
  State<GastosPage> createState() => _GastosPageState();
}

class _GastosPageState extends State<GastosPage> {
  String activeFilter = 'Hoje';

  late final String _baseUrl;
  double _kwhPrice = kDefaultKwhPrice;

  bool _loadingDevices = false;
  bool _loadingEnergy = false;

  List<_Device> _devices = const [];
  String? _selectedDeviceId;

  EnergySnapshot? _snap;
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();
    _baseUrl = _resolveBaseUrl(kBackendBaseUrlEnv);
    _kwhPrice = kDefaultKwhPrice;
    _fetchDevices().then((_) {
      if (_selectedDeviceId != null) {
        _fetchEnergy();
      }
      // Auto-refresh a cada 30s
      _autoTimer = Timer.periodic(const Duration(seconds: 30), (_) => _fetchEnergy());
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    super.dispose();
  }

  // =============== Helpers de URL ===============
  String _resolveBaseUrl(String raw) {
    String url = raw.trim();
    if (url.endsWith('/')) url = url.substring(0, url.length - 1);
    if (!kIsWeb) {
      try {
        if (Platform.isAndroid && (url.contains('127.0.0.1') || url.contains('localhost'))) {
          url = url.replaceFirst(RegExp(r'127\.0\.0\.1|localhost'), '10.0.2.2');
        }
      } catch (_) {}
    }
    return url;
  }

  Uri _buildUri(String path) {
    final hasScheme = _baseUrl.startsWith('http://') || _baseUrl.startsWith('https://');
    final base = hasScheme ? _baseUrl : 'http://$_baseUrl';
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$cleanPath');
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  String _money(double? v) {
    if (v == null || v.isNaN || v.isInfinite) return 'R\$ 0,00';
    return 'R\$ ${v.toStringAsFixed(2)}';
  }

  String _kwh(double? v, {int digits = 3}) {
    if (v == null || v.isNaN || v.isInfinite) return '0.000';
    return v.toStringAsFixed(digits);
  }

  // =============== Backend calls ===============
  Future<void> _fetchDevices() async {
    setState(() => _loadingDevices = true);
    try {
      final resp = await http.get(_buildUri('/devices')).timeout(const Duration(seconds: 20));
      if (resp.statusCode == 200) {
        final list = jsonDecode(resp.body);
        if (list is List) {
          final ds = list
              .map((e) => _Device(
                    id: (e['id'] ?? '').toString(),
                    title: (e['title'] ?? '').toString(),
                    ip: (e['ip'] ?? '').toString(),
                  ))
              .toList()
              .cast<_Device>();
          setState(() {
            _devices = ds;
            _selectedDeviceId ??= ds.isNotEmpty ? ds.first.id : null;
          });
        } else {
          _toast('Resposta inválida de /devices');
        }
      } else {
        String detail = '';
        try {
          final m = jsonDecode(resp.body);
          if (m is Map && m['detail'] != null) detail = ' (${m['detail']})';
        } catch (_) {}
        _toast('Falha ao buscar dispositivos (HTTP ${resp.statusCode})$detail');
      }
    } on TimeoutException {
      _toast('Tempo esgotado ao buscar dispositivos.');
    } on SocketException {
      _toast('Sem conexão com o servidor ao buscar dispositivos.');
    } catch (e) {
      _toast('Erro ao buscar dispositivos: $e');
    } finally {
      if (mounted) setState(() => _loadingDevices = false);
    }
  }

  Future<void> _fetchEnergy() async {
    final id = _selectedDeviceId;
    if (id == null) return;
    setState(() => _loadingEnergy = true);
    try {
      final resp =
          await http.get(_buildUri('/devices/$id/energy')).timeout(const Duration(seconds: 20));
      if (resp.statusCode == 200) {
        final m = jsonDecode(resp.body);
        setState(() {
          _snap = EnergySnapshot.fromJson(m);
        });
      } else {
        String detail = '';
        try {
          final m = jsonDecode(resp.body);
          if (m is Map && m['detail'] != null) detail = ' (${m['detail']})';
        } catch (_) {}
        _toast('Falha ao ler energia (HTTP ${resp.statusCode})$detail');
      }
    } on TimeoutException {
      _toast('Tempo esgotado ao consultar energia.');
    } on SocketException {
      _toast('Sem conexão com o servidor ao consultar energia.');
    } catch (e) {
      _toast('Erro ao consultar energia: $e');
    } finally {
      if (mounted) setState(() => _loadingEnergy = false);
    }
  }

  // =============== Cálculos de custo/projeção ===============
  double _costFromKwh(double? kwh) => (kwh ?? 0.0) * _kwhPrice;

  ({double costToday, double costMonth, double projMonthCost}) _calcCosts() {
    final kwhHoje = _snap?.kwhHoje ?? 0.0;
    final kwhMes = _snap?.kwhMes ?? 0.0;

    final costToday = _costFromKwh(kwhHoje);
    final costMonth = _costFromKwh(kwhMes);

    // projeção mensal simples: (kwh_mes / diaAtual) * diasNoMes
    final now = DateTime.now();
    final dia = now.day;
    final diasNoMes = DateUtils.getDaysInMonth(now.year, now.month);
    final projKwh = (dia > 0) ? (kwhMes / dia) * diasNoMes : kwhMes;
    final projMonthCost = _costFromKwh(projKwh);

    return (costToday: costToday, costMonth: costMonth, projMonthCost: projMonthCost);
  }

  // =============== UI ===============
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    final colors = getThemeStyles(isDarkMode);

    const primaryColor = kPrimaryRed;
    final textColor = colors['textColor']!;
    final secondaryTextColor = colors['secondaryTextColor']!;
    final cardBackground = colors['cardBackground']!;

    final screenWidth = MediaQuery.of(context).size.width;

    final costs = _calcCosts();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: themeNotifier.currentGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ===================== CABEÇALHO =====================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gastos',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Monitore seus custos de energia',
                            style: TextStyle(fontSize: 17, color: secondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                    // Seletor de Dispositivo + botões
                    SizedBox(
                      width: 210,
                      child: _loadingDevices
                          ? const Center(
                              child: SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2)))
                          : DropdownButtonFormField<String>(
                              value: _selectedDeviceId,
                              isDense: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                filled: true,
                                fillColor:
                                    isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              hint: const Text('Dispositivo'),
                              items: _devices
                                  .map(
                                    (d) => DropdownMenuItem<String>(
                                      value: d.id,
                                      child: Text(
                                        d.title.isNotEmpty ? d.title : 'ID ${d.id} (${d.ip})',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) => setState(() {
                                _selectedDeviceId = v;
                                _fetchEnergy();
                              }),
                            ),
                    ),
                    IconButton(
                      tooltip: 'Atualizar lista',
                      onPressed: _loadingDevices ? null : _fetchDevices,
                      icon: const Icon(Icons.refresh),
                      color: primaryColor,
                    ),
                    IconButton(
                      tooltip: 'Ler energia agora',
                      onPressed: _loadingEnergy ? null : _fetchEnergy,
                      icon: _loadingEnergy
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.bolt),
                      color: primaryColor,
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // ===================== FILTROS =====================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['Hoje', 'Semana', 'Mês'].map((filter) {
                    final bool isActive = activeFilter == filter;
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => activeFilter = filter);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isActive ? primaryColor : cardBackground,
                            foregroundColor: isActive ? Colors.white : secondaryTextColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: isActive ? 3 : 0,
                          ),
                          child: Text(
                            filter.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 25),

                // ===================== CARDS DE RESUMO =====================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ResumoCard(
                      label: 'Custo no mês',
                      value: _money(costs.costMonth),
                      subtext: 'Tarifa: ${_money(_kwhPrice)}/kWh',
                      subtextColor: secondaryTextColor,
                      icon: Icons.calendar_month,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      cardBackground: cardBackground,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 15),
                    _ResumoCard(
                      label: 'Hoje',
                      value: _money(costs.costToday),
                      subtext: 'Consumo: ${_kwh(_snap?.kwhHoje)} kWh',
                      subtextColor: secondaryTextColor,
                      icon: Icons.today,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      cardBackground: cardBackground,
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // ===================== STATUS INSTANTÂNEO =====================
                if (_snap != null)
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.12),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                      border: Border(top: BorderSide(color: primaryColor, width: 3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.power, color: primaryColor, size: 26),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Instantâneo: ${(_snap!.wInstantaneo ?? 0).toStringAsFixed(1)} W  ·  Hoje: ${_kwh(_snap!.kwhHoje)} kWh  ·  Mês: ${_kwh(_snap!.kwhMes)} kWh',
                            style: TextStyle(fontSize: 14, color: textColor),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 25),

                // ===================== GRÁFICO (placeholder) =====================
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.12),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Gastos por hora',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600, color: textColor)),
                          Icon(Icons.filter_list, color: secondaryTextColor),
                        ],
                      ),
                      const SizedBox(height: 15),
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: secondaryTextColor),
                            borderRadius: BorderRadius.circular(8),
                            color: isDarkMode ? Colors.black : Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              'Em breve: série temporal\n(consumo vs hora)\n\nDevice: ${_snap?.title ?? '-'}',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: secondaryTextColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // ===================== CARDS MENORES =====================
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: screenWidth < 600 ? 1 : 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 4.0,
                  children: [
                    _InfoCard(
                      label: 'Projeção mensal',
                      value: _money(costs.projMonthCost),
                      icon: Icons.trending_up,
                      iconColor: Colors.green,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      cardBackground: cardBackground,
                      isDarkMode: isDarkMode,
                    ),
                    _InfoCard(
                      label: 'Tarifa aplicada',
                      value: _money(_kwhPrice) + '/kWh',
                      icon: Icons.monetization_on,
                      iconColor: secondaryTextColor,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      cardBackground: cardBackground,
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // ===================== CARD ASSISTENTE =====================
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.12),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                    border: Border(top: BorderSide(color: primaryColor, width: 4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.smart_toy, color: primaryColor, size: 28),
                          const SizedBox(width: 10),
                          Text(
                            'Fale com a Voltrix Assistente',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Quer um resumo do seu consumo no mês? A Assistente Voltrix lê e explica seus padrões de gastos.',
                        style: TextStyle(fontSize: 14, color: secondaryTextColor),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/assistente');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryRed,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'ACESSAR ASSISTENTE',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===================== MODELOS / WIDGETS =====================

class _Device {
  final String id;
  final String title;
  final String ip;
  const _Device({required this.id, required this.title, required this.ip});
}

class EnergySnapshot {
  final String? deviceId;
  final String? title;
  final String? ip;
  final double? wInstantaneo;
  final double? kwhHoje;
  final double? kwhMes;
  final bool? ligado;

  EnergySnapshot({
    this.deviceId,
    this.title,
    this.ip,
    this.wInstantaneo,
    this.kwhHoje,
    this.kwhMes,
    this.ligado,
  });

  factory EnergySnapshot.fromJson(Map<String, dynamic> m) => EnergySnapshot(
        deviceId: m['device_id']?.toString(),
        title: m['title']?.toString(),
        ip: m['ip']?.toString(),
        wInstantaneo: (m['w_instantaneo'] is num) ? (m['w_instantaneo'] as num).toDouble() : null,
        kwhHoje: (m['kwh_hoje'] is num) ? (m['kwh_hoje'] as num).toDouble() : null,
        kwhMes: (m['kwh_mes'] is num) ? (m['kwh_mes'] as num).toDouble() : null,
        ligado: (m['ligado'] is bool) ? m['ligado'] as bool : null,
      );
}

class _ResumoCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtext;
  final Color subtextColor;
  final IconData icon;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardBackground;
  final bool isDarkMode;

  const _ResumoCard({
    required this.label,
    required this.value,
    required this.subtext,
    required this.subtextColor,
    required this.icon,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardBackground,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 15, color: secondaryTextColor)),
          const SizedBox(height: 1),
          Text(
            value,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 1),
          Row(
            children: [
              Icon(icon, size: 14, color: subtextColor),
              const SizedBox(width: 5),
              Expanded(
                child: Text(subtext, style: TextStyle(fontSize: 14, color: subtextColor)),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardBackground;
  final bool isDarkMode;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardBackground,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: secondaryTextColor)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
              ),
              Icon(icon, size: 20, color: iconColor),
            ],
          )
        ],
      ),
    );
  }
}
