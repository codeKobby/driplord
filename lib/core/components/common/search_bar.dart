import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../features/closet/providers/closet_provider.dart';

class SearchBar extends ConsumerStatefulWidget {
  final double height;
  final Color? backgroundColor;
  final bool showDivider;

  const SearchBar({
    super.key,
    this.height = 48,
    this.backgroundColor,
    this.showDivider = true,
  });

  @override
  ConsumerState<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<SearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    // Listen to changes and update the search query
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Update the search query in the provider
    ref.read(searchQueryProvider.notifier).setSearchQuery(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = widget.backgroundColor ??
        (isDarkMode ? AppColors.glassSurface : Colors.white);

    return Container(
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
        border: Border.all(
          color: isDarkMode ? AppColors.glassBorder : AppColors.glassBorderDark,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.search,
            size: 20,
            color: isDarkMode ? AppColors.textSecondary : AppColors.textTertiary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Search your closet...",
                hintStyle: TextStyle(
                  color: isDarkMode ? AppColors.textSecondary : AppColors.textTertiary,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(
                color: isDarkMode ? AppColors.textPrimary : AppColors.textPrimary,
                fontSize: 14,
              ),
              cursorColor: isDarkMode ? AppColors.primary : AppColors.primaryDark,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) {
                // Keep focus on search bar
                FocusScope.of(context).requestFocus(_controller.text.isEmpty ? FocusNode() : FocusNode());
              },
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: Icon(
                LucideIcons.x,
                size: 18,
                color: isDarkMode ? AppColors.textSecondary : AppColors.textTertiary,
              ),
              onPressed: () {
                _controller.clear();
                // Clear search query
                ref.read(searchQueryProvider.notifier).setSearchQuery("");
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 20,
            ),
        ],
      ),
    );
  }
}
