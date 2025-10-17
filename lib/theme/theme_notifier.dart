import 'package:flutter/material.dart';
import 'package:voltrix/theme/app_gradients.dart'; // Importação do arquivo de constantes

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;

  // Variável para acessar o gradiente atual
  LinearGradient get currentGradient => _isDarkMode 
      ? kDarkGradient 
      : kPrimaryGradient;

  // Inicializa o tema com base na configuração do sistema
  void initializeTheme(Brightness platformBrightness) {
    // Definimos o estado inicial baseado no sistema. 
    // Usamos o setter para disparar a notificação se o tema for dark.
    if (platformBrightness == Brightness.dark && !_isDarkMode) {
        _isDarkMode = true;
        notifyListeners(); // Avisa o app para construir com o tema do sistema
    }
  }

  // Altera o tema quando o usuário clica no botão
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notifica todas as telas
  }
}