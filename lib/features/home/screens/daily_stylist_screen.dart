import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../providers/daily_stylist_provider.dart';
import '../providers/recommendation_provider.dart'; // For Vibe enum
import '../components/outfit_hero_card.dart';
import '../../outfits/providers/history_provider.dart';
import '../providers/saved_outfits_provider.dart';

// import '../providers/weather_provider.dart'; // Future integration

class DailyStylistScreen extends ConsumerWidget {
  const DailyStylistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyState = ref.watch(dailyStylistProvider);
    final vibeNotifier = ref.read(dailyStylistProvider.notifier);
    final history = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: _AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Daily Briefing',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _AppColors.getTextPrimary(context),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: _AppColors.getTextPrimary(context),
            ),
            onPressed: () => context.push('/home/notifications'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: dailyState.isLoading
          ? Center(
              child: CircularProgressIndicator(color: _AppColors.getPrimary(context)),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // 1. Today's Looks (PageView)
                  SizedBox(
                    height: 520, // Taller hero section
                    child: PageView.builder(
                      controller: PageController(viewportFraction: 0.9),
                      itemCount: dailyState.dailyOutfits.length,
                      itemBuilder: (context, index) {
                        final outfit = dailyState.dailyOutfits[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: OutfitHeroCard(
                                  outfit: outfit,
                                  onEdit: () {
                                    context.push('/try-on/edit/${outfit.id}');
                                  },
                                  onTryOn: () {
                                    context.push('/try-on/outfit/${outfit.id}');
                                  },
                                  onSave: () {
                                    // Convert OutfitRecommendation to Recommendation
                                    final recommendation = Recommendation(
                                      id: outfit.id,
                                      title: outfit.title,
                                      imageUrl: outfit.imageUrl,
                                      tags: outfit.tags,
                                      confidenceScore: outfit.confidenceScore,
                                      reasoning: outfit.reasoning,
                                    );
                                    // Save to saved outfits
                                    ref.read(savedOutfitsProvider.notifier).saveVariant(recommendation);
                                    // Add to history as worn today
                                    ref.read(historyProvider.notifier).addEntry(recommendation);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Look saved to favorites and marked as worn!'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // 2. "Why This Works" (Attached to card logic conceptually)
                              _buildWhyThisWorks(context, outfit.reasoning),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 3. Mood (Vibe) Selector
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingLg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Adjust Vibe',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _AppColors.getTextSecondary(context),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: Vibe.values.map((vibe) {
                              final isSelected = dailyState.currentVibe == vibe;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(
                                    vibe.name.toUpperCase(),
                                    style: TextStyle(
                                      color: isSelected
                                          ? _AppColors.getTextOnPrimary(context)
                                          : _AppColors.getTextPrimary(context),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      vibeNotifier.setVibe(vibe);
                                    }
                                  },
                                  backgroundColor: _AppColors.getSurface(context),
                                  selectedColor: _AppColors.getPrimary(context),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    side: BorderSide(
                                      color: isSelected
                                          ? _AppColors.getPrimary(context)
                                          : _AppColors.getGlassBorder(context),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 4. Outfit History (Light Memory)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingLg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Wears',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _AppColors.getTextSecondary(context),
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go('/outfits'),
                              child: Text(
                                'View All',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: _AppColors.getPrimary(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Real history data - Larger thumbnails
                        SizedBox(
                          height: 140, // Increased height for larger thumbnails
                          child: history.isEmpty
                              ? Center(
                                  child: Text(
                                    'No recent wears yet',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: _AppColors.getTextSecondary(context),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: history.length,
                                  itemBuilder: (context, index) {
                                    final entry = history[index];
                                    return _buildHistoryItem(context, entry);
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Bottom padding for FAB
                ],
              ),
            ),
    );
  }

  Widget _buildWhyThisWorks(BuildContext context, String reasoning) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            "Why this works",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _AppColors.getTextSecondary(context),
            ),
          ),
          iconColor: _AppColors.getTextSecondary(context),
          collapsedIconColor: _AppColors.getTextSecondary(context),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                reasoning,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _AppColors.getTextPrimary(context),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, HistoryEntry entry) {
    final daysAgo = DateTime.now().difference(entry.wornAt).inDays;
    final label = daysAgo == 0
        ? 'Today'
        : daysAgo == 1
            ? 'Yesterday'
            : '${daysAgo}d ago';

    return GestureDetector(
      onTap: () => context.push('/try-on/outfit/${entry.outfit.id}'),
      child: Container(
        width: 110, // Increased width for larger thumbnails
        margin: const EdgeInsets.only(right: 16), // More spacing
        decoration: BoxDecoration(
          color: _AppColors.getSurface(context),
          borderRadius: BorderRadius.circular(16), // More rounded
          border: Border.all(color: _AppColors.getGlassBorder(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Larger image container
            Container(
              height: 70, // Much larger image
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(entry.outfit.imageUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Better typography and spacing
            Text(
              entry.outfit.title.length > 12
                  ? '${entry.outfit.title.substring(0, 12)}...'
                  : entry.outfit.title,
              style: GoogleFonts.inter(
                fontSize: 12, // Slightly larger
                fontWeight: FontWeight.w700, // Bolder
                color: _AppColors.getTextPrimary(context),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Better styled date label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _AppColors.getPrimary(context).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _AppColors.getPrimary(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppColors {
  static Color getBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.background
          : const Color(0xFFFBF9F6); // Light cream

  static Color getSurface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.surface
          : Colors.white;

  static Color getTextPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.textPrimary
          : Colors.black;

  static Color getTextSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.textSecondary
          : Colors.black54;

  static Color getGlassBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.glassBorder
          : AppColors.glassBorderDark;

  static Color getPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.primary
          : Colors.black;

  static Color getTextOnPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.textOnPrimary
          : Colors.white;
}
