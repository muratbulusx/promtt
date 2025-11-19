import 'package:flutter/material.dart';

/// App color palette for light and dark themes
class AppColors {
  AppColors._();

  // Primary Colors - Limoncuk (Lemon) theme
  static const Color primaryLight = Color(0xFFFFC107); // Amber
  static const Color primaryDark = Color(0xFFFFB300); // Darker Amber
  static const Color primaryVariant = Color(0xFFFF6F00); // Orange

  // Secondary Colors
  static const Color secondaryLight = Color(0xFF66BB6A); // Green
  static const Color secondaryDark = Color(0xFF43A047); // Darker Green

  // Background Colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Difficulty Level Colors
  static const Color difficultyEasy = Color(0xFF66BB6A);
  static const Color difficultyMedium = Color(0xFFFFB300);
  static const Color difficultyHard = Color(0xFFF44336);

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFFFFC107), // Amber
    Color(0xFF66BB6A), // Green
    Color(0xFF2196F3), // Blue
    Color(0xFFFF6F00), // Orange
    Color(0xFF9C27B0), // Purple
    Color(0xFF00BCD4), // Cyan
    Color(0xFFE91E63), // Pink
    Color(0xFF8BC34A), // Light Green
  ];

  // Activity Calendar Colors
  static const Color activityNone = Color(0xFFE0E0E0);
  static const Color activityLow = Color(0xFFFFE082);
  static const Color activityMedium = Color(0xFFFFC107);
  static const Color activityHigh = Color(0xFFFF6F00);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFFC107), Color(0xFFFF6F00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Divider Colors
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x3A000000);
}
