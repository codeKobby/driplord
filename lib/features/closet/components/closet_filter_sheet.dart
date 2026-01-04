import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/components/cards/glass_card.dart';
import '../../../core/components/buttons/primary_button.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/closet_provider.dart';

class ClosetFilterSheet extends ConsumerWidget {
  const ClosetFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GlassSurface(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filter & Sort",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? AppColors.textPrimary : Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.x),
                onPressed: () => Navigator.pop(context),
                color: isDarkMode ? AppColors.textSecondary : Colors.black54,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Sort Section
          Text(
            "Sort By",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isDarkMode ? AppColors.textSecondary : Colors.black54,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SortChip(
                label: "Name (A-Z)",
                value: "name_asc",
                icon: LucideIcons.arrowUp,
              ),
              _SortChip(
                label: "Date Added",
                value: "date_added_desc",
                icon: LucideIcons.calendar,
              ),
              _SortChip(
                label: "Recently Worn",
                value: "last_worn_desc",
                icon: LucideIcons.clock,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Filters Section
          Text(
            "Filters",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isDarkMode ? AppColors.textSecondary : Colors.black54,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterChip(
                label: "Worn Recently",
                filterKey: "worn_recently",
                icon: LucideIcons.clock,
              ),
              _FilterChip(
                label: "Unworn (30d+)",
                filterKey: "unworn",
                icon: LucideIcons.eyeOff,
              ),
              _FilterChip(
                label: "Auto Added",
                filterKey: "auto_added",
                icon: LucideIcons.download,
              ),
              _FilterChip(
                label: "Manual Only",
                filterKey: "favorites",
                icon: LucideIcons.user,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(filterOptionsProvider.notifier).clearAllFilters();
                    ref
                        .read(sortOptionProvider.notifier)
                        .setSortOption("name_asc");
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: isDarkMode
                          ? AppColors.glassBorder
                          : Colors.black12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                    ),
                  ),
                  child: Text(
                    "RESET",
                    style: TextStyle(
                      color: isDarkMode ? AppColors.textPrimary : Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PrimaryButton(
                  text: "Apply",
                  onPressed: () => Navigator.pop(context),
                  fullWidth: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SortChip extends ConsumerWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SortChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(sortOptionProvider);
    final isSelected = currentSort == value;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          ref.read(sortOptionProvider.notifier).setSortOption(value);
        }
      },
      avatar: Icon(
        icon,
        size: 14,
        color: isSelected
            ? (isDarkMode ? AppColors.textOnPrimary : Colors.white)
            : (isDarkMode ? AppColors.textSecondary : Colors.black54),
      ),
      selectedColor: isDarkMode ? AppColors.primary : Colors.black,
      backgroundColor: isDarkMode
          ? AppColors.surface
          : Colors.black12.withValues(alpha: 0.05),
      labelStyle: TextStyle(
        color: isSelected
            ? (isDarkMode ? AppColors.textOnPrimary : Colors.white)
            : (isDarkMode ? AppColors.textPrimary : Colors.black),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? (isDarkMode ? AppColors.primary : Colors.black)
              : (isDarkMode ? AppColors.glassBorder : Colors.transparent),
        ),
      ),
    );
  }
}

class _FilterChip extends ConsumerWidget {
  final String label;
  final String filterKey;
  final IconData icon;

  const _FilterChip({
    required this.label,
    required this.filterKey,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(filterOptionsProvider);
    final isSelected = activeFilters.contains(filterKey);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        ref.read(filterOptionsProvider.notifier).toggleFilter(filterKey);
      },
      avatar: Icon(
        icon,
        size: 14,
        color: isSelected
            ? (isDarkMode ? AppColors.textOnPrimary : Colors.white)
            : (isDarkMode ? AppColors.textSecondary : Colors.black54),
      ),
      selectedColor: isDarkMode ? AppColors.primary : Colors.black,
      backgroundColor: isDarkMode
          ? AppColors.surface
          : Colors.black12.withValues(alpha: 0.05),
      checkmarkColor: isDarkMode ? AppColors.textOnPrimary : Colors.white,
      labelStyle: TextStyle(
        color: isSelected
            ? (isDarkMode ? AppColors.textOnPrimary : Colors.white)
            : (isDarkMode ? AppColors.textPrimary : Colors.black),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? (isDarkMode ? AppColors.primary : Colors.black)
              : (isDarkMode ? AppColors.glassBorder : Colors.transparent),
        ),
      ),
    );
  }
}
