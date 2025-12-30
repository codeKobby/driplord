import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClothingItem {
  final String id;
  final String name;
  final String category;
  final String imageUrl;

  ClothingItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
  });
}

class ClosetNotifier extends Notifier<List<ClothingItem>> {
  @override
  List<ClothingItem> build() {
    return _mockItems;
  }

  static final List<ClothingItem> _mockItems = [
    ClothingItem(
      id: "1",
      name: "Classic White Tee",
      category: "Tops",
      imageUrl:
          "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400",
    ),
    ClothingItem(
      id: "2",
      name: "Black Hoodie",
      category: "Outerwear",
      imageUrl:
          "https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=400",
    ),
    ClothingItem(
      id: "3",
      name: "Slim Fit Jeans",
      category: "Bottoms",
      imageUrl:
          "https://images.unsplash.com/photo-1542272604-787c3835535d?w=400",
    ),
    ClothingItem(
      id: "4",
      name: "Leather Jacket",
      category: "Outerwear",
      imageUrl:
          "https://images.unsplash.com/photo-1551028711-131da507bd89?w=400",
    ),
    ClothingItem(
      id: "5",
      name: "Sneakers",
      category: "Shoes",
      imageUrl:
          "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400",
    ),
    ClothingItem(
      id: "6",
      name: "Oversized Flannel",
      category: "Tops",
      imageUrl:
          "https://images.unsplash.com/photo-1481325544415-bc49418e662c?w=400",
    ),
  ];

  void addItem(ClothingItem item) {
    state = [...state, item];
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

final closetProvider = NotifierProvider<ClosetNotifier, List<ClothingItem>>(() {
  return ClosetNotifier();
});

class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() => "All";

  void setCategory(String category) {
    state = category;
  }
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String>(() {
      return SelectedCategoryNotifier();
    });

final filteredClosetProvider = Provider<List<ClothingItem>>((ref) {
  final items = ref.watch(closetProvider);
  final category = ref.watch(selectedCategoryProvider);
  if (category == "All") return items;
  return items.where((item) => item.category == category).toList();
});
