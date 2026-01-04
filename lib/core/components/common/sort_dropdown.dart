import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../features/closet/providers/closet_provider.dart';

class SortDropdown extends ConsumerWidget {
  final double width;

  const SortDropdown({
    super.key,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortOption = ref.watch(sortOptionProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.surface : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
        border: Border.all(
          color: isDarkMode ? AppColors.glassBorder : AppColors.glassBorderDark,
          width: 1,
        ),
      ),
      child: DropdownButton<String>(
        value: sortOption,
        isExpanded: true,
        underline: Container(),
        icon: Icon(
          LucideIcons.chevronDown,
          size: 16,
          color: isDarkMode ? AppColors.textSecondary : AppColors.textTertiary,
        ),
        style: TextStyle(
          color: isDarkMode ? AppColors.textPrimary : AppColors.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        items: _getSortOptions().map((option) {
          return DropdownMenuItem<String>(
            value: option.value,
            child: Row(
              children: [
                Icon(
                  option.icon,
                  size: 14,
                  color: isDarkMode ? AppColors.textSecondary : AppColors.textTertiary,
                ),
                const SizedBox(width: 8),
                Text(
                  option.label,
                  style: TextStyle(
                    color: isDarkMode ? AppColors.textPrimary : AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            ref.read(sortOptionProvider.notifier).setSortOption(newValue);
          }
        },
        dropdownColor: isDarkMode ? AppColors.surface : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
        elevation: 8,
        menuMaxHeight: 300,
      ),
    );
  }

  List<_SortOption> _getSortOptions() {
    return [
      _SortOption(
        value: "name_asc",
        label: "Name (A-Z)",
        icon: LucideIcons.arrowUp,
      ),
      _SortOption(
        value: "name_desc",
        label: "Name (Z-A)",
        icon: LucideIcons.arrowDown,
      ),
      _SortOption(
        value: "date_added_asc",
        label: "Date Added (Old → New)",
        icon: LucideIcons.calendar,
      ),
      _SortOption(
        value: "date_added_desc",
        label: "Date Added (New → Old)",
        icon: LucideIcons.calendar,
      ),
      _SortOption(
        value: "last_worn_asc",
        label: "Last Worn (Old → New)",
        icon: LucideIcons.clock,
      ),
      _SortOption(
        value: "last_worn_desc",
        label: "Last Worn (New → Old)",
        icon: LucideIcons.clock,
      ),
      _SortOption(
        value: "category_asc",
        label: "Category (A-Z)",
        icon: LucideIcons.tag,
      ),
      _SortOption(
        value: "category_desc",
        label: "Category (Z-A)",
        icon: LucideIcons.tag,
      ),
    ];
  }
}

class _SortOption {
  final String value;
  final String label;
  final IconData icon;

  _SortOption({
    required this.value,
    required this.label,
    required this.icon,
  });
}
