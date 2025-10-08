// >>>>>>>>>>> PAGINA EM FLUTTER

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  // Cores principais
  final String PRIMARY_RED = '#B42222';
  final String BORDER_COLOR = '#E0E0E0';
  final String MAIN_TEXT_COLOR_REQUESTED = '#A6A6A6';

  // Controle de tema
  String theme = 'Claro';

  Map<String, Map<String, Color>> get themeStyles {
    return {
      'Claro': {
        'pageBackground': Colors.white,
        'cardBackground': const Color(0xFFF6F6F6),
        'textColor': const Color(0xFFA6A6A6),
        'secondaryTextColor': const Color(0xFFA6A6A6),
        'reverseTextColor': Colors.white,
        'borderColor': const Color(0xFFE0E0E0),
      },
      'Escuro': {
        'pageBackground': const Color(0xFF1C1C1E),
        'cardBackground': const Color(0xFF2C2C2E),
        'textColor': Colors.white,
        'secondaryTextColor': Color(0xFFB0B0B0),
        'reverseTextColor': Colors.black,
        'borderColor': Color(0xFF38383A),
      }
    };
  }

  // Dados de exemplo
  final String userName = "Manoella Ginez";
  final String userEmail = "ginez.mano@gmail.com";
  final String status = "CONTA ATIVA";

  @override
  Widget build(BuildContext context) {
    final currentTheme = themeStyles[theme]!;
    final pageBackground = currentTheme['pageBackground']!;
    final cardBackground = currentTheme['cardBackground']!;
    final textColor = currentTheme['textColor']!;
    final secondaryTextColor = currentTheme['secondaryTextColor']!;
    final borderColor = currentTheme['borderColor']!;
    final reverseTextColor = currentTheme['reverseTextColor']!;
    final primaryRed = Color(0xFFB42222);

    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
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
                          color: secondaryTextColor,
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
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
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
                              color: pageBackground,
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
                              color: secondaryTextColor,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        userName,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        userEmail,
                        style: TextStyle(
                          color: secondaryTextColor,
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
                            color: theme == 'Claro'
                                ? Colors.white
                                : Colors.black,
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
                    color: textColor,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 15,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      _statItem('25', 'Dias de uso', textColor, secondaryTextColor),
                      _statItem('12', 'Dispositivos', textColor, secondaryTextColor),
                      _statItem('R\$ 87,50', 'Economia total', textColor, secondaryTextColor),
                      _statItem('15%', 'Redução consumo', textColor, secondaryTextColor),
                    ],
                  ),
                ),

                // AÇÕES DE ENERGIA
                Text(
                  'Ações de energia',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
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
                      foregroundColor: reverseTextColor,
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
                      color: secondaryTextColor,
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
    );
  }

  Widget _statItem(
      String value, String label, Color textColor, Color secondaryTextColor) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4 - 15,
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: textColor,
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
              color: secondaryTextColor,
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
                  bottom: BorderSide(color: borderColor, width: 1),
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
                      color: textColor,
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
                          color: secondaryTextColor,
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
              color: secondaryTextColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
