import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../features/closet/providers/closet_provider.dart';

class FilterChips extends ConsumerStatefulWidget {
  final bool showCategoryFilters;
  final bool showAdvancedFilters;

  const FilterChips({
    super.key,
    this.showCategoryFilters = true,
    this.showAdvancedFilters = true,
  });

  @override
  ConsumerState<FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends ConsumerState<FilterChips> {
  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(filterOptionsProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (widget.showCategoryFilters) ...[
            _buildFilterChip(
              context,
              "All",
              isSelected: ref.watch(selectedCategoryProvider) == "All",
              onTap: () => ref.read(selectedCategoryProvider.notifier).setCategory("All"),
              isDarkMode: isDarkMode,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              context,
              "Tops",
              isSelected: ref.watch(selectedCategoryProvider) == "Tops",
              onTap: () => ref.read(selectedCategoryProvider.notifier).setCategory("Tops"),
              isDarkMode: isDarkMode,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              context,
              "Bottoms",
              isSelected: ref.watch(selectedCategoryProvider) == "Bottoms",
              onTap: () => ref.read(selectedCategoryProvider.notifier).setCategory("Bottoms"),
              isDarkMode: isDarkMode,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              context,
              "Shoes",
              isSelected: ref.watch(selectedCategoryProvider) == "Shoes",
              onTap: () => ref.read(selectedCategoryProvider.notifier).setCategory("Shoes"),
              isDarkMode: isDarkMode,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              context,
              "Outerwear",
              isSelected: ref.watch(selectedCategoryProvider) == "Outerwear",
              onTap: () => ref.read(selectedCategoryProvider.notifier).setCategory("Outerwear"),
              isDarkMode: isDarkMode,
            ),
            const SizedBox(width: 8),
          ],

          // Advanced filters
          if (widget.showAdvancedFilters) ...[
            _buildAdvancedFilterChip(
              context,
              "Worn Recently",
              LucideIcons.clock,
              isActive: filters.contains('worn_recently'),
              onTap: () => _toggleFilter('worn_recently'),
              isDarkMode: isDarkMode,
            ),
            const SizedBox(width: 8),
            _buildAdvancedFilterChip(
              context,
              "Unworn",
              LucideIcons.eyeOff,
              isActive: filters.contains('unworn'),
              onTap: () => _toggleFilter('unworn'),
              isDarkMode: isDarkMode,
            ),
            const SizedBox(width: 8),
            _buildAdvancedFilterChip(
              context,
              "Favorites",
              LucideIcons.heart,
              isActive: filters.contains('favorites'),
              onTap: () => _toggleFilter('favorites'),
              isDarkMode: isDarkMode,
            ),
            const SizedBox(width: 8),
            _buildAdvancedFilterChip(
              context,
              "Auto Added",
              LucideIcons.download,
              isActive: filters.contains('auto_added'),
              onTap: () => _toggleFilter('auto_added'),
              isDarkMode: isDarkMode,
            ),
            const SizedBox(width: 8),
          ],

          // Clear all filters button
          if (filters.isNotEmpty || widget.showAdvancedFilters)
            _buildClearFiltersButton(context),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? (isDarkMode ? AppColors.textOnPrimary : AppColors.primaryDark)
              : (isDarkMode ? AppColors.textPrimary : AppColors.textSecondary),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      backgroundColor: isDarkMode ? AppColors.surface : Colors.white,
      selectedColor: isDarkMode ? AppColors.primary : AppColors.surfaceLight,
      checkmarkColor: isDarkMode ? AppColors.textOnPrimary : AppColors.primaryDark,
      side: BorderSide(
        color: isSelected
            ? (isDarkMode ? AppColors.primary : AppColors.borderLight)
            : (isDarkMode ? AppColors.border : AppColors.glassBorderDark),
        width: isSelected ? 2 : 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        onTap();
      },
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 0,
      pressElevation: 2,
      shadowColor: Colors.transparent,
      selectedShadowColor: Colors.transparent,
    );
  }

  Widget _buildAdvancedFilterChip(
    BuildContext context,
    String label,
    IconData icon, {
    required bool isActive,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isActive
                ? (isDarkMode ? AppColors.textOnPrimary : AppColors.primaryDark)
                : (isDarkMode ? AppColors.textSecondary : AppColors.textTertiary),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? (isDarkMode ? AppColors.textOnPrimary : AppColors.primaryDark)
                  : (isDarkMode ? AppColors.textSecondary : AppColors.textTertiary),
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
      avatar: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: isActive
            ? const Icon(
                LucideIcons.check,
                size: 9,
                color: AppColors.textOnPrimary,
              )
            : null,
      ),
      backgroundColor: isDarkMode ? AppColors.surface : AppColors.surfaceLight,
      selectedColor: isDarkMode ? AppColors.primary : AppColors.surfaceLight,
      side: BorderSide(
        color: isActive
            ? (isDarkMode ? AppColors.primary : AppColors.borderLight)
            : (isDarkMode ? AppColors.border : AppColors.glassBorderDark),
        width: isActive ? 2 : 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      selected: isActive,
      onSelected: (bool selected) {
        if (selected) {
          onTap();
        }
      },
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      labelPadding: const EdgeInsets.only(left: 4),
      elevation: 0,
      pressElevation: 2,
      shadowColor: Colors.transparent,
      selectedShadowColor: Colors.transparent,
    );
  }

  Widget _buildClearFiltersButton(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.x,
            size: 12,
            color: isDarkMode ? AppColors.textSecondary : AppColors.textTertiary,
          ),
          const SizedBox(width: 4),
          Text(
            "Clear All",
            style: TextStyle(
              color: isDarkMode ? AppColors.textSecondary : AppColors.textTertiary,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
      backgroundColor: isDarkMode ? AppColors.surface : AppColors.surfaceLight,
      selectedColor: AppColors.error,
      side: BorderSide(
        color: isDarkMode ? AppColors.border : AppColors.glassBorderDark,
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      selected: false, // Always false for clear button
      onSelected: (_) {
        // Clear all filters
        ref.read(filterOptionsProvider.notifier).clearAllFilters();
        // Reset category to All
        ref.read(selectedCategoryProvider.notifier).setCategory("All");
      },
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      labelPadding: const EdgeInsets.only(left: 4),
      elevation: 0,
      pressElevation: 2,
      shadowColor: Colors.transparent,
      selectedShadowColor: Colors.transparent,
    );
  }

  void _toggleFilter(String filter) {
    ref.read(filterOptionsProvider.notifier).toggleFilter(filter);
  }
}
