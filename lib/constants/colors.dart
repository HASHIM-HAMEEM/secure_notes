import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF6200EE);
  static const Color primaryVariant = Color(0xFF3700B3);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryVariant = Color(0xFF018786);

  // Theme Colors - Light
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textLight = Color(0xFF121212);
  static const Color dividerLight = Color(0xFFE0E0E0);

  // Theme Colors - Dark
  static const Color surfaceDark = Color(0xFF121212);
  static const Color textDark = Color(0xFFFFFFFF);
  static const Color dividerDark = Color(0xFF2C2C2C);

  // Note Colors
  static const List<Color> noteColors = [
    Color(0xFFFFAB91), // Red-ish
    Color(0xFFFFCC80), // Orange
    Color(0xFFE6EE9C), // Yellow-green
    Color(0xFF80DEEA), // Blue
    Color(0xFFCF94DA), // Purple
    Color(0xFFE8EAF6), // Light Blue-grey
    Color(0xFFF5F5F5), // Light Grey
    Color(0xFFB2DFDB), // Teal
    Color(0xFFF8BBD0), // Pink
    Color(0xFFD7CCC8), // Brown
  ];

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFB00020);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Gradient Colors
  static const List<List<Color>> gradients = [
    [Color(0xFF6200EE), Color(0xFF03DAC6)],
    [Color(0xFFFF9800), Color(0xFFFFEB3B)],
    [Color(0xFF4CAF50), Color(0xFF8BC34A)],
    [Color(0xFF2196F3), Color(0xFF03A9F4)],
    [Color(0xFF9C27B0), Color(0xFFE91E63)],
  ];

  // Helper methods
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}
