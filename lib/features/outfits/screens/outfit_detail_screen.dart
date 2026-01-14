import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/components/buttons/primary_button.dart';
import '../../../core/components/buttons/secondary_button.dart';
import '../providers/history_provider.dart';
import '../../home/providers/saved_outfits_provider.dart';
import '../../home/providers/recommendation_provider.dart';

class OutfitDetailScreen extends ConsumerWidget {
  const OutfitDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Find the outfit from saved outfits or history
    final savedOutfits = ref.watch(savedOutfitsProvider);
    final history = ref.watch(historyProvider);

    // First try to find in saved outfits
    Recommendation outfit;
    HistoryEntry? historyEntry;

    try {
      outfit = savedOutfits.firstWhere((o) => o.id == id);
    } catch (e) {
      // Not in saved outfits, try history
      try {
        historyEntry = history.firstWhere((h) => h.outfit.id == id);
        outfit = historyEntry.outfit;
      } catch (e2) {
        // Not found anywhere, show error outfit
        outfit = Recommendation(
          id: id,
          title: 'Outfit Not Found',
          imageUrl: '',
          personalImageUrl: '',
          tags: [],
          confidenceScore: 0.0,
          reasoning: '',
          source: 'Unknown',
          sourceUrl: '',
        );
        historyEntry = null;
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            LucideIcons.arrowLeft,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "OUTFIT DETAILS",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 4,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteConfirmation(context, ref, outfit);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(LucideIcons.trash2, size: 16, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Outfit', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            icon: Icon(
              LucideIcons.moreVertical,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
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
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: outfit.imageUrl.isNotEmpty
                  ? Image.network(
                      outfit.imageUrl,
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

            // Outfit Info
            Text(
              outfit.title.toUpperCase(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),

            // Status badges
            Row(
              children: [
                if (savedOutfits.any((o) => o.id == id))
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pink.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.heart, size: 14, color: Colors.pink),
                        const SizedBox(width: 6),
                        Text(
                          "SAVED",
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (historyEntry != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "LAST WORN: ${_getRelativeTime(historyEntry.wornAt)}",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 32),

            // Analytics Section
            Text(
              "ANALYTICS",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 4,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),

            // Created at
            _buildAnalyticsCard(
              context,
              "Created",
              "2 days ago", // Mock data - would come from outfit.createdAt
              LucideIcons.calendar,
            ),
            const SizedBox(height: 12),

            // Wear stats
            if (historyEntry != null) ...[
              _buildAnalyticsCard(
                context,
                "Times Worn",
                history.where((h) => h.outfit.id == id).length.toString(),
                LucideIcons.trendingUp,
              ),
              const SizedBox(height: 12),
            ],

            _buildAnalyticsCard(
              context,
              "Style Confidence",
              "${(outfit.confidenceScore * 100).round()}%",
              LucideIcons.target,
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

            // Try On button
            PrimaryButton(
              text: "TRY ON OUTFIT",
              onPressed: () => context.push('/try-on/outfit/$id'),
              icon: LucideIcons.eye,
            ),
            const SizedBox(height: 12),

            // Edit Outfit button
            SecondaryButton(
              text: "EDIT OUTFIT",
              onPressed: () => context.push('/try-on/edit/$id'),
              icon: LucideIcons.edit,
            ),

            const SizedBox(height: 32),

            // Outfit Items Section
            Text(
              "OUTFIT ITEMS",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 4,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            _buildOutfitItemsThumbnails(context, outfit),
            const SizedBox(height: 32),

            // Outfit reasoning (if available)
            if (outfit.reasoning.isNotEmpty) ...[
              Text(
                "WHY THIS WORKS",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  outfit.reasoning,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
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
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    Recommendation outfit,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Delete Outfit',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Text(
          'Are you sure you want to delete "${outfit.title}"? This action cannot be undone.',
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Remove from saved outfits
              ref.read(savedOutfitsProvider.notifier).toggleFavorite(outfit);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to outfits list
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${outfit.title} deleted')),
              );
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
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

  Widget _buildOutfitItemsThumbnails(
    BuildContext context,
    Recommendation outfit,
  ) {
    // Mock item thumbnails based on outfit tags
    // In a real implementation, this would use actual item IDs from the outfit
    final mockItems = _getMockItemsForOutfit(outfit);

    if (mockItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: const Center(
          child: Text(
            "No items found for this outfit",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mockItems.length,
              itemBuilder: (context, index) {
                final item = mockItems[index];
                return Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Icon(
                          LucideIcons.imageOff,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.3),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "${mockItems.length} items in this outfit",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _getMockItemsForOutfit(Recommendation outfit) {
    // Mock items based on outfit tags - in real implementation this would come from outfit.itemIds
    final mockItems = <Map<String, String>>[];

    // Add mock items based on tags
    for (final tag in outfit.tags) {
      if (tag.toLowerCase().contains('cotton') ||
          tag.toLowerCase().contains('loose')) {
        mockItems.add({
          'image':
              'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=200',
          'name': 'Cotton T-Shirt',
        });
      } else if (tag.toLowerCase().contains('blazer') ||
          tag.toLowerCase().contains('tailored')) {
        mockItems.add({
          'image':
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
          'name': 'Tailored Blazer',
        });
      } else if (tag.toLowerCase().contains('denim') ||
          tag.toLowerCase().contains('jeans')) {
        mockItems.add({
          'image':
              'https://images.unsplash.com/photo-1542272604-787c3835535d?w=200',
          'name': 'Denim Jeans',
        });
      } else if (tag.toLowerCase().contains('sneakers')) {
        mockItems.add({
          'image':
              'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=200',
          'name': 'White Sneakers',
        });
      }
    }

    // Ensure we have at least 2-4 items for demonstration
    while (mockItems.length < 3) {
      mockItems.add({
        'image':
            'https://images.unsplash.com/photo-1445205170230-053b83016050?w=200',
        'name': 'Fashion Item',
      });
    }

    return mockItems.take(4).toList(); // Limit to 4 items max
  }
}
