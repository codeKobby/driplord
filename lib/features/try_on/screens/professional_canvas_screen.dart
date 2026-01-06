import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/components/common/fixed_app_bar.dart';
import '../components/professional_toolbar.dart';
import '../components/professional_layer_panel.dart';
import '../components/professional_closet_panel.dart';
import '../components/professional_selection_system.dart';
import '../components/selection_system.dart';
import '../models/outfit_item.dart';

/// Mode for the Style Composer
enum ComposerMode {
  tryOn, // Single item preview
  view, // Complete outfit display
  manual, // Drag-drop composition
  ai, // AI-generated with suggestions
  edit, // Modify existing outfit
}

/// Professional Canvas Screen - Canva/Photoshop-style design
class ProfessionalCanvasScreen extends ConsumerStatefulWidget {
  const ProfessionalCanvasScreen({
    super.key,
    this.mode = ComposerMode.manual,
    this.initialItemId,
    this.outfitId,
    this.vibe,
    this.initialItems,
  });

  final ComposerMode mode;
  final String? initialItemId;
  final String? outfitId;
  final String? vibe;
  final List<OutfitStackItem>? initialItems;

  @override
  ConsumerState<ProfessionalCanvasScreen> createState() =>
      _ProfessionalCanvasScreenState();
}

class _ProfessionalCanvasScreenState
    extends ConsumerState<ProfessionalCanvasScreen> {
  // Canvas State
  List<CanvasItem> _canvasItems = [];
  Color _backgroundColor = const Color(0xFFF8F9FA);
  bool _isClosetPanelVisible = false;
  bool _isLayerPanelVisible = false;

  // Default Mock Items
  final List<OutfitStackItem> _mockRegistry = [
    const OutfitStackItem(
      id: 'top_1',
      category: 'Top',
      name: 'Beige Wool Sweater',
      imageUrl:
          'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=400',
      price: 49.99,
    ),
    const OutfitStackItem(
      id: 'bottom_1',
      category: 'Bottom',
      name: 'Loose Straight Jeans',
      imageUrl:
          'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400',
      price: 49.99,
    ),
    const OutfitStackItem(
      id: 'shoes_1',
      category: 'Footwear',
      name: 'New Balance 530 Sneakers',
      imageUrl:
          'https://images.unsplash.com/photo-1539185441755-769473a23570?w=400',
      price: 129.99,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.mode == ComposerMode.edit && widget.outfitId != null) {
        _loadOutfitForEdit(widget.outfitId!);
      } else if (widget.initialItems != null) {
        _initializeCanvasWithItems(widget.initialItems!);
      } else {
        _initializeCanvas();
      }
    });
  }

  void _initializeCanvasWithItems(List<OutfitStackItem> items) {
    final Size screenSize = MediaQuery.of(context).size;
    final Offset center = Offset(screenSize.width / 2, screenSize.height * 0.4);

    setState(() {
      _canvasItems = items.map((item) {
        double yOffset = 0;
        if (item.category.toLowerCase().contains('top')) {
          yOffset = -80;
        } else if (item.category.toLowerCase().contains('bottom')) {
          yOffset = 80;
        } else if (item.category.toLowerCase().contains('shoe') ||
            item.category.toLowerCase().contains('footwear')) {
          yOffset = 240;
        }

        return CanvasItem(
          id: "${item.id}_canvas",
          data: item,
          position: center + Offset(0, yOffset),
          scale: 1.0,
          zIndex: CanvasItem.getDefaultZIndex(item.category),
        );
      }).toList();

      _canvasItems.sort((a, b) => a.zIndex.compareTo(b.zIndex));
    });
  }

  void _loadOutfitForEdit(String outfitId) {
    setState(() {
      _canvasItems = _mockRegistry.map((item) {
        return CanvasItem(
          id: item.id,
          data: item,
          position: Offset(
            MediaQuery.of(context).size.width / 2,
            MediaQuery.of(context).size.height * 0.4 +
                (item.category == 'Top'
                    ? -80
                    : item.category == 'Bottom'
                    ? 80
                    : 240),
          ),
          zIndex: CanvasItem.getDefaultZIndex(item.category),
        );
      }).toList();
    });
  }

  void _initializeCanvas() {
    final Size screenSize = MediaQuery.of(context).size;
    final Offset center = Offset(screenSize.width / 2, screenSize.height * 0.4);

    setState(() {
      _canvasItems = _mockRegistry.map((item) {
        double yOffset;
        if (item.category == 'Top') {
          yOffset = -80;
        } else if (item.category == 'Bottom') {
          yOffset = 80;
        } else if (item.category == 'Footwear') {
          yOffset = 240;
        } else {
          yOffset = 0;
        }

        double xOffset = 0;

        return CanvasItem(
          id: item.id,
          data: item,
          position: center + Offset(xOffset, yOffset),
          scale: 1.0,
          zIndex: CanvasItem.getDefaultZIndex(item.category),
        );
      }).toList();

      _canvasItems.sort((a, b) => a.zIndex.compareTo(b.zIndex));
    });
  }

  void _bringToFront(CanvasItem item) {
    setState(() {
      int maxZ = _canvasItems.fold(
        0,
        (max, i) => i.zIndex > max ? i.zIndex : max,
      );
      item.zIndex = maxZ + 1;
      _canvasItems.sort((a, b) => a.zIndex.compareTo(b.zIndex));
    });
  }

  void _sendToBack(CanvasItem item) {
    setState(() {
      int minZ = _canvasItems.fold(
        999,
        (min, i) => i.zIndex < min ? i.zIndex : min,
      );
      item.zIndex = minZ - 1;
      _canvasItems.sort((a, b) => a.zIndex.compareTo(b.zIndex));
    });
  }

  void _removeItem(String itemId) {
    setState(() {
      _canvasItems.removeWhere((i) => i.id == itemId);
    });
  }

  void _toggleClosetPanel() {
    setState(() {
      _isClosetPanelVisible = !_isClosetPanelVisible;
      if (_isClosetPanelVisible) {
        _isLayerPanelVisible = false; // Close layer panel when opening closet
      }
    });
  }

  void _toggleLayerPanel() {
    setState(() {
      _isLayerPanelVisible = !_isLayerPanelVisible;
      if (_isLayerPanelVisible) {
        _isClosetPanelVisible = false; // Close closet panel when opening layers
      }
    });
  }

  void _addItemFromCloset(OutfitStackItem item) {
    final Size screenSize = MediaQuery.of(context).size;
    final Offset center = Offset(screenSize.width / 2, screenSize.height * 0.4);

    setState(() {
      double yOffset = 0;
      if (item.category.toLowerCase().contains('top')) {
        yOffset = -80;
      } else if (item.category.toLowerCase().contains('bottom')) {
        yOffset = 80;
      } else if (item.category.toLowerCase().contains('shoe') ||
          item.category.toLowerCase().contains('footwear')) {
        yOffset = 240;
      }

      final newItem = CanvasItem(
        id: "${item.id}_canvas_${DateTime.now().millisecondsSinceEpoch}",
        data: item,
        position: center + Offset(0, yOffset),
        scale: 1.0,
        zIndex: CanvasItem.getDefaultZIndex(item.category),
      );

      _canvasItems.add(newItem);
      _canvasItems.sort((a, b) => a.zIndex.compareTo(b.zIndex));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${item.name} to canvas'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updateItemOpacity(String itemId, double opacity) {
    setState(() {
      final index = _canvasItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _canvasItems[index] = _canvasItems[index].copyWith(opacity: opacity);
      }
    });
  }

  void _toggleItemVisibility(String itemId) {
    setState(() {
      final index = _canvasItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        final current = _canvasItems[index].isVisible ?? true;
        _canvasItems[index] = _canvasItems[index].copyWith(isVisible: !current);
      }
    });
  }

  void _toggleItemLock(String itemId) {
    setState(() {
      final index = _canvasItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        final current = _canvasItems[index].isLocked ?? false;
        _canvasItems[index] = _canvasItems[index].copyWith(isLocked: !current);
      }
    });
  }

  void _reorderItems(String itemId) {
    setState(() {
      final item = _canvasItems.firstWhere((i) => i.id == itemId);
      _bringToFront(item);
    });
  }

  void _saveOutfit() {
    if (_canvasItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add some items to your canvas first'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Outfit saved successfully!'),
        backgroundColor: AppColors.success,
      ),
    );

    // Navigate back after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  void _showTryOn() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Virtual try-on coming soon!')),
    );
  }

  void _onArrangeAuto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AI Auto-arrange coming soon!')),
    );
  }

  void _onShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share feature coming soon!')),
    );
  }

  void _onBackgroundChange(Color color) {
    setState(() {
      _backgroundColor = color;
    });
  }

  void _onUndo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Undo coming soon!')),
    );
  }

  void _onRedo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Redo coming soon!')),
    );
  }

  Widget _buildContextualToolbar(String selectedItemId) {
    final selectedItem = _canvasItems.firstWhere((item) => item.id == selectedItemId);
    final isLocked = selectedItem.isLocked ?? false;

    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Replace
          _buildContextualButton(
            icon: LucideIcons.refreshCw,
            label: 'Replace',
            onPressed: () {
              // Open closet panel to replace current item
              setState(() {
                _isClosetPanelVisible = true;
                _isLayerPanelVisible = false;
              });
              // TODO: Implement item replacement logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Select a new item from the closet to replace this one')),
              );
            },
          ),

          // Delete
          _buildContextualButton(
            icon: LucideIcons.trash2,
            label: 'Delete',
            onPressed: () => _removeItem(selectedItemId),
            color: AppColors.error,
          ),

          // Layer Controls
          _buildContextualButton(
            icon: LucideIcons.arrowUp,
            label: 'Front',
            onPressed: () => _bringToFront(selectedItem),
          ),

          _buildContextualButton(
            icon: LucideIcons.arrowDown,
            label: 'Back',
            onPressed: () => _sendToBack(selectedItem),
          ),

          // Lock/Unlock
          _buildContextualButton(
            icon: isLocked ? LucideIcons.lock : LucideIcons.unlock,
            label: isLocked ? 'Unlock' : 'Lock',
            onPressed: () => _toggleItemLock(selectedItemId),
            color: isLocked ? AppColors.warning : AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildContextualButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    final buttonColor = color ?? AppColors.primary;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: buttonColor,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: buttonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectionState = ref.watch(selectionProvider);
    final selectedItemId = selectionState.hasSelection
        ? selectionState.selectedItems.first
        : null;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: FixedAppBar(
        title: 'Style Canvas',
        actions: [
          // AI Try On - Premium Feature
          IconButton(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.sparkles, color: AppColors.primary, size: 18),
                const SizedBox(width: 4),
                Icon(LucideIcons.star, color: AppColors.primary, size: 12),
              ],
            ),
            onPressed: _showTryOn,
            tooltip: 'AI Try On',
          ),
          IconButton(
            icon: Icon(LucideIcons.save, color: AppColors.textPrimary),
            onPressed: _saveOutfit,
            tooltip: 'Save Outfit',
          ),
        ],
      ),
      body: Column(
        children: [
          // Professional Toolbar (Top) with Subtle Shadow
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ProfessionalToolbar(
              onUndo: _onUndo,
              onRedo: _onRedo,
              onArrangeAuto: _onArrangeAuto,
              onBackgroundChange: _onBackgroundChange,
              onTryOn: _showTryOn,
              onShare: _onShare,
              onClosetToggle: _toggleClosetPanel,
              onLayersToggle: _toggleLayerPanel,
              isClosetPanelVisible: _isClosetPanelVisible,
              isLayerPanelVisible: _isLayerPanelVisible,
              canUndo: false, // TODO: Implement undo/redo
              canRedo: false,
            ),
          ),

          // Main Canvas Area
          Expanded(
            child: Row(
              children: [
                // Left Panel (Closet or Layers)
                if (_isClosetPanelVisible)
                  ProfessionalClosetPanel(
                    onAddItem: _addItemFromCloset,
                    onClose: _toggleClosetPanel,
                    canvasItems: _canvasItems,
                  )
                else if (_isLayerPanelVisible)
                  ProfessionalLayerPanel(
                    items: _canvasItems,
                    selectedItemId: selectedItemId,
                    onItemSelect: (itemId) {
                      ref
                          .read(selectionProvider.notifier)
                          .toggleSelection(itemId);
                    },
                    onItemReorder: (itemId) => _reorderItems(itemId),
                    onItemToggleVisibility: _toggleItemVisibility,
                    onItemToggleLock: _toggleItemLock,
                    onItemRemove: _removeItem,
                    onItemOpacityChange: (opacityMap) {
                      opacityMap.forEach((itemId, opacity) {
                        _updateItemOpacity(itemId, opacity);
                      });
                    },
                    onClose: _toggleLayerPanel,
                  ),

                // Canvas Area with Subtle Shadow
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _backgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ProfessionalCanvasArea(
                      items: _canvasItems,
                      onItemSelect: (itemId) {
                        ref.read(selectionProvider.notifier).toggleSelection(itemId);
                      },
                      onItemUpdate: (item) {
                        setState(() {
                          final index = _canvasItems.indexWhere((i) => i.id == item.id);
                          if (index != -1) {
                            _canvasItems[index] = item;
                          }
                        });
                      },
                      onBringToFront: _bringToFront,
                      onSendToBack: _sendToBack,
                      onRemoveItem: _removeItem,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Contextual Toolbar (when items selected)
          if (selectedItemId != null) _buildContextualToolbar(selectedItemId),

            // Bottom Status Bar (Safe Area Compliant)
            SafeArea(
              top: false, // Don't add padding to top
              bottom: true, // Add padding to bottom for home indicator/notch
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    top: BorderSide(color: AppColors.glassBorder),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(
                      LucideIcons.palette,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_canvasItems.length} items',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Canvas',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
