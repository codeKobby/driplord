import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/components/cards/glass_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../try_on/screens/try_on_mirror_screen.dart';
import '../providers/recommendation_provider.dart';
import '../providers/saved_outfits_provider.dart';
import '../providers/weather_provider.dart';
import '../../try_on/providers/mirror_provider.dart';
import '../../closet/providers/closet_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyHubScreen extends ConsumerWidget {
  const DailyHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendation = ref.watch(recommendationProvider);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          pinned: true,
          title: Text(
            "DripLord",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w800,
              fontSize: 24,
              letterSpacing: 2,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.bell),
              onPressed: () => context.push('/home/notifications'),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildWeatherWidget(context, ref),
                const SizedBox(height: 16),
                _buildVibeSelectors(context, ref),
                const SizedBox(height: 32),
                Text(
                  "Today's Recommendation",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildMainOutfitCard(context, recommendation, ref),
                const SizedBox(height: 32),
                _buildInsightsSection(context, ref),
                const SizedBox(height: 120), // Space for FAB and Nav
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherWidget(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: weatherAsync.when(
        data: (weather) {
          if (weather == null) {
            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    LucideIcons.cloudRain,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Weather unavailable",
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        "Check location permissions",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // Weather icon based on condition
          IconData weatherIcon;
          if (weather.isRainy) {
            weatherIcon = LucideIcons.cloudRain;
          } else if (weather.isSunny) {
            weatherIcon = LucideIcons.sun;
          } else if (weather.conditionCode >= 801) {
            weatherIcon = LucideIcons.cloud;
          } else {
            weatherIcon = LucideIcons.cloudRain;
          }

          return Row(
            children: [
              // Large temperature display
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.temperatureString,
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      weather.weatherDescription,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              // Weather icon with background
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  weatherIcon,
                  size: 36,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              // Clothing suggestion
              Expanded(
                flex: 4,
                child: Text(
                  weather.clothingSuggestion,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Loading weather...",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    "Getting location data",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        error: (_, __) => Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                LucideIcons.alertCircle,
                size: 32,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Weather unavailable",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    "Using default recommendations",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX();
  }

  Widget _buildMainOutfitCard(
    BuildContext context,
    Recommendation recommendation,
    WidgetRef ref,
  ) {
    return Container(
      width: double.infinity,
      height: 450,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        image: DecorationImage(
          image: NetworkImage(recommendation.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.pureBlack.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),
          // Heart icon in top-right corner (Instagram-style)
          Positioned(
            top: 24,
            right: 24,
            child: GestureDetector(
              onTap: () {
                ref
                    .read(savedOutfitsProvider.notifier)
                    .toggleFavorite(recommendation);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.whiteOverlay.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  ref
                          .watch(savedOutfitsProvider)
                          .any((item) => item.title == recommendation.title)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color:
                      ref
                          .watch(savedOutfitsProvider)
                          .any((item) => item.title == recommendation.title)
                      ? AppColors.favoriteRed
                      : AppColors.pureWhite,
                  size: 24,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  recommendation.title,
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.pureWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  children: recommendation.tags
                      .map(
                        (tag) => Text(
                          "#$tag",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.pureWhite.withValues(alpha: 0.7),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                // Centered "Try this look" button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final currentVibe = ref.read(vibeProvider);
                      context.push('/try-on/ai/${currentVibe.name}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pureWhite,
                      foregroundColor: AppColors.pureBlack,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      elevation: 4,
                    ),
                    child: const Text("Try this look"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildInsightsSection(BuildContext context, WidgetRef ref) {
    final unwornItems = ref.watch(unwornItemsProvider);
    final recentlyAddedItems = ref.watch(recentlyAddedItemsProvider);
    final autoAddedItems = ref.watch(autoAddedItemsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              LucideIcons.barChart3,
              size: 20,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 8),
            Text(
              "Quick Insights",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Haven't Worn Card
        GestureDetector(
          onTap: () {
            // Navigate to unworn items screen (per docs: /closet/insights/unworn)
            context.push('/closet/insights/unworn');
          },
          child: GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        LucideIcons.archive,
                        size: 24,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Haven't Worn",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${unwornItems.length} items gathering dust",
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronRight,
                      size: 20,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ],
                ),
                if (unwornItems.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildSmartGrid(unwornItems),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Recently Added Card
        GestureDetector(
          onTap: () {
            // Navigate to recent items screen (per docs: /closet/insights/recent)
            context.push('/closet/insights/recent');
          },
          child: GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        LucideIcons.sparkles,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Recently Added",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              if (autoAddedItems.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Auto",
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${recentlyAddedItems.length} new items • Mix them in!",
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronRight,
                      size: 20,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ],
                ),
                if (recentlyAddedItems.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildSmartGrid(recentlyAddedItems, showAutoBadge: true),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmartGrid(
    List<ClothingItem> items, {
    bool showAutoBadge = false,
  }) {
    // Smart grid that adapts based on item count - increased sizes for better visibility
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final itemCount = items.length > 9 ? 9 : items.length;
    final crossAxisCount = itemCount <= 3
        ? 1
        : itemCount <= 6
        ? 2
        : 3;
    final aspectRatio = crossAxisCount == 1
        ? 2.5
        : crossAxisCount == 2
        ? 1.0
        : 0.85;

    return SizedBox(
      height: crossAxisCount == 1
          ? 120
          : crossAxisCount == 2
          ? 200
          : 180,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: aspectRatio,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          final item = items[index];
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(item.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackOverlayLight,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        AppColors.blackOverlayMedium.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        item.name.length > 15
                            ? '${item.name.substring(0, 15)}...'
                            : item.name,
                        style: GoogleFonts.inter(
                          fontSize: crossAxisCount == 1 ? 14 : 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              // Auto-added badge
              if (showAutoBadge && item.isAutoAdded) ...[
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "Auto",
                      style: GoogleFonts.inter(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildVibeSelectors(BuildContext context, WidgetRef ref) {
    final selectedVibe = ref.watch(vibeProvider);
    final vibes = [
      ("Chill", Vibe.chill),
      ("Bold", Vibe.bold),
      ("Work", Vibe.work),
      ("Hype", Vibe.hype),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: vibes.map((vibe) {
          final isSelected = selectedVibe == vibe.$2;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Semantics(
              label: "Set vibe to ${vibe.$1}",
              button: true,
              selected: isSelected,
              excludeSemantics: true,
              child: InkWell(
                onTap: () {
                  ref.read(vibeProvider.notifier).setVibe(vibe.$2);
                },
                borderRadius: BorderRadius.circular(100),
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    vibe.$1,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1, end: 0);
  }
}
