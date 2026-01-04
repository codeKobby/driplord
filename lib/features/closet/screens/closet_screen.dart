import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/components/cards/glass_card.dart';
import '../../../core/components/buttons/primary_button.dart';
import '../../../core/components/buttons/secondary_button.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/closet_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _AppColors {
  static Color getBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.background
      : const Color(0xFFFBF9F6); // Light cream

  static Color getSurface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.surface
      : Colors.white;

  static Color getTextPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.textPrimary
      : Colors.black;

  static Color getTextSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.textSecondary
      : Colors.black54;

  static Color getGlassBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.glassBorder
      : AppColors.glassBorderDark;

  static Color getPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.primary
      : Colors.black;

  static Color getTextOnPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.textOnPrimary
      : Colors.white;
}

class ClosetScreen extends ConsumerStatefulWidget {
  const ClosetScreen({super.key});

  @override
  ConsumerState<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends ConsumerState<ClosetScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final filteredItems = ref.watch(filteredClosetProvider);
    return Scaffold(
      backgroundColor: _AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "My Closet",
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: _AppColors.getTextPrimary(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () {},
            color: _AppColors.getTextPrimary(context),
          ),
        ],
      ),
      body: SafeArea(
        child: filteredItems.isEmpty
            ? _buildEmptyState()
            : _buildClosetGrid(filteredItems),
      ),
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
          Column(
            children: [
              PrimaryButton(
                text: "Add from Gallery",
                onPressed: _addClothing,
                icon: LucideIcons.image,
              ),
              const SizedBox(height: 16),
              SecondaryButton(
                text: "Take Photo",
                onPressed: _addClothingFromCamera,
                icon: LucideIcons.camera,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildClosetGrid(List<ClothingItem> items) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  context,
                  "All",
                  isSelected: ref.watch(selectedCategoryProvider) == "All",
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  "Tops",
                  isSelected: ref.watch(selectedCategoryProvider) == "Tops",
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  "Bottoms",
                  isSelected: ref.watch(selectedCategoryProvider) == "Bottoms",
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  "Shoes",
                  isSelected: ref.watch(selectedCategoryProvider) == "Shoes",
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  "Outerwear",
                  isSelected: ref.watch(selectedCategoryProvider) == "Outerwear",
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Grid view
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0, // Square cards to prevent overflow
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildClosetItemCard(item, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label, {
    bool isSelected = false,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? _AppColors.getTextOnPrimary(context)
              : _AppColors.getTextPrimary(context),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      labelStyle: TextStyle(
        color: isSelected
            ? _AppColors.getTextOnPrimary(context)
            : _AppColors.getTextPrimary(context),
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      backgroundColor: _AppColors.getSurface(context),
      selectedColor: _AppColors.getPrimary(context),
      checkmarkColor: _AppColors.getTextOnPrimary(context),
      side: BorderSide(
        color: isSelected
            ? _AppColors.getPrimary(context)
            : _AppColors.getGlassBorder(context),
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        ref.read(selectedCategoryProvider.notifier).setCategory(label);
      },
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 0,
      pressElevation: 2,
      shadowColor: Colors.transparent,
      selectedShadowColor: Colors.transparent,
    );
  }

  Widget _buildClosetItemCard(ClothingItem item, int index) {
    final isRecentlyAdded = item.addedDate.isAfter(
      DateTime.now().subtract(const Duration(days: 7)),
    );

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Main image container (takes full card)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              image: DecorationImage(
                image: NetworkImage(item.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient overlay for text readability
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),

          // Content overlay
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: badges and favorite
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Right side: color indicator and favorite
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (item.color != null)
                          Container(
                            width: 16,
                            height: 16,
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: _getColorFromString(item.color!),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _AppColors.getSurface(
                                  context,
                                ).withValues(alpha: 0.8),
                                width: 1,
                              ),
                            ),
                          ),

                        // Favorite icon
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _AppColors.getSurface(
                              context,
                            ).withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            LucideIcons.heart,
                            size: 14,
                            color: _AppColors.getTextSecondary(context),
                          ),
                        ),

                        // NEW badge (if recently added)
                        if (isRecentlyAdded)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _AppColors.getPrimary(context),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "NEW",
                              style: TextStyle(
                                color: AppColors.textOnPrimary,
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

                const Spacer(),

                // Bottom content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item name
                    Text(
                      item.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 2),

                    // Brand
                    Text(
                      item.brand ?? 'Unknown Brand',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Auto-added indicator (if applicable)
          if (item.isAutoAdded)
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "AUTO",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    ).animate().fadeIn(delay: (200 + index * 50).ms);
  }

  Future<void> _addClothing() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // TODO: Upload image to Supabase Storage and save to database
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Image selected! (Upload coming soon)"),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to pick image: ${e.toString()}"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _addClothingFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        // TODO: Upload image to Supabase Storage and save to database
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Photo taken! (Upload coming soon)"),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to take photo: ${e.toString()}"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'white':
        return Colors.white;
      case 'black':
        return Colors.black;
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'orange':
        return Colors.orange;
      case 'gray':
      case 'grey':
        return Colors.grey;
      default:
        return AppColors.textSecondary;
    }
  }
}
