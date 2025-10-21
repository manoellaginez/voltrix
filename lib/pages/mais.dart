import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:voltrix/theme/theme_notifier.dart'; 
import 'package:voltrix/theme/app_gradients.dart'; 

class MaisPage extends StatefulWidget {
  const MaisPage({super.key});

  @override
  State<MaisPage> createState() => _MaisPageState();
}

class _MaisPageState extends State<MaisPage> {
  // Cores fixas (referenciam as constantes importadas)
  static const Color PRIMARY_RED = kPrimaryRed; 
  bool isNotificationToggled = true;

  @override
  Widget build(BuildContext context) {
    // 1. Acessa o estado global do tema
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    final currentThemeName = isDarkMode ? 'Escuro' : 'Claro';

    // 2. Obtém as cores dinâmicas usando a função global
    final colors = getThemeStyles(isDarkMode);
        
    final cardBackground = colors['cardBackground']!;
    final textColor = colors['textColor']!;
    final secondaryTextColor = colors['secondaryTextColor']!;
    final borderColor = colors['borderColor']!;

    // 3. Determina o gradiente atual
    final LinearGradient currentGradient = themeNotifier.currentGradient;
    
    return Scaffold(
      // Fundo será o Container no body
      body: Container(
        decoration: BoxDecoration(
          gradient: currentGradient,
        ),
        child: SafeArea(
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
                          description: "Tema atual: $currentThemeName",
                          isToggle: true,
                          toggled: isDarkMode, 
                          onToggle: (val) => themeNotifier.toggleTheme(), 
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
                activeThumbColor: primaryColor,
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