import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/providers/recommendation_provider.dart';
import '../../home/providers/saved_outfits_provider.dart';

/// Mode for the Style Composer
enum ComposerMode {
  tryOn, // Single item preview
  view, // Complete outfit display
  manual, // Drag-drop composition
  ai, // AI-generated with suggestions
  edit, // Modify existing outfit
}

/// Represents the underlying clothing data
class OutfitStackItem {
  final String id;
  final String category;
  final String name;
  final String imageUrl;
  final double? price;

  const OutfitStackItem({
    required this.id,
    required this.category,
    required this.name,
    required this.imageUrl,
    this.price,
  });
}

/// Represents an item on the interactive canvas
class CanvasItem {
  final String id;
  final OutfitStackItem data;
  Offset position;
  double scale;
  int zIndex;

  CanvasItem({
    required this.id,
    required this.data,
    required this.position,
    this.scale = 1.0,
    required this.zIndex,
  });

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

class StyleComposerScreen extends ConsumerStatefulWidget {
  const StyleComposerScreen({
    super.key,
    this.mode = ComposerMode.manual,
    this.initialItemId,
    this.outfitId,
    this.vibe,
  });

  final ComposerMode mode;
  final String? initialItemId;
  final String? outfitId;
  final String? vibe;

  @override
  ConsumerState<StyleComposerScreen> createState() =>
      _StyleComposerScreenState();
}

class _StyleComposerScreenState extends ConsumerState<StyleComposerScreen> {
  // Canvas State
  List<CanvasItem> _canvasItems = [];
  Color _backgroundColor = const Color(0xFFF5F5F5);

  // Track initial scale during gesture for delta calculation
  double? _baseScale;

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
      } else {
        _initializeCanvas();
      }
    });
  }

  void _loadOutfitForEdit(String outfitId) {
     // Mock loading logic based on ID
     // In a real app, fetch items from the outfit ID
     setState(() {
        _canvasItems = _mockRegistry.map((item) {
           return CanvasItem(
            id: item.id,
            data: item,
            position: Offset(
              MediaQuery.of(context).size.width / 2, 
              MediaQuery.of(context).size.height * 0.4 + (item.category == 'Top' ? -50 : item.category == 'Bottom' ? 150 : 350)
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
          yOffset = -50;
        } else if (item.category == 'Bottom') {
          yOffset = 150;
        } else if (item.category == 'Footwear') {
          yOffset = 350;
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

      // Sort by z-index initially
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

  void _removeItem(CanvasItem item) {
    setState(() {
      _canvasItems.removeWhere((i) => i.id == item.id);
    });
  }

  double get _totalPrice {
    return _canvasItems.fold(0.0, (sum, item) => sum + (item.data.price ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildToolbar(),
            Expanded(
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(double.infinity),
                minScale: 0.1,
                maxScale: 4.0,
                child: GestureDetector(
                  onTap: () {
                    // Background tap could deselect items
                  },
                  child: Container(
                    width: 3000, // Large canvas size
                    height: 3000,
                    alignment: Alignment.center,
                    color: Colors.transparent, // Hit test target
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: _canvasItems.map((item) {
                        return Positioned(
                          // Center items initially relative to the large canvas center
                          left:
                              item.position.dx +
                              1500 -
                              (MediaQuery.of(context).size.width / 2),
                          top:
                              item.position.dy +
                              1500 -
                              (MediaQuery.of(context).size.height * 0.4),
                          child: _buildCanvasItem(item),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showTryOnSheet,
        backgroundColor: AppColors.pureBlack,
        foregroundColor: AppColors.pureWhite,
        icon: const Icon(LucideIcons.sparkles),
        label: const Text('AI Try On'),
      ),
    );
  }

  Widget _buildCanvasItem(CanvasItem item) {
    return GestureDetector(
      onScaleStart: (details) {
        _baseScale = item.scale;
        _bringToFront(item);
      },
      onScaleUpdate: (details) {
        setState(() {
          // Drag Logic (Pan)
          item.position += details.focalPointDelta;

          // Pinch/Scale Logic (Uniform)
          if (_baseScale != null && details.scale != 1.0) {
            final newScale = _baseScale! * details.scale;
            item.scale = newScale.clamp(0.5, 3.0);
          }
        });
      },
      onScaleEnd: (details) {
        _baseScale = null;
      },
      onTap: () {
        _bringToFront(item);
      },
      onLongPress: () {
        _showItemContextMenu(item);
      },
      child: Transform.scale(
        scale: item.scale,
        child: SizedBox(
          width: 200,
          height: 200,
          child: Image.network(
            item.data.imageUrl,
            fit: BoxFit.contain, // Maintain aspect ratio within box
            errorBuilder: (context, error, stackTrace) =>
                const Icon(LucideIcons.alertCircle),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
                icon: Icon(LucideIcons.x, color: AppColors.textPrimary),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Canvas',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${_canvasItems.length} items',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.pureBlack,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '\$${_totalPrice.toStringAsFixed(2)}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.pureWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildToolbarAction(LucideIcons.plus, 'Add Item', () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Add Item coming soon')),
            );
          }),
          _buildToolbarAction(
            LucideIcons.palette,
            'Background',
            _showColorPicker,
          ),
          _buildToolbarAction(LucideIcons.trash2, 'Clear', () {
            setState(() {
              _canvasItems.clear();
            });
          }),
          _buildToolbarAction(LucideIcons.save, 'Save Look', () {
            _saveOutfit();
          }),
        ],
      ),
    );
  }

  Widget _buildToolbarAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.textPrimary.withValues(alpha: 0.87)),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary.withValues(alpha: 0.87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Features Logic ---

  void _saveOutfit() {
    if (widget.mode == ComposerMode.edit && widget.outfitId != null) {
      // Create a variant recommendation
      final originalId = widget.outfitId!;
      final variantId = "${originalId}_variant_${DateTime.now().millisecondsSinceEpoch}";
      
      // In a real app, we'd generate a composite image from the canvas
      // For now, use a placeholder or reuse the first item's image
      final variantImage = _canvasItems.isNotEmpty 
          ? _canvasItems.first.data.imageUrl 
          : "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400";

      final variant = Recommendation(
        id: variantId,
        title: "My Twist on ${originalId.split('_').first}", // specific title logic can be improved
        imageUrl: variantImage,
        tags: ["edited", "my-style"],
        confidenceScore: 1.0, // User created it, so 100% confidence!
        reasoning: "You customized this look yourself.",
      );

      // Save as variant
      ref.read(savedOutfitsProvider.notifier).saveVariant(variant);
      
      // Set as today's active outfit
      ref.read(dailyOutfitProvider.notifier).setActive(variant);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Saved as today\'s outfit!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Navigate back to home
      context.go('/home');
    } else {
       ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Look saved to collection!')));
    }
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Background Color',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildColorOption(const Color(0xFFF5F5F5)),
                    _buildColorOption(Colors.white),
                    _buildColorOption(const Color(0xFFE0E0E0)),
                    _buildColorOption(const Color(0xFFD7CCC8)), // Beige
                    _buildColorOption(const Color(0xFFCFD8DC)), // Blue Grey
                    _buildColorOption(const Color(0xFF1A1A1A)), // Dark
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _backgroundColor = color;
        });
        Navigator.pop(context);
      },
      child: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.glassBorder),
          boxShadow: [
            if (_backgroundColor == color)
              BoxShadow(
                color: AppColors.pureBlack.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
      ),
    );
  }

  void _showItemContextMenu(CanvasItem item) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(LucideIcons.refreshCcw),
                title: const Text('Replace Item'),
                onTap: () {
                  Navigator.pop(context);
                  _showReplacementSheet(item);
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.search),
                title: const Text('Find Similar'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Finding similar items...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.arrowUp),
                title: const Text('Bring to Front'),
                onTap: () {
                  _bringToFront(item);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(LucideIcons.trash2, color: AppColors.error),
                title: Text(
                  'Remove from Canvas',
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  _removeItem(item);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReplacementSheet(CanvasItem currentItem) {
    // Mock replacements
    final replacements = [
      OutfitStackItem(
        id: '${currentItem.data.category.toLowerCase()}_alt1',
        category: currentItem.data.category,
        name: 'Alternative ${currentItem.data.name}',
        imageUrl:
            'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400',
        price: 39.99,
      ),
      OutfitStackItem(
        id: '${currentItem.data.category.toLowerCase()}_alt2',
        category: currentItem.data.category,
        name: 'Premium ${currentItem.data.name}',
        imageUrl:
            'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=400',
        price: 79.99,
      ),
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Replace ${currentItem.data.name}',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: replacements.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final rep = replacements[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Replace data but keep ID/Position/Scale/ZIndex
                          // Actually we usually replace the ID too for logic uniqueness,
                          // but for the CanvasItem wrapper we might want to keep that reference or replace it.
                          // Let's replace the data in the existing CanvasItem wrapper if possible,
                          // OR find the index and swap the CanvasItem.

                          final idx = _canvasItems.indexWhere(
                            (i) => i.id == currentItem.id,
                          );
                          if (idx != -1) {
                            _canvasItems[idx] = CanvasItem(
                              id: rep.id, // New ID
                              data: rep,
                              position: currentItem.position, // Keep position
                              scale: currentItem.scale, // Keep scale
                              zIndex: currentItem.zIndex, // Keep z-index
                            );
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: NetworkImage(rep.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            rep.name,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '\$${rep.price}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTryOnSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildTryOnResultSheet(),
    );
  }

  Widget _buildTryOnResultSheet() {
    // Mock Try On Logic
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.glassBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'AI Virtual Try-On',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        height: 400,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(24),
                          image: const DecorationImage(
                            image: NetworkImage(
                              "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: 16,
                              bottom: 16,
                              child: CircleAvatar(
                                backgroundColor: AppColors.surface,
                                child: IconButton(
                                  icon: Icon(
                                    LucideIcons.share2,
                                    color: AppColors.textPrimary,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "This outfit has been generated based on your canvas composition.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.pureBlack,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              "Back to Canvas",
                              style: TextStyle(color: AppColors.pureWhite),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
