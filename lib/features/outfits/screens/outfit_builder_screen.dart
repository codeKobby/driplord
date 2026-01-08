import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/components/common/driplord_scaffold.dart';
import '../../../core/components/cards/glass_card.dart';
import '../../closet/providers/closet_provider.dart';
import '../providers/canvas_provider.dart';

class OutfitBuilderScreen extends ConsumerWidget {
  const OutfitBuilderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final closetItems = ref.watch(closetProvider);
    final canvasItems = ref.watch(canvasProvider);
    final canvasNotifier = ref.read(canvasProvider.notifier);

    return DripLordScaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                LucideIcons.x,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Build Outfit",
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            centerTitle: true,
            actions: [
              if (canvasItems.isNotEmpty) ...[
                TextButton(
                  onPressed: () => canvasNotifier.autoArrange(),
                  child: Text(
                    "Auto-Arrange",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Outfit saved!")),
                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Save",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ]
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPreviewSection(context, canvasItems, canvasNotifier),
                  const SizedBox(height: 32),
                  Text(
                    "Select items from your closet",
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = closetItems[index];
                final isSelected =
                    canvasItems.any((i) => i.clothingItem.id == item.id);
                return _buildItemSelectionCard(
                    context, item, isSelected, canvasNotifier);
              }, childCount: closetItems.length),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  Widget _buildPreviewSection(BuildContext context, List<CanvasItem> canvasItems,
      CanvasNotifier canvasNotifier) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: AspectRatio(
        aspectRatio: 1,
        child: Consumer(
          builder: (context, ref, _) {
            final selectedItemId = ref.watch(selectedCanvasItemProvider);

            return GestureDetector(
              onTap: () {
                ref.read(selectedCanvasItemProvider.notifier).state = null;
              },
              child: Stack(
                children: [
                  if (canvasItems.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Choose items below to compose your look",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    )
                  else
                    ...() {
                      final sortedItems = [...canvasItems]..sort(
                          (a, b) => a.zIndex.compareTo(b.zIndex),
                        );
                      return sortedItems.map((item) {
                        final isSelected =
                            item.clothingItem.id == selectedItemId;
                        return Positioned(
                          left: item.position.dx,
                        top: item.position.dy,
                        child: Transform.scale(
                          scale: item.scale,
                          child: Transform.rotate(
                            angle: item.rotation,
                            child: GestureDetector(
                              onTap: () {
                                ref
                                    .read(selectedCanvasItemProvider.notifier)
                                    .state = item.clothingItem.id;
                              },
                                onPanUpdate: (details) {
                                  canvasNotifier.updateItem(
                                    item.copyWith(
                                      position: item.position + details.delta,
                                    ),
                                  );
                                },
                              onScaleUpdate: (details) {
                                  final newScale =
                                      item.scale * details.scale;
                                canvasNotifier.updateItem(
                                  item.copyWith(
                                      position: item.position +
                                          details.focalPointDelta,
                                      scale: newScale.clamp(0.2, 5.0),
                                      rotation:
                                          item.rotation + details.rotation,
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      border: isSelected
                                          ? Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: 2,
                                            )
                                          : null,
                                    ),
                                    child: Image.network(
                                      item.clothingItem.imageUrl,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  if (isSelected)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          canvasNotifier
                                              .removeItem(item.clothingItem.id);
                                          ref
                                              .read(selectedCanvasItemProvider
                                                  .notifier)
                                              .state = null;
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            LucideIcons.x,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItemSelectionCard(BuildContext context, ClothingItem item,
      bool isSelected, CanvasNotifier canvasNotifier) {
    return GestureDetector(
      onTap: () {
        if (isSelected) {
          canvasNotifier.removeItem(item.id);
        } else {
          canvasNotifier.addItem(item);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(item.imageUrl),
            fit: BoxFit.cover,
          ),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            if (isSelected)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            if (isSelected)
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  LucideIcons.checkCircle,
                  color: Colors.white,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
