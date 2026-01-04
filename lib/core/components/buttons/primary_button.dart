import 'package:flutter/material.dart';

/// Standard high-contrast primary button
/// Clean minimalist aesthetic using solid colors and rounded corners.
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
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      text.toUpperCase(),
                      style: const TextStyle(letterSpacing: 1),
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(icon, size: 18),
                  ],
                ],
              ),
      ),
    );
  }
}

/// Compact button for follow actions
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
              : Theme.of(context).colorScheme.primary,
          foregroundColor: isFollowing
              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)
              : Theme.of(context).colorScheme.onPrimary,
          side: isFollowing
              ? BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        child: Text(isFollowing ? 'FOLLOWING' : 'FOLLOW'),
      ),
    );
  }
}
