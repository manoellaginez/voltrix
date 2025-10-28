import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:voltrix/theme/theme_notifier.dart';

// ================== CONFIG BACKEND ==================
// Pode sobrescrever em build/run com --dart-define=BACKEND_BASE_URL=...
const String kBackendBaseUrlEnv =
    String.fromEnvironment('BACKEND_BASE_URL', defaultValue: 'http://127.0.0.1:8000');

class AssistentePage extends StatefulWidget {
  const AssistentePage({super.key});

  @override
  State<AssistentePage> createState() => _AssistentePageState();
}

class _AssistentePageState extends State<AssistentePage> {
  final Color primaryColor = const Color(0xFFE53935);

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  bool _isSending = false;
  bool _isLoadingDevices = false;

  // Devices
  List<_Device> _devices = const [];
  String? _selectedDeviceId; // id string (ex: "1")

  // Base URL
  late final String _baseUrl;

  // Chat messages
  List<Map<String, dynamic>> messages = [
    {
      'id': 1,
      'text':
          'Olá! Sou a assistente da Voltrix. Como posso te ajudar a otimizar o consumo de energia hoje?',
      'sender': 'bot',
      'time': '16:03'
    },
  ];

  final List<Map<String, dynamic>> suggestions = [
    {'icon': FeatherIcons.zap, 'title': 'Reduzir consumo', 'text': 'Como posso economizar energia?'},
    {'icon': FeatherIcons.thermometer, 'title': 'Status dos dispositivos', 'text': 'Quais dispositivos estão ligados?'},
    {'icon': FeatherIcons.clock, 'title': 'Melhor horário', 'text': 'Quando usar mais energia?'},
    {'icon': FeatherIcons.activity, 'title': 'Dicas personalizadas', 'text': 'Sugestões para minha casa'},
  ];

