import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/components/buttons/primary_button.dart';
import '../../../core/components/buttons/secondary_button.dart';
import '../providers/closet_provider.dart';

class ClosetItemDetailScreen extends ConsumerWidget {
  const ClosetItemDetailScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(closetProvider);
    final item = items.firstWhere(
      (item) => item.id == itemId,
      orElse: () => ClothingItem(
        id: itemId,
        name: 'Item Not Found',
        category: 'Unknown',
        imageUrl: '',
        addedDate: DateTime.now(),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "ITEM DETAILS",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 4,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Hero Image
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: item.imageUrl.isNotEmpty
                  ? Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: const Center(
                          child: Icon(LucideIcons.imageOff, size: 48),
                        ),
                      ),
                    )
                  : Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: const Center(
                        child: Icon(LucideIcons.imageOff, size: 48),
                      ),
                    ),
            ),

            const SizedBox(height: 32),

            // Item Info
            Text(
              item.name.toUpperCase(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.category.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Added ${_getRelativeTime(item.addedDate)}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),

            const SizedBox(height: 32),

            // Quick Actions
            Text(
              "QUICK ACTIONS",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 4,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),

            // Create Outfit Button
            PrimaryButton(
              text: "CREATE OUTFIT WITH THIS",
              onPressed: () => _createOutfitWithItem(context, item),
              icon: LucideIcons.palette,
            ),
            const SizedBox(height: 12),

            // View Details Button (shows bottom sheet)
            SecondaryButton(
              text: "VIEW FULL DETAILS",
              onPressed: () => _showItemDetailsBottomSheet(context, ref, item),
              icon: LucideIcons.info,
            ),

            const SizedBox(height: 32),

            // Suggestions
            Text(
              "SUGGESTIONS",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 4,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),

            _buildSuggestionCard(
              context,
              "Complete the Look",
              "Add complementary pieces to create a full outfit",
              LucideIcons.layers,
              () => _suggestComplementaryItems(context, item),
            ),
            const SizedBox(height: 12),

            _buildSuggestionCard(
              context,
              "Style Inspiration",
              "See how this piece fits your style preferences",
              LucideIcons.lightbulb,
              () => _showStyleInspiration(context, item),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return "today";
    if (diff.inDays == 1) return "yesterday";
    return "${diff.inDays} days ago";
  }

  void _createOutfitWithItem(BuildContext context, ClothingItem item) {
    // Navigate to style composer with this item pre-selected
    context.push('/try-on/compose', extra: {'initialItem': item});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Starting outfit creation with ${item.name}')),
    );
  }

  void _suggestComplementaryItems(BuildContext context, ClothingItem item) {
    // Show complementary items suggestion
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Finding complementary pieces...')),
    );
  }

  void _showStyleInspiration(BuildContext context, ClothingItem item) {
    // Show style inspiration based on this item
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Analyzing style compatibility...')),
    );
  }

  void _showItemDetailsBottomSheet(BuildContext context, WidgetRef ref, ClothingItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ItemDetailsBottomSheet(item: item, ref: ref),
    );
  }
}

class ItemDetailsBottomSheet extends ConsumerStatefulWidget {
  const ItemDetailsBottomSheet({super.key, required this.item, required this.ref});

  final ClothingItem item;
  final WidgetRef ref;

  @override
  ConsumerState<ItemDetailsBottomSheet> createState() => _ItemDetailsBottomSheetState();
}

class _ItemDetailsBottomSheetState extends ConsumerState<ItemDetailsBottomSheet> {
  bool _isEditing = false;

  // Controllers for editing
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _priceController;
  String? _selectedCategory;
  String? _selectedColor;

  final List<String> _categories = [
    'Tops', 'Bottoms', 'Shoes', 'Outerwear', 'Accessories', 'Dresses', 'Skirts'
  ];

