import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Professional Toolbar - Canva/Photoshop-style top toolbar
class ProfessionalToolbar extends StatelessWidget {
  const ProfessionalToolbar({
    super.key,
    required this.onUndo,
    required this.onRedo,
    required this.onArrangeAuto,
    required this.onBackgroundChange,
    required this.onTryOn,
    required this.onShare,
    required this.onClosetToggle,
    required this.onLayersToggle,
    required this.isClosetPanelVisible,
    required this.isLayerPanelVisible,
    required this.canUndo,
    required this.canRedo,
  });

  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onArrangeAuto;
  final ValueChanged<Color> onBackgroundChange;
  final VoidCallback onTryOn;
  final VoidCallback onShare;
  final VoidCallback onClosetToggle;
  final VoidCallback onLayersToggle;
  final bool isClosetPanelVisible;
  final bool isLayerPanelVisible;
  final bool canUndo;
  final bool canRedo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        children: [
          // Left Section - Essential Tools
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                _buildIconButton(
                  context: context,
                  icon: LucideIcons.undo2,
                  tooltip: 'Undo',
                  onPressed: canUndo ? onUndo : null,
                  enabled: canUndo,
                ),
                _buildIconButton(
                  context: context,
                  icon: LucideIcons.redo2,
                  tooltip: 'Redo',
                  onPressed: canRedo ? onRedo : null,
                  enabled: canRedo,
                ),
              ],
            ),
          ),

          // Center Section - Main Panels (Scrollable)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  // Add button (icon-only)
                  _buildIconButton(
                    context: context,
                    icon: LucideIcons.plus,
                    tooltip: 'Add Items',
                    onPressed: onClosetToggle,
                  ),
                  _buildIconButton(
                    context: context,
                    icon: LucideIcons.layers,
                    tooltip: 'Layers',
                    onPressed: onLayersToggle,
                  ),
                  // Separator
                  _buildDivider(context),
                  // Auto Arrange
                  _buildIconButton(
                    context: context,
                    icon: LucideIcons.layout,
                    tooltip: 'Auto Arrange',
                    onPressed: onArrangeAuto,
                  ),
                  // Background
                  _buildIconButton(
                    context: context,
                    icon: LucideIcons.palette,
                    tooltip: 'Background',
                    onPressed: () => _showBackgroundPicker(context),
                  ),
                ],
              ),
            ),
          ),

          // Right Section - More Options
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildMoreOptionsMenu(context),
          ),
        ],
      ),
    );
  }



  Widget _buildIconButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: IconButton(
        icon: Icon(
          icon,
          size: 18,
          color: enabled ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
        ),
        tooltip: tooltip,
        onPressed: enabled ? onPressed : null,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(
          minWidth: 32,
          minHeight: 32,
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: colorScheme.outline.withValues(alpha: 0.3),
    );
  }

  Widget _buildMoreOptionsMenu(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<String>(
      icon: Icon(
        LucideIcons.moreHorizontal,
        size: 18,
        color: colorScheme.onSurface,
      ),
      tooltip: 'More Options',
      onSelected: (value) {
        // Handle menu item selection
        switch (value) {
          case 'ai-try-on':
            onTryOn(); // AI Try On as premium feature
            break;
          case 'background':
            _showBackgroundPicker(context);
            break;
          case 'export':
            onShare();
            break;
          case 'arrange':
            onArrangeAuto();
            break;
        }
      },
      itemBuilder: (context) => [
        // AI Try On - Premium Feature (highlighted)
        PopupMenuItem<String>(
          value: 'ai-try-on',
          child: Row(
            children: [
              Icon(
                LucideIcons.sparkles,
                size: 16,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'AI Try On',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                LucideIcons.star,
                size: 12,
                color: colorScheme.primary,
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'background',
          child: Row(
            children: [
              Icon(LucideIcons.palette, size: 16),
              SizedBox(width: 8),
              Text('Background'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'arrange',
          child: Row(
            children: [
              Icon(LucideIcons.layout, size: 16),
              SizedBox(width: 8),
              Text('Auto Arrange'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'export',
          child: Row(
            children: [
              Icon(LucideIcons.download, size: 16),
              SizedBox(width: 8),
              Text('Export'),
            ],
          ),
        ),
      ],
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
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

            const SizedBox(height: 20),

            // Color Grid
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildColorOption(context, Colors.white, 'White'),
                _buildColorOption(context, const Color(0xFFF8F9FA), 'Light Gray'),
                _buildColorOption(context, const Color(0xFFF1F3F4), 'Gray'),
                _buildColorOption(context, const Color(0xFFE8F5E8), 'Light Green'),
                _buildColorOption(context, const Color(0xFFE3F2FD), 'Light Blue'),
                _buildColorOption(context, const Color(0xFFF3E5F5), 'Light Purple'),
                _buildColorOption(context, const Color(0xFFFFF3E0), 'Light Orange'),
                _buildColorOption(context, const Color(0xFFFFEBEE), 'Light Red'),
                _buildColorOption(context, const Color(0xFF212121), 'Dark'),
                _buildColorOption(context, const Color(0xFF424242), 'Charcoal'),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(BuildContext context, Color color, String name) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLight = color.computeLuminance() > 0.5;

    return GestureDetector(
      onTap: () {
        onBackgroundChange(color);
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isLight ? null : Icon(LucideIcons.check, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: TextStyle(
              fontSize: 10,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
