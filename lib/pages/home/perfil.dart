// >>>>>>>>>>> PAGINA EM FLUTTER

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:voltrix/theme/theme_notifier.dart';
import 'package:voltrix/theme/app_gradients.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  // Cores principais (agora referenciam as constantes estáticas)
  static const Color primaryRed = kPrimaryRed;

  // Dados de exemplo
  final String userName = "Manoella Ginez";
  final String userEmail = "ginez.mano@gmail.com";
  final String status = "CONTA ATIVA";

  @override
  Widget build(BuildContext context) {
    // 1. Acessa o estado global do tema
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    final colors = getThemeStyles(isDarkMode);

    final textColor = colors['textColor']!;
    final secondaryTextColor = colors['secondaryTextColor']!;
    final cardBackground = colors['cardBackground']!;
    final borderColor = colors['borderColor']!;
    
    // Cor do texto reverso para o botão Sair
    final reverseTextColor = isDarkMode ? Colors.black : Colors.white; 
    
    // Gradiente dinâmico
    final LinearGradient currentGradient = themeNotifier.currentGradient;

    return Scaffold(
      // 2. Aplicando o Gradiente Dinâmico na raiz
      body: Container(
        decoration: BoxDecoration(
          gradient: currentGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              margin: const EdgeInsets.symmetric(horizontal: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CABEÇALHO
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Perfil',
                          style: TextStyle(
                            color: primaryRed,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Seu espaço pessoal e dados de consumo',
                          style: TextStyle(
                            color: secondaryTextColor, // Cor dinâmica
                            fontSize: 17,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),

                  // CARTÃO DE INFORMAÇÕES DO USUÁRIO
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardBackground, // Cor dinâmica
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.12), 
                            blurRadius: 5, offset: const Offset(0, 2))
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: secondaryTextColor.withOpacity(0.1), // Cor de fundo do ícone
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                FeatherIcons.user,
                                color: primaryRed,
                                size: 30,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                debugPrint('Editar Perfil');
                              },
                              child: Icon(
                                FeatherIcons.edit2,
                                color: secondaryTextColor, // Cor dinâmica
                                size: 20,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          userName,
                          style: TextStyle(
                            color: textColor, // Cor dinâmica
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          userEmail,
                          style: TextStyle(
                            color: secondaryTextColor, // Cor dinâmica
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: primaryRed,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              // A cor do texto do status é sempre o reverso do tema no botão vermelho
                              color: reverseTextColor, 
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  // ESTATÍSTICAS DE USO
                  Text(
                    'Estatísticas de uso',
                    style: TextStyle(
                      color: textColor, // Cor dinâmica
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardBackground, // Cor dinâmica
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.12),
                            blurRadius: 5, offset: const Offset(0, 2))
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 15,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        // Passando as cores dinâmicas para o statItem
                        _statItem('25', 'Dias de uso', textColor, secondaryTextColor, context),
                        _statItem('12', 'Dispositivos', textColor, secondaryTextColor, context),
                        _statItem('R\$ 87,50', 'Economia total', textColor, secondaryTextColor, context),
                        _statItem('15%', 'Redução consumo', textColor, secondaryTextColor, context),
                      ],
                    ),
                  ),

                  // AÇÕES DE ENERGIA
                  Text(
                    'Ações de energia',
                    style: TextStyle(
                      color: textColor, // Cor dinâmica
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardBackground, // Cor dinâmica
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.12),
                            blurRadius: 5, offset: const Offset(0, 2))
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        // Passando as cores dinâmicas para o actionItem
                        _actionItem(
                          icon: FeatherIcons.zap,
                          title: 'Meus dispositivos',
                          description: 'Gerencie os aparelhos conectados',
                          onTap: () => debugPrint('Abrir Meus Dispositivos'),
                          borderColor: borderColor,
                          textColor: textColor,
                          secondaryTextColor: secondaryTextColor,
                          primaryRed: primaryRed,
                          isLast: false,
                        ),
                        _actionItem(
                          icon: FeatherIcons.target,
                          title: 'Metas de economia',
                          description: 'Defina e acompanhe seus objetivos',
                          onTap: () => debugPrint('Abrir Metas de Economia'),
                          borderColor: borderColor,
                          textColor: textColor,
                          secondaryTextColor: secondaryTextColor,
                          primaryRed: primaryRed,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  // BOTÃO SAIR
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => debugPrint('Sair da Conta'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        foregroundColor: Colors.white, // Mantido branco para contraste máximo no botão primário
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadowColor: Colors.black12,
                        elevation: 2,
                      ),
                      child: const Text(
                        'SAIR DA CONTA',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // RODAPÉ
                  Center(
                    child: Text(
                      '© 2025 Voltrix. Todos os direitos reservados.',
                      style: TextStyle(
                        color: secondaryTextColor, // Cor dinâmica
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statItem(
      String value, String label, Color textColor, Color secondaryTextColor, BuildContext context) {
    return SizedBox(
      // Usar MediaQuery.of(context).size.width / 2 para evitar overflows em telas menores
      width: (MediaQuery.of(context).size.width * 0.5) - 30, 
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: textColor, // Cor dinâmica
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondaryTextColor, // Cor dinâmica
              fontSize: 12,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionItem({
    required IconData icon,
    required String title,
    String? description,
    required VoidCallback onTap,
    required Color borderColor,
    required Color textColor,
    required Color secondaryTextColor,
    required Color primaryRed,
    required bool isLast,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(color: borderColor, width: 1), // Cor dinâmica
                ),
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryRed, size: 20),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor, // Cor dinâmica
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  if (description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        description,
                        style: TextStyle(
                          color: secondaryTextColor, // Cor dinâmica
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              FeatherIcons.chevronRight,
              color: secondaryTextColor, // Cor dinâmica
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}