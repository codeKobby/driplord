import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/components/common/driplord_scaffold.dart';
import '../../../core/components/cards/glass_card.dart';
import '../../../core/components/buttons/primary_button.dart';
import '../../../core/components/buttons/secondary_button.dart';
import '../../../core/components/buttons/primary_button.dart';
import '../../../core/components/buttons/secondary_button.dart';
import '../../../core/services/ai_image_service.dart';
import '../../../core/services/database_service.dart';
import '../../../core/providers/database_providers.dart';
import '../../closet/providers/closet_provider.dart';

/// Screen for reviewing AI-detected clothing items before adding to closet
class SegmentedItemsReviewScreen extends ConsumerStatefulWidget {
  final String imageUrl; // URL of the original image
  final List<DetectedClothingItem> detectedItems;
  final String source; // 'camera', 'gallery', or 'url'

  const SegmentedItemsReviewScreen({
    super.key,
    required this.imageUrl,
    required this.detectedItems,
    required this.source,
  });

  @override
  ConsumerState<SegmentedItemsReviewScreen> createState() =>
      _SegmentedItemsReviewScreenState();
}

class _SegmentedItemsReviewScreenState
    extends ConsumerState<SegmentedItemsReviewScreen> {
  late List<bool> _selectedItems;

  @override
  void initState() {
    super.initState();
    // Start with all items selected by default
    _selectedItems = List.filled(widget.detectedItems.length, true);
  }

  void _toggleItemSelection(int index) {
    setState(() {
      _selectedItems[index] = !_selectedItems[index];
    });
  }

  void _selectAll() {
    setState(() {
      _selectedItems = List.filled(widget.detectedItems.length, true);
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedItems = List.filled(widget.detectedItems.length, false);
    });
  }

  List<DetectedClothingItem> get _approvedItems {
    return widget.detectedItems
        .asMap()
        .entries
        .where((entry) => _selectedItems[entry.key])
        .map((entry) => entry.value)
        .toList();
  }

  bool _isSaving = false;

  Future<void> _addApprovedItems() async {
    final approvedItems = _approvedItems;

    if (approvedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one item to add'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final dbService = ref.read(databaseServiceProvider);
      // Determine if we need to upload the image
      // If widget.imageUrl matches widget.source path, it's local.
      // If widget.imageUrl starts with http, it is already a URL (e.g. pasted URL or re-edit)

      String finalImageUrl = widget.imageUrl;

      if (!widget.imageUrl.startsWith('http')) {
        // It is a local file path
        final file = File(widget.imageUrl);
        if (await file.exists()) {
          // Create a unique path: closet_items/{timestamp}_{uuid}.jpg
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          // Simple uuid-like suffix
          final randomSuffix = timestamp % 10000;
          final fileName = 'upload_${timestamp}_$randomSuffix.jpg';

          finalImageUrl = await dbService.uploadImage(file, fileName);
        }
      }

      // Save all approved items
      final List<ClothingItem> newItems = [];

      for (final detected in approvedItems) {
        final newItem = ClothingItem(
          id:
              DateTime.now().millisecondsSinceEpoch.toString() +
              detected.id, // Ensure unique ID
          name: detected.name,
          category: detected.category,
          imageUrl: finalImageUrl,
          color: detected.color,
          brand: detected.brand,
          addedDate: DateTime.now(),
          isAutoAdded: false, // User explicitly approved it
        );
        newItems.add(newItem);

        // Add to database via provider wrapper if available, or direct calls
        // The closetProvider.notifier.addItem handles DB call if authenticated
        await ref.read(closetProvider.notifier).addItem(newItem);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Successfully added ${newItems.length} item(s) to closet!',
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        context.go('/closet');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save items: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DripLordScaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                LucideIcons.x,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () => context.go('/closet'),
            ),
            title: Text(
              "Review Items",
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            centerTitle: true,
            actions: [
              PopupMenuButton<String>(
                icon: Icon(
                  LucideIcons.moreVertical,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'select_all':
                      _selectAll();
                      break;
                    case 'deselect_all':
                      _deselectAll();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'select_all',
                    child: Text('Select All'),
                  ),
                  const PopupMenuItem(
                    value: 'deselect_all',
                    child: Text('Deselect All'),
                  ),
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Original Image Preview
                  _buildOriginalImagePreview(),

                  const SizedBox(height: 24),

                  // Detected Items Summary
                  _buildSummaryHeader(),

                  const SizedBox(height: 16),

                  // Items Grid
                  _buildItemsGrid(),

                  const SizedBox(height: 32),

                  // Action Buttons
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOriginalImagePreview() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Original Image",
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: widget.imageUrl.startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(LucideIcons.imageOff, size: 48),
                    ),
                  )
                : Image.file(
                    File(widget.imageUrl),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(LucideIcons.imageOff, size: 48),
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            "AI detected ${widget.detectedItems.length} item(s)",
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader() {
    final approvedCount = _approvedItems.length;
    final totalCount = widget.detectedItems.length;

    return Row(
      children: [
        Expanded(
          child: Text(
            "Detected Items ($approvedCount/$totalCount selected)",
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: approvedCount > 0
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            approvedCount > 0 ? "Ready to Add" : "Select Items",
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: approvedCount > 0
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsGrid() {
    if (widget.detectedItems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(LucideIcons.shirt, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                "No clothing items detected",
                style: GoogleFonts.outfit(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: widget.detectedItems.length,
      itemBuilder: (context, index) {
        return _buildDetectedItemCard(widget.detectedItems[index], index);
      },
    );
  }

  Widget _buildDetectedItemCard(DetectedClothingItem item, int index) {
    final isSelected = _selectedItems[index];

    return GestureDetector(
      onTap: () => _toggleItemSelection(index),
      child: GlassCard(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Image (placeholder for now - would show segmented portion)
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(item.category),
                    size: 48,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 12),

                // Item Details
                Text(
                  item.name,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  "${item.category} • ${item.color}",
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),

                if (item.brand != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.brand!,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],

                const SizedBox(height: 8),

                // Confidence Score
                Row(
                  children: [
                    Icon(
                      LucideIcons.checkCircle,
                      size: 12,
                      color: item.confidence > 0.8
                          ? Theme.of(context).colorScheme.primary
                          : item.confidence > 0.6
                          ? Colors.orange
                          : Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${(item.confidence * 100).round()}%",
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Selection Indicator
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.outline.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  isSelected ? LucideIcons.check : LucideIcons.circle,
                  size: 14,
                  color: isSelected ? Colors.white : Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        PrimaryButton(
          text: _isSaving ? "Saving..." : "Add Selected Items (${_approvedItems.length})",
          onPressed: _isSaving || _approvedItems.isEmpty ? null : _addApprovedItems,
          isLoading: _isSaving,
          icon: _isSaving ? null : LucideIcons.plus,
        ),
        const SizedBox(height: 12),
        SecondaryButton(
          text: "Start Over",
          onPressed: () => context.pop(),
          icon: LucideIcons.rotateCcw,
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'tops':
        return LucideIcons.shirt;
      case 'bottoms':
        return LucideIcons.alignCenter; // Simple alternative
      case 'shoes':
        return LucideIcons.move; // Simple alternative
      case 'outerwear':
        return LucideIcons.cloud; // Simple alternative
      case 'accessories':
        return LucideIcons.watch;
      case 'hats':
        return LucideIcons.sun; // Simple alternative
      case 'bags':
        return LucideIcons.package; // Simple alternative
      case 'jewelry':
        return LucideIcons.gem;
      default:
        return LucideIcons.shirt;
    }
  }
}
