import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/cache_service.dart';

/// State for tracking closet loading progress
enum ClosetLoadState { loading, loaded, error }

/// Tracks the loading state of the closet
final closetLoadStateProvider = StateProvider<ClosetLoadState>((ref) {
  return ClosetLoadState.loading;
});

/// Stores any error message from loading
final closetErrorProvider = StateProvider<String?>((ref) => null);

class ClothingItem {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final String? color;
  final String? brand;
  final double? purchasePrice;
  final DateTime? lastWornAt;
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
    this.lastWornAt,
    DateTime? addedDate,
    this.isAutoAdded = false,
  }) : addedDate = addedDate ?? DateTime.now();

  factory ClothingItem.fromJson(Map<String, dynamic> json) {
    return ClothingItem(
      id:
          json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name']?.toString() ?? 'Unnamed Item',
      category: json['category']?.toString() ?? 'Misc',
      imageUrl: json['image_url']?.toString() ?? '',
      color: json['color']?.toString(),
      brand: json['brand']?.toString(),
      purchasePrice: (json['purchase_price'] as num?)?.toDouble(),
      lastWornAt: json['last_worn_date'] != null
          ? DateTime.tryParse(json['last_worn_date'] as String)
          : null,
      addedDate: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      isAutoAdded: json['is_auto_added'] ?? false,
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
      'last_worn_date': lastWornAt?.toIso8601String(),
      'created_at': addedDate.toIso8601String(),
    };
  }
}

class ClosetNotifier extends AsyncNotifier<List<ClothingItem>> {
  final CacheService _cacheService = CacheService();

  @override
  Future<List<ClothingItem>> build() async {
    final dbService = DatabaseService();

    // If unauthenticated, use mock data for demo/preview mode
    if (!dbService.isAuthenticated) {
      return mockItems;
    }

    try {
      // First try to get from cache
      final cachedItems = await _cacheService.get<List>(
        'closet_items',
        config: CacheConfig.userData,
      );
      if (cachedItems != null && cachedItems.isNotEmpty) {
        // Refresh from server in background
        _refreshFromServer();
        return cachedItems.map((item) => ClothingItem.fromJson(item)).toList();
      }

      // If not in cache, fetch from server
      final items = await dbService.getClosetItems();

      // Cache the fetched items
      if (items.isNotEmpty) {
        await _cacheService.set(
          'closet_items',
          items.map((item) => item.toJson()).toList(),
          config: CacheConfig.userData,
        );
      }

      return items;
    } catch (e) {
      debugPrint('Error loading closet items: $e');
      // Fall back to cache if available
      final cachedItems = await _cacheService.get<List>(
        'closet_items',
        config: CacheConfig.userData,
      );
      if (cachedItems != null && cachedItems.isNotEmpty) {
        return cachedItems.map((item) => ClothingItem.fromJson(item)).toList();
      }
      // Re-throw to trigger AsyncValue.error
      rethrow;
    }
  }

