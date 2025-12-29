import 'package:flutter/material.dart';

class AppColors {
  // Primary - Luxury minimal accent
  static const Color primary = Color(0xFFFFFFFF); // Pure white for CTAs
  static const Color primaryGlow = Color(0x33FFFFFF); // 20% opacity white

  // Backgrounds - Deep Midnight Blue/Gunmetal (luxury dark mode)
  static const Color background = Color(0xFF0B121C); // Deep Gunmetal
  static const Color backgroundDark = Color(0xFF050A10); // Darker midnight
  static const Color surface = Color(0xFF151D2B); // Surface for cards
  static const Color surfaceLight = Color(0xFF1E2A3D); // Slightly lighter surface
  
  // Glassmorphism
  static const Color glassSurface = Color(0x40151D2B);
  static const Color glassBorder = Color(0x1AFFFFFF);

  // Text
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFA0A0A0); // Light gray for descriptions
  static const Color textTertiary = Color(0xFF6B7280);
  static const Color textOnPrimary = Color(0xFF0B121C); // Black text on white buttons

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  
  // Product image placeholder tones (warm beige/cream)
  static const Color placeholderWarm = Color(0xFFF5F0E8);
  static const Color placeholderBeige = Color(0xFFEBE5D9);
}
