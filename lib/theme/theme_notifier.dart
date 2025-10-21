// lib/theme/theme_notifier.dart

import 'package:flutter/material.dart';
import 'package:voltrix/theme/app_gradients.dart';

class ThemeNotifier extends ChangeNotifier {
  // Inicialização no Construtor para ler o tema do sistema IMEDIATAMENTE
  late bool _isDarkMode;
  
  ThemeNotifier() {
    // Acesso ao tema do sistema para inicializar o estado
    final platformBrightness = WidgetsBinding.instance.window.platformBrightness;
    _isDarkMode = platformBrightness == Brightness.dark;
    // Não chama notifyListeners() aqui, pois o Provider ainda está sendo criado.
  }

  bool get isDarkMode => _isDarkMode;

  LinearGradient get currentGradient => _isDarkMode 
      ? kDarkGradient 
      : kPrimaryGradient;

  // Altera o tema quando o usuário clica no botão
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notifica todas as telas
  }
}