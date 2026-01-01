import 'package:flutter/material.dart';

class AppColors {
  // Primary - Luxury minimal accent (Design System compliant)
  static const Color primary = Color(0xFFFFFFFF); // Pure white for CTAs
  static const Color primaryGlow = Color(0x33FFFFFF);

  // Backgrounds - Luxury Midnight Blue (Design System compliant)
  static const Color background = Color(0xFF0B121C); // Luxury Midnight Blue - richer than pure black
  static const Color backgroundAlternative = Color(0xFF151D2B);
  static const Color surface = Color(0xFF151D2B); // Updated to match design system
  static const Color surfaceLight = Color(0xFF1E2A3D);

  // Glassmorphism - Design System compliant
  static const Color glassSurface = Color(0x40151D2B); // 25% opacity for dark mode
  static const Color glassBorder = Color(0x1AFFFFFF); // Subtle white border
  static const Color glassHighlight = Color(0x0DFFFFFF); // 5% white highlight

  // Text - Design System compliant
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0A0); // Updated to match design system
  static const Color textTertiary = Color(0xFF666666);
  static const Color textOnPrimary = Color(0xFF000000); // Black text on white buttons

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6); // Blue for info/status

  // Supporting Colors
  static const Color glassBorderDark = Color(0x0D000000); // For light mode glass

  // Hardcoded Color Replacements
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color pureBlack = Color(0xFF000000);
  static const Color favoriteRed = Color(0xFFEF4444);
  static const Color whiteOverlay = Color(0x1AFFFFFF);
  static const Color blackOverlayLight = Color(0x1A000000);
  static const Color blackOverlayMedium = Color(0x4D000000);
}
