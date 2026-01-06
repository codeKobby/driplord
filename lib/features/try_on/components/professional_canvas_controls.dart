import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Professional floating control system inspired by Canva, Acloset, Whering, and Fits
/// Streamlined design with minimal primary actions and contextual secondary controls
class ProfessionalCanvasControls extends ConsumerStatefulWidget {
  const ProfessionalCanvasControls({
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
  ConsumerState<ProfessionalCanvasControls> createState() =>
      _ProfessionalCanvasControlsState();
}

class _ProfessionalCanvasControlsState
    extends ConsumerState<ProfessionalCanvasControls>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive design: stack vertically on very small screens
    final isCompact = screenWidth < 400;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        height: isCompact ? 100 : 72,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            bottom: BorderSide(color: colorScheme.outline.withValues(alpha:0.2)),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha:0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: isCompact ? _buildCompactLayout(context, colorScheme, textTheme) : _buildStandardLayout(context, colorScheme, textTheme),
        ),
      ),
    );
  }

  Widget _buildStandardLayout(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        // Left: Undo/Redo (compact)
        _buildUndoRedoGroup(colorScheme),

        const Spacer(),

        // Center: Status indicator (when items selected)
        if (widget.selectedItemCount > 0)
          _buildStatusIndicator(colorScheme, textTheme),

        const Spacer(),

        // Right: Primary action + More menu
        _buildRightActions(context, colorScheme),
      ],
    );
  }

  Widget _buildCompactLayout(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        // Top row: Undo/Redo + Status
        Row(
          children: [
            _buildUndoRedoGroup(colorScheme),
            const Spacer(),
            if (widget.selectedItemCount > 0)
              _buildStatusIndicator(colorScheme, textTheme),
          ],
        ),
        const SizedBox(height: 8),
        // Bottom row: Primary action + More menu
        Row(
          children: [
            const Spacer(),
            _buildRightActions(context, colorScheme),
          ],
        ),
      ],
    );
  }

  Widget _buildUndoRedoGroup(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha:0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline.withValues(alpha:0.2)),
      ),
      child: Row(
        children: [
          _buildIconButton(
            icon: LucideIcons.undo2,
            tooltip: 'Undo',
            onPressed: widget.canUndo ? widget.onUndo : null,
            colorScheme: colorScheme,
            enabled: widget.canUndo,
            size: 32,
          ),
          Container(
            width: 1,
            height: 16,
            color: colorScheme.outline.withValues(alpha:0.2),
          ),
          _buildIconButton(
            icon: LucideIcons.redo2,
            tooltip: 'Redo',
            onPressed: widget.canRedo ? widget.onRedo : null,
            colorScheme: colorScheme,
            enabled: widget.canRedo,
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha:0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha:0.3)),
      ),
      child: Row(
        children: [
          Icon(
            widget.selectedItemCount == 1
                ? LucideIcons.mousePointer2
                : LucideIcons.layers,
            size: 14,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            widget.selectedItemCount == 1
                ? '1 selected'
                : '${widget.selectedItemCount} selected',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightActions(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        // More menu (3-dot menu with all secondary actions)
        _buildMoreMenu(context, colorScheme),

        const SizedBox(width: 8),

        // Primary action: Save
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primaryContainer,
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha:0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onSaveLook,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.save,
                      size: 16,
                      color: colorScheme.onPrimary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Save',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoreMenu(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha:0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline.withValues(alpha:0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: PopupMenuButton<String>(
          onSelected: (value) => _handleMoreMenuSelection(context, value),
          itemBuilder: (context) => [
            _buildMenuItem(
              value: 'arrange',
              icon: LucideIcons.sparkles,
              title: 'AI Arrange',
              subtitle: 'Auto-organize items',
            ),
            _buildMenuItem(
              value: 'background',
              icon: LucideIcons.palette,
              title: 'Background',
              subtitle: 'Change canvas color',
            ),
            _buildMenuItem(
              value: 'layers',
              icon: LucideIcons.layers,
              title: 'Layers',
              subtitle: widget.isLayerPanelVisible ? 'Hide panel' : 'Show panel',
            ),
            _buildMenuItem(
              value: 'closet',
              icon: LucideIcons.shirt,
              title: 'Closet',
              subtitle: widget.isClosetDrawerVisible ? 'Hide drawer' : 'Show drawer',
            ),
            const PopupMenuDivider(),
            _buildMenuItem(
              value: 'try_on',
              icon: LucideIcons.eye,
              title: 'Try On',
              subtitle: 'Virtual preview',
            ),
            _buildMenuItem(
              value: 'share',
              icon: LucideIcons.share2,
              title: 'Share',
              subtitle: 'Export & share',
            ),
            const PopupMenuDivider(),
            _buildMenuItem(
              value: 'clear',
              icon: LucideIcons.trash2,
              title: 'Clear Canvas',
              subtitle: 'Remove all items',
              isDestructive: true,
            ),
          ],
          position: PopupMenuPosition.under,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            LucideIcons.moreHorizontal,
            size: 18,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required IconData icon,
    required String title,
    required String subtitle,
    bool isDestructive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isDestructive ? colorScheme.error : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDestructive ? colorScheme.error : colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMoreMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'arrange':
        widget.onArrangeAuto();
        break;
      case 'background':
        _showBackgroundPicker(context);
        break;
      case 'layers':
        widget.onLayerPanelToggle();
        break;
      case 'closet':
        widget.onClosetDrawerToggle();
        break;
      case 'try_on':
        widget.onTryOn();
        break;
      case 'share':
        widget.onShare();
        break;
      case 'clear':
        _showClearConfirmation(context);
        break;
    }
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

  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
    required ColorScheme colorScheme,
    bool enabled = true,
    double size = 36,
  }) {
    final foregroundColor = enabled
        ? colorScheme.onSurface
        : colorScheme.onSurface.withValues(alpha:0.4);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: enabled
            ? colorScheme.surfaceContainerHighest.withValues(alpha:0.3)
            : colorScheme.surfaceContainerHighest.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha:enabled ? 0.2 : 0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(6),
          child: Icon(
            icon,
            size: size == 32 ? 16 : 18,
            color: foregroundColor,
          ),
        ),
      ),
    );
  }

  void _showBackgroundPicker(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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

enum ButtonVariant { primary, secondary, active }
