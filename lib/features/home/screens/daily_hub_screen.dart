import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
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
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    letterSpacing: 2,
                    fontWeight: FontWeight.w900,
                    fontSize: 32,
                  ),
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
                      const SnackBar(content: Text("Calendar styling coming soon...")),
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
                  _buildVibeSelectors(context, ref),
                  const SizedBox(height: 32),
                  Text(
                    "DAILY INSPO",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.5),
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
                  const SizedBox(height: 60),
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
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: vibes.length,
        separatorBuilder: (context, index) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          final vibe = vibes[index];
          final isSelected = selectedVibe == vibe.$2;

          return GestureDetector(
            onTap: () => ref.read(vibeProvider.notifier).setVibe(vibe.$2),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isSelected ? 1.0 : 0.3,
              child: Text(
                vibe.$1,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 2,
                  decoration: isSelected ? TextDecoration.underline : null,
                  decorationColor: Theme.of(context).colorScheme.primary,
                  decorationThickness: 2,
                ),
              ),
            ),
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
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
                    borderRadius: BorderRadius.circular(8),
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
                      Image.network(recommendation.personalImageUrl, fit: BoxFit.cover),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "YOUR STYLE",
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
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
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              fontSize: 24,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black, blurRadius: 4)],
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
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      context.push('/try-on/ai/${recommendation.id}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    minimumSize: Size(80, 36),
                  ),
                  child: Text(
                    "TRY ON",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/try-on/edit/${recommendation.id}'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.8)),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(80, 36),
                  ),
                  child: Text(
                    "EDIT",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsSection(BuildContext context, WidgetRef ref) {
    final unwornItems = ref.watch(unwornItemsProvider);
    final recentlyAddedItems = ref.watch(recentlyAddedItemsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, "WARDROBE ARCHIVE", "SCAN ALL"),
        const SizedBox(height: 24),
        if (unwornItems.isNotEmpty) ...[
          _buildSubHeader(context, "NEGLECTED PIECES"),
          const SizedBox(height: 16),
          _buildAsymmetricGrid(context, unwornItems.take(3).toList()),
          const SizedBox(height: 48),
        ],
        if (recentlyAddedItems.isNotEmpty) ...[
          _buildSubHeader(context, "RECENT ACQUISITIONS"),
          const SizedBox(height: 16),
          _buildAsymmetricGrid(context, recentlyAddedItems.take(3).toList()),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String action,
  ) {
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
        Text(
          action,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.4),
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }

  Widget _buildSubHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
        fontSize: 12,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
      ),
    );
  }

  Widget _buildAsymmetricGrid(BuildContext context, List<ClothingItem> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 320,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 3, child: _buildArchiveItem(context, items[0])),
          const SizedBox(width: 1),
          if (items.length > 1)
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(child: _buildArchiveItem(context, items[1])),
                  if (items.length > 2) ...[
                    const SizedBox(height: 1),
                    Expanded(child: _buildArchiveItem(context, items[2])),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildArchiveItem(BuildContext context, ClothingItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        image: DecorationImage(
          image: NetworkImage(item.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 8,
            left: 8,
            child: Text(
              item.lastWornAt != null
                  ? getRelativeTime(item.lastWornAt!).toUpperCase()
                  : "NEW",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherWidget(BuildContext context, WidgetRef ref) {
    return ref.watch(weatherProvider).when(
      data: (weather) => weather != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.cloudSun, size: 18, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${weather.temperatureString} · ${weather.condition.toUpperCase()}",
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          weather.clothingSuggestion.toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
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
      error: (_, __) => const SizedBox.shrink(),
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
