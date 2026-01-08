import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class OAuthButton extends StatelessWidget {
  const OAuthButton({
    super.key,
    this.icon,
    this.svgIcon,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = AppColors.surface,
    this.foregroundColor = AppColors.textPrimary,
    this.borderColor = AppColors.glassBorder,
  });

  final IconData? icon;
  final String? svgIcon;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            side: BorderSide(color: borderColor, width: 2),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXl,
            vertical: AppDimensions.paddingMd,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Icon(icon, size: 24)
                  else if (svgIcon != null)
                    SvgPicture.asset(
                      svgIcon!,
                      width: 24,
                      height: 24,
                    ),
                  const SizedBox(width: AppDimensions.paddingMd),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Pre-configured OAuth buttons for common providers
class GoogleOAuthButton extends StatelessWidget {
  const GoogleOAuthButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return OAuthButton(
      svgIcon: 'assets/icons/google_icon.svg',
      label: 'Continue with Google',
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      borderColor: Theme.of(context).colorScheme.outline,
    );
  }
}

class AppleOAuthButton extends StatelessWidget {
  const AppleOAuthButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return OAuthButton(
      svgIcon: 'assets/icons/apple_icon.svg',
      label: 'Continue with Apple',
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      borderColor: Colors.white.withValues(alpha: 0.3),
    );
  }
}
