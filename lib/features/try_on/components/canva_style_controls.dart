import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Canva-inspired control system for DripLord fashion canvas
/// No top toolbar - uses floating buttons, bottom sheets, and contextual drawers
class CanvaStyleCanvasControls extends ConsumerStatefulWidget {
  const CanvaStyleCanvasControls({
    super.key,
    required this.onArrangeAuto,
    required this.onClearCanvas,
    required this.onSaveLook,
    required this.onTryOn,
    required this.onShare,
    required this.onBackgroundChange,
    required this.onLayerPanelToggle,
    required this.onClosetDrawerToggle,
    required this.isLayerPanelVisible,
    required this.isClosetDrawerVisible,
    required this.selectedItemCount,
    required this.onUndo,
    required this.onRedo,
    required this.canUndo,
    required this.canRedo,
  });

  final VoidCallback onArrangeAuto;
  final VoidCallback onClearCanvas;
  final VoidCallback onSaveLook;
  final VoidCallback onTryOn;
  final VoidCallback onShare;
  final ValueChanged<Color> onBackgroundChange;
  final VoidCallback onLayerPanelToggle;
  final VoidCallback onClosetDrawerToggle;
  final bool isLayerPanelVisible;
  final bool isClosetDrawerVisible;
  final int selectedItemCount;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final bool canUndo;
  final bool canRedo;

  @override
  ConsumerState<CanvaStyleCanvasControls> createState() =>
      _CanvaStyleCanvasControlsState();
}

