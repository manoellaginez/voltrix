import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voltrix/theme/theme_notifier.dart'; // Import necessário
import 'package:voltrix/theme/app_gradients.dart'; // Import das constantes

class DispositivoCard extends StatelessWidget {
  final int id;
  final String name;
  final String room;
  final bool status;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const DispositivoCard({
    super.key,
    required this.id,
    required this.name,
    required this.room,
    required this.status,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Acessa o estado global do tema
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        final isDarkMode = themeNotifier.isDarkMode;
        final colors = getThemeStyles(isDarkMode);

        // Cores Dinâmicas
        const redColor = kPrimaryRed;
        final cardBackground = colors['cardBackground']!;
        final textColor = colors['textColor']!;
        final secondaryTextColor = colors['secondaryTextColor']!;
        final inactiveTrackColor = secondaryTextColor; // Usar a cor secundária para a trilha inativa

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: cardBackground, // Cor dinâmica
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.04), // Sombra adaptável
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Ícone
                Icon(
                  Icons.power_outlined,
                  size: 28,
                  color: status ? redColor : secondaryTextColor, // Cor dinâmica
                ),
                const SizedBox(width: 14),

                // Nome e descrição
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: textColor, // Cor dinâmica
                        ),
                      ),
                      Text(
                        "${status ? 'Ligado' : 'Desligado'} | $room",
                        style: TextStyle(
                          color: secondaryTextColor, // Cor dinâmica
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Toggle switch
                Switch(
                  value: status,
                  onChanged: (_) => onToggle(),
                  activeColor: Colors.white, // bolinha branca
                  activeTrackColor: redColor, // fundo vermelho
                  inactiveThumbColor: Colors.white, // bolinha branca quando off
                  inactiveTrackColor: inactiveTrackColor, // trilha cinza/escura dinâmica
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  splashRadius: 0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}