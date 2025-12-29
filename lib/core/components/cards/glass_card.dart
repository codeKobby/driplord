import 'dart:ui';
import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';
import '../../theme/app_colors.dart';

/// Glassmorphism card with frosted glass effect
/// Used for floating navigation, overlays, and premium UI elements
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double? borderRadius;
  final bool showBorder;
  final double? width;
  final double? height;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderRadius,
    this.showBorder = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadiusValue = borderRadius ?? AppDimensions.radiusLg;
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
      child: GlassEffect(
        borderRadius: borderRadiusValue,
        onTap: onTap,
        padding: padding,
        showBorder: showBorder,
        child: child,
      ),
    );
  }
}

/// Inner glass effect widget with BackdropFilter
class GlassEffect extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool showBorder;

  const GlassEffect({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    required this.borderRadius,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 20,
          sigmaY: 20,
          tileMode: TileMode.decal,
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: padding ?? const EdgeInsets.all(AppDimensions.paddingLg),
            decoration: _buildDecoration(),
            child: child,
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      // Gradient for subtle depth
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.glassSurface.withValues(alpha: 0.8),
          AppColors.glassSurface.withValues(alpha: 0.6),
        ],
        stops: const [0.0, 1.0],
      ),
      border: showBorder
          ? Border.all(
              color: AppColors.glassBorder,
              width: 1,
            )
          : null,
      // Subtle inner glow effect
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 30,
          spreadRadius: -5,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}

/// Full-width glass container for navigation bars and bottom sheets
class GlassSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool includeTopRadius;

  const GlassSurface({
    super.key,
    required this.child,
    this.padding,
    this.includeTopRadius = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: includeTopRadius
          ? const BorderRadius.vertical(
              top: Radius.circular(AppDimensions.radiusXl),
            )
          : BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 30,
          sigmaY: 30,
          tileMode: TileMode.decal,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.glassSurface.withValues(alpha: 0.85),
                AppColors.glassSurface.withValues(alpha: 0.7),
              ],
            ),
            border: Border(
              top: BorderSide(
                color: AppColors.glassBorder,
                width: 0.5,
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
