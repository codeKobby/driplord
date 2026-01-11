import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';

/// Minimalist card component (formerly GlassCard)
/// Now uses solid backgrounds and clean borders to align with the Clean Minimalist theme.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double? borderRadius;
  final bool showBorder;
  final double? width;
  final double? height;
  final Color? color;
  final String? semanticLabel;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderRadius,
    this.showBorder = true,
    this.width,
    this.height,
    this.color,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadiusValue = borderRadius ?? AppDimensions.radiusCard;

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
        color: color,
        semanticLabel: semanticLabel,
        child: child,
      ),
    );
  }
}

/// Inner minimalist effect widget
class GlassEffect extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool showBorder;
  final Color? color;
  final String? semanticLabel;

  const GlassEffect({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    required this.borderRadius,
    this.showBorder = true,
    this.color,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: padding ?? const EdgeInsets.all(AppDimensions.paddingLg),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.5),
                width: 1,
              )
            : null,
      ),
      child: child,
    );

    if (onTap == null) {
      return content;
    }

    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: ExcludeSemantics(
          child: content,
        ),
      ),
    );
  }
}

/// Solid surface container for navigation bars and bottom sheets
class GlassSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool includeTopRadius;
  final Color? color;

  const GlassSurface({
    super.key,
    required this.child,
    this.padding,
    this.includeTopRadius = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surface,
        borderRadius: includeTopRadius
            ? const BorderRadius.vertical(
                top: Radius.circular(AppDimensions.radiusXl),
              )
            : BorderRadius.zero,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
      ),
      child: child,
    );
  }
}
