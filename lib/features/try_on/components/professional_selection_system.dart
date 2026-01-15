import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../components/selection_system.dart';

/// Professional Canvas Area with selection and manipulation
class ProfessionalCanvasArea extends ConsumerStatefulWidget {
  const ProfessionalCanvasArea({
    super.key,
    required this.items,
    required this.onItemSelect,
    required this.onItemUpdate,
    required this.onBringToFront,
    required this.onSendToBack,
    required this.onRemoveItem,
  });

  final List<CanvasItem> items;
  final ValueChanged<String> onItemSelect;
  final ValueChanged<CanvasItem> onItemUpdate;
  final ValueChanged<CanvasItem> onBringToFront;
  final ValueChanged<CanvasItem> onSendToBack;
  final ValueChanged<String> onRemoveItem;

  @override
  ConsumerState<ProfessionalCanvasArea> createState() =>
      _ProfessionalCanvasAreaState();
}

class _ProfessionalCanvasAreaState
    extends ConsumerState<ProfessionalCanvasArea> {
  Offset? _dragStartOffset;
  double? _baseScale;
  double? _baseRotation;
  Offset? _rotationCenter;

  @override
  Widget build(BuildContext context) {
    final selectionState = ref.watch(selectionProvider);

    return GestureDetector(
      onTap: () {
        // Clear selection on background tap
        ref.read(selectionProvider.notifier).clearSelection();
      },
      child: Stack(
        children: [
          // Canvas items
          ...widget.items.map((item) => _buildCanvasItem(item)),

          // Selection marquee overlay
          if (selectionState.isMarqueeActive &&
              selectionState.marqueeRect != null)
            _buildMarqueeOverlay(context, selectionState.marqueeRect!),
        ],
      ),
    );
  }

  Widget _buildCanvasItem(CanvasItem item) {
    final selectionState = ref.watch(selectionProvider);
    final isSelected = selectionState.isSelected(item.id);
    final isLocked = item.isLocked ?? false;
    final isVisible = item.isVisible ?? true;

    if (!isVisible) return const SizedBox.shrink();

    final itemSize = item.scale * 100;
    final handleAreaSize =
        itemSize + 80; // Account for handles and rotation handle

    return Positioned(
      left:
          item.position.dx -
          (item.scale * 50) -
          30, // Extra padding for handles
      top:
          item.position.dy -
          (item.scale * 50) -
          50, // Extra padding for rotation handle
      width: handleAreaSize,
      height: handleAreaSize,
      child: Transform.rotate(
        angle: item.rotation ?? 0,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            // Select item on tap
            ref.read(selectionProvider.notifier).selectItem(item.id);
            widget.onItemSelect(item.id);
          },
          onPanStart: isLocked
              ? null
              : (details) {
                  _dragStartOffset = item.position;
                  widget.onBringToFront(item); // Bring to front when dragging
                },
          onPanUpdate: isLocked
              ? null
              : (details) {
                  if (_dragStartOffset != null) {
                    final newPosition = _dragStartOffset! + details.delta;
                    final updatedItem = item.copyWith(position: newPosition);
                    widget.onItemUpdate(updatedItem);
                  }
                },
          onPanEnd: isLocked
              ? null
              : (details) {
                  _dragStartOffset = null;
                },
          child: SizedBox(
            width: itemSize,
            height: itemSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Item image with selection border
                Container(
                  width: itemSize,
                  height: itemSize,
                  decoration: BoxDecoration(
                    border: isSelected
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Opacity(
                    opacity: item.opacity ?? 1.0,
                    child: CachedNetworkImage(
                      imageUrl: item.data.imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const SizedBox.shrink(),
                      errorWidget: (context, url, error) =>
                          const Icon(LucideIcons.image, size: 40),
                      // Cache settings to prevent re-fetching
                      maxWidthDiskCache: 1000,
                      maxHeightDiskCache: 1000,
                      memCacheWidth: 400,
                      memCacheHeight: 400,
                      useOldImageOnUrlChange: true,
                    ),
                  ),
                ),

                // Selection handles and controls
                if (isSelected) _buildSelectionHandles(context, item),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionHandles(BuildContext context, CanvasItem item) {
    final size = item.scale * 100;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none, // Allow handles to extend outside bounds
        children: [
          // Corner resize handles - positioned relative to the item
          Positioned(
            left: -10,
            top: -10,
            child: _buildResizeHandle(context, _onScaleStart),
          ),
          Positioned(
            right: -10,
            top: -10,
            child: _buildResizeHandle(context, _onScaleStart),
          ),
          Positioned(
            left: -10,
            bottom: -10,
            child: _buildResizeHandle(context, _onScaleStart),
          ),
          Positioned(
            right: -10,
            bottom: -10,
            child: _buildResizeHandle(context, _onScaleStart),
          ),

          // Rotation handle (above the item)
          Positioned(
            left: size / 2 - 12, // Center horizontally
            top: -45, // Above the top edge
            child: GestureDetector(
              onPanStart: (_) => _onRotateStart(),
              onPanUpdate: (details) => _onRotateUpdate(details, item),
              onPanEnd: (_) => _onRotateEnd(),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  LucideIcons.rotateCcw,
                  size: 14,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResizeHandle(BuildContext context, VoidCallback onPanStart) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onPanStart: (_) => onPanStart(),
      onPanUpdate: (details) => _onScaleUpdate(details),
      onPanEnd: (_) => _onScaleEnd(),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border.all(color: colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(LucideIcons.move, size: 12, color: colorScheme.primary),
      ),
    );
  }

  Widget _buildMarqueeOverlay(BuildContext context, Rect rect) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(4),
          color: colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  void _onScaleStart() {
    // Store base scale for delta calculation
    final selectionState = ref.read(selectionProvider);
    if (selectionState.hasSelection) {
      final selectedId = selectionState.selectedItems.first;
      final item = widget.items.where((i) => i.id == selectedId).firstOrNull;
      if (item != null) {
        _baseScale = item.scale;
      }
    }
  }

  void _onScaleUpdate(DragUpdateDetails details) {
    final selectionState = ref.read(selectionProvider);
    if (selectionState.hasSelection && _baseScale != null) {
      final delta = details.delta.dx + details.delta.dy;
      final scaleFactor = 1 + (delta / 200); // Adjust sensitivity
      final newScale = (_baseScale! * scaleFactor).clamp(0.1, 3.0);

      final selectedId = selectionState.selectedItems.first;
      final item = widget.items.where((i) => i.id == selectedId).firstOrNull;
      if (item != null) {
        final updatedItem = item.copyWith(scale: newScale);
        widget.onItemUpdate(updatedItem);
      }
    }
  }

  void _onScaleEnd() {
    _baseScale = null;
  }

  void _onRotateStart() {
    final selectionState = ref.read(selectionProvider);
    if (selectionState.hasSelection) {
      final selectedId = selectionState.selectedItems.first;
      final item = widget.items.where((i) => i.id == selectedId).firstOrNull;
      if (item != null) {
        _baseRotation = item.rotation ?? 0.0;
        _rotationCenter = item.position;
      }
    }
  }

  void _onRotateUpdate(DragUpdateDetails details, CanvasItem item) {
    if (_baseRotation != null && _rotationCenter != null) {
      final touchPoint = details.globalPosition;
      final center = _rotationCenter!;

      // Calculate angle from center to touch point
      final deltaX = touchPoint.dx - center.dx;
      final deltaY = touchPoint.dy - center.dy;
      final angle = math.atan2(deltaY, deltaX); // atan2 gives angle in radians

      final updatedItem = item.copyWith(rotation: angle);
      widget.onItemUpdate(updatedItem);
    }
  }

  void _onRotateEnd() {
    _baseRotation = null;
    _rotationCenter = null;
  }
}
