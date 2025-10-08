import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const Navbar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: const Color(0xFFB42222),
      unselectedItemColor: Colors.grey,
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
  }
}
