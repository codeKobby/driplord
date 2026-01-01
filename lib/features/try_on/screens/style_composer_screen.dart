import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/components/common/fixed_app_bar.dart';
import '../../../core/theme/app_colors.dart';
import '../../closet/providers/closet_provider.dart';

/// Mode for the Style Composer
enum ComposerMode {
  tryOn, // Single item preview
  view, // Complete outfit display
  manual, // Drag-drop composition
  ai, // AI-generated with suggestions
  edit, // Modify existing outfit
}

/// Represents an item in the outfit stack
class OutfitStackItem {
  final String id;
  final String category;
  final String name;
  final String imageUrl;
  final double? price;
  final bool isPlaceholder;

  const OutfitStackItem({
    required this.id,
    required this.category,
    required this.name,
    required this.imageUrl,
    this.price,
    this.isPlaceholder = false,
  });
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
  int _currentOutfitIndex = 0;
  final int _totalOutfits = 30; // Simulated total AI suggestions

  // Mock outfit stack - in real app this would come from provider
  List<OutfitStackItem> _outfitStack = [
    const OutfitStackItem(
      id: 'top_1',
      category: 'Top',
      name: 'Beige Wool Sweater',
      imageUrl:
          'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=300',
      price: 49.99,
    ),
    const OutfitStackItem(
      id: 'bottom_1',
      category: 'Bottom',
      name: 'Loose Straight Jeans',
      imageUrl:
          'https://images.unsplash.com/photo-1542272604-787c3835535d?w=300',
      price: 49.99,
    ),
    const OutfitStackItem(
      id: 'shoes_1',
      category: 'Footwear',
      name: 'New Balance 530 Sneakers',
      imageUrl:
          'https://images.unsplash.com/photo-1539185441755-769473a23570?w=300',
      price: 129.99,
    ),
  ];

  bool _isTryOnMode = false;
  String? _tryOnImageUrl;
  bool _isGeneratingTryOn = false;

