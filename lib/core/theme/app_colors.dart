import 'package:flutter/material.dart';

class AppColors {
  // Primary - Luxury minimal accent
  static const Color primary = Color(0xFFFFFFFF); // Pure white for CTAs
  static const Color primaryGlow = Color(0x33FFFFFF);

  // Backgrounds - Rich Luxury Dark (less blue, more neutral/warm dark)
  static const Color background = Color(
    0xFF000000,
  ); // Pure black for deep contrast
  static const Color backgroundAlternative = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF141414); // Very dark grey
  static const Color surfaceLight = Color(0xFF1C1C1C);

  // Glassmorphism - Enhanced for the premium vibe in Reference Image 2
  static const Color glassSurface = Color(0x731C1C1C); // Approx 45% opacity
  static const Color glassBorder = Color(0x1AFFFFFF); // Subtle white border
  static const Color glassHighlight = Color(0x0DFFFFFF); // 5% white highlight

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9E9E9E); // Neutral grey
  static const Color textTertiary = Color(0xFF666666);
  static const Color textOnPrimary = Color(
    0xFF000000,
  ); // Black text on white buttons

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Luxury Tones
  static const Color luxuryGold = Color(0xFFD4AF37);
  static const Color accentBeige = Color(0xFFF5F0E8);
}
