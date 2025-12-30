import 'package:flutter/material.dart';
import '../cards/glass_card.dart';

class FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavItem> items;
  final Widget? centerAction;

  const FloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.centerAction,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 32,
      right: 32,
      bottom: 32,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          GlassCard(
            borderRadius: 100, // Pill shape
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ...items
                    .sublist(0, (items.length / 2).floor())
                    .asMap()
                    .entries
                    .map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isSelected = index == currentIndex;
                      return _NavBarItem(
                        item: item,
                        isSelected: isSelected,
                        onTap: () => onTap(index),
                      );
                    }),
                if (centerAction != null)
                  const SizedBox(width: 60), // Space for center action
                ...items
                    .sublist((items.length / 2).floor())
                    .asMap()
                    .entries
                    .map((entry) {
                      final index = entry.key + (items.length / 2).floor();
                      final item = entry.value;
                      final isSelected = index == currentIndex;
                      return _NavBarItem(
                        item: item,
                        isSelected: isSelected,
                        onTap: () => onTap(index),
                      );
                    }),
              ],
            ),
          ),
          if (centerAction != null)
            Positioned(
              top: -24, // Adjusted for smaller button size
              child: centerAction!,
            ),
        ],
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  const NavItem({required this.icon, required this.label});
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              item.icon,
              size: 24,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          if (isSelected)
            const SizedBox(height: 4)
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
