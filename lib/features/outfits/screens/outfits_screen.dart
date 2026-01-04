import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/components/cards/glass_card.dart';
import '../../../core/components/buttons/primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../providers/history_provider.dart';
import '../../home/providers/saved_outfits_provider.dart';
import '../../home/providers/recommendation_provider.dart';

class _AppColors {
  static Color getBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.background
      : const Color(0xFFFBF9F6);

  static Color getTextPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.textPrimary
      : Colors.black;

  static Color getTextSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.textSecondary
      : Colors.black54;

  static Color getPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.primary
      : Colors.black;

  static Color getTextOnPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.textOnPrimary
      : Colors.white;
}

class OutfitsScreen extends ConsumerWidget {
  const OutfitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedOutfits = ref.watch(savedOutfitsProvider);
    final history = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: _AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "My Outfits",
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: _AppColors.getTextPrimary(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          // Filter/Sort options
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle sort/filter options
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'recent', child: Text('Most Recent')),
              const PopupMenuItem(
                value: 'favorites',
                child: Text('Favorites First'),
              ),
              const PopupMenuItem(value: 'worn', child: Text('Recently Worn')),
            ],
            icon: Icon(
              LucideIcons.filter,
              color: _AppColors.getTextPrimary(context),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: savedOutfits.isEmpty && history.isEmpty
            ? _buildEmptyState(context)
            : _buildOutfitsContent(context, ref, savedOutfits, history),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.palette,
            size: 80,
            color: _AppColors.getTextSecondary(context),
          ),
          const SizedBox(height: 24),
          Text(
            "No outfits yet",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: _AppColors.getTextPrimary(context),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Create your first outfit combination using the Style Composer",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: _AppColors.getTextSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          PrimaryButton(
            text: "Create Outfit",
            onPressed: () => context.push('/try-on/compose'),
            icon: LucideIcons.palette,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildOutfitsContent(
    BuildContext context,
    WidgetRef ref,
    List<Recommendation> savedOutfits,
    List<HistoryEntry> history,
  ) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Saved Outfits Section
              if (savedOutfits.isNotEmpty) ...[
                _buildSectionHeader(
                  context,
                  "Saved Outfits",
                  "${savedOutfits.length} outfits",
                ),
                const SizedBox(height: 16),
                _buildSavedOutfitsGrid(context, ref, savedOutfits),
                const SizedBox(height: 32),
              ],

              // History Section
              if (history.isNotEmpty) ...[
                _buildSectionHeader(
                  context,
                  "Recently Worn",
                  "${history.length} entries",
                ),
                const SizedBox(height: 16),
                _buildHistoryGrid(context, ref, history),
              ],

              const SizedBox(height: 100), // Space for FAB
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: _AppColors.getTextPrimary(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: _AppColors.getTextSecondary(context),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSavedOutfitsGrid(
    BuildContext context,
    WidgetRef ref,
    List<Recommendation> outfits,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: outfits.length,
      itemBuilder: (context, index) {
        return _buildOutfitCard(context, ref, outfits[index], isSaved: true);
      },
    ).animate().fadeIn().slideY();
  }

  Widget _buildHistoryGrid(
    BuildContext context,
    WidgetRef ref,
    List<HistoryEntry> history,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: history.length,
      itemBuilder: (context, index) {
        return _buildOutfitCard(
          context,
          ref,
          history[index].outfit,
          historyEntry: history[index],
        );
      },
    ).animate().fadeIn(delay: 200.ms).slideY();
  }

  Widget _buildOutfitCard(
    BuildContext context,
    WidgetRef ref,
    Recommendation outfit, {
    bool isSaved = false,
    HistoryEntry? historyEntry,
  }) {
    final daysAgo = historyEntry != null
        ? DateTime.now().difference(historyEntry.wornAt).inDays
        : 0;

    final lastWornText = daysAgo == 0
        ? 'Today'
        : daysAgo == 1
        ? 'Yesterday'
        : '$daysAgo days ago';

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Outfit image (full card background)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              image: DecorationImage(
                image: NetworkImage(outfit.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient overlay for text readability
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),

          // Content overlay
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top badges
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status badges
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isSaved)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.pink.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.heart,
                                  size: 12,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "SAVED",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        if (historyEntry != null)
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              lastWornText.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                      ],
                    ),

                    // Action menu
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(LucideIcons.moreVertical, size: 16),
                        padding: EdgeInsets.zero,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Bottom content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Outfit title
                    Text(
                      outfit.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Action buttons row
                    Row(
                      children: [
                        // Try On button (primary action)
                        Expanded(
                          child: Container(
                            height: 32,
                            decoration: BoxDecoration(
                              color: _AppColors.getPrimary(context),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextButton(
                              onPressed: () {
                                // Navigate to try-on with this outfit
                                context.push('/try-on/outfit/${outfit.id}');
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                'Try On',
                                style: TextStyle(
                                  color: _AppColors.getTextOnPrimary(context),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 6),

                        // Mark as Worn button
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: IconButton(
                            onPressed: () {
                              // Mark outfit as worn today
                              ref
                                  .read(historyProvider.notifier)
                                  .addEntry(outfit);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Outfit marked as worn today!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            icon: const Icon(LucideIcons.check, size: 16),
                            padding: EdgeInsets.zero,
                            color: Colors.white,
                            tooltip: 'Mark as Worn',
                          ),
                        ),

                        const SizedBox(width: 6),

                        // More actions menu
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: PopupMenuButton<String>(
                            onSelected: (value) {
                              switch (value) {
                                case 'edit':
                                  context.push('/try-on/edit/${outfit.id}');
                                  break;
                                case 'share':
                                  // TODO: Implement share functionality
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Share coming soon!'),
                                    ),
                                  );
                                  break;
                                case 'delete':
                                  // Show delete confirmation
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Outfit'),
                                      content: const Text(
                                        'Are you sure you want to delete this outfit?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Remove from saved outfits using toggleFavorite
                                            ref
                                                .read(
                                                  savedOutfitsProvider.notifier,
                                                )
                                                .toggleFavorite(outfit);
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Outfit removed from saved',
                                                ),
                                              ),
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.red,
                                          ),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(LucideIcons.edit, size: 16),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'share',
                                child: Row(
                                  children: [
                                    Icon(LucideIcons.share, size: 16),
                                    SizedBox(width: 8),
                                    Text('Share'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(LucideIcons.trash, size: 16),
                                    SizedBox(width: 8),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                            icon: const Icon(
                              LucideIcons.moreVertical,
                              size: 16,
                            ),
                            padding: EdgeInsets.zero,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
