import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../closet/providers/closet_provider.dart';
import '../models/outfit_item.dart';

/// Closet drawer for adding items to the canvas
class ClosetDrawer extends ConsumerWidget {
  const ClosetDrawer({
    super.key,
    required this.onAddItem,
    required this.isVisible,
    required this.onToggleVisibility,
  });

  final ValueChanged<OutfitStackItem> onAddItem;
  final bool isVisible;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredItems = ref.watch(filteredClosetProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isVisible ? 320 : 0,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(color: AppColors.glassBorder),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.pureBlack.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(-4, 0),
          ),
        ],
      ),
      child: isVisible
          ? Column(
              children: [
                _buildDrawerHeader(context, selectedCategory, ref),
                const SizedBox(height: 8),
                _buildCategoryChips(ref),
                const SizedBox(height: 8),
                _buildClosetContent(filteredItems),
              ],
            )
          : null,
    );
  }

  Widget _buildDrawerHeader(BuildContext context, String selectedCategory, WidgetRef ref) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.glassBorder),
        ),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.shirt, size: 20, color: AppColors.textPrimary),
          const SizedBox(width: 8),
          Text(
            'Closet',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              LucideIcons.x,
              size: 18,
              color: AppColors.textSecondary,
            ),
            onPressed: onToggleVisibility,
            tooltip: 'Close Closet',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(WidgetRef ref) {
    final categories = ['All', 'Tops', 'Bottoms', 'Shoes', 'Outerwear', 'Accessories'];
    
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = ref.watch(selectedCategoryProvider) == category;
          
          return FilterChip(
            label: Text(
              category,
              style: TextStyle(
                color: isSelected ? AppColors.pureBlack : AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            selected: isSelected,
            selectedColor: AppColors.surfaceLight,
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isSelected ? AppColors.pureBlack : AppColors.glassBorder,
                width: 1.5,
              ),
            ),
            onSelected: (selected) {
              if (selected) {
                ref.read(selectedCategoryProvider.notifier).setCategory(category);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildClosetContent(List<ClothingItem> items) {
    if (items.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.shirt, size: 48, color: AppColors.textSecondary),
              const SizedBox(height: 8),
              Text(
                'No Items',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Add items to your closet first',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ClosetItemCard(
            item: item,
            onAddToCanvas: onAddItem,
          );
        },
      ),
    );
  }
}

/// Individual closet item card with drag functionality
class ClosetItemCard extends StatelessWidget {
  const ClosetItemCard({
    super.key,
    required this.item,
    required this.onAddToCanvas,
  });

  final ClothingItem item;
  final ValueChanged<OutfitStackItem> onAddToCanvas;

  @override
  Widget build(BuildContext context) {
    return Draggable<OutfitStackItem>(
      data: OutfitStackItem(
        id: item.id,
        category: item.category,
        name: item.name,
        imageUrl: item.imageUrl,
        price: item.purchasePrice ?? 0.0,
      ),
      feedback: _buildDragFeedback(),
      childWhenDragging: _buildPlaceholder(),
      child: _buildItemCard(),
      onDragStarted: () {
        // Optional: Add haptic feedback or visual indication
      },
      onDraggableCanceled: (velocity, offset) {
        // Optional: Handle when drag is canceled
      },
    );
  }

  Widget _buildItemCard() {
    return GlassCard(
      padding: EdgeInsets.zero,
      onTap: () {
        // Optional: Show item details
      },
      child: Stack(
        children: [
          // Item Image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.surfaceLight,
                  child: const Icon(
                    LucideIcons.imageOff,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),

          // Overlay gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),

          // Category badge
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.pureBlack.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                item.category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Add to canvas button
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.pureBlack.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.plus,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),

          // Item info overlay
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.brand != null)
                  Text(
                    item.brand!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 8,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (100 + (item.id.hashCode % 100)).ms);
  }

  Widget _buildDragFeedback() {
    return Material(
      type: MaterialType.transparency,
      child: Transform.scale(
        scale: 1.2,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.pureBlack, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.pureBlack.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(
                LucideIcons.image,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
    );
  }
}

/// Enhanced GlassCard for closet items
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    required this.onTap,
    this.padding = const EdgeInsets.all(12),
  });

  final Widget child;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.glassBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.pureBlack.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

