import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voltrix/theme/theme_notifier.dart';
import 'package:voltrix/theme/app_gradients.dart'; // Import das constantes

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  // Cor primária mantida como constante
  static const Color primaryRed = kPrimaryRed;

  const Navbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos Consumer para reconstruir apenas este widget quando o tema muda
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        final isDarkMode = themeNotifier.isDarkMode;
        final colors = getThemeStyles(isDarkMode);

        // Cores Dinâmicas
        final Color activeIconColor = primaryRed;
        final Color inactiveIconColor = colors['secondaryTextColor']!;
        final Color backgroundColor = colors['cardBackground']!;
        
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          
          // Cores dinâmicas para o tema
          backgroundColor: backgroundColor,
          selectedItemColor: activeIconColor,
          unselectedItemColor: inactiveIconColor,
          
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy), // Assistente
              label: 'Assistente',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), // Gastos
              label: 'Gastos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home), // Início
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person), // Perfil
              label: 'Perfil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz), // Mais
              label: 'Mais',
            ),
          ],
        );
      },
    );
  }
}