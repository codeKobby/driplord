import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../closet/providers/closet_provider.dart';

class NewlyAddedScreen extends ConsumerWidget {
  const NewlyAddedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyAddedItems = ref.watch(recentlyAddedItemsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Newly Added",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              "New additions to your virtual closet",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                letterSpacing: 2,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 24),
            if (recentlyAddedItems.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: recentlyAddedItems.length,
                  itemBuilder: (context, index) => _buildNewlyAddedCard(
                    context,
                    recentlyAddedItems[index],
                  ),
                ),
              )
            else
              Expanded(
                child: Center(
                  child: Text(
                    "No newly added items yet.\nAdd some clothes to see them here!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewlyAddedCard(BuildContext context, ClothingItem item) {
    return GestureDetector(
      onTap: () => context.push('/closet/item/${item.id}'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
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
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.category.toUpperCase(),
                    style: GoogleFonts.outfit(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Added ${_getRelativeTime(item.addedDate)}",
                    style: GoogleFonts.outfit(
                      color: Colors.white54,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return "Today";
    if (diff.inDays == 1) return "Yesterday";
    return "${diff.inDays}D Ago";
  }
}