  @override
  void initState() {
    super.initState();
    _baseUrl = _resolveBaseUrl(kBackendBaseUrlEnv);
    _fetchDevices(); // carrega devices ao abrir
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // ================= Helpers de URL / tempo =================
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

  Uri _buildUri(String path, [Map<String, String>? query]) {
    final hasScheme = _baseUrl.startsWith('http://') || _baseUrl.startsWith('https://');
    final base = hasScheme ? _baseUrl : 'http://$_baseUrl';
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$cleanPath').replace(queryParameters: query);
  }

  String _nowHHmm() {
    final now = TimeOfDay.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  // =================== Dispositivos ===================
  Future<void> _fetchDevices() async {
    setState(() => _isLoadingDevices = true);
    try {
      final uri = _buildUri('/devices');
      Future<http.Response> doGet() => http.get(uri).timeout(const Duration(seconds: 20));

      http.Response resp = await doGet();
      if (resp.statusCode == 502 || resp.statusCode == 504 || resp.statusCode == 408) {
        await Future.delayed(const Duration(milliseconds: 250));
        resp = await doGet();
      }

      if (resp.statusCode == 200) {
        final list = jsonDecode(resp.body);
        if (list is List) {
          final devices = list
              .map((e) => _Device(
                    id: (e['id'] ?? '').toString(),
                    title: (e['title'] ?? '').toString(),
                    ip: (e['ip'] ?? '').toString(),
                  ))
              .toList()
              .cast<_Device>();
          setState(() {
            _devices = devices;
            // seleciona o primeiro se nada escolhido
            _selectedDeviceId ??= devices.isNotEmpty ? devices.first.id : null;
          });
        } else {
          _showSnack('Resposta inválida de /devices');
        }
      } else {
        String detail = '';
        try {
          final m = jsonDecode(resp.body);
          if (m is Map && m['detail'] != null) detail = ' (${m['detail']})';
        } catch (_) {}
        _showSnack('Falha ao buscar dispositivos (HTTP ${resp.statusCode})$detail');
      }
    } on TimeoutException {
      _showSnack('Tempo esgotado ao buscar dispositivos.');
    } on SocketException {
      _showSnack('Sem conexão com o servidor ao buscar dispositivos.');
    } catch (e) {
      _showSnack('Erro ao buscar dispositivos: $e');
    } finally {
      if (mounted) setState(() => _isLoadingDevices = false);
    }
  }

  Future<void> _fetchAndShowEnergySnapshot() async {
    final deviceId = _selectedDeviceId ?? (_devices.isNotEmpty ? _devices.first.id : null);
    if (deviceId == null) {
      _showSnack('Nenhum dispositivo selecionado.');
      return;
    }

    try {
      final uri = _buildUri('/devices/$deviceId/energy');
      Future<http.Response> doGet() => http.get(uri).timeout(const Duration(seconds: 20));

      http.Response resp = await doGet();
      if (resp.statusCode == 502 || resp.statusCode == 504 || resp.statusCode == 408) {
        await Future.delayed(const Duration(milliseconds: 250));
        resp = await doGet();
      }

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        final w = (data['w_instantaneo'] ?? 0).toString();
        final d = (data['kwh_hoje'] ?? 0).toString();
        final m = (data['kwh_mes'] ?? 0).toString();
        final lg = data['ligado'];
        final title = data['title'] ?? 'dispositivo';

        final text =
            'STATUS[$title]: ${w} W agora | Hoje: ${d} kWh | Mês: ${m} kWh | Ligado: $lg';

        // empurra como “mensagem do bot”
        setState(() {
          messages.add({
            'id': messages.length + 1,
            'text': text,
            'sender': 'bot',
            'time': _nowHHmm(),
          });
        });
        _scrollToEnd();
      } else {
        String detail = '';
        try {
          final m = jsonDecode(resp.body);
          if (m is Map && m['detail'] != null) detail = ' (${m['detail']})';
        } catch (_) {}
        _showSnack('Falha ao ler energia (HTTP ${resp.statusCode})$detail');
      }
    } on TimeoutException {
      _showSnack('Tempo esgotado ao consultar energia.');
    } on SocketException {
      _showSnack('Sem conexão com o servidor ao consultar energia.');
    } catch (e) {
      _showSnack('Erro ao consultar energia: $e');
    }
  }

  // ======================= Chat =======================
  Future<String> _askBackend(String text, {String? dispositivoId}) async {
    final uri = _buildUri('/chat/once');
    final body = <String, dynamic>{
      'message': text,
      if (dispositivoId != null && dispositivoId.isNotEmpty) 'dispositivo_id': dispositivoId,
      'temperature': 0.6,
      'top_p': 0.95,
      'top_k': 40,
      'max_output_tokens': 768, // um pouco maior, evita MAX_TOKENS
    };

    Future<http.Response> doPost() => http
        .post(
          uri,
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 35));

    try {
      http.Response resp = await doPost();

      // retry rápido em erros transitórios
      if (resp.statusCode == 502 || resp.statusCode == 504 || resp.statusCode == 408) {
        await Future.delayed(const Duration(milliseconds: 300));
        resp = await doPost();
      }

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        return (data['output'] ?? '').toString().trim();
      } else {
        String serverDetail = '';
        try {
          final m = jsonDecode(resp.body);
          if (m is Map && m['detail'] != null) {
            serverDetail = ' Detalhe: ${m['detail']}';
          }
        } catch (_) {}
        debugPrint('HTTP ${resp.statusCode} => ${resp.body}');
        return 'Tive um problema ao consultar o servidor (HTTP ${resp.statusCode}).$serverDetail';
      }
    } on SocketException {
      return 'Sem conexão com o servidor. Verifique sua rede e tente novamente.';
    } on HttpException {
      return 'Erro de comunicação com o servidor. Tente novamente.';
    } on FormatException {
      return 'Resposta inesperada do servidor.';
    } on TimeoutException {
      return 'O servidor demorou para responder. Tente novamente.';
    } catch (e) {
      debugPrint('Erro inesperado: $e');
      return 'Erro inesperado: $e';
    }
  }

  Future<void> _sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isSending) return;

    final time = _nowHHmm();

    setState(() {
      messages.add({'id': messages.length + 1, 'text': trimmed, 'sender': 'user', 'time': time});
      _messageController.clear();
      _isSending = true;
    });
    _scrollToEnd();

    setState(() {
      messages.add({'id': messages.length + 1, 'text': 'digitando…', 'sender': 'typing', 'time': time});
    });
    _scrollToEnd();

    final botText = await _askBackend(trimmed, dispositivoId: _selectedDeviceId);

    if (!mounted) return;
    setState(() {
      final idx = messages.indexWhere((m) => m['sender'] == 'typing');
      if (idx != -1) messages.removeAt(idx);

      messages.add({
        'id': messages.length + 1,
        'text': botText.isEmpty ? 'Não consegui gerar uma resposta agora. Por favor, tente novamente.' : botText,
        'sender': 'bot',
        'time': _nowHHmm(),
      });
      _isSending = false;
    });
    _scrollToEnd();

    if (botText.startsWith('Tive um problema') ||
        botText.startsWith('Sem conexão') ||
        botText.startsWith('Erro de comunicação') ||
        botText.startsWith('Resposta inesperada') ||
        botText.startsWith('O servidor demorou') ||
        botText.startsWith('Erro inesperado')) {
      _showSnack(botText);
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Map<String, Color> getThemeStyles(bool isDarkMode) {
    return {
      'textColor': isDarkMode ? Colors.white : Colors.black87,
      'secondaryTextColor': isDarkMode ? Colors.white70 : Colors.grey.shade600,
      'cardBackground': isDarkMode ? const Color(0xFF2C2C2E) : Colors.white,
    };
  }

  // ===================== UI ======================
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    final colors = getThemeStyles(isDarkMode);

    final textColor = colors['textColor']!;
    final secondaryTextColor = colors['secondaryTextColor']!;
    final cardBackground = colors['cardBackground']!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(gradient: themeNotifier.currentGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Cabeçalho com seleção de device
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Assistente Voltrix',
                              style: TextStyle(color: primaryColor, fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text('Sua consultora de energia inteligente',
                              style: TextStyle(color: secondaryTextColor, fontSize: 14)),
                        ],
                      ),
                    ),
                    // Dropdown de dispositivos
                    SizedBox(
                      width: 180,
                      child: _isLoadingDevices
                          ? const Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)))
                          : DropdownButtonFormField<String>(
                              value: _selectedDeviceId,
                              isDense: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                filled: true,
                                fillColor: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              hint: const Text('Dispositivo'),
                              items: _devices
                                  .map((d) => DropdownMenuItem<String>(
                                        value: d.id,
                                        child: Text(d.title.isNotEmpty ? d.title : 'ID ${d.id} (${d.ip})', overflow: TextOverflow.ellipsis),
                                      ))
                                  .toList(),
                              onChanged: (v) => setState(() => _selectedDeviceId = v),
                            ),
                    ),
                    const SizedBox(width: 8),
                    // Refresh devices
                    IconButton(
                      tooltip: 'Atualizar dispositivos',
                      onPressed: _isLoadingDevices ? null : _fetchDevices,
                      icon: const Icon(FeatherIcons.refreshCcw),
                      color: primaryColor,
                    ),
                    // Snapshot energia
                    IconButton(
                      tooltip: 'Ler status (energia)',
                      onPressed: _fetchAndShowEnergySnapshot,
                      icon: const Icon(FeatherIcons.activity),
                      color: primaryColor,
                    ),
                  ],
                ),
              ),

              // Chat
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final bool isUser = msg['sender'] == 'user';
                    final bool isTyping = msg['sender'] == 'typing';

                    if (isTyping) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          constraints: const BoxConstraints(maxWidth: 300),
                          decoration: BoxDecoration(
                            color: cardBackground,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(2),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            _TypingDots(color: secondaryTextColor),
                          ]),
                        ),
                      );
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        constraints: const BoxConstraints(maxWidth: 300),
                        decoration: BoxDecoration(
                          color: isUser ? primaryColor : cardBackground,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(isUser ? 15 : 2),
                            topRight: Radius.circular(isUser ? 2 : 15),
                            bottomLeft: const Radius.circular(15),
                            bottomRight: const Radius.circular(15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              (msg['text'] ?? '').toString(),
                              style: TextStyle(color: isUser ? Colors.white : textColor, fontSize: 15, height: 1.4),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              (msg['time'] ?? '').toString(),
                              style: TextStyle(
                                color: isUser ? Colors.white.withOpacity(0.7) : secondaryTextColor,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Sugestões (antes do primeiro envio)
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _messageController,
                builder: (context, value, child) {
                  if (value.text.isNotEmpty) return const SizedBox.shrink();
                  if (messages.any((m) => m['sender'] == 'user')) return const SizedBox.shrink();

                  final cardBackground = getThemeStyles(Provider.of<ThemeNotifier>(context).isDarkMode)['cardBackground']!;
                  final secondaryTextColor = getThemeStyles(Provider.of<ThemeNotifier>(context).isDarkMode)['secondaryTextColor']!;
                  final textColor = getThemeStyles(Provider.of<ThemeNotifier>(context).isDarkMode)['textColor']!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text('Sugestões:', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: suggestions.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.8,
                          ),
                          itemBuilder: (context, index) {
                            final s = suggestions[index];
                            return GestureDetector(
                              onTap: () => _sendMessage(s['text']),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cardBackground,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(s['icon'], color: primaryColor, size: 20),
                                    const SizedBox(height: 4),
                                    Text(s['title'], style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 2),
                                    Text(s['text'], style: TextStyle(color: secondaryTextColor, fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  );
                },
              ),

              // Campo de mensagem
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: cardBackground,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        enabled: !_isSending,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: 'Digite sua pergunta sobre energia...',
                          hintStyle: TextStyle(color: secondaryTextColor),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                          filled: true,
                          fillColor: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey.shade200,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide(color: primaryColor, width: 1.5)),
                          isDense: true,
                        ),
                        onSubmitted: _sendMessage,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _isSending ? null : () => _sendMessage(_messageController.text),
                      child: Opacity(
                        opacity: _isSending ? 0.6 : 1.0,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
                          ),
                          child: const Icon(FeatherIcons.send, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============== Models simples ==============
class _Device {
  final String id;
  final String title;
  final String ip;
  const _Device({required this.id, required this.title, required this.ip});
}

// =========== Indicador “digitando…” ==========
class _TypingDots extends StatefulWidget {
  final Color color;
  const _TypingDots({required this.color});

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
    _a = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _a,
      builder: (_, __) {
        final v = (_a.value * 3).floor(); // 0,1,2
        final dots = '.' * (v + 1);
        return Text('digitando$dots', style: TextStyle(color: widget.color));
      },
    );
  }
}
