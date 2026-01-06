import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../models/outfit_item.dart';

/// Selection state management for the canvas
class SelectionState {
  final Set<String> selectedItems;
  final bool isMarqueeActive;
  final Rect? marqueeRect;

  const SelectionState({
    required this.selectedItems,
    this.isMarqueeActive = false,
    this.marqueeRect,
  });

  SelectionState copyWith({
    Set<String>? selectedItems,
    bool? isMarqueeActive,
    Rect? marqueeRect,
  }) {
    return SelectionState(
      selectedItems: selectedItems ?? this.selectedItems,
      isMarqueeActive: isMarqueeActive ?? this.isMarqueeActive,
      marqueeRect: marqueeRect ?? this.marqueeRect,
    );
  }

  bool isSelected(String itemId) => selectedItems.contains(itemId);
  bool get hasSelection => selectedItems.isNotEmpty;
}

/// Selection notifier for managing canvas selection state
class SelectionNotifier extends Notifier<SelectionState> {
  @override
  SelectionState build() => const SelectionState(selectedItems: <String>{});

  void selectItem(String itemId) {
    state = state.copyWith(
      selectedItems: {...state.selectedItems, itemId},
      isMarqueeActive: false,
      marqueeRect: null,
    );
  }

  void deselectItem(String itemId) {
    final newSelection = Set<String>.from(state.selectedItems)..remove(itemId);
    state = state.copyWith(
      selectedItems: newSelection,
      isMarqueeActive: false,
      marqueeRect: null,
    );
  }

  void toggleSelection(String itemId) {
    if (state.isSelected(itemId)) {
      deselectItem(itemId);
    } else {
      selectItem(itemId);
    }
  }

  void clearSelection() {
    state = state.copyWith(
      selectedItems: <String>{},
      isMarqueeActive: false,
      marqueeRect: null,
    );
  }

  void selectMultiple(Set<String> itemIds) {
    state = state.copyWith(
      selectedItems: itemIds,
      isMarqueeActive: false,
      marqueeRect: null,
    );
  }

  void startMarquee(Rect rect) {
    state = state.copyWith(isMarqueeActive: true, marqueeRect: rect);
  }

  void updateMarquee(Rect rect) {
    if (state.isMarqueeActive) {
      state = state.copyWith(marqueeRect: rect);
    }
  }

  void endMarquee() {
    state = state.copyWith(isMarqueeActive: false, marqueeRect: null);
  }
}

final selectionProvider = NotifierProvider<SelectionNotifier, SelectionState>(
  () => SelectionNotifier(),
);

/// Enhanced CanvasItem with additional layer properties
class CanvasItem {
  String id;
  final OutfitStackItem data;
  Offset position;
  double scale;
  int zIndex;
  bool? isVisible;
  bool? isLocked;
  double? opacity;
  double? rotation;

  CanvasItem({
    required this.id,
    required this.data,
    required this.position,
    this.scale = 1.0,
    required this.zIndex,
    this.isVisible = true,
    this.isLocked = false,
    this.opacity = 1.0,
    this.rotation = 0.0,
  });

  CanvasItem copyWith({
    String? id,
    OutfitStackItem? data,
    Offset? position,
    double? scale,
    int? zIndex,
    bool? isVisible,
    bool? isLocked,
    double? opacity,
    double? rotation,
  }) {
    return CanvasItem(
      id: id ?? this.id,
      data: data ?? this.data,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      zIndex: zIndex ?? this.zIndex,
      isVisible: isVisible ?? this.isVisible,
      isLocked: isLocked ?? this.isLocked,
      opacity: opacity ?? this.opacity,
      rotation: rotation ?? this.rotation,
    );
  }

  /// Logic to determine default Z-Index based on "Human Dressing Order"
  static int getDefaultZIndex(String category) {
    switch (category.toLowerCase()) {
      case 'footwear':
      case 'shoes':
        return 10;
      case 'bottom':
      case 'bottoms':
      case 'pants':
      case 'jeans':
      case 'skirt':
        return 20;
      case 'top':
      case 'tops':
      case 'shirt':
      case 't-shirt':
      case 'blouse':
        return 30;
      case 'outerwear':
      case 'jacket':
      case 'coat':
        return 40;
      case 'accessory':
      case 'accessories':
      case 'hat':
      case 'bag':
        return 50;
      default:
        return 25; // Default middle layer
    }
  }
}

