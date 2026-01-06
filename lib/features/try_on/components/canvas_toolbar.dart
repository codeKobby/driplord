import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Professional floating control system inspired by Canva, Acloset, Whering, and Fits
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

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        height: 72,
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              // Primary Actions (Left)
              _buildPrimaryActions(context, colorScheme),

              const Spacer(),

              // Center Status
              _buildCenterStatus(context, textTheme, colorScheme),

              const Spacer(),

              // Secondary Actions (Right)
              _buildSecondaryActions(context, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryActions(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        // Undo/Redo Group
        Container(
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
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Main Actions
        _buildActionButton(
          icon: LucideIcons.sparkles,
          label: 'AI Arrange',
          onPressed: widget.onArrangeAuto,
          colorScheme: colorScheme,
          variant: ButtonVariant.primary,
        ),

        const SizedBox(width: 8),

        _buildActionButton(
          icon: LucideIcons.palette,
          label: 'Background',
          onPressed: () => _showBackgroundPicker(context),
          colorScheme: colorScheme,
          variant: ButtonVariant.secondary,
        ),

        const SizedBox(width: 8),

        _buildActionButton(
          icon: LucideIcons.layers,
          label: 'Layers',
          onPressed: widget.onLayerPanelToggle,
          colorScheme: colorScheme,
          variant: widget.isLayerPanelVisible
              ? ButtonVariant.active
              : ButtonVariant.secondary,
        ),

        const SizedBox(width: 8),

        _buildActionButton(
          icon: LucideIcons.shirt,
          label: 'Closet',
          onPressed: widget.onClosetDrawerToggle,
          colorScheme: colorScheme,
          variant: widget.isClosetDrawerVisible
              ? ButtonVariant.active
              : ButtonVariant.secondary,
        ),
      ],
    );
  }

  Widget _buildCenterStatus(BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha:0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withValues(alpha:0.3)),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.layout,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            widget.selectedItemCount > 0
                ? '${widget.selectedItemCount} selected'
                : 'Canvas Studio',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryActions(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        // Utility Actions
        _buildIconButton(
          icon: LucideIcons.share2,
          tooltip: 'Share',
          onPressed: widget.onShare,
          colorScheme: colorScheme,
        ),

        const SizedBox(width: 8),

        _buildIconButton(
          icon: LucideIcons.eye,
          tooltip: 'Try On',
          onPressed: widget.onTryOn,
          colorScheme: colorScheme,
        ),

        const SizedBox(width: 8),

        _buildIconButton(
          icon: LucideIcons.trash2,
          tooltip: 'Clear Canvas',
          onPressed: widget.onClearCanvas,
          colorScheme: colorScheme,
          isDestructive: true,
        ),

        const SizedBox(width: 16),

        // Primary Action
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primaryContainer,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
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
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.save,
                      size: 16,
                      color: colorScheme.onPrimary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Save Look',
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required ColorScheme colorScheme,
    required ButtonVariant variant,
  }) {
    Color backgroundColor;
    Color foregroundColor;
    Color borderColor;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        borderColor = colorScheme.primary;
        break;
      case ButtonVariant.active:
        backgroundColor = colorScheme.primaryContainer;
        foregroundColor = colorScheme.onPrimaryContainer;
        borderColor = colorScheme.primary;
        break;
      case ButtonVariant.secondary:
        backgroundColor = colorScheme.surfaceContainerHighest.withValues(alpha:0.5);
        foregroundColor = colorScheme.onSurface;
        borderColor = colorScheme.outline.withValues(alpha:0.3);
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
        boxShadow: variant == ButtonVariant.primary
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha:0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(icon, size: 16, color: foregroundColor),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
    required ColorScheme colorScheme,
    bool enabled = true,
    bool isDestructive = false,
  }) {
    final foregroundColor = isDestructive
        ? colorScheme.error
        : enabled
            ? colorScheme.onSurface
            : colorScheme.onSurface.withValues(alpha:0.4);

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: enabled
            ? colorScheme.surfaceContainerHighest.withValues(alpha:0.3)
            : colorScheme.surfaceContainerHighest.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha:enabled ? 0.2 : 0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(8),
          child: Icon(
            icon,
            size: 18,
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

/// Professional floating item controls (appears when items are selected)
class ProfessionalItemControls extends StatefulWidget {
  const ProfessionalItemControls({
    super.key,
    required this.selectedItems,
    required this.onReplace,
    required this.onDuplicate,
    required this.onDelete,
    required this.onLock,
    required this.onGroup,
    required this.onOpacityChange,
    required this.onBringToFront,
    required this.onSendToBack,
    required this.onAlign,
    required this.onDistribute,
    required this.isLocked,
    required this.opacity,
    required this.onDismiss,
  });

  final List<String> selectedItems;
  final VoidCallback onReplace;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final VoidCallback onLock;
  final VoidCallback onGroup;
  final ValueChanged<double> onOpacityChange;
  final VoidCallback onBringToFront;
  final VoidCallback onSendToBack;
  final VoidCallback onAlign;
  final VoidCallback onDistribute;
  final bool isLocked;
  final double opacity;
  final VoidCallback onDismiss;

  @override
  State<ProfessionalItemControls> createState() => _ProfessionalItemControlsState();
}

class _ProfessionalItemControlsState extends State<ProfessionalItemControls>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
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
    final isMultiple = widget.selectedItems.length > 1;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha:0.15),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: colorScheme.outline.withValues(alpha:0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(context, colorScheme),

            // Controls
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Primary Actions Row
                  _buildPrimaryActions(context, colorScheme),

                  if (isMultiple) ...[
                    const SizedBox(height: 16),
                    _buildMultiSelectActions(context, colorScheme),
                  ],

                  const SizedBox(height: 16),

                  // Opacity Control
                  _buildOpacityControl(context, colorScheme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha:0.3),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withValues(alpha:0.2)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            widget.selectedItems.length == 1
                ? LucideIcons.mousePointer2
                : LucideIcons.layers,
            size: 20,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.selectedItems.length == 1
                  ? '1 item selected'
                  : '${widget.selectedItems.length} items selected',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            onPressed: widget.onDismiss,
            icon: Icon(LucideIcons.x, color: colorScheme.onSurfaceVariant),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha:0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryActions(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _buildControlButton(
            icon: LucideIcons.replace,
            label: 'Replace',
            onPressed: widget.onReplace,
            colorScheme: colorScheme,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildControlButton(
            icon: LucideIcons.copy,
            label: 'Duplicate',
            onPressed: widget.onDuplicate,
            colorScheme: colorScheme,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildControlButton(
            icon: widget.isLocked ? LucideIcons.lock : LucideIcons.unlock,
            label: widget.isLocked ? 'Unlock' : 'Lock',
            onPressed: widget.onLock,
            colorScheme: colorScheme,
            variant: widget.isLocked ? ButtonVariant.active : ButtonVariant.secondary,
          ),
        ),
        if (widget.selectedItems.length > 1) ...[
          const SizedBox(width: 8),
          Expanded(
            child: _buildControlButton(
              icon: LucideIcons.group,
              label: 'Group',
              onPressed: widget.onGroup,
              colorScheme: colorScheme,
            ),
          ),
        ],
        const SizedBox(width: 8),
        Expanded(
          child: _buildControlButton(
            icon: LucideIcons.trash2,
            label: 'Delete',
            onPressed: widget.onDelete,
            colorScheme: colorScheme,
            isDestructive: true,
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelectActions(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha:0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha:0.2)),
      ),
      child: Column(
        children: [
          Text(
            'Multi-Select Actions',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSmallButton(
                  icon: LucideIcons.alignLeft,
                  label: 'Align',
                  onPressed: widget.onAlign,
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSmallButton(
                  icon: LucideIcons.moveHorizontal,
                  label: 'Distribute',
                  onPressed: widget.onDistribute,
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOpacityControl(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha:0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha:0.2)),
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
                  '${(widget.opacity * 100).toInt()}%',
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
              value: widget.opacity,
              onChanged: widget.onOpacityChange,
              min: 0.0,
              max: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required ColorScheme colorScheme,
    ButtonVariant variant = ButtonVariant.secondary,
    bool isDestructive = false,
  }) {
    Color backgroundColor;
    Color foregroundColor;

    if (isDestructive) {
      backgroundColor = colorScheme.error.withValues(alpha:0.1);
      foregroundColor = colorScheme.error;
    } else {
      switch (variant) {
        case ButtonVariant.primary:
          backgroundColor = colorScheme.primary;
          foregroundColor = colorScheme.onPrimary;
          break;
        case ButtonVariant.active:
          backgroundColor = colorScheme.primaryContainer;
          foregroundColor = colorScheme.onPrimaryContainer;
          break;
        case ButtonVariant.secondary:
          backgroundColor = colorScheme.surfaceContainerHighest.withValues(alpha:0.5);
          foregroundColor = colorScheme.onSurface;
          break;
      }
    }

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDestructive
              ? colorScheme.error.withValues(alpha:0.3)
              : colorScheme.outline.withValues(alpha:0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: foregroundColor),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: foregroundColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required ColorScheme colorScheme,
  }) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha:0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline.withValues(alpha:0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 14, color: colorScheme.onSurface),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Legacy CanvasToolbar - kept for backward compatibility
/// @deprecated Use ProfessionalCanvasControls instead
class CanvasToolbar extends ConsumerWidget {
  const CanvasToolbar({
    super.key,
    required this.onArrangeAuto,
    required this.onClearCanvas,
    required this.onSaveLook,
    required this.onTryOn,
    required this.onShare,
    required this.backgroundColor,
    required this.onBackgroundChange,
    required this.onLayerPanelToggle,
    required this.onClosetDrawerToggle,
    this.isLayerPanelVisible = false,
    this.isClosetDrawerVisible = false,
  });

  final VoidCallback onArrangeAuto;
  final VoidCallback onClearCanvas;
  final VoidCallback onSaveLook;
  final VoidCallback onTryOn;
  final VoidCallback onShare;
  final Color backgroundColor;
  final ValueChanged<Color> onBackgroundChange;
  final VoidCallback onLayerPanelToggle;
  final VoidCallback onClosetDrawerToggle;
  final bool isLayerPanelVisible;
  final bool isClosetDrawerVisible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProfessionalCanvasControls(
      onArrangeAuto: onArrangeAuto,
      onClearCanvas: onClearCanvas,
      onSaveLook: onSaveLook,
      onTryOn: onTryOn,
      onShare: onShare,
      onBackgroundChange: onBackgroundChange,
      onLayerPanelToggle: onLayerPanelToggle,
      onClosetDrawerToggle: onClosetDrawerToggle,
      isLayerPanelVisible: isLayerPanelVisible,
      isClosetDrawerVisible: isClosetDrawerVisible,
      selectedItemCount: 0,
      onUndo: () {},
      onRedo: () {},
      canUndo: false,
      canRedo: false,
    );
  }
}

/// Legacy ItemContextToolbar - kept for backward compatibility
/// @deprecated Use ProfessionalItemControls instead
class ItemContextToolbar extends StatelessWidget {
  const ItemContextToolbar({
    super.key,
    required this.selectedItem,
    required this.onRemove,
    required this.onReplace,
    required this.onDuplicate,
    required this.onLock,
    required this.onGroup,
    required this.onOpacityChange,
    required this.onBringToFront,
    required this.onSendToBack,
    required this.isLocked,
    required this.opacity,
  });

  final String selectedItem;
  final VoidCallback onRemove;
  final VoidCallback onReplace;
  final VoidCallback onDuplicate;
  final VoidCallback onLock;
  final VoidCallback onGroup;
  final ValueChanged<double> onOpacityChange;
  final VoidCallback onBringToFront;
  final VoidCallback onSendToBack;
  final bool isLocked;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return ProfessionalItemControls(
      selectedItems: [selectedItem],
      onReplace: onReplace,
      onDuplicate: onDuplicate,
      onDelete: onRemove,
      onLock: onLock,
      onGroup: onGroup,
      onOpacityChange: onOpacityChange,
      onBringToFront: onBringToFront,
      onSendToBack: onSendToBack,
      onAlign: () {},
      onDistribute: () {},
      isLocked: isLocked,
      opacity: opacity,
      onDismiss: () {},
    );
  }
}

