import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FixedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final double elevation;
  final SystemUiOverlayStyle? systemOverlayStyle;

  const FixedAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.elevation = 0,
    this.systemOverlayStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = colorScheme.surface;
    final foregroundColor = colorScheme.onSurface;

    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      shadowColor: elevation == 0 ? Colors.transparent : null,
      surfaceTintColor: backgroundColor,
      systemOverlayStyle: systemOverlayStyle ?? SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: Theme.of(context).brightness,
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