/// Marquee selection widget for multi-select functionality
class MarqueeSelection extends ConsumerWidget {
  const MarqueeSelection({
    super.key,
    required this.onMarqueeSelect,
    required this.child,
  });

  final Widget child;
  final ValueChanged<Rect> onMarqueeSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionState = ref.watch(selectionProvider);

    return GestureDetector(
      onPanStart: (details) {
        ref
            .read(selectionProvider.notifier)
            .startMarquee(
              Rect.fromPoints(details.localPosition, details.localPosition),
            );
      },
      onPanUpdate: (details) {
        final notifier = ref.read(selectionProvider.notifier);
        final currentState = ref.read(selectionProvider);

        if (currentState.isMarqueeActive && currentState.marqueeRect != null) {
          final rect = Rect.fromPoints(
            currentState.marqueeRect!.topLeft,
            details.localPosition,
          );
          notifier.updateMarquee(rect);
        }
      },
      onPanEnd: (details) {
        final currentState = ref.read(selectionProvider);
        if (currentState.isMarqueeActive && currentState.marqueeRect != null) {
          onMarqueeSelect(currentState.marqueeRect!);
        }
        ref.read(selectionProvider.notifier).endMarquee();
      },
      child: Stack(
        children: [
          child,
          if (selectionState.isMarqueeActive &&
              selectionState.marqueeRect != null)
            _buildMarqueeOverlay(selectionState.marqueeRect!),
        ],
      ),
    );
  }

  Widget _buildMarqueeOverlay(Rect rect) {
    return Positioned(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.pureBlack, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.pureBlack.withValues(alpha: 0.1),
                AppColors.pureBlack.withValues(alpha: 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Selection handles for individual items
class SelectionHandles extends StatelessWidget {
  const SelectionHandles({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onRotateStart,
    required this.onRotateUpdate,
    required this.onRotateEnd,
    required this.onScaleStart,
    required this.onScaleUpdate,
    required this.onScaleEnd,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final CanvasItem item;
  final bool isSelected;
  final VoidCallback onRotateStart;
  final ValueChanged<Offset> onRotateUpdate;
  final VoidCallback onRotateEnd;
  final VoidCallback onScaleStart;
  final ValueChanged<double> onScaleUpdate;
  final VoidCallback onScaleEnd;
  final VoidCallback onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    if (!isSelected) return const SizedBox.shrink();

    return Stack(
      children: [
        // Rotation Handle
        Positioned(
          top: -40,
          left: item.scale * 100 - 10,
          child: GestureDetector(
            onPanStart: (_) => onRotateStart(),
            onPanUpdate: (details) => onRotateUpdate(details.localPosition),
            onPanEnd: (_) => onRotateEnd(),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                border: Border.all(color: AppColors.pureBlack, width: 2),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.pureBlack.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                LucideIcons.rotateCcw,
                size: 12,
                color: AppColors.pureBlack,
              ),
            ),
          ),
        ),

        // Scale Handles (8 points)
        ..._buildScaleHandles(),
      ],
    );
  }

  List<Widget> _buildScaleHandles() {
    final size = item.scale * 100;
    final handles = <Widget>[];

    // Top-left
    handles.add(
      Positioned(
        top: -10,
        left: -10,
        child: _buildScaleHandle(
          Alignment.topLeft,
          onPanStart: onScaleStart,
          onPanUpdate: (offset) => onScaleUpdate(offset.dx / 100),
          onPanEnd: onScaleEnd,
        ),
      ),
    );

    // Top-right
    handles.add(
      Positioned(
        top: -10,
        left: size - 10,
        child: _buildScaleHandle(
          Alignment.topRight,
          onPanStart: onScaleStart,
          onPanUpdate: (offset) => onScaleUpdate(offset.dx / 100),
          onPanEnd: onScaleEnd,
        ),
      ),
    );

    // Bottom-left
    handles.add(
      Positioned(
        top: size - 10,
        left: -10,
        child: _buildScaleHandle(
          Alignment.bottomLeft,
          onPanStart: onScaleStart,
          onPanUpdate: (offset) => onScaleUpdate(offset.dx / 100),
          onPanEnd: onScaleEnd,
        ),
      ),
    );

    // Bottom-right
    handles.add(
      Positioned(
        top: size - 10,
        left: size - 10,
        child: _buildScaleHandle(
          Alignment.bottomRight,
          onPanStart: onScaleStart,
          onPanUpdate: (offset) => onScaleUpdate(offset.dx / 100),
          onPanEnd: onScaleEnd,
        ),
      ),
    );

    return handles;
  }

  Widget _buildScaleHandle(
    Alignment alignment, {
    required VoidCallback onPanStart,
    required ValueChanged<Offset> onPanUpdate,
    required VoidCallback onPanEnd,
  }) {
    return GestureDetector(
      onPanStart: (details) => onPanStart(),
      onPanUpdate: (details) => onPanUpdate(details.localPosition),
      onPanEnd: (details) => onPanEnd(),
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          border: Border.all(color: AppColors.pureBlack, width: 2),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.pureBlack.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(LucideIcons.square, size: 10, color: AppColors.pureBlack),
      ),
    );
  }
}

/// Precision alignment tools for professional canvas control
class AlignmentTools extends StatelessWidget {
  const AlignmentTools({
    super.key,
    required this.onAlignLeft,
    required this.onAlignCenter,
    required this.onAlignRight,
    required this.onAlignTop,
    required this.onAlignMiddle,
    required this.onAlignBottom,
    required this.onDistributeHorizontal,
    required this.onDistributeVertical,
    required this.onGroupItems,
    required this.onUngroupItems,
    required this.onFlipHorizontal,
    required this.onFlipVertical,
  });

  final VoidCallback onAlignLeft;
  final VoidCallback onAlignCenter;
  final VoidCallback onAlignRight;
  final VoidCallback onAlignTop;
  final VoidCallback onAlignMiddle;
  final VoidCallback onAlignBottom;
  final VoidCallback onDistributeHorizontal;
  final VoidCallback onDistributeVertical;
  final VoidCallback onGroupItems;
  final VoidCallback onUngroupItems;
  final VoidCallback onFlipHorizontal;
  final VoidCallback onFlipVertical;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.glassBorder),
          bottom: BorderSide(color: AppColors.glassBorder),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Alignment Section
            Expanded(
              child: Row(
                children: [
                  _buildAlignmentButton(
                    LucideIcons.alignLeft,
                    'Left',
                    onAlignLeft,
                  ),
                  const SizedBox(width: 8),
                  _buildAlignmentButton(
                    LucideIcons.alignCenter,
                    'Center',
                    onAlignCenter,
                  ),
                  const SizedBox(width: 8),
                  _buildAlignmentButton(
                    LucideIcons.alignRight,
                    'Right',
                    onAlignRight,
                  ),
                  const SizedBox(width: 16),
                  _buildAlignmentButton(
                    LucideIcons.alignStartVertical,
                    'Top',
                    onAlignTop,
                  ),
                  const SizedBox(width: 8),
                  _buildAlignmentButton(
                    LucideIcons.alignCenterVertical,
                    'Middle',
                    onAlignMiddle,
                  ),
                  const SizedBox(width: 8),
                  _buildAlignmentButton(
                    LucideIcons.alignEndVertical,
                    'Bottom',
                    onAlignBottom,
                  ),
                ],
              ),
            ),

            // Distribution Section
            Expanded(
              child: Row(
                children: [
                  _buildAlignmentButton(
                    LucideIcons.alignJustify,
                    'Distribute H',
                    onDistributeHorizontal,
                  ),
                  const SizedBox(width: 8),
                  _buildAlignmentButton(
                    LucideIcons.alignJustify,
                    'Distribute V',
                    onDistributeVertical,
                  ),
                  const SizedBox(width: 16),
                  _buildAlignmentButton(
                    LucideIcons.copy,
                    'Group',
                    onGroupItems,
                  ),
                  const SizedBox(width: 8),
                  _buildAlignmentButton(
                    LucideIcons.copy,
                    'Ungroup',
                    onUngroupItems,
                  ),
                  const SizedBox(width: 16),
                  _buildAlignmentButton(
                    LucideIcons.flipHorizontal,
                    'Flip H',
                    onFlipHorizontal,
                  ),
                  const SizedBox(width: 8),
                  _buildAlignmentButton(
                    LucideIcons.flipVertical,
                    'Flip V',
                    onFlipVertical,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlignmentButton(
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.textPrimary),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 150.ms).scale();
  }
}
