import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/app_colors.dart';
import '../../constants/app_dimensions.dart';
import '../cards/glass_card.dart';

/// Floating bottom navigation bar with glassmorphism effect
/// Detached from bottom edge for a modern, premium feel
class FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavItem> items;

  const FloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items = const [
      NavItem(icon: LucideIcons.home, label: 'Home'),
      NavItem(icon: LucideIcons.search, label: 'Explore'),
      NavItem(icon: LucideIcons.shoppingBag, label: 'Shop'),
      NavItem(icon: LucideIcons.heart, label: 'Saved'),
      NavItem(icon: LucideIcons.user, label: 'Profile'),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppDimensions.paddingLg,
      right: AppDimensions.paddingLg,
      bottom: AppDimensions.paddingXl,
      child: GlassSurface(
        includeTopRadius: true,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
          vertical: AppDimensions.paddingSm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == currentIndex;
            
            return _NavBarItem(
              item: item,
              isSelected: isSelected,
              onTap: () => onTap(index),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  const NavItem({
    required this.icon,
    required this.label,
  });
}

class _NavBarItem extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
            vertical: AppDimensions.paddingSm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with animated selection state
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: EdgeInsets.all(isSelected ? 4 : 0),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  size: isSelected ? 24 : 22,
                  color: isSelected 
                      ? AppColors.primary 
                      : AppColors.textSecondary,
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Label with animated opacity
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 1.0 : 0.7,
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected 
                        ? AppColors.primary 
                        : AppColors.textSecondary,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Minimal icon button with circular background
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.glassBorder,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: size * 0.45,
          color: iconColor ?? AppColors.textPrimary,
        ),
      ),
    );
  }
}
