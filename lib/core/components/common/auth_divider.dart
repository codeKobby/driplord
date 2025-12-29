import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
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
            color: AppColors.textTertiary.withValues(alpha: 0.3),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.textTertiary.withValues(alpha: 0.3),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
