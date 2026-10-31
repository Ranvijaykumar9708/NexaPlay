import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color background = Color(0xFF090A10);
  static const Color surface = Color(0xFF131522);
  static const Color surfaceLight = Color(0xFF1E2135);
  static const Color cardColor = Color(0xFF161828);

  // Gradient & Neon Accents
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color primaryViolet = Color(0xFFA855F7);
  static const Color primaryPink = Color(0xFFD946EF);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color imdbGold = Color(0xFFF5C518);
  static const Color netflixRed = Color(0xFFE50914);

  // Focus Ring
  static const Color focusRing = Color(0xFFA855F7);
  static const Color focusGlow = Color(0xFF00D2FF);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);

  // Gradients
  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF9333EA), Color(0xFF6366F1), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [
      Color(0xFF090A10),
      Colors.transparent,
      Colors.transparent,
      Color(0xFF090A10),
    ],
    stops: [0.0, 0.35, 0.65, 1.0],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient horizontalHeroGradient = LinearGradient(
    colors: [
      Color(0xFF090A10),
      Color(0xCC090A10),
      Color(0x44090A10),
      Colors.transparent,
    ],
    stops: [0.0, 0.45, 0.75, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.outfitTextTheme(
      ThemeData.dark().textTheme,
    ).apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primaryViolet,
      cardColor: cardColor,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        primary: primaryViolet,
        secondary: accentCyan,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // Enhance focus highlight across TV
      focusColor: primaryViolet.withValues(alpha: 0.3),
      highlightColor: accentCyan.withValues(alpha: 0.2),
    );
  }
}
