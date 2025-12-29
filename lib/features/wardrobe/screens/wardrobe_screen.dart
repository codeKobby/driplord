import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/components/cards/glass_card.dart';
import '../../../core/components/buttons/primary_button.dart';
import '../../../core/components/buttons/secondary_button.dart';
import '../../../core/constants/app_dimensions.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  List<Map<String, dynamic>> _wardrobeItems = [];
  bool _isLoading = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadWardrobe();
  }

  Future<void> _loadWardrobe() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Load wardrobe items from Supabase
      // For now, create mock data
      await Future.delayed(const Duration(seconds: 1)); // Simulate delay
      _wardrobeItems = [
        {
          'id': '1',
          'name': 'White T-Shirt',
          'category': 'Top',
          'color': 'White',
          'brand': 'Uniqlo',
          'image': 'assets/images/tshirt.jpg',
        },
        {
          'id': '2',
          'name': 'Blue Jeans',
          'category': 'Bottom',
          'color': 'Blue',
          'brand': 'Levi\'s',
          'image': 'assets/images/jeans.jpg',
        },
        {
          'id': '3',
          'name': 'Black Sneakers',
          'category': 'Shoes',
          'color': 'Black',
          'brand': 'Nike',
          'image': 'assets/images/sneakers.jpg',
        },
      ];
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to load wardrobe: ${e.toString()}"),
          backgroundColor: AppColors.error,
        ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addClothing() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // TODO: Upload image to Supabase Storage and save to database
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Image selected! (Upload coming soon)"),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to pick image: ${e.toString()}"),
          backgroundColor: AppColors.error,
        ));
      }
    }
  }

  Future<void> _addClothingFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        // TODO: Upload image to Supabase Storage and save to database
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Photo taken! (Upload coming soon)"),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to take photo: ${e.toString()}"),
          backgroundColor: AppColors.error,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "My Wardrobe",
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () {},
            color: AppColors.textPrimary,
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingState()
            : _wardrobeItems.isEmpty
                ? _buildEmptyState()
                : _buildWardrobeGrid(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addClothing,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            "Loading your wardrobe...",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.shirt, size: 80, color: AppColors.textSecondary),
          const SizedBox(height: 24),
          Text(
            "Your wardrobe is empty",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add your first clothing item to get started",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Column(
            children: [
              PrimaryButton(
                text: "Add from Gallery",
                onPressed: _addClothing,
                icon: LucideIcons.image,
              ),
              const SizedBox(height: 16),
              SecondaryButton(
                text: "Take Photo",
                onPressed: _addClothingFromCamera,
                icon: LucideIcons.camera,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildWardrobeGrid() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter buttons
          Row(
            children: [
              _buildFilterChip("All", isSelected: true),
              const SizedBox(width: 8),
              _buildFilterChip("Tops"),
              const SizedBox(width: 8),
              _buildFilterChip("Bottoms"),
              const SizedBox(width: 8),
              _buildFilterChip("Shoes"),
            ],
          ),
          const SizedBox(height: 24),

          // Grid view
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: _wardrobeItems.length,
              itemBuilder: (context, index) {
                final item = _wardrobeItems[index];
                return _buildWardrobeItemCard(item, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      backgroundColor: isSelected ? AppColors.primary : AppColors.surface,
      selectedColor: isSelected ? AppColors.primary : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.transparent : AppColors.glassBorder,
        ),
      ),
      selected: isSelected,
      onSelected: (bool selected) {},
    );
  }

  Widget _buildWardrobeItemCard(Map<String, dynamic> item, int index) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Image placeholder
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Center(
              child: Icon(
                LucideIcons.shirt,
                size: 48,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          
          // Category badge
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item['category'],
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Color indicator
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _getColorFromString(item['color']),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.glassBorder, width: 1),
              ),
            ),
          ),

          // Item details
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.surface.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimensions.radiusMd),
                  bottomRight: Radius.circular(AppDimensions.radiusMd),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['brand'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Actions overlay
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.heart, size: 18),
                  onPressed: () {},
                  color: AppColors.textSecondary,
                  splashRadius: 20,
                ),
                IconButton(
                  icon: const Icon(LucideIcons.moreVertical, size: 18),
                  onPressed: () {},
                  color: AppColors.textSecondary,
                  splashRadius: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (200 + index * 50).ms);
  }

  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'white':
        return Colors.white;
      case 'black':
        return Colors.black;
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'orange':
        return Colors.orange;
      case 'gray':
      case 'grey':
        return Colors.grey;
      default:
        return AppColors.textSecondary;
    }
  }
}