class _CanvaStyleCanvasControlsState
    extends ConsumerState<CanvaStyleCanvasControls> {
  bool _isToolsSheetVisible = false;

  @override
  Widget build(BuildContext context) {
    // No top toolbar - Canva style with floating elements only
    return const SizedBox.shrink();
  }

  // This component provides the control logic - actual UI is in floating controls
  void showToolsBottomSheet(BuildContext context) {
    if (_isToolsSheetVisible) return;

    setState(() => _isToolsSheetVisible = true);

    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.6,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha:0.2),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha:0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.wrench,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Canvas Tools',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        LucideIcons.x,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Tool Grid
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Quick Actions Row
                      Row(
                        children: [
                          _buildToolButton(
                            icon: LucideIcons.undo2,
                            label: 'Undo',
                            onPressed: widget.canUndo ? widget.onUndo : null,
                            colorScheme: colorScheme,
                            enabled: widget.canUndo,
                          ),
                          const SizedBox(width: 12),
                          _buildToolButton(
                            icon: LucideIcons.redo2,
                            label: 'Redo',
                            onPressed: widget.canRedo ? widget.onRedo : null,
                            colorScheme: colorScheme,
                            enabled: widget.canRedo,
                          ),
                          const SizedBox(width: 12),
                          _buildToolButton(
                            icon: LucideIcons.trash2,
                            label: 'Clear',
                            onPressed: () => _showClearConfirmation(context),
                            colorScheme: colorScheme,
                            isDestructive: true,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Main Tools Grid
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          _buildToolButton(
                            icon: LucideIcons.sparkles,
                            label: 'AI Arrange',
                            onPressed: widget.onArrangeAuto,
                            colorScheme: colorScheme,
                          ),
                          _buildToolButton(
                            icon: LucideIcons.palette,
                            label: 'Background',
                            onPressed: () => _showBackgroundPicker(context),
                            colorScheme: colorScheme,
                          ),
                          _buildToolButton(
                            icon: LucideIcons.layers,
                            label: widget.isLayerPanelVisible ? 'Hide Layers' : 'Show Layers',
                            onPressed: widget.onLayerPanelToggle,
                            colorScheme: colorScheme,
                            isActive: widget.isLayerPanelVisible,
                          ),
                          _buildToolButton(
                            icon: LucideIcons.shirt,
                            label: widget.isClosetDrawerVisible ? 'Hide Closet' : 'Show Closet',
                            onPressed: widget.onClosetDrawerToggle,
                            colorScheme: colorScheme,
                            isActive: widget.isClosetDrawerVisible,
                          ),
                          _buildToolButton(
                            icon: LucideIcons.eye,
                            label: 'Try On',
                            onPressed: widget.onTryOn,
                            colorScheme: colorScheme,
                          ),
                          _buildToolButton(
                            icon: LucideIcons.share2,
                            label: 'Share',
                            onPressed: widget.onShare,
                            colorScheme: colorScheme,
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(() => setState(() => _isToolsSheetVisible = false));
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required ColorScheme colorScheme,
    bool enabled = true,
    bool isDestructive = false,
    bool isActive = false,
  }) {
    final backgroundColor = isDestructive
        ? colorScheme.error.withValues(alpha:0.1)
        : isActive
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest.withValues(alpha:0.5);

    final foregroundColor = isDestructive
        ? colorScheme.error
        : isActive
            ? colorScheme.onPrimaryContainer
            : enabled
                ? colorScheme.onSurface
                : colorScheme.onSurface.withValues(alpha:0.4);

    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha:0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: foregroundColor,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: foregroundColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Clear Canvas',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: Text(
          'This will remove all items from the canvas. This action cannot be undone.',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onClearCanvas();
            },
            child: Text(
              'Clear',
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showBackgroundPicker(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Text(
                  'Canvas Background',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(LucideIcons.x, color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Color Grid
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildColorOption(Colors.white, 'White'),
                _buildColorOption(const Color(0xFFF8F9FA), 'Light Gray'),
                _buildColorOption(const Color(0xFFF1F3F4), 'Gray'),
                _buildColorOption(const Color(0xFFE8F5E8), 'Light Green'),
                _buildColorOption(const Color(0xFFE3F2FD), 'Light Blue'),
                _buildColorOption(const Color(0xFFF3E5F5), 'Light Purple'),
                _buildColorOption(const Color(0xFFFFF3E0), 'Light Orange'),
                _buildColorOption(const Color(0xFFFFEBEE), 'Light Red'),
                _buildColorOption(const Color(0xFF212121), 'Dark'),
                _buildColorOption(const Color(0xFF424242), 'Charcoal'),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color, String name) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLight = color.computeLuminance() > 0.5;

    return GestureDetector(
      onTap: () {
        widget.onBackgroundChange(color);
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha:0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha:0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isLight ? null : Icon(LucideIcons.check, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Canva-style Floating Action Controls - Main interaction point
class CanvaStyleFloatingControls extends ConsumerWidget {
  const CanvaStyleFloatingControls({
    super.key,
    required this.onToolsTap,
    required this.onSaveTap,
    required this.selectedItemCount,
  });

  final VoidCallback onToolsTap;
  final VoidCallback onSaveTap;
  final int selectedItemCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Tools button
          FloatingActionButton(
            onPressed: onToolsTap,
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
            elevation: 4,
            child: Icon(LucideIcons.wrench, size: 20),
          ).animate().scale().fadeIn(),

          // Center: Selection indicator (if items selected)
          if (selectedItemCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme.primary),
              ),
              child: Row(
                children: [
                  Icon(
                    selectedItemCount == 1
                        ? LucideIcons.mousePointer2
                        : LucideIcons.layers,
                    size: 16,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$selectedItemCount selected',
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 1).fadeIn(),

          // Right: Save button
          FloatingActionButton.extended(
            onPressed: onSaveTap,
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            elevation: 4,
            icon: Icon(LucideIcons.save, size: 18),
            label: const Text('Save Look'),
          ).animate().scale().fadeIn(),
        ],
      ),
    );
  }
}

/// Bottom Action Bar for selected items - Canva style
class CanvaStyleItemActions extends StatelessWidget {
  const CanvaStyleItemActions({
    super.key,
    required this.onReplace,
    required this.onDuplicate,
    required this.onDelete,
    required this.onLock,
    required this.onGroup,
    required this.onOpacityChange,
    required this.onBringToFront,
    required this.onSendToBack,
    required this.isLocked,
    required this.opacity,
    required this.onDismiss,
  });

  final VoidCallback onReplace;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final VoidCallback onLock;
  final VoidCallback onGroup;
  final ValueChanged<double> onOpacityChange;
  final VoidCallback onBringToFront;
  final VoidCallback onSendToBack;
  final bool isLocked;
  final double opacity;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha:0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha:0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 16),

            // Action buttons in a wrap
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildActionChip(
                  icon: LucideIcons.refreshCcw,
                  label: 'Replace',
                  onPressed: onReplace,
                  colorScheme: colorScheme,
                ),
                _buildActionChip(
                  icon: LucideIcons.copy,
                  label: 'Duplicate',
                  onPressed: onDuplicate,
                  colorScheme: colorScheme,
                ),
                _buildActionChip(
                  icon: isLocked ? LucideIcons.unlock : LucideIcons.lock,
                  label: isLocked ? 'Unlock' : 'Lock',
                  onPressed: onLock,
                  colorScheme: colorScheme,
                  isActive: isLocked,
                ),
                _buildActionChip(
                  icon: LucideIcons.group,
                  label: 'Group',
                  onPressed: onGroup,
                  colorScheme: colorScheme,
                ),
                _buildActionChip(
                  icon: LucideIcons.arrowUp,
                  label: 'Front',
                  onPressed: onBringToFront,
                  colorScheme: colorScheme,
                ),
                _buildActionChip(
                  icon: LucideIcons.arrowDown,
                  label: 'Back',
                  onPressed: onSendToBack,
                  colorScheme: colorScheme,
                ),
                _buildActionChip(
                  icon: LucideIcons.trash2,
                  label: 'Delete',
                  onPressed: onDelete,
                  colorScheme: colorScheme,
                  isDestructive: true,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Opacity slider
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha:0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.eye,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Opacity',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha:0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${(opacity * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                      activeTrackColor: colorScheme.primary,
                      inactiveTrackColor: colorScheme.surfaceContainerHighest,
                      thumbColor: colorScheme.primary,
                      overlayColor: colorScheme.primary.withValues(alpha:0.2),
                    ),
                    child: Slider(
                      value: opacity,
                      onChanged: onOpacityChange,
                      min: 0.0,
                      max: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required ColorScheme colorScheme,
    bool isActive = false,
    bool isDestructive = false,
  }) {
    final backgroundColor = isDestructive
        ? colorScheme.error.withValues(alpha:0.1)
        : isActive
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest.withValues(alpha:0.5);

    final foregroundColor = isDestructive
        ? colorScheme.error
        : isActive
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSurface;

    return ActionChip(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      side: BorderSide(
        color: isActive ? colorScheme.primary : colorScheme.outline.withValues(alpha:0.2),
      ),
      avatar: Icon(icon, size: 16, color: foregroundColor),
      label: Text(
        label,
        style: TextStyle(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    );
  }
}
