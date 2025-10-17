import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:voltrix/theme/theme_notifier.dart'; // Import necessário
import 'package:voltrix/theme/app_gradients.dart'; // Import necessário (para kPrimaryRed e getThemeStyles)

class AssistentePage extends StatefulWidget {
  const AssistentePage({super.key});

  @override
  State<AssistentePage> createState() => _AssistentePageState();
}

class _AssistentePageState extends State<AssistentePage> {
  // Apenas a cor primária é mantida estática, o resto será lido do tema
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
    });
    _messageController.clear();

    Future.delayed(const Duration(seconds: 1), () {
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
    // 1. Acessa o tema global e as cores dinâmicas
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    final colors = getThemeStyles(isDarkMode);

    final textColor = colors['textColor']!;
    final secondaryTextColor = colors['secondaryTextColor']!;
    final cardBackground = colors['cardBackground']!;
    final inputFillColor = colors['cardBackground']!;

    // A caixa de sugestões só some se o usuário começar a digitar.
    final bool showSuggestions = _messageController.text.isEmpty;

    return Scaffold(
      backgroundColor: Colors.transparent, // Necessário para ver o gradiente no body
      resizeToAvoidBottomInset: true, 
      
      // 2. Aplicando o Gradiente Dinâmico na raiz
      body: Container(
        decoration: BoxDecoration(
          gradient: themeNotifier.currentGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 🔸 Cabeçalho
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Container( 
                  color: Colors.transparent, // Fundo transparente para ver o gradiente
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
                                color: secondaryTextColor, // Cor dinâmica
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

              // 🔸 Chat
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
                          // Cores dinâmicas para os balões de mensagem
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
                                // Texto do usuário é sempre branco no balão vermelho
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
                                    ? Colors.white.withOpacity(0.7) // Opacidade para o texto claro
                                    : secondaryTextColor, // Cor dinâmica
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

              // 🔸 Sugestões fixas acima do input
              if (showSuggestions)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    color: Colors.transparent, // Fundo transparente
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sugestões:',
                          style: TextStyle(
                            color: textColor, // Cor dinâmica
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: suggestions.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.8,
                          ),
                          itemBuilder: (context, index) {
                            final s = suggestions[index];
                            return GestureDetector(
                              onTap: () => _sendMessage(s['text']),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cardBackground, // Cor dinâmica do card
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(s['icon'], color: primaryColor),
                                    const SizedBox(height: 5),
                                    Text(
                                      s['title'],
                                      style: TextStyle(
                                        color: textColor, // Cor dinâmica
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      s['text'],
                                      style: TextStyle(
                                        color: secondaryTextColor, // Cor dinâmica
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

              // 🔸 Campo de mensagem fixo acima da navbar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: inputFillColor, // Cor de fundo do input (dinâmica)
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(color: textColor), // Cor dinâmica do texto digitado
                        decoration: InputDecoration(
                          hintText: 'Digite sua pergunta sobre energia...',
                          hintStyle: TextStyle(color: secondaryTextColor), // Cor dinâmica
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          filled: true,
                          fillColor: inputFillColor, // Cor dinâmica do input
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: secondaryTextColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: secondaryTextColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: primaryColor, // Cor primária no foco
                              width: 1.5
                            ),
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