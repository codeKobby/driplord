import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/components/buttons/primary_button.dart';
import '../../../core/components/buttons/secondary_button.dart';
import '../../closet/providers/closet_provider.dart';

class NeglectedItemDetailScreen extends ConsumerWidget {
  const NeglectedItemDetailScreen({super.key, required this.itemId});

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

    // Calculate neglect severity
    final daysSinceWorn = item.lastWornAt != null
        ? DateTime.now().difference(item.lastWornAt!).inDays
        : DateTime.now().difference(item.addedDate).inDays;
    final severity = _getSeverity(daysSinceWorn);

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
          "NEGLECTED PIECE",
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

            // Hero Image with Neglect Severity Badge
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                border: Border.all(
                  color: _getSeverityColor(context, severity).withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  item.imageUrl.isNotEmpty
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

                  // Neglect Severity Badge
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getSeverityColor(context, severity),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.alertTriangle, color: Theme.of(context).colorScheme.onPrimary, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            "${_getSeverityText(severity)} NEGLECTED",
                            style: GoogleFonts.outfit(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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

            const SizedBox(height: 24),

            // Wear Statistics
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(
                  color: _getSeverityColor(context, severity).withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.clock,
                        color: _getSeverityColor(context, severity),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "WEAR STATISTICS",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _getSeverityColor(context, severity),
                          letterSpacing: 4,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.lastWornAt != null
                        ? "Last worn ${_getRelativeTime(item.lastWornAt!)}"
                        : "Never worn",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$daysSinceWorn days since last wear",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
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



            // View Details Button
            SecondaryButton(
              text: "VIEW FULL DETAILS",
              onPressed: () => _showItemDetailsBottomSheet(context, item),
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
              "Find complementary pieces to create a full outfit with this neglected item",
              LucideIcons.layers,
              () => _suggestComplementaryItems(context, item),
            ),
            const SizedBox(height: 12),

            _buildSuggestionCard(
              context,
              "Style Refresh",
              "Get ideas for styling this piece in new and exciting ways",
              LucideIcons.refreshCw,
              () => _showStyleRefresh(context, item),
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

  int _getSeverity(int daysSinceWorn) {
    if (daysSinceWorn < 30) return 1;
    if (daysSinceWorn < 60) return 2;
    if (daysSinceWorn < 90) return 3;
    if (daysSinceWorn < 120) return 4;
    return 5;
  }

  String _getSeverityText(int severity) {
    switch (severity) {
      case 1: return "MILD";
      case 2: return "MODERATE";
      case 3: return "SIGNIFICANT";
      case 4: return "SEVERE";
      case 5: return "CRITICAL";
      default: return "UNKNOWN";
    }
  }

  Color _getSeverityColor(BuildContext context, int severity) {
    switch (severity) {
      case 1: return Theme.of(context).colorScheme.primary;
      case 2: return Colors.orange;
      case 3: return Colors.deepOrange;
      case 4: return Theme.of(context).colorScheme.error;
      case 5: return Colors.red.shade900;
      default: return Theme.of(context).colorScheme.primary;
    }
  }

  String _getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return "today";
    if (diff.inDays == 1) return "yesterday";
    return "${diff.inDays} days ago";
  }

  void _createOutfitWithItem(BuildContext context, ClothingItem item) {
    context.push('/try-on/compose', extra: {'initialItem': item});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Starting outfit creation with ${item.name}')),
    );
  }

  void _tryOnItem(BuildContext context, ClothingItem item) {
    context.push('/try-on/item/${item.id}');
  }

  void _markAsWorn(BuildContext context, ClothingItem item) {
    // TODO: Implement mark as worn functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Marked ${item.name} as worn today')),
    );
  }

  void _viewFullDetails(BuildContext context, ClothingItem item) {
    context.push('/closet/item/${item.id}');
  }

  void _suggestComplementaryItems(BuildContext context, ClothingItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Finding complementary pieces...')),
    );
  }

  void _showStyleRefresh(BuildContext context, ClothingItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generating style refresh ideas...')),
    );
  }

  void _showItemDetailsBottomSheet(BuildContext context, ClothingItem item) {
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

            // Item Details
            Text(
              'ITEM DETAILS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 4,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),

            _buildDetailRow(context, 'Name', item.name),
            const SizedBox(height: 8),
            _buildDetailRow(context, 'Category', item.category),
            if (item.color != null) ...[
              const SizedBox(height: 8),
              _buildDetailRow(context, 'Color', item.color!),
            ],
            if (item.brand != null) ...[
              const SizedBox(height: 8),
              _buildDetailRow(context, 'Brand', item.brand!),
            ],
            if (item.purchasePrice != null) ...[
              const SizedBox(height: 8),
              _buildDetailRow(context, 'Purchase Price', '\$${item.purchasePrice}'),
            ],
            const SizedBox(height: 8),
            _buildDetailRow(context, 'Added', _getRelativeTime(item.addedDate)),

            const SizedBox(height: 24),

            // Edit Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Navigate to full edit screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit functionality coming soon')),
                  );
                },
                icon: const Icon(LucideIcons.edit3),
                label: const Text('EDIT ITEM'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Theme.of(context).colorScheme.outline),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
