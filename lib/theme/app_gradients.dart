import 'package:flutter/material.dart';

// Cores base
const Color kPrimaryRed = Color(0xFFB42222);
const Color kWhite = Colors.white;

// Cores de Fundo do Tema Escuro
const Color kDarkBackground = Color(0xFF1C1C1E);
const Color kDarkRedAccent = Color(0xFF450000);

// Gradiente para Tema CLARO (Fundo padrão do app)
const LinearGradient kPrimaryGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    kWhite,        // Top Left: Branco
    kPrimaryRed,   // Bottom Right: #B42222
  ],
  stops: [0.4, 1.0], 
);

// Gradiente para Tema ESCURO (Gradiente escuro)
const LinearGradient kDarkGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    kDarkBackground, // Top Left: Preto Escuro
    kDarkRedAccent,  // Bottom Right: Vermelho Escuro
  ],
  stops: [0.4, 1.0],
);

// Função que retorna o mapa de estilos (cores dinâmicas)
Map<String, Color> getThemeStyles(bool isDark) {
  if (isDark) {
    return {
      // Tema Escuro
      'cardBackground': const Color(0xFF2C2C2E),
      'textColor': Colors.white,
      'secondaryTextColor': const Color(0xFFB0B0B0),
      'borderColor': const Color(0xFF38383A),
    };
  } else {
    // Tema Claro
    const Color BORDER_COLOR = Color(0xFFE0E0E0);
    const Color MAIN_TEXT_COLOR_REQUESTED = Color(0xFFA6A6A6);

    return {
      'cardBackground': const Color(0xFFF6F6F6),
      'textColor': Colors.black,
      'secondaryTextColor': MAIN_TEXT_COLOR_REQUESTED,
      'borderColor': BORDER_COLOR,
    };
  }
}