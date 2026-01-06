import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_dimensions.dart';

import '../../../core/components/buttons/secondary_button.dart';
import '../providers/closet_provider.dart';

class ItemDetailScreen extends ConsumerWidget {
  const ItemDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(closetProvider);
    final item = items.firstWhere(
      (item) => item.id == id,
      orElse: () => ClothingItem(
        id: id,
        name: 'Item Not Found',
        category: 'Unknown',
        imageUrl: '',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          item.name.toUpperCase(),
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.moreVertical, size: 20),
            onPressed: () => _showItemOptions(context, item),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Main Image
            Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                border: Border.all(
                  color: const Color.fromARGB(255, 2, 2, 2).withValues(alpha: 0.1),
                  width: 1,
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

            // Item Details
            Text(
              'DETAILS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 4,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),

            _buildDetailRow('Category', item.category.toUpperCase()),
            const SizedBox(height: 12),
            if (item.color != null) ...[
              _buildDetailRow('Color', item.color!.toUpperCase()),
              const SizedBox(height: 12),
            ],
            if (item.brand != null) ...[
              _buildDetailRow('Brand', item.brand!.toUpperCase()),
              const SizedBox(height: 12),
            ],
            if (item.purchasePrice != null) ...[
              _buildDetailRow('Purchase Price', '\$${item.purchasePrice}'),
              const SizedBox(height: 12),
            ],
            _buildDetailRow('Added', _formatDate(item.addedDate)),
            const SizedBox(height: 12),
            _buildDetailRow('Last Worn', item.lastWornAt != null ? _formatDate(item.lastWornAt!) : 'Never'),

            const SizedBox(height: 48),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: SecondaryButton(
                text: 'ADD TO OUTFIT',
                onPressed: () => _addToOutfit(context, item),
                icon: LucideIcons.plus,
              ),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).round()} weeks ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).round()} months ago';
    return '${(diff.inDays / 365).round()} years ago';
  }

  void _showItemOptions(BuildContext context, ClothingItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Item Options',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Icon(LucideIcons.edit3, color: Theme.of(context).colorScheme.onSurface),
              title: const Text('Edit Details'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to edit screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit functionality coming soon')),
                );
              },
            ),
            ListTile(
              leading: Icon(LucideIcons.share, color: Theme.of(context).colorScheme.onSurface),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement share functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share functionality coming soon')),
                );
              },
            ),
            ListTile(
              leading: Icon(LucideIcons.trash2, color: Theme.of(context).colorScheme.error),
              title: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, item);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ClothingItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement delete functionality
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delete functionality coming soon')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addToOutfit(BuildContext context, ClothingItem item) {
    // TODO: Navigate to outfit composer with this item
    context.push('/try-on/compose');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added ${item.name} to outfit composer')),
    );
  }


}
