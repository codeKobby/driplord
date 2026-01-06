import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../components/selection_system.dart';

/// Professional Layer Panel - Canva-style side panel for layer management
class ProfessionalLayerPanel extends ConsumerWidget {
  const ProfessionalLayerPanel({
    super.key,
    required this.items,
    required this.selectedItemId,
    required this.onItemSelect,
    required this.onItemReorder,
    required this.onItemToggleVisibility,
    required this.onItemToggleLock,
    required this.onItemRemove,
    required this.onItemOpacityChange,
    required this.onClose,
  });

  final List<CanvasItem> items;
  final String? selectedItemId;
  final ValueChanged<String> onItemSelect;
  final ValueChanged<String> onItemReorder;
  final ValueChanged<String> onItemToggleVisibility;
  final ValueChanged<String> onItemToggleLock;
  final ValueChanged<String> onItemRemove;
  final ValueChanged<Map<String, double>> onItemOpacityChange;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          left: BorderSide(color: colorScheme.outline),
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
          _buildPanelHeader(context),
          const SizedBox(height: 8),
          _buildLayerList(context),
        ],
      ),
    );
  }

  Widget _buildPanelHeader(BuildContext context) {
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
          Icon(LucideIcons.layers, size: 20, color: colorScheme.onSurface),
          const SizedBox(width: 8),
          Text(
            'Layers',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              LucideIcons.x,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: onClose,
            tooltip: 'Close Layers',
          ),
        ],
      ),
    );
  }

  Widget _buildLayerList(BuildContext context) {
    if (items.isEmpty) {
      final colorScheme = Theme.of(context).colorScheme;
      return Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.layers, size: 48, color: colorScheme.onSurfaceVariant),
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
                'Add items to see layers',
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
      child: ReorderableListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        onReorder: (oldIndex, newIndex) {
          // Handle reordering
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = items.removeAt(oldIndex);
          items.insert(newIndex, item);

          // Update z-indexes based on new order
          for (int i = 0; i < items.length; i++) {
            items[i].zIndex = (items.length - 1 - i) * 10;
          }

          onItemReorder(item.id);
        },
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = selectedItemId == item.id;

          return _buildLayerItem(item, isSelected, index, index);
        },
      ),
    );
  }

  Widget _buildLayerItem(CanvasItem item, bool isSelected, int index, int listIndex) {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Container(
          key: ValueKey(item.id),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary.withValues(alpha: 0.1) : colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? colorScheme.primary : colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: InkWell(
            onTap: () => onItemSelect(item.id),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Item thumbnail - using cached network image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: item.data.imageUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const SizedBox.shrink(),
                          errorWidget: (context, url, error) =>
                              const Icon(LucideIcons.image, size: 20),
                          // Cache settings to prevent re-fetching
                          maxWidthDiskCache: 200,
                          maxHeightDiskCache: 200,
                          memCacheWidth: 80,
                          memCacheHeight: 80,
                          useOldImageOnUrlChange: true,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Item info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.data.name,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              item.data.category,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Layer controls
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              item.isVisible ?? true
                                  ? LucideIcons.eye
                                  : LucideIcons.eyeOff,
                              size: 16,
                              color: item.isVisible ?? true
                                  ? colorScheme.onSurfaceVariant
                                  : colorScheme.error,
                            ),
                            onPressed: () => onItemToggleVisibility(item.id),
                            tooltip: item.isVisible ?? true ? 'Hide' : 'Show',
                          ),
                          IconButton(
                            icon: Icon(
                              item.isLocked ?? false
                                  ? LucideIcons.lock
                                  : LucideIcons.unlock,
                              size: 16,
                              color: item.isLocked ?? false
                                  ? colorScheme.error
                                  : colorScheme.onSurfaceVariant,
                            ),
                            onPressed: () => onItemToggleLock(item.id),
                            tooltip: item.isLocked ?? false ? 'Unlock' : 'Lock',
                          ),
                          IconButton(
                            icon: Icon(
                              LucideIcons.trash2,
                              size: 16,
                              color: colorScheme.error,
                            ),
                            onPressed: () => onItemRemove(item.id),
                            tooltip: 'Remove',
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Opacity control (only show when selected)
                  if (isSelected) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.eye,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Slider(
                            value: item.opacity ?? 1.0,
                            min: 0.0,
                            max: 1.0,
                            activeColor: colorScheme.primary,
                            inactiveColor: colorScheme.outline,
                            onChanged: (value) {
                              onItemOpacityChange({item.id: value});
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${((item.opacity ?? 1.0) * 100).toInt()}%',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    // Layer info
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Z-Index: ${item.zIndex}',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Scale: ${item.scale.toStringAsFixed(1)}x',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: (index * 50).ms);
      },
    );
  }
}
