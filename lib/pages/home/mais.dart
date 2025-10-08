import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class MaisPage extends StatefulWidget {
  const MaisPage({super.key});

  @override
  State<MaisPage> createState() => _MaisPageState();
}

class _MaisPageState extends State<MaisPage> {
  // Cores fixas
  static const PRIMARY_RED = Color(0xFFB42222);
  static const BORDER_COLOR = Color(0xFFE0E0E0);
  static const MAIN_TEXT_COLOR_REQUESTED = Color(0xFFA6A6A6);

  String theme = 'Claro';
  bool isNotificationToggled = true;

  // Estilos de tema
  Map<String, Map<String, Color>> get themeStyles => {
        'Claro': {
          'pageBackground': Colors.white,
          'cardBackground': const Color(0xFFF6F6F6),
          'textColor': MAIN_TEXT_COLOR_REQUESTED,
          'secondaryTextColor': MAIN_TEXT_COLOR_REQUESTED,
          'borderColor': BORDER_COLOR,
        },
        'Escuro': {
          'pageBackground': const Color(0xFF1C1C1E),
          'cardBackground': const Color(0xFF2C2C2E),
          'textColor': Colors.white,
          'secondaryTextColor': Color(0xFFB0B0B0),
          'borderColor': Color(0xFF38383A),
        },
      };

  void toggleTheme() {
    setState(() {
      theme = theme == 'Claro' ? 'Escuro' : 'Claro';
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = themeStyles[theme]!;
    final pageBackground = colors['pageBackground']!;
    final cardBackground = colors['cardBackground']!;
    final textColor = colors['textColor']!;
    final secondaryTextColor = colors['secondaryTextColor']!;
    final borderColor = colors['borderColor']!;

    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabeçalho
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mais",
                          style: TextStyle(
                            color: PRIMARY_RED,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Ajustes do aplicativo, ajuda e informações",
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Seção: Configurações
                  _SectionTitle(title: "Configurações", color: textColor),
                  _CardSection(
                    backgroundColor: cardBackground,
                    children: [
                      ConfigItem(
                        icon: FeatherIcons.user,
                        title: "Detalhes da conta",
                        description: "Gerencie nome, e-mail e senha",
                        onTap: () => print('Abrir Detalhes da Conta'),
                        primaryColor: PRIMARY_RED,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        borderColor: borderColor,
                      ),
                      ConfigItem(
                        icon: FeatherIcons.shield,
                        title: "Privacidade e segurança",
                        description: "Configurações de segurança e dados",
                        onTap: () => print('Abrir Privacidade'),
                        primaryColor: PRIMARY_RED,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        borderColor: borderColor,
                      ),
                      ConfigItem(
                        icon: FeatherIcons.bell,
                        title: "Notificações",
                        description: "Ligar/Desligar alertas do sistema",
                        isToggle: true,
                        toggled: isNotificationToggled,
                        onToggle: (value) {
                          setState(() {
                            isNotificationToggled = value;
                          });
                        },
                        primaryColor: PRIMARY_RED,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        borderColor: borderColor,
                      ),
                      ConfigItem(
                        icon: FeatherIcons.moon,
                        title: "Tema",
                        description: "Tema atual: $theme",
                        isToggle: true,
                        toggled: theme == 'Escuro',
                        onToggle: (val) => toggleTheme(),
                        primaryColor: PRIMARY_RED,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        borderColor: borderColor,
                      ),
                      ConfigItem(
                        icon: FeatherIcons.globe,
                        title: "Idioma",
                        description: "Português (Brasil)",
                        onTap: () => print('Mudar Idioma'),
                        isLast: true,
                        primaryColor: PRIMARY_RED,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        borderColor: borderColor,
                      ),
                    ],
                  ),

                  // Seção: Ajuda
                  _SectionTitle(title: "Ajuda", color: textColor),
                  _CardSection(
                    backgroundColor: cardBackground,
                    children: [
                      ConfigItem(
                        icon: FeatherIcons.helpCircle,
                        title: "Central de ajuda",
                        description: "Dúvidas frequentes e contato com suporte",
                        onTap: () => print('Abrir Central de Ajuda'),
                        primaryColor: PRIMARY_RED,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        borderColor: borderColor,
                      ),
                      ConfigItem(
                        icon: FeatherIcons.fileText,
                        title: "Termos de uso",
                        description: "Condições gerais de serviço",
                        onTap: () => print('Abrir termos de uso'),
                        primaryColor: PRIMARY_RED,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        borderColor: borderColor,
                      ),
                      ConfigItem(
                        icon: FeatherIcons.lock,
                        title: "Política de privacidade",
                        description: "Como seus dados são usados",
                        onTap: () => print('Abrir Política de Privacidade'),
                        isLast: true,
                        primaryColor: PRIMARY_RED,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        borderColor: borderColor,
                      ),
                    ],
                  ),

                  // Seção: Sobre
                  _SectionTitle(title: "Sobre", color: textColor),
                  _CardSection(
                    backgroundColor: cardBackground,
                    children: [
                      ConfigItem(
                        icon: FeatherIcons.info,
                        title: "Versão do aplicativo",
                        description: "Informações sobre Voltrix",
                        customTrailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "v1.0",
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "2025",
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        isLast: true,
                        primaryColor: PRIMARY_RED,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        borderColor: borderColor,
                      ),
                    ],
                  ),

                  // Rodapé
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50, top: 20),
                    child: Center(
                      child: Text(
                        "© 2025 Voltrix. Todos os direitos reservados.",
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------- COMPONENTES REUTILIZÁVEIS -------------------

class ConfigItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final VoidCallback? onTap;
  final bool isToggle;
  final bool toggled;
  final ValueChanged<bool>? onToggle;
  final Widget? customTrailing;
  final bool isLast;
  final Color primaryColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Color borderColor;

  const ConfigItem({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.onTap,
    this.isToggle = false,
    this.toggled = false,
    this.onToggle,
    this.customTrailing,
    this.isLast = false,
    required this.primaryColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isToggle ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: isLast
                ? BorderSide.none
                : BorderSide(color: borderColor, width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryColor, size: 20),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  if (description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        description!,
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isToggle)
              Switch(
                activeColor: primaryColor,
                value: toggled,
                onChanged: onToggle,
              )
            else if (customTrailing != null)
              customTrailing!
            else
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

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionTitle({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _CardSection extends StatelessWidget {
  final List<Widget> children;
  final Color backgroundColor;
  const _CardSection({
    required this.children,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}