  @override
  void initState() {
    super.initState();
    _currentOutfitIndex = 1; // Start at outfit 9 like reference

    // Initialize based on mode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeState();
    });
  }

  void _initializeState() {
    if (widget.mode == ComposerMode.tryOn && widget.initialItemId != null) {
      // Logic to load single item and auto-populate rest of outfit
      // For now, we'll just show the mock stack but simulate "populating"
      _populateOutfitAroundItem(widget.initialItemId!);
    } else if (widget.mode == ComposerMode.ai && widget.vibe != null) {
      // Logic to generate outfit based on vibe
      _generateAiOutfit(widget.vibe!);
    }
  }

  void _populateOutfitAroundItem(String itemId) {
    // In a real app, this would fetch compatiable items from closet
    // For now, we simulate by modifying the top item ID
    setState(() {
      // Keep mock stack but pretending we built it around item
      // Real implementation would look up item category and replace corresponding slot
    });
  }

  void _generateAiOutfit(String vibe) {
    // Mock AI generation
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Generating $vibe outfit...')));
  }

  String _getTitleForMode() {
    switch (widget.mode) {
      case ComposerMode.tryOn:
        return 'Try On';
      case ComposerMode.view:
        return 'Outfit Details';
      case ComposerMode.manual:
        return 'Style Composer';
      case ComposerMode.ai:
        return 'AI Stylist';
      case ComposerMode.edit:
        return 'Edit Outfit';
    }
  }

  double get _totalPrice {
    return _outfitStack
        .where((item) => item.price != null)
        .fold(0.0, (sum, item) => sum + (item.price ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildPreviewArea(),
                    const SizedBox(height: 16),

                    // Outfit Stack
                    ..._outfitStack.asMap().entries.map((entry) {
                      return _buildOutfitItem(entry.value, entry.key)
                          .animate(
                            delay: Duration(milliseconds: entry.key * 100),
                          )
                          .fadeIn()
                          .slideY(begin: 0.1, end: 0);
                    }),

                    // Add item button
                    if (widget.mode == ComposerMode.manual)
                      _buildAddItemButton(),

                    const SizedBox(height: 100), // Space for bottom actions
                  ],
                ),
              ),
            ),

            // Bottom Actions
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  LucideIcons.chevronLeft,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              if (widget.mode != ComposerMode.manual)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Text(
                    _getTitleForMode(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
            ],
          ),

          // Outfit counter (for AI mode)
          if (widget.mode == ComposerMode.ai)
            Expanded(
              child: Center(
                child: Text(
                  '${_currentOutfitIndex + 1} / $_totalOutfits',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            )
          else
            const Spacer(),

          // Total price
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.1),
              ),
            ),
            child: Text(
              '\$${_totalPrice.toStringAsFixed(2)}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewArea() {
    return Column(
      children: [
        // Mode Toggle
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleOption('Outfit Stack', !_isTryOnMode),
              _buildToggleOption('AI Try On', _isTryOnMode),
            ],
          ),
        ),

        // Try On View
        if (_isTryOnMode)
          Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(24),
              image: _tryOnImageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(_tryOnImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _tryOnImageUrl == null
                ? Center(
                    child: _isGeneratingTryOn
                        ? const CircularProgressIndicator()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.sparkles,
                                color: Colors.white.withValues(alpha: 0.5),
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tap to generate AI Try On',
                                style: GoogleFonts.inter(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _generateTryOn,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                ),
                                child: const Text('Generate Look'),
                              ),
                            ],
                          ),
                  )
                : Stack(
                    children: [
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton.small(
                          onPressed: _generateTryOn,
                          backgroundColor: Colors.white,
                          child: const Icon(
                            LucideIcons.refreshCcw,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
          )
        else
          // Minimal summary or nothing if stack is visible below
          const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildToggleOption(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isTryOnMode = label == 'AI Try On';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.onSurface
              : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Theme.of(context).colorScheme.surface
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Future<void> _generateTryOn() async {
    setState(() {
      _isGeneratingTryOn = true;
    });

    // Simulate AI generation delay
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isGeneratingTryOn = false;
        // Mock result image
        _tryOnImageUrl =
            "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800";
      });
    }
  }

  Widget _buildOutfitItem(OutfitStackItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          // Item image
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: Icon(
                        LucideIcons.shirt,
                        size: 64,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                    );
                  },
                ),
              ),

              // Price tag
              if (item.price != null)
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '\$${item.price!.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),

              // Swap button
              Positioned(
                right: 12,
                bottom: 12,
                child: _buildSwapButton(() => _showReplacementSheet(index)),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Item name
          Text(
            item.name,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSwapButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          LucideIcons.refreshCcw,
          size: 18,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildAddItemButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: GestureDetector(
        onTap: _showAddItemSheet,
        child: Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.1),
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.plus,
                size: 32,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 8),
              Text(
                'Add Accessory',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Discard button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                LucideIcons.x,
                size: 28,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),

          const SizedBox(width: 48),

          // Save/Favorite button
          GestureDetector(
            onTap: _saveOutfit,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                LucideIcons.heart,
                size: 28,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReplacementSheet(int itemIndex) {
    final item = _outfitStack[itemIndex];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildReplacementSheet(item, itemIndex),
    );
  }

  Widget _buildReplacementSheet(OutfitStackItem item, int index) {
    // Mock replacement items
    final replacements = [
      OutfitStackItem(
        id: '${item.category.toLowerCase()}_2',
        category: item.category,
        name: 'Alternative ${item.category}',
        imageUrl:
            'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=200',
        price: 39.99,
      ),
      OutfitStackItem(
        id: '${item.category.toLowerCase()}_3',
        category: item.category,
        name: 'Premium ${item.category}',
        imageUrl:
            'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=200',
        price: 79.99,
      ),
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Replace ${item.category}',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: replacements.length,
              itemBuilder: (context, i) {
                final replacement = replacements[i];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _outfitStack[index] = replacement;
                    });
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            replacement.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        replacement.name,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (replacement.price != null)
                        Text(
                          '\$${replacement.price!.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
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
  }

  void _showAddItemSheet() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add accessory feature coming soon!')),
    );
  }

  void _saveOutfit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Outfit saved to your collection!'),
        backgroundColor: AppColors.success,
      ),
    );
    context.pop();
  }
}
