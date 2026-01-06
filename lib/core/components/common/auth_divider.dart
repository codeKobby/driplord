import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({
    super.key,
    this.text = 'or',
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            thickness: 1.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
          child: Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            thickness: 1.5,
          ),
        ),
      ],
    );
  }
}
