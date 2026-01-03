import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_dimensions.dart';
import '../../theme/app_colors.dart';

class _AdaptiveColors {
  static Color getPrimaryBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.primary
          : Colors.black;

  static Color getPrimaryForeground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.textOnPrimary
          : Colors.white;

  static Color getTextSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.textSecondary
          : Colors.black54;

  static Color getGlassBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.glassBorder
          : AppColors.glassBorderDark;
}

/// Luxury Primary Button
/// White pill-shaped button with black text for high-contrast CTAs
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;
  final double? width;
  final double height;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
    this.width,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _AdaptiveColors.getPrimaryBackground(context),
          foregroundColor: _AdaptiveColors.getPrimaryForeground(context),
          disabledBackgroundColor: _AdaptiveColors.getPrimaryBackground(context).withValues(alpha: 0.6),
          disabledForegroundColor: _AdaptiveColors.getPrimaryForeground(context).withValues(
            alpha: 0.6,
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXl,
            vertical: AppDimensions.paddingMd,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            height: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100), // Full pill shape
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: _AdaptiveColors.getPrimaryForeground(context),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: AppDimensions.paddingSm),
                    Icon(icon, size: 18, color: _AdaptiveColors.getPrimaryForeground(context)),
                  ],
                ],
              ),
      ),
    );
  }
}

// SecondaryButton moved to secondary_button.dart

/// Follow/Subscribe Button
/// Compact pill button for follow actions
class FollowButton extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onPressed;
  final double? width;

  const FollowButton({
    super.key,
    required this.isFollowing,
    required this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 100,
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFollowing
              ? Colors.transparent
              : _AdaptiveColors.getPrimaryBackground(context),
          foregroundColor: isFollowing
              ? _AdaptiveColors.getTextSecondary(context)
              : _AdaptiveColors.getPrimaryForeground(context),
          side: isFollowing
              ? BorderSide(color: _AdaptiveColors.getGlassBorder(context), width: 1)
              : null,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
            vertical: AppDimensions.paddingSm,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100), // Full pill shape
          ),
        ),
        child: Text(isFollowing ? 'Following' : 'Follow'),
      ),
    );
  }
}