  final List<String> _colors = [
    'Black', 'White', 'Gray', 'Navy', 'Red', 'Blue', 'Green', 'Yellow', 'Pink', 'Purple', 'Brown', 'Beige'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _brandController = TextEditingController(text: widget.item.brand ?? '');
    _priceController = TextEditingController(text: widget.item.purchasePrice?.toString() ?? '');
    _selectedCategory = widget.item.category;
    _selectedColor = widget.item.color;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 32,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEditing ? 'EDIT ITEM' : 'ITEM DETAILS',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (!_isEditing)
                  IconButton(
                    icon: const Icon(LucideIcons.edit3),
                    onPressed: () => setState(() => _isEditing = true),
                    color: Theme.of(context).colorScheme.primary,
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => _isEditing = false),
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: _saveChanges,
                        child: Text(
                          'SAVE',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 24),

            if (_isEditing) ...[
              // Editing Mode
              _buildTextField('Name', _nameController),
              const SizedBox(height: 16),
              _buildDropdownField('Category', _selectedCategory, _categories, (value) {
                setState(() => _selectedCategory = value);
              }),
              const SizedBox(height: 16),
              _buildDropdownField('Color', _selectedColor, _colors, (value) {
                setState(() => _selectedColor = value);
              }),
              const SizedBox(height: 16),
              _buildTextField('Brand', _brandController),
              const SizedBox(height: 16),
              _buildTextField('Purchase Price', _priceController, keyboardType: TextInputType.number),
              const SizedBox(height: 24),
              _buildDeleteButton(),
            ] else ...[
              // View Mode
              _buildDetailRow(context, 'Name', widget.item.name),
              const SizedBox(height: 12),
              _buildDetailRow(context, 'Category', widget.item.category),
              if (widget.item.color != null) ...[
                const SizedBox(height: 12),
                _buildDetailRow(context, 'Color', widget.item.color!),
              ],
              if (widget.item.brand != null) ...[
                const SizedBox(height: 12),
                _buildDetailRow(context, 'Brand', widget.item.brand!),
              ],
              if (widget.item.purchasePrice != null) ...[
                const SizedBox(height: 12),
                _buildDetailRow(context, 'Purchase Price', '\$${widget.item.purchasePrice}'),
              ],
              const SizedBox(height: 12),
              _buildDetailRow(context, 'Added', _getRelativeTime(widget.item.addedDate)),
              const SizedBox(height: 24),
              _buildDeleteButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            letterSpacing: 2,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            letterSpacing: 2,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
              );
            }).toList(),
            onChanged: onChanged,
            dropdownColor: Theme.of(context).colorScheme.surface,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _showDeleteConfirmation,
        icon: const Icon(LucideIcons.trash2, color: Colors.red),
        label: const Text(
          'DELETE ITEM',
          style: TextStyle(color: Colors.red),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),
      ),
    );
  }

  void _saveChanges() {
    final updatedItem = ClothingItem(
      id: widget.item.id,
      name: _nameController.text.trim(),
      category: _selectedCategory ?? widget.item.category,
      imageUrl: widget.item.imageUrl,
      color: _selectedColor,
      brand: _brandController.text.trim().isEmpty ? null : _brandController.text.trim(),
      purchasePrice: _priceController.text.trim().isEmpty ? null : double.tryParse(_priceController.text.trim()),
      lastWornAt: widget.item.lastWornAt,
      addedDate: widget.item.addedDate,
      isAutoAdded: widget.item.isAutoAdded,
    );

    // Update the item in the provider
    widget.ref.read(closetProvider.notifier).updateItem(updatedItem);

    setState(() => _isEditing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item updated successfully')),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Delete Item',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Text(
          'Are you sure you want to delete "${widget.item.name}"? This action cannot be undone.',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close bottom sheet
              // Delete the item
              widget.ref.read(closetProvider.notifier).removeItem(widget.item.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${widget.item.name} deleted')),
              );
            },
            child: const Text(
              'DELETE',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return "today";
    if (diff.inDays == 1) return "yesterday";
    return "${diff.inDays} days ago";
  }
}