  Future<void> _refreshFromServer() async {
    try {
      final items = await DatabaseService().getClosetItems();
      if (items.isNotEmpty) {
        state = AsyncValue.data(items);
        // Update cache with fresh data
        await _cacheService.set(
          'closet_items',
          items.map((item) => item.toJson()).toList(),
          config: CacheConfig.userData,
        );
      }
    } catch (e) {
      // Silently fail - we already have cached data
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
      lastWornAt: DateTime.now().subtract(
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
      lastWornAt: DateTime.now().subtract(
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
      lastWornAt: DateTime.now().subtract(
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
      lastWornAt: DateTime.now().subtract(
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
      lastWornAt: DateTime.now().subtract(
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
      lastWornAt: DateTime.now().subtract(
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
      lastWornAt: null, // Never worn
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
      lastWornAt: null, // Never worn
      addedDate: DateTime.now().subtract(
        const Duration(days: 5),
      ), // Recently added
      isAutoAdded: false, // Manually added
    ),
  ];

  Future<void> addItem(ClothingItem item) async {
    final currentItems = state.value ?? [];
    state = AsyncValue.data([...currentItems, item]);
    await _updateCache();
  }

  Future<void> addItems(List<ClothingItem> items) async {
    final currentItems = state.value ?? [];
    state = AsyncValue.data([...currentItems, ...items]);
    await _updateCache();
  }

  Future<void> removeItem(String id) async {
    final currentItems = state.value ?? [];
    state = AsyncValue.data(currentItems.where((item) => item.id != id).toList());
    await _updateCache();
  }

  Future<void> updateItem(ClothingItem updatedItem) async {
    final currentItems = state.value ?? [];
    state = AsyncValue.data(
      currentItems.map((item) => item.id == updatedItem.id ? updatedItem : item).toList(),
    );
    await _updateCache();
  }

  Future<void> _updateCache() async {
    try {
      final items = state.value ?? [];
      final itemsJson = items.map((item) => item.toJson()).toList();
      await _cacheService.set(
        'closet_items',
        itemsJson,
        config: CacheConfig.userData,
      );
    } catch (e) {
      // Silently fail - cache update is not critical
    }
  }
}

final closetProvider =
    AsyncNotifierProvider<ClosetNotifier, List<ClothingItem>>(() {
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
    NotifierProvider.autoDispose<SelectedCategoryNotifier, String>(() {
      return SelectedCategoryNotifier();
    });

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => "";

  void setSearchQuery(String query) {
    state = query.toLowerCase(); // Remove trim() to allow spaces while typing
  }
}

final searchQueryProvider =
    NotifierProvider.autoDispose<SearchQueryNotifier, String>(() {
      return SearchQueryNotifier();
    });

class SortOptionNotifier extends Notifier<String> {
  @override
  String build() => "name_asc";

  void setSortOption(String sortOption) {
    state = sortOption;
  }
}

final sortOptionProvider =
    NotifierProvider.autoDispose<SortOptionNotifier, String>(() {
      return SortOptionNotifier();
    });

class FilterOptionsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggleFilter(String filter) {
    final currentFilters = state;
    if (currentFilters.contains(filter)) {
      state = currentFilters.where((f) => f != filter).toSet();
    } else {
      state = {...currentFilters, filter};
    }
  }

  void clearAllFilters() {
    state = {};
  }
}

final filterOptionsProvider =
    NotifierProvider.autoDispose<FilterOptionsNotifier, Set<String>>(() {
      return FilterOptionsNotifier();
    });

// Enhanced filtered provider that handles search, sort, category, and filters
final filteredClosetProvider = Provider<List<ClothingItem>>((ref) {
  final asyncItems = ref.watch(closetProvider);
  final items = asyncItems.value ?? [];
  final searchQuery = ref.watch(searchQueryProvider);
  final category = ref.watch(selectedCategoryProvider);
  final sortOption = ref.watch(sortOptionProvider);
  final filters = ref.watch(filterOptionsProvider);

  // Apply category filter
  var filteredItems = items;
  if (category != "All") {
    filteredItems = filteredItems
        .where((item) => item.category == category)
        .toList();
  }

  // Apply search filter with multiple criteria
  if (searchQuery.isNotEmpty) {
    filteredItems = filteredItems.where((item) {
      final query = searchQuery
          .toLowerCase(); // Consistent with Notifier (no trim)
      final nameMatches = item.name.toLowerCase().contains(query);
      final brandMatches = (item.brand?.toLowerCase() ?? "").contains(query);
      final colorMatches = (item.color?.toLowerCase() ?? "").contains(query);
      final categoryMatches = item.category.toLowerCase().contains(query);

      return nameMatches || brandMatches || colorMatches || categoryMatches;
    }).toList();
  }

  // Apply additional filters
  if (filters.isNotEmpty) {
    filteredItems = filteredItems.where((item) {
      bool matches = true;

      if (filters.contains('worn_recently')) {
        matches =
            matches &&
            item.lastWornAt != null &&
            DateTime.now().difference(item.lastWornAt!).inDays <= 7;
      }

      if (filters.contains('unworn')) {
        matches =
            matches &&
            (item.lastWornAt == null ||
                DateTime.now().difference(item.lastWornAt!).inDays > 30);
      }

      if (filters.contains('favorites')) {
        matches =
            matches &&
            item.isAutoAdded ==
                false; // Assuming non-auto added items are favorites
      }

      if (filters.contains('auto_added')) {
        matches = matches && item.isAutoAdded;
      }

      return matches;
    }).toList();
  }

  // Apply sorting
  filteredItems = _applySorting(filteredItems, sortOption);

  return filteredItems;
});

// Helper function to apply sorting without mutating the original list
List<ClothingItem> _applySorting(List<ClothingItem> items, String sortOption) {
  final sortedItems = List<ClothingItem>.from(items);
  switch (sortOption) {
    case "name_asc":
      return sortedItems..sort((a, b) => a.name.compareTo(b.name));
    case "name_desc":
      return sortedItems..sort((a, b) => b.name.compareTo(a.name));
    case "date_added_asc":
      return sortedItems..sort((a, b) => a.addedDate.compareTo(b.addedDate));
    case "date_added_desc":
      return sortedItems..sort((a, b) => b.addedDate.compareTo(a.addedDate));
    case "last_worn_asc":
      final withWearDate =
          sortedItems.where((item) => item.lastWornAt != null).toList()
            ..sort((a, b) => a.lastWornAt!.compareTo(b.lastWornAt!));
      return withWearDate;
    case "last_worn_desc":
      final withWearDate =
          sortedItems.where((item) => item.lastWornAt != null).toList()
            ..sort((a, b) => b.lastWornAt!.compareTo(a.lastWornAt!));
      return withWearDate;
    case "category_asc":
      return sortedItems..sort((a, b) => a.category.compareTo(b.category));
    case "category_desc":
      return sortedItems..sort((a, b) => b.category.compareTo(a.category));
    default:
      return sortedItems;
  }
}

// Items that haven't been worn in more than 30 days
final unwornItemsProvider = Provider<List<ClothingItem>>((ref) {
  final asyncItems = ref.watch(closetProvider);
  final items = asyncItems.value ?? [];
  final now = DateTime.now();
  return items.where((item) {
    if (item.lastWornAt == null) return true; // Never worn items
    return now.difference(item.lastWornAt!).inDays > 30;
  }).toList();
});

// Items added in the last 7 days
final recentlyAddedItemsProvider = Provider<List<ClothingItem>>((ref) {
  final asyncItems = ref.watch(closetProvider);
  final items = asyncItems.value ?? [];
  final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
  return items.where((item) => item.addedDate.isAfter(sevenDaysAgo)).toList();
});

// Auto-added items from the recently added ones
final autoAddedItemsProvider = Provider<List<ClothingItem>>((ref) {
  final recentlyAdded = ref.watch(recentlyAddedItemsProvider);
  return recentlyAdded.where((item) => item.isAutoAdded).toList();
});

// Items that have been worn most frequently (recently worn items)
final frequentlyWornItemsProvider = Provider<List<ClothingItem>>((ref) {
  final asyncItems = ref.watch(closetProvider);
  final items = asyncItems.value ?? [];

  // Get items that have been worn at least once, sorted by most recent wear
  final wornItems = items.where((item) => item.lastWornAt != null).toList()
    ..sort((a, b) => b.lastWornAt!.compareTo(a.lastWornAt!));

  return wornItems.take(4).toList();
});
