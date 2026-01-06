import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../closet/providers/closet_provider.dart';
import '../models/outfit_item.dart';
import '../components/selection_system.dart';

/// Professional Closet Panel - Canva-style side panel for adding items
class ProfessionalClosetPanel extends ConsumerStatefulWidget {
  const ProfessionalClosetPanel({
    super.key,
    required this.onAddItem,
    required this.onClose,
    required this.canvasItems,
  });

  final ValueChanged<OutfitStackItem> onAddItem;
  final VoidCallback onClose;
  final List<CanvasItem> canvasItems;

  @override
  ConsumerState<ProfessionalClosetPanel> createState() => _ProfessionalClosetPanelState();
}

class _ProfessionalClosetPanelState extends ConsumerState<ProfessionalClosetPanel> {
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

  @override
  Widget build(BuildContext context) {
    final filteredItems = ref.watch(filteredClosetProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          right: BorderSide(color: colorScheme.outline),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPanelHeader(context, selectedCategory, ref),
          const SizedBox(height: 8),
          if (_isSearching)
            _buildSearchBar(context)
          else
            _buildCategoryChips(ref),
          const SizedBox(height: 8),
          _buildClosetContent(context, filteredItems),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                    width: 1.5,
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
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  isDense: true,
                ),
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 14,
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
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(LucideIcons.x, size: 18),
            onPressed: _toggleSearch,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildPanelHeader(BuildContext context, String selectedCategory, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outline),
        ),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.shirt, size: 20, color: colorScheme.onSurface),
          const SizedBox(width: 8),
          Text(
            'Closet',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          IconButton(
            icon: Icon(
              LucideIcons.search,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: _toggleSearch,
            tooltip: 'Search Closet',
          ),
          IconButton(
            icon: Icon(
              LucideIcons.x,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: widget.onClose,
            tooltip: 'Close Closet',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(WidgetRef ref) {
    final categories = ['All', 'Tops', 'Bottoms', 'Shoes', 'Outerwear', 'Accessories'];

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = ref.watch(selectedCategoryProvider) == category;
          final colorScheme = Theme.of(context).colorScheme;

          return FilterChip(
            label: Text(
              category,
              style: TextStyle(
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            selected: isSelected,
            selectedColor: colorScheme.primary,
            backgroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isSelected ? colorScheme.primary : colorScheme.outline,
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

  Widget _buildClosetContent(BuildContext context, List<ClothingItem> items) {
    if (items.isEmpty) {
      final colorScheme = Theme.of(context).colorScheme;
      return Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.shirt, size: 48, color: colorScheme.onSurfaceVariant),
              const SizedBox(height: 8),
              Text(
                'No Items',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Add items to your closet first',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.85,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          // Check if this item is already on the canvas
          final isAlreadyAdded = widget.canvasItems.any((canvasItem) =>
            canvasItem.data.id == item.id ||
            canvasItem.data.imageUrl == item.imageUrl
          );

          return ProfessionalClosetItemCard(
            item: item,
            onAddToCanvas: widget.onAddItem,
            isAlreadyAdded: isAlreadyAdded,
          );
        },
      ),
    );
  }
}

/// Professional Closet Item Card - Clean, plus icon interface
class ProfessionalClosetItemCard extends StatelessWidget {
  const ProfessionalClosetItemCard({
    super.key,
    required this.item,
    required this.onAddToCanvas,
    required this.isAlreadyAdded,
  });

  final ClothingItem item;
  final ValueChanged<OutfitStackItem> onAddToCanvas;
  final bool isAlreadyAdded;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return _buildItemCard(colorScheme);
  }

  Widget _buildItemCard(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    LucideIcons.imageOff,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    colorScheme.shadow.withValues(alpha: 0.4),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.shadow.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                item.category,
                style: TextStyle(
                  color: colorScheme.surface,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: InkWell(
              onTap: () {
                final outfitItem = OutfitStackItem(
                  id: item.id,
                  category: item.category,
                  name: item.name,
                  imageUrl: item.imageUrl,
                  price: item.purchasePrice ?? 0.0,
                );
                onAddToCanvas(outfitItem);
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isAlreadyAdded
                      ? colorScheme.tertiary.withValues(alpha: 0.9)
                      : colorScheme.primary.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  isAlreadyAdded ? LucideIcons.check : LucideIcons.plus,
                  size: 16,
                  color: colorScheme.surface,
                ),
              ),
            ),
          ),
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
                  style: TextStyle(
                    color: colorScheme.surface,
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
                      color: colorScheme.surface.withValues(alpha: 0.7),
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


}
