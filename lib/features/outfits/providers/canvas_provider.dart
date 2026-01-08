import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../closet/models/clothing_category.dart';
import '../../closet/providers/closet_provider.dart';

@immutable
class CanvasItem {
  const CanvasItem({
    required this.clothingItem,
    required this.position,
    required this.scale,
    required this.rotation,
    required this.zIndex,
  });

  final ClothingItem clothingItem;
  final Offset position;
  final double scale;
  final double rotation;
  final int zIndex;

  CanvasItem copyWith({
    ClothingItem? clothingItem,
    Offset? position,
    double? scale,
    double? rotation,
    int? zIndex,
  }) {
    return CanvasItem(
      clothingItem: clothingItem ?? this.clothingItem,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      zIndex: zIndex ?? this.zIndex,
    );
  }
}

class CanvasNotifier extends StateNotifier<List<CanvasItem>> {
  CanvasNotifier() : super([]);

  void addItem(ClothingItem item) {
    final newItem = CanvasItem(
      clothingItem: item,
      position: const Offset(100, 100), // Default position
      scale: 1.0,
      rotation: 0.0,
      zIndex: state.length,
    );
    state = [...state, newItem];
  }

  void removeItem(String itemId) {
    state = state
        .where((item) => item.clothingItem.id != itemId)
        .toList();
  }

  void updateItem(CanvasItem updatedItem) {
    state = state.map((item) {
      if (item.clothingItem.id == updatedItem.clothingItem.id) {
        return updatedItem;
      }
      return item;
    }).toList();
  }

  void autoArrange() {
    final categoryZIndex = {
      ClothingCategory.shoes: 0,
      ClothingCategory.bottoms: 1,
      ClothingCategory.tops: 2,
      ClothingCategory.outerwear: 3,
      ClothingCategory.accessory: 4,
    };

    final arrangedItems = <CanvasItem>[];
    final remainingItems = List<CanvasItem>.from(state);

    final categorizedItems = <ClothingCategory, List<CanvasItem>>{};
    for (var item in state) {
      (categorizedItems[item.clothingItem.category] ??= []).add(item);
    }

    for (var category in categoryZIndex.keys) {
      if (categorizedItems.containsKey(category)) {
        final items = categorizedItems[category]!;
        double yPos = 0;
        switch (category) {
          case ClothingCategory.tops:
            yPos = 60;
            break;
          case ClothingCategory.outerwear:
            yPos = 50;
            break;
          case ClothingCategory.bottoms:
            yPos = 160;
            break;
          case ClothingCategory.shoes:
            yPos = 250;
            break;
          case ClothingCategory.accessory:
            yPos = 20;
            break;
          default:
            yPos = 20;
        }

        for (int i = 0; i < items.length; i++) {
          final originalItem = items[i];
          arrangedItems.add(
            originalItem.copyWith(
              position: Offset(100.0 + (i * 20), yPos + (i * 10)),
              scale: 1.0,
              rotation: 0.0,
              zIndex: categoryZIndex[category],
            ),
          );
          remainingItems.removeWhere(
              (item) => item.clothingItem.id == originalItem.clothingItem.id);
        }
      }
    }

    for (int i = 0; i < remainingItems.length; i++) {
      arrangedItems.add(
        remainingItems[i].copyWith(
          position: Offset(20.0, 20.0 + (i * 20)),
          scale: 1.0,
          rotation: 0.0,
          zIndex: 5,
        ),
      );
    }

    state = arrangedItems;
  }
}

final canvasProvider = StateNotifierProvider<CanvasNotifier, List<CanvasItem>>((ref) {
  return CanvasNotifier();
});

final selectedCanvasItemProvider = StateProvider<String?>((ref) => null);
