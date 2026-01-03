import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/database_service.dart';

class ClothingItem {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final String? color;
  final String? brand;
  final double? purchasePrice;
  final DateTime? lastWornDate;
  final DateTime addedDate;
  final bool isAutoAdded;

  ClothingItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    this.color,
    this.brand,
    this.purchasePrice,
    this.lastWornDate,
    DateTime? addedDate,
    this.isAutoAdded = false,
  }) : addedDate = addedDate ?? DateTime.now();

  factory ClothingItem.fromJson(Map<String, dynamic> json) {
    return ClothingItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      imageUrl: json['image_url'],
      color: json['color'],
      brand: json['brand'],
      purchasePrice: (json['purchase_price'] as num?)?.toDouble(),
      lastWornDate: json['last_worn_date'] != null
          ? DateTime.parse(json['last_worn_date'])
          : null,
      addedDate: DateTime.parse(json['created_at']),
      isAutoAdded: false, // Default for now
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'image_url': imageUrl,
      'color': color,
      'brand': brand,
      'purchase_price': purchasePrice,
      'last_worn_date': lastWornDate?.toIso8601String(),
      'created_at': addedDate.toIso8601String(),
    };
  }
}

class ClosetNotifier extends Notifier<List<ClothingItem>> {
  @override
  List<ClothingItem> build() {
    // Start empty to force the "Scan" onboarding flow for new users
    // TODO: Load from Supabase when user is authenticated
    _loadClosetItems();
    return [];
  }

  Future<void> _loadClosetItems() async {
    try {
      final items = await DatabaseService().getClosetItems();
      state = items;
    } catch (e) {
      // Fall back to mock data if Supabase fails
      state = mockItems;
    }
  }

  // Exposed for the mock "AI Scan" feature
  static final List<ClothingItem> mockItems = [
    ClothingItem(
      id: "1",
      name: "Classic White Tee",
      category: "Tops",
      imageUrl:
          "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400",
      color: "White",
      brand: "Uniqlo",
      lastWornDate: DateTime.now().subtract(
        const Duration(days: 45),
      ), // Haven't worn in 45 days
      addedDate: DateTime.now().subtract(const Duration(days: 120)),
      isAutoAdded: false,
    ),
    ClothingItem(
      id: "2",
      name: "Black Hoodie",
      category: "Outerwear",
      imageUrl:
          "https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=400",
      color: "Black",
      brand: "Nike",
      lastWornDate: DateTime.now().subtract(
        const Duration(days: 60),
      ), // Haven't worn in 60 days
      addedDate: DateTime.now().subtract(const Duration(days: 90)),
      isAutoAdded: false,
    ),
    ClothingItem(
      id: "3",
      name: "Slim Fit Jeans",
      category: "Bottoms",
      imageUrl:
          "https://images.unsplash.com/photo-1542272604-787c3835535d?w=400",
      color: "Blue",
      brand: "Levi's",
      lastWornDate: DateTime.now().subtract(
        const Duration(days: 5),
      ), // Recently worn
      addedDate: DateTime.now().subtract(const Duration(days: 60)),
      isAutoAdded: false,
    ),
    ClothingItem(
      id: "4",
      name: "Leather Jacket",
      category: "Outerwear",
      imageUrl:
          "https://images.unsplash.com/photo-1520975661595-6453be3f7070?w=400",
      color: "Black",
      brand: "Zara",
      lastWornDate: DateTime.now().subtract(
        const Duration(days: 35),
      ), // Haven't worn in 35 days
      addedDate: DateTime.now().subtract(const Duration(days: 80)),
      isAutoAdded: false,
    ),
    ClothingItem(
      id: "5",
      name: "Sneakers",
      category: "Shoes",
      imageUrl:
          "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400",
      color: "White",
      brand: "Adidas",
      lastWornDate: DateTime.now().subtract(
        const Duration(days: 2),
      ), // Recently worn
      addedDate: DateTime.now().subtract(
        const Duration(days: 3),
      ), // Recently added
      isAutoAdded: true, // Auto-added by app
    ),
    ClothingItem(
      id: "6",
      name: "Oversized Flannel",
      category: "Tops",
      imageUrl:
          "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400",
      color: "Red",
      brand: "H&M",
      lastWornDate: DateTime.now().subtract(
        const Duration(days: 50),
      ), // Haven't worn in 50 days
      addedDate: DateTime.now().subtract(
        const Duration(days: 25),
      ), // Recently added but manually
      isAutoAdded: false,
    ),
    ClothingItem(
      id: "7",
      name: "Denim Jacket",
      category: "Outerwear",
      imageUrl:
          "https://images.unsplash.com/photo-1544966503-7cc5ac882d5e?w=400",
      color: "Blue",
      brand: "Levi's",
      lastWornDate: null, // Never worn
      addedDate: DateTime.now().subtract(
        const Duration(days: 2),
      ), // Recently added
      isAutoAdded: true, // Auto-added by app
    ),
    ClothingItem(
      id: "8",
      name: "Plaid Shirt",
      category: "Tops",
      imageUrl:
          "https://images.unsplash.com/photo-1584273140824-2fa4dc3f15e7?w=400",
      color: "Blue",
      brand: "Uniqlo",
      lastWornDate: null, // Never worn
      addedDate: DateTime.now().subtract(
        const Duration(days: 5),
      ), // Recently added
      isAutoAdded: false, // Manually added
    ),
  ];

  void addItem(ClothingItem item) {
    state = [...state, item];
  }

  void addItems(List<ClothingItem> items) {
    state = [...state, ...items];
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

// Items that haven't been worn in more than 30 days
final unwornItemsProvider = Provider<List<ClothingItem>>((ref) {
  final items = ref.watch(closetProvider);
  final now = DateTime.now();
  return items.where((item) {
    if (item.lastWornDate == null) return true; // Never worn items
    return now.difference(item.lastWornDate!).inDays > 30;
  }).toList();
});

// Items added in the last 7 days
final recentlyAddedItemsProvider = Provider<List<ClothingItem>>((ref) {
  final items = ref.watch(closetProvider);
  final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
  return items.where((item) => item.addedDate.isAfter(sevenDaysAgo)).toList();
});

// Auto-added items from the recently added ones
final autoAddedItemsProvider = Provider<List<ClothingItem>>((ref) {
  final recentlyAdded = ref.watch(recentlyAddedItemsProvider);
  return recentlyAdded.where((item) => item.isAutoAdded).toList();
});
