import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FixedBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavItem> items;
  final Widget? centerAction;

  const FixedBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.centerAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64, // Sleeker height
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Left items
              ...items
                  .sublist(0, (items.length / 2).floor())
                  .asMap()
                  .entries
                  .map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isSelected = index == currentIndex;
                    return Expanded(
                      child: _ModernNavItem(
                        item: item,
                        isSelected: isSelected,
                        onTap: () => onTap(index),
                      ),
                    );
                  }),

              // Center action button
              if (centerAction != null)
                Expanded(child: Center(child: centerAction!)),

              // Right items
              ...items.sublist((items.length / 2).floor()).asMap().entries.map((
                entry,
              ) {
                final index = entry.key + (items.length / 2).floor();
                final item = entry.value;
                final isSelected = index == currentIndex;
                return Expanded(
                  child: _ModernNavItem(
                    item: item,
                    isSelected: isSelected,
                    onTap: () => onTap(index),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  const NavItem({required this.icon, required this.label});
}

class _ModernNavItem extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModernNavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item.icon,
            size: 22,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              letterSpacing: 0.2,
            ),
          ),
          if (isSelected) ...[
            const SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
