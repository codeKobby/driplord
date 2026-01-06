import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_dimensions.dart';
import '../providers/recommendation_provider.dart';
import '../providers/saved_outfits_provider.dart';
import '../providers/weather_provider.dart';
import '../../closet/providers/closet_provider.dart';

class DailyHubScreen extends ConsumerWidget {
  const DailyHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyRecos = ref.watch(recommendationProvider);
    final activeOutfit = ref.watch(dailyOutfitProvider);

    // Prepend active outfit if it exists, filtering duplicates
    final recommendations = activeOutfit != null
        ? [activeOutfit, ...dailyRecos.where((r) => r.id != activeOutfit.id)]
        : dailyRecos;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            pinned: true,
            floating: false,
            snap: false,
            centerTitle: false,
            toolbarHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DRIPLORD",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: IconButton(
                  icon: const Icon(LucideIcons.calendar, size: 20),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Calendar styling coming soon..."),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: IconButton(
                  icon: const Icon(LucideIcons.bell, size: 20),
                  onPressed: () => context.push('/home/notifications'),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWeatherWidget(context, ref),
                  const SizedBox(height: 16),
                  Text(
                    "DAILY INSPO",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 560,
                    child: PageView.builder(
                      itemCount: recommendations.length,
                      controller: PageController(viewportFraction: 1.0),
                      itemBuilder: (context, index) {
                        return _buildFeatureSpread(
                          context,
                          recommendations[index],
                          ref,
                          index,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildVibeSelectors(context, ref),
                  const SizedBox(height: 32),
                  _buildInsightsSection(context, ref),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVibeSelectors(BuildContext context, WidgetRef ref) {
    final selectedVibe = ref.watch(vibeProvider);
    final vibes = [
      ("CHILL", Vibe.chill),
      ("BOLD", Vibe.bold),
      ("WORK", Vibe.work),
      ("HYPE", Vibe.hype),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: vibes.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final vibe = vibes[index];
          final isSelected = selectedVibe == vibe.$2;

          return ChoiceChip(
            label: Text(
              vibe.$1,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                ref.read(vibeProvider.notifier).setVibe(vibe.$2);
              }
            },
            selectedColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  Widget _buildFeatureSpread(
    BuildContext context,
    Recommendation recommendation,
    WidgetRef ref,
    int index,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Main Image
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(recommendation.imageUrl, fit: BoxFit.cover),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.4),
                      ],
                    ),
                  ),
                ),
              ),
              // PiP Overlay: User's Translation (moved above the buttons)
              Positioned(
                bottom: 120,
                left: 24,
                child: Container(
                  width: 140,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    border: Border.all(color: Colors.white24, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Image.network(
                        recommendation.personalImageUrl,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusXs,
                            ),
                          ),
                          child: Text(
                            "YOUR STYLE",
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 8,
                                  letterSpacing: 1,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Title Overlay (moved to avoid PiP conflict)
        Positioned(
          top: 24,
          left: 24,
          right: 24,
          child: Text(
            recommendation.title.toUpperCase(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              letterSpacing: 2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Action Buttons Overlay
        Positioned(
          bottom: 24,
          left: 24,
          right: 24,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            context.push('/try-on/ai/${recommendation.id}'),
                        icon: const Icon(LucideIcons.sparkles, size: 16),
                        label: Text(
                          "TRY ON",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            fontSize: 12,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMd,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () =>
                            context.push('/try-on/edit/${recommendation.id}'),
                        icon: const Icon(LucideIcons.edit3, size: 16),
                        label: Text(
                          "EDIT",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            fontSize: 12,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMd,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsSection(BuildContext context, WidgetRef ref) {
    final unwornItems = ref.watch(unwornItemsProvider);
    final recentlyAddedItems = ref.watch(recentlyAddedItemsProvider);
    final frequentlyWornItems = ref.watch(frequentlyWornItemsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Newly Added Section (2x2 grid)
        if (recentlyAddedItems.isNotEmpty) ...[
          _buildSectionHeader(context, "NEWLY ADDED", "VIEW ALL", onActionTap: () {
            context.push('/home/newly-added');
          }),
          const SizedBox(height: 20),
          _buildGridSection(context, recentlyAddedItems, () {
            context.push('/home/newly-added');
          }),
          const SizedBox(height: 48),
        ],

        // Neglected Section (2x2 grid)
        if (unwornItems.isNotEmpty) ...[
          _buildSectionHeader(context, "NEGLECTED PIECES", "VIEW ALL", onActionTap: () {
            context.push('/home/neglected');
          }),
          const SizedBox(height: 20),
          _buildGridSection(context, unwornItems, () {
            context.push('/home/neglected');
          }),
          const SizedBox(height: 48),
        ],

        // Frequently Worn Section (2x2 grid)
        if (frequentlyWornItems.isNotEmpty) ...[
          _buildSectionHeader(context, "FREQUENTLY WORN", "VIEW ALL", onActionTap: () {
            context.push('/home/frequently-worn');
          }),
          const SizedBox(height: 20),
          _buildGridSection(context, frequentlyWornItems, () {
            context.push('/home/frequently-worn');
          }),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String action, {
    VoidCallback? onActionTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 4,
            fontWeight: FontWeight.w900,
          ),
        ),
        GestureDetector(
          onTap: action == "VIEW ALL"
              ? onActionTap
              : () {
                  if (action == "SCAN ALL") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Scan functionality coming soon..."),
                      ),
                    );
                  }
                },
          child: Text(
            action,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: action == "VIEW ALL"
                  ? FontWeight.bold
                  : FontWeight.normal,
              letterSpacing: 1,
              decoration: action == "VIEW ALL"
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridSection(
    BuildContext context,
    List<ClothingItem> items,
    VoidCallback onViewAllTap, {
    bool showAll = false,
  }) {
    final itemsToShow = showAll ? items : items.take(4).toList();

    return Container(
      height: showAll ? null : 240,
      constraints: BoxConstraints(
        minHeight: 240,
        maxHeight: showAll ? MediaQuery.of(context).size.height * 0.5 : 240,
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: itemsToShow.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = itemsToShow[index];
          return SizedBox(
            width: 180, // Fixed width for each item
            child: _buildGridItemCard(context, item, index),
          );
        },
      ),
    );
  }

  Widget _buildGridItemCard(
    BuildContext context,
    ClothingItem item,
    int index,
  ) {
    return GestureDetector(
      onTap: () => context.push('/closet/item/${item.id}'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(item.imageUrl, fit: BoxFit.cover),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name.toUpperCase(),
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.category.toUpperCase(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.lastWornAt != null
                        ? "Last worn ${getRelativeTime(item.lastWornAt!)}"
                        : "Never worn",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherWidget(BuildContext context, WidgetRef ref) {
    return ref
        .watch(weatherProvider)
        .when(
          data: (weather) => weather != null
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusInput,
                    ),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.cloudSun,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${weather.temperatureString} · ${weather.condition.toUpperCase()}",
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0,
                                    fontSize: 12,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              weather.clothingSuggestion.toUpperCase(),
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0,
                                    fontSize: 10,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        );
  }

  String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return "Today";
    if (diff.inDays == 1) return "Yesterday";
    return "${diff.inDays}D Ago";
  }
}
