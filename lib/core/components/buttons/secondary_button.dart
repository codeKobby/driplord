import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_dimensions.dart';
import '../../theme/app_colors.dart';

/// Secondary Outline Button
/// Transparent background with white border for secondary actions
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;
  final double? width;
  final double height;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
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
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(
            color: AppColors.glassBorder,
            width: 1,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXl,
            vertical: AppDimensions.paddingMd,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100), // Full pill shape
          ),
        ),
        child: Row(
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
              Icon(icon, size: 18, color: AppColors.textPrimary),
            ],
          ],
        ),
      ),
    );
  }
}
