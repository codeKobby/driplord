import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../components/selection_system.dart';

/// Collapsible layer management panel for the canvas
class LayerPanel extends ConsumerWidget {
  const LayerPanel({
    super.key,
    required this.items,
    required this.selectedItemId,
    required this.onItemSelect,
    required this.onItemReorder,
    required this.onItemToggleVisibility,
    required this.onItemToggleLock,
    required this.onItemRemove,
    required this.onItemOpacityChange,
    required this.isVisible,
    required this.onToggleVisibility,
  });

  final List<CanvasItem> items;
  final String? selectedItemId;
  final ValueChanged<String> onItemSelect;
  final ValueChanged<String> onItemReorder;
  final ValueChanged<String> onItemToggleVisibility;
  final ValueChanged<String> onItemToggleLock;
  final ValueChanged<String> onItemRemove;
  final ValueChanged<Map<String, double>> onItemOpacityChange;
  final bool isVisible;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isVisible ? 320 : 0,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          left: BorderSide(color: AppColors.glassBorder),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.pureBlack.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: isVisible
          ? Column(
              children: [
                _buildPanelHeader(),
                const SizedBox(height: 8),
                _buildLayerList(),
              ],
            )
          : null,
    );
  }

  Widget _buildPanelHeader() {
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
          Icon(LucideIcons.layers, size: 20, color: AppColors.textPrimary),
          const SizedBox(width: 8),
          Text(
            'Layers',
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
            tooltip: 'Close Layers',
          ),
        ],
      ),
    );
  }

  Widget _buildLayerList() {
    if (items.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.layers, size: 48, color: AppColors.textSecondary),
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
                'Add items to see layers',
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
      child: ReorderableListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return LayerItem(
            key: Key(item.id),
            item: item,
            isSelected: selectedItemId == item.id,
            onItemSelect: onItemSelect,
            onItemToggleVisibility: onItemToggleVisibility,
            onItemToggleLock: onItemToggleLock,
            onItemRemove: onItemRemove,
            onItemOpacityChange: onItemOpacityChange,
          );
        },
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = items.removeAt(oldIndex);
          items.insert(newIndex, item);
          onItemReorder(item.id);
        },
      ),
    );
  }
}

/// Individual layer item in the layer panel
class LayerItem extends StatelessWidget {
  const LayerItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onItemSelect,
    required this.onItemToggleVisibility,
    required this.onItemToggleLock,
    required this.onItemRemove,
    required this.onItemOpacityChange,
  });

  final CanvasItem item;
  final bool isSelected;
  final ValueChanged<String> onItemSelect;
  final ValueChanged<String> onItemToggleVisibility;
  final ValueChanged<String> onItemToggleLock;
  final ValueChanged<String> onItemRemove;
  final ValueChanged<Map<String, double>> onItemOpacityChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.surfaceLight : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.pureBlack : AppColors.glassBorder,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.pureBlack.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          // Layer Header
          _buildLayerHeader(),
          
          // Layer Controls
          _buildLayerControls(),
        ],
      ),
    ).animate().fade(duration: 150.ms).scale();
  }

  Widget _buildLayerHeader() {
    return InkWell(
      onTap: () => onItemSelect(item.id),
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            // Drag Handle
            Icon(
              LucideIcons.gripVertical,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),

            // Item Preview
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  item.data.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(LucideIcons.image, color: AppColors.textSecondary),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Item Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.data.name,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item.data.category,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Layer Status Icons
            Row(
              children: [
                // Visibility Toggle
                IconButton(
                  icon: Icon(
                    item.isVisible ?? true
                        ? LucideIcons.eye
                        : LucideIcons.eyeOff,
                    size: 16,
                    color: item.isVisible ?? true
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                  onPressed: () => onItemToggleVisibility(item.id),
                  tooltip: item.isVisible ?? true ? 'Hide' : 'Show',
                ),

                // Lock Toggle
                IconButton(
                  icon: Icon(
                    item.isLocked ?? false
                        ? LucideIcons.lock
                        : LucideIcons.unlock,
                    size: 16,
                    color: item.isLocked ?? false
                        ? AppColors.success
                        : AppColors.textSecondary,
                  ),
                  onPressed: () => onItemToggleLock(item.id),
                  tooltip: item.isLocked ?? false ? 'Unlock' : 'Lock',
                ),

                // Remove
                IconButton(
                  icon: Icon(
                    LucideIcons.trash2,
                    size: 16,
                    color: AppColors.error,
                  ),
                  onPressed: () => onItemRemove(item.id),
                  tooltip: 'Remove',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayerControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
        border: Border(
          top: BorderSide(color: AppColors.glassBorder),
        ),
      ),
      child: Column(
        children: [
          // Opacity Control
          Row(
            children: [
              Icon(LucideIcons.eye, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: item.opacity ?? 1.0,
                  min: 0.0,
                  max: 1.0,
                  activeColor: AppColors.pureBlack,
                  inactiveColor: AppColors.glassBorder,
                  onChanged: (value) {
                    onItemOpacityChange({item.id: value});
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${((item.opacity ?? 1.0) * 100).toInt()}%',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Z-Index Display
          Row(
            children: [
              Icon(LucideIcons.layers, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                'Z-Index: ${item.zIndex}',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                'Scale: ${item.scale.toStringAsFixed(1)}x',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

