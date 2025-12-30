import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/components/cards/glass_card.dart';
import '../../try_on/screens/try_on_mirror_screen.dart';
import '../providers/history_provider.dart';
import '../../home/providers/saved_outfits_provider.dart';
import '../../home/providers/recommendation_provider.dart';
import '../../try_on/providers/mirror_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OutfitsScreen extends ConsumerWidget {
  const OutfitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(savedOutfitsProvider);
    final history = ref.watch(historyProvider);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          floating: true,
          title: Text(
            "Outfits",
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.calendar),
              onPressed: () {},
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
                _buildSectionHeader(context, "Favorite Looks"),
                const SizedBox(height: 16),
                _buildOutfitCarousel(favorites, ref),
                const SizedBox(height: 32),
                _buildSectionHeader(context, "Recently Worn"),
                const SizedBox(height: 16),
                _buildHistoryList(context, history, ref),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Text(
          "See all",
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.54),
          ),
        ),
      ],
    );
  }

  Widget _buildOutfitCarousel(List<Recommendation> favorites, WidgetRef ref) {
    if (favorites.isEmpty) {
      return GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(
                LucideIcons.heart,
                color: Colors.white.withValues(alpha: 0.2),
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                "No favorites yet",
                style: GoogleFonts.outfit(color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final outfit = favorites[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                ref
                    .read(mirrorProvider.notifier)
                    .setItemFromRecommendation(outfit);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TryOnMirrorScreen(),
                  ),
                );
              },
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    image: NetworkImage(outfit.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Text(
                        outfit.title,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn().slideX();
  }

  Widget _buildHistoryList(
    BuildContext context,
    List<HistoryEntry> history,
    WidgetRef ref,
  ) {
    if (history.isEmpty) {
      return Center(
        child: Text(
          "No history available",
          style: GoogleFonts.outfit(color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final entry = history[index];
        final timeAgo = DateFormat.yMMMd().format(entry.wornAt);
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () {
              ref
                  .read(mirrorProvider.notifier)
                  .setItemFromRecommendation(entry.outfit);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TryOnMirrorScreen(),
                ),
              );
            },
            child: GlassCard(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(entry.outfit.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.outfit.title,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Worn $timeAgo",
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.54),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    LucideIcons.chevronRight,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.38),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(delay: 200.ms);
  }
}
