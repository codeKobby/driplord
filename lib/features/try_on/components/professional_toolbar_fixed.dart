import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

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
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.glassBorder),
        ),
      ),
      child: Row(
        children: [
          // Left Section - Edit Tools
          _buildToolbarSection([
            _buildToolbarButton(
              icon: LucideIcons.undo2,
              label: 'Undo',
              onPressed: canUndo ? onUndo : null,
              enabled: canUndo,
            ),
            _buildToolbarButton(
              icon: LucideIcons.redo2,
              label: 'Redo',
              onPressed: canRedo ? onRedo : null,
              enabled: canRedo,
            ),
            _buildDivider(),
            _buildToolbarButton(
              icon: LucideIcons.sparkles,
              label: 'Auto Arrange',
              onPressed: onArrangeAuto,
            ),
          ]),

          // Center Section - Canvas Tools
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildToolbarButton(
                  icon: LucideIcons.palette,
                  label: 'Background',
                  onPressed: () => _showBackgroundPicker(context),
                ),
                _buildToolbarButton(
                  icon: LucideIcons.shirt,
                  label: 'Closet',
                  onPressed: onClosetToggle,
                  isActive: isClosetPanelVisible,
                ),
                _buildToolbarButton(
                  icon: LucideIcons.layers,
                  label: 'Layers',
                  onPressed: onLayersToggle,
                  isActive: isLayerPanelVisible,
                ),
              ],
            ),
          ),

          // Right Section - Actions
          _buildToolbarSection([
            _buildToolbarButton(
              icon: LucideIcons.eye,
              label: 'Try On',
              onPressed: onTryOn,
            ),
            _buildToolbarButton(
              icon: LucideIcons.share2,
              label: 'Share',
              onPressed: onShare,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildToolbarSection(List<Widget> children) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    bool enabled = true,
    bool isActive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? AppColors.primary : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: enabled
                    ? (isActive ? AppColors.primary : AppColors.textPrimary)
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: enabled
                      ? (isActive ? AppColors.primary : AppColors.textPrimary)
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 150.ms);
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: AppColors.glassBorder,
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
                _buildColorOption(Colors.white, 'White', context),
                _buildColorOption(const Color(0xFFF8F9FA), 'Light Gray', context),
                _buildColorOption(const Color(0xFFF1F3F4), 'Gray', context),
                _buildColorOption(const Color(0xFFE8F5E8), 'Light Green', context),
                _buildColorOption(const Color(0xFFE3F2FD), 'Light Blue', context),
                _buildColorOption(const Color(0xFFF3E5F5), 'Light Purple', context),
                _buildColorOption(const Color(0xFFFFF3E0), 'Light Orange', context),
                _buildColorOption(const Color(0xFFFFEBEE), 'Light Red', context),
                _buildColorOption(const Color(0xFF212121), 'Dark', context),
                _buildColorOption(const Color(0xFF424242), 'Charcoal', context),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color, String name, BuildContext context) {
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
