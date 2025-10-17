import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voltrix/theme/theme_notifier.dart'; // Import do Notifier
import 'package:voltrix/theme/app_gradients.dart'; // Import das constantes

/// Modelo básico para um dispositivo (inalterado)
class Device {
  final int id;
  final String name;
  final String room;
  final String type;
  bool status;

  Device({
    required this.id,
    required this.name,
    required this.room,
    required this.type,
    this.status = false,
  });
}

/// Simulação de chamada de API (inalterado)
Future<Map<String, dynamic>> fetchEnergia(int dispositivoId) async {
  await Future.delayed(const Duration(seconds: 1));
  return {
    'w_instantaneo': 102.45,
    'kwh_hoje': 1.876,
    'kwh_mes': 35.927,
    'ligado': true,
  };
}

class DetalheDispositivo extends StatefulWidget {
  final List<Device> devices;
  final void Function(int id) onRemoveDevice;
  final void Function(int id) onToggleDevice;
  final int dispositivoId;

  const DetalheDispositivo({
    super.key,
    required this.devices,
    required this.onRemoveDevice,
    required this.onToggleDevice,
    required this.dispositivoId,
  });

  @override
  State<DetalheDispositivo> createState() => _DetalheDispositivoState();
}

class _DetalheDispositivoState extends State<DetalheDispositivo> {
  Map<String, dynamic>? energia;
  bool loadingEnergia = true;
  String? erroEnergia;
  bool showModal = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _loadEnergia();
    timer = Timer.periodic(const Duration(seconds: 5), (_) => _loadEnergia());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _loadEnergia() async {
    try {
      setState(() {
        loadingEnergia = true;
        erroEnergia = null;
      });
      final data = await fetchEnergia(widget.dispositivoId);
      setState(() {
        energia = data;
      });
    } catch (e) {
      setState(() {
        erroEnergia = e.toString();
      });
    } finally {
      setState(() {
        loadingEnergia = false;
      });
    }
  }

  String fmt(dynamic n, [int digits = 3]) {
    if (n == null) return '—';
    final num? numValue = num.tryParse(n.toString());
    if (numValue == null) return '—';
    return numValue.toStringAsFixed(digits);
  }

  @override
  Widget build(BuildContext context) {
    // 1. Acesso ao tema global e cores dinâmicas
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    final colors = getThemeStyles(isDarkMode);

    final textColor = colors['textColor']!;
    final secondaryTextColor = colors['secondaryTextColor']!;
    final cardBackground = colors['cardBackground']!;
    
    final device = widget.devices.firstWhere(
      (d) => d.id == widget.dispositivoId,
      orElse: () => Device(id: -1, name: 'N/A', room: '—', type: '—'),
    );

    if (device.id == -1) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Dispositivo não encontrado.',
              style: TextStyle(color: textColor, fontSize: 18),
            ),
          ),
        ),
      );
    }

    final watts = energia?['w_instantaneo'];
    final kwhHoje = energia?['kwh_hoje'];
    final kwhMes = energia?['kwh_mes'];
    final ligado = energia?['ligado'];

    const primaryColor = kPrimaryRed;
    const lightText = Colors.white;
    final inactiveCardColor = isDarkMode ? colors['borderColor'] : Colors.grey.shade200; // Cor do card quando DESLIGADO
    final modalColor = isDarkMode ? kDarkBackground : Colors.white;

    return Scaffold(
      // 2. Aplicando o Gradiente Dinâmico na raiz
      body: Container(
        decoration: BoxDecoration(
          gradient: themeNotifier.currentGradient,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== TOPO =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new),
                          color: secondaryTextColor, // Cor dinâmica
                        ),
                        IconButton(
                          onPressed: () => setState(() => showModal = true),
                          icon: Icon(Icons.delete, color: primaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ===== TÍTULO =====
                    Text(
                      device.name,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Local: ${device.room} | Tipo: ${device.type}',
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryTextColor, // Cor dinâmica
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ===== CARD STATUS =====
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        // Cor do card: Vermelho Ativo / Cinza/Borda Inativo
                        color: device.status ? primaryColor : inactiveCardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.12),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status',
                                style: TextStyle(
                                  color:
                                      device.status ? lightText : secondaryTextColor, // Cor dinâmica
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                device.status ? 'LIGADO' : 'DESLIGADO',
                                style: TextStyle(
                                  color: device.status ? lightText : textColor, // Cor dinâmica
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (ligado != null)
                                Text(
                                  '(Tapo: ${ligado ? 'Ligado' : 'Desligado'})',
                                  style: TextStyle(
                                    color: device.status ? lightText.withOpacity(0.7) : secondaryTextColor, // Cor dinâmica
                                    fontSize: 14,
                                  ),
                                ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.onToggleDevice(device.id);
                              setState(() {});
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 55,
                              height: 30,
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: device.status
                                    ? Colors.green
                                    : Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: device.status
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ===== CARD CONSUMO (Informações de Uso) =====
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: cardBackground, // Cor de fundo dinâmica
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
                        children: [
                          Text(
                            'Informações de Uso',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: textColor, // Cor dinâmica
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (loadingEnergia)
                            Text(
                              'Carregando telemetria…',
                              style: TextStyle(color: secondaryTextColor), // Cor dinâmica
                            ),
                          if (erroEnergia != null && !loadingEnergia)
                            Text(
                              'Erro: $erroEnergia',
                              style: TextStyle(color: primaryColor),
                            ),
                          if (!loadingEnergia && erroEnergia == null) ...[
                            Text(
                              'Potência agora: ${fmt(watts, 2)} W',
                              style: TextStyle(fontSize: 16, color: textColor), // Cor dinâmica
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Hoje: ${fmt(kwhHoje, 3)} kWh',
                              style: TextStyle(fontSize: 16, color: textColor), // Cor dinâmica
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Mês: ${fmt(kwhMes, 3)} kWh',
                              style: TextStyle(fontSize: 16, color: textColor), // Cor dinâmica
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ===== MODAL (FICA POR CIMA) =====
              if (showModal)
                Container(
                  color: Colors.black54, // Overlay escuro
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: modalColor, // Fundo dinâmico do modal
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Confirmar remoção',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: textColor), // Cor dinâmica
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Tem certeza que deseja remover o dispositivo "${device.name}"?',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: secondaryTextColor), // Cor dinâmica
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    widget.onRemoveDevice(device.id);
                                    setState(() {
                                      showModal = false;
                                    });
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Remover'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      showModal = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Cancelar'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}