import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/components/cards/glass_card.dart';
import '../../../core/components/buttons/primary_button.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/closet_provider.dart';
import '../components/closet_filter_sheet.dart';

class _AppColors {
  static Color getBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.background
      : const Color(0xFFFBF9F6); // Light cream

  static Color getTextPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  static Color getTextSecondary(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  static Color getGlassBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.glassBorder
      : AppColors.glassBorderDark;
}

class ClosetScreen extends ConsumerStatefulWidget {
  const ClosetScreen({super.key});

  @override
  ConsumerState<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends ConsumerState<ClosetScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        ref.read(searchQueryProvider.notifier).setSearchQuery("");
      }
    });
  }

  void _syncSearchState() {
    // Listen to search query changes to reset UI when state is cleared externally (e.g. from MainScaffold)
    ref.listen(searchQueryProvider, (previous, next) {
      if (next.isEmpty && _isSearching) {
        setState(() {
          _isSearching = false;
          _searchController.clear();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _syncSearchState();

    return Scaffold(
      backgroundColor: _AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLg,
          ),
          child: _isSearching
              ? _buildAnimatedSearch()
              : Text(
                  "My Closet",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: _AppColors.getTextPrimary(context),
                  ),
                ),
        ),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(LucideIcons.search),
              onPressed: _toggleSearch,
              color: _AppColors.getTextPrimary(context),
            ),
          IconButton(
            icon: const Icon(LucideIcons.sliders),
            onPressed: _showFilterSheet,
            color: _AppColors.getTextPrimary(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    final loadState = ref.watch(closetLoadStateProvider);
    final errorMessage = ref.watch(closetErrorProvider);
    final filteredItems = ref.watch(filteredClosetProvider);

    // Show loading state
    if (loadState == ClosetLoadState.loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              "Syncing your closet...",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: _AppColors.getTextSecondary(context),
              ),
            ),
          ],
        ).animate().fadeIn(),
      );
    }

    // Show error state
    if (loadState == ClosetLoadState.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.wifiOff,
                size: 64,
                color: _AppColors.getTextSecondary(
                  context,
                ).withValues(alpha: 0.5),
              ),
              const SizedBox(height: 24),
              Text(
                "Connection Error",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: _AppColors.getTextPrimary(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage ?? "Failed to load your closet",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: _AppColors.getTextSecondary(context),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: "Try Again",
                onPressed: () {
                  ref.invalidate(closetProvider);
                },
                icon: LucideIcons.refreshCw,
              ),
            ],
          ).animate().fadeIn(),
        ),
      );
    }

    // Loaded state - show content or empty
    if (filteredItems.isEmpty && !_isSearching) {
      return _buildEmptyState();
    }
    return _buildClosetContent(filteredItems);
  }

  Widget _buildAnimatedSearch() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: _AppColors.getTextPrimary(
                    context,
                  ).withValues(alpha: 0.8),
                  width: 2.0,
                ),
              ),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search closet...",
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: _AppColors.getTextSecondary(
                    context,
                  ).withValues(alpha: 0.6),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                isDense: true,
              ),
              style: TextStyle(
                color: _AppColors.getTextPrimary(context),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 150), () {
                  ref.read(searchQueryProvider.notifier).setSearchQuery(value);
                });
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          icon: const Icon(LucideIcons.x, size: 20),
          onPressed: _toggleSearch,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          color: _AppColors.getTextPrimary(context).withValues(alpha: 0.6),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.shirt,
            size: 80,
            color: _AppColors.getTextSecondary(context),
          ),
          const SizedBox(height: 24),
          Text(
            "Your closet is empty",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: _AppColors.getTextPrimary(context),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add your first clothing item to get started",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: _AppColors.getTextSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          PrimaryButton(
            text: "Get Started",
            onPressed: () {
              context.push('/closet/add');
            },
            icon: LucideIcons.plus,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildClosetContent(List<ClothingItem> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip("All"),
                const SizedBox(width: 8),
                _buildFilterChip("Tops"),
                const SizedBox(width: 8),
                _buildFilterChip("Bottoms"),
                const SizedBox(width: 8),
                _buildFilterChip("Shoes"),
                const SizedBox(width: 8),
                _buildFilterChip("Outerwear"),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (_isSearching &&
              items.isNotEmpty &&
              ref.watch(searchQueryProvider).isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                "${items.length} items found",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _AppColors.getTextSecondary(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          Expanded(
            child: items.isEmpty
                ? (ref.watch(searchQueryProvider).isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.searchX,
                                size: 48,
                                color: _AppColors.getTextSecondary(
                                  context,
                                ).withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No results",
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: _AppColors.getTextPrimary(context),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Try searching for something else",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: _AppColors.getTextSecondary(
                                        context,
                                      ),
                                    ),
                              ),
                            ],
                          ).animate().fadeIn(),
                        )
                      : _buildEmptyState())
                : GridView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return _buildClosetItemCard(items[index], index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ClosetFilterSheet(),
    );
  }

  Widget _buildFilterChip(String label) {
    final currentCategory = ref.watch(selectedCategoryProvider);
    final isSelected = currentCategory == label;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          ref.read(selectedCategoryProvider.notifier).setCategory(label);
        }
      },
      selectedColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Colors.transparent,
      labelStyle: TextStyle(
        color: isSelected
            ? Theme.of(context).colorScheme.onPrimary
            : _AppColors.getTextPrimary(context),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : _AppColors.getGlassBorder(context),
          width: 1.2,
        ),
      ),
      showCheckmark: false,
    );
  }

  Widget _buildClosetItemCard(ClothingItem item, int index) {
    final isRecentlyAdded = item.addedDate.isAfter(
      DateTime.now().subtract(const Duration(days: 7)),
    );

    return GlassCard(
          padding: EdgeInsets.zero,
          onTap: () {
            context.push('/closet/item/${item.id}');
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        LucideIcons.imageOff,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 8,
                right: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.heart,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                    if (isRecentlyAdded)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "NEW",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item.brand ?? 'Essential',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: (100 + index * 30).ms)
        .scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutBack);
  }
}
