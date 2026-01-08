import 'package:flutter/material.dart';

class AppColors {
  // Primary - Minimalist Contrast
  static const Color primary = Color(0xFFFFFFFF);
  static const Color primaryDark = Color(0xFF000000);

  // Backgrounds - High Contrast
  static const Color background = Color(0xFF000000); // True Black
  static const Color backgroundLight = Color(0xFFFFFFFF); // True White
  static const Color surface = Color(0xFF0A0A0A); // Very Dark Gray
  static const Color surfaceLight = Color(0xFFF9F9F9); // Near White

  // Minimal Borders & Accents
  static const Color border = Color(0xFF1F1F1F);
  static const Color borderLight = Color(0xFFE5E5E5);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textTertiary = Color(0xFF71717A);
  static const Color textOnPrimary = Color(0xFF000000);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Constants
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color pureBlack = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
  static const Color favoriteRed = Color(0xFFEF4444);

  // Legacy Glassmorphism Aliases (pointing to new minimalist colors)
  static const Color glassSurface = surface;
  static const Color glassBorder = border;
  static const Color glassBorderDark = border;
}
