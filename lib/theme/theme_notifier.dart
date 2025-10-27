import 'package:flutter/material.dart'; // <-- O ERRO ESTAVA AQUI
import 'package:voltrix/theme/app_gradients.dart';

class ThemeNotifier extends ChangeNotifier {
  late bool _isDarkMode;

  ThemeNotifier() {
    final platformBrightness = WidgetsBinding.instance.window.platformBrightness;
    _isDarkMode = platformBrightness == Brightness.dark;
  }

  bool get isDarkMode => _isDarkMode;

  LinearGradient get currentGradient =>
      _isDarkMode ? kDarkGradient : kPrimaryGradient;

  /// Retorna o ThemeData com base no modo atual (claro ou escuro).
  ThemeData get currentTheme {
    // Busca as cores dinâmicas
    final colors = getThemeStyles(_isDarkMode);
    
    // Define o tema base
    final baseTheme = _isDarkMode ? ThemeData.dark() : ThemeData.light();

    // Retorna o tema personalizado
    return baseTheme.copyWith(
      primaryColor: kPrimaryRed,
      scaffoldBackgroundColor: Colors.transparent, // Importante para os gradientes
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent, // AppBar transparente
        iconTheme: IconThemeData(color: colors['textColor']),
      ),
      textTheme: baseTheme.textTheme.apply(
        fontFamily: 'Inter',
        bodyColor: colors['textColor'],
        displayColor: colors['textColor'],
      ),
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: kPrimaryRed,
        secondary: kPrimaryRed,
        background: _isDarkMode ? kDarkBackground : Colors.white,
      ),
      // Corrige a cor do texto do DropdownButton e do fundo
      canvasColor: colors['cardBackground'], 
    );
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

