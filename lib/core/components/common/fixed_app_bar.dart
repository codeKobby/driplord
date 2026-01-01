import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class FixedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final SystemUiOverlayStyle? systemOverlayStyle;

  const FixedAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.backgroundColor = AppColors.background,
    this.foregroundColor = AppColors.textPrimary,
    this.elevation = 0,
    this.systemOverlayStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      shadowColor: backgroundColor == AppColors.background
          ? Colors.transparent
          : null,
      surfaceTintColor: backgroundColor,
      systemOverlayStyle: systemOverlayStyle ?? SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarIconBrightness: backgroundColor == AppColors.background
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: backgroundColor == AppColors.background
            ? Brightness.dark
            : Brightness.light,
      ),
      leading: showBackButton ? IconButton(
        icon: Icon(
          LucideIcons.chevronLeft,
          color: foregroundColor,
        ),
        onPressed: () => context.pop(),
      ) : null,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
