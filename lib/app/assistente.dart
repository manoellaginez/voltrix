import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:voltrix/theme/theme_notifier.dart';
import 'package:voltrix/theme/app_gradients.dart';

class AssistentePage extends StatefulWidget {
  const AssistentePage({super.key});

  @override
  State<AssistentePage> createState() => _AssistentePageState();
}

class _AssistentePageState extends State<AssistentePage> {
  final Color primaryColor = kPrimaryRed;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

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
    {
      'icon': FeatherIcons.zap,
      'title': 'Reduzir consumo',
      'text': 'Como posso economizar energia?'
    },
    {
      'icon': FeatherIcons.thermometer,
      'title': 'Status dos dispositivos',
      'text': 'Quais dispositivos estão ligados?'
    },
    {
      'icon': FeatherIcons.clock,
      'title': 'Melhor horário',
      'text': 'Quando usar mais energia?'
    },
    {
      'icon': FeatherIcons.activity,
      'title': 'Dicas personalizadas',
      'text': 'Sugestões para minha casa'
    },
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final now = TimeOfDay.now();
    final formattedTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      messages.add({
        'id': messages.length + 1,
        'text': text,
        'sender': 'user',
        'time': formattedTime
      });
      _messageController.clear();
    });


    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          messages.add({
            'id': messages.length + 1,
            'text':
                'Essa é uma excelente pergunta! Vou processar a sua solicitação. (Esta será a área de resposta da IA)',
            'sender': 'bot',
            'time': formattedTime
          });
        });
        _scrollToEnd();
      }
    });

    _scrollToEnd();
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
        decoration: BoxDecoration(
          gradient: themeNotifier.currentGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 🔸 Cabeçalho
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Assistente Voltrix',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Sua consultora de energia inteligente',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 🔸 Chat (ListView)
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final bool isUser = msg['sender'] == 'user';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
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
                          crossAxisAlignment: isUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg['text'],
                              style: TextStyle(
                                color: isUser ? Colors.white : textColor,
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              msg['time'],
                              style: TextStyle(
                                color: isUser
                                    ? Colors.white.withOpacity(0.7)
                                    : secondaryTextColor,
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

             // 🔸 Sugestões
             ListenableBuilder(
                listenable: _messageController,
                builder: (context, child) {
                  if (_messageController.text.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             const SizedBox(height: 10),
                            Text(
                              'Sugestões:',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                             const SizedBox(height: 5),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: suggestions.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                // ========== [CORREÇÃO 1 AQUI] ==========
                                childAspectRatio: 2.0, // Voltado para 2.0
                                // ========== [FIM DA CORREÇÃO 1] ==========
                              ),
                              itemBuilder: (context, index) {
                                final s = suggestions[index];
                                return GestureDetector(
                                  onTap: () => _sendMessage(s['text']),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: cardBackground,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      // ========== [CORREÇÃO 2 AQUI] ==========
                                      // Removido mainAxisAlignment: MainAxisAlignment.spaceBetween
                                      // ========== [FIM DA CORREÇÃO 2] ==========
                                      children: [
                                        Icon(s['icon'], color: primaryColor, size: 20,),
                                        // Adiciona um Spacer para empurrar o texto para baixo se necessário
                                        // Ou simplesmente deixa o espaço natural da Column
                                        const Spacer(), // Opcional, dependendo do visual desejado
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              s['title'],
                                              style: TextStyle(
                                                color: textColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              s['text'],
                                              style: TextStyle(
                                                color: secondaryTextColor,
                                                // ========== [CORREÇÃO 3 AQUI] ==========
                                                fontSize: 11, // Reduzido de 12 para 11
                                                // ========== [FIM DA CORREÇÃO 3] ==========
                                              ),
                                               maxLines: 2,
                                               overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                             const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
             ),


              // 🔸 Campo de mensagem fixo
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: cardBackground,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: 'Digite sua pergunta sobre energia...',
                          hintStyle: TextStyle(color: secondaryTextColor),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          filled: true,
                          fillColor: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25),
                             borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                                color: primaryColor,
                                width: 1.5),
                          ),
                          isDense: true,
                        ),
                        onSubmitted: _sendMessage,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => _sendMessage(_messageController.text),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          FeatherIcons.send,
                          color: Colors.white,
                          size: 20,
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

