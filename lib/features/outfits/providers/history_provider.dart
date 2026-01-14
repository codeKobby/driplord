import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/providers/recommendation_provider.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/cache_service.dart';

class HistoryEntry {
  final Recommendation outfit;
  final DateTime wornAt;

  HistoryEntry({required this.outfit, required this.wornAt});
}

class HistoryNotifier extends Notifier<List<HistoryEntry>> {
  final CacheService _cacheService = CacheService();

  @override
  List<HistoryEntry> build() {
    _loadHistory();
    return [];
  }

  Future<void> _loadHistory() async {
    try {
      // Check cache first
      final cachedHistory = await _cacheService.get<List>(
        'outfit_history',
        config: CacheConfig.sessionData,
      );
      if (cachedHistory != null && cachedHistory.isNotEmpty) {
        state = cachedHistory
            .map((entry) => _historyEntryFromJson(entry))
            .toList();
        // Refresh from server in background
        _refreshFromServer();
        return;
      }

      // If not in cache, fetch from server
      final history = await DatabaseService().getHistory();

      if (history.isNotEmpty) {
        state = history;
        // Cache the fetched history
        await _cacheService.set(
          'outfit_history',
          history.map((entry) => _historyEntryToJson(entry)).toList(),
          config: CacheConfig.sessionData,
        );
      } else {
        // Use mock data for new users
        state = _mockHistory;
        // Cache mock history
        await _cacheService.set(
          'outfit_history',
          _mockHistory.map((entry) => _historyEntryToJson(entry)).toList(),
          config: CacheConfig.sessionData,
        );
      }
    } catch (e) {
      // Fall back to cache if available, otherwise mock data
      final cachedHistory = await _cacheService.get<List>(
        'outfit_history',
        config: CacheConfig.sessionData,
      );
      if (cachedHistory != null && cachedHistory.isNotEmpty) {
        state = cachedHistory
            .map((entry) => _historyEntryFromJson(entry))
            .toList();
      } else {
        state = _mockHistory;
      }
    }
  }

  Future<void> _refreshFromServer() async {
    try {
      final history = await DatabaseService().getHistory();
      if (history.isNotEmpty) {
        state = history;
        // Update cache with fresh data
        await _cacheService.set(
          'outfit_history',
          history.map((entry) => _historyEntryToJson(entry)).toList(),
          config: CacheConfig.sessionData,
        );
      }
    } catch (e) {
      // Silently fail - we already have cached data
    }
  }

  static final List<HistoryEntry> _mockHistory = [
    HistoryEntry(
      outfit: Recommendation(
        id: "history_1",
        title: "Monochrome Business",
        imageUrl:
            "https://images.unsplash.com/photo-1481325544415-bc49418e662c?w=400",
        personalImageUrl:
            "https://images.unsplash.com/photo-1481325544415-bc49418e662c?w=400",
        tags: ["Work", "Blazer"],
        confidenceScore: 0.95,
        reasoning:
            "Professional look that commands respect in business settings.",
        source: "Unsplash",
        sourceUrl:
            "https://unsplash.com/photos/man-wearing-black-blazer-and-white-dress-shirt-X_M_U9Y6-oY",
      ),
      wornAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    HistoryEntry(
      outfit: Recommendation(
        id: "history_2",
        title: "Weekend Casual",
        imageUrl:
            "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400",
        personalImageUrl:
            "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400",
        tags: ["Chill", "Cotton"],
        confidenceScore: 0.88,
        reasoning: "Relaxed weekend vibe with comfortable, breathable fabrics.",
        source: "Unsplash",
        sourceUrl:
            "https://unsplash.com/photos/woman-wearing-white-tank-top-X_M_U9Y6-oY",
      ),
      wornAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  Future<void> addEntry(Recommendation reco) async {
    // Add to local state immediately for UI responsiveness
    final newEntry = HistoryEntry(outfit: reco, wornAt: DateTime.now());
    state = [newEntry, ...state];

    // Update cache
    await _updateCache();

    // Save to Supabase in background
    try {
      await DatabaseService().addToHistory(reco);
    } catch (e) {
      // If Supabase fails, the local state will still be updated
      // In a production app, you might want to show an error or retry
    }
  }

  Future<void> _updateCache() async {
    try {
      final historyJson = state
          .map((entry) => _historyEntryToJson(entry))
          .toList();
      await _cacheService.set(
        'outfit_history',
        historyJson,
        config: CacheConfig.sessionData,
      );
    } catch (e) {
      // Silently fail - cache update is not critical
    }
  }

  Map<String, dynamic> _historyEntryToJson(HistoryEntry entry) {
    return {
      'outfit': {
        'id': entry.outfit.id,
        'title': entry.outfit.title,
        'imageUrl': entry.outfit.imageUrl,
        'personalImageUrl': entry.outfit.personalImageUrl,
        'tags': entry.outfit.tags,
        'confidenceScore': entry.outfit.confidenceScore,
        'reasoning': entry.outfit.reasoning,
        'source': entry.outfit.source,
        'sourceUrl': entry.outfit.sourceUrl,
      },
      'wornAt': entry.wornAt.toIso8601String(),
    };
  }

  HistoryEntry _historyEntryFromJson(Map<String, dynamic> json) {
    final outfitData = json['outfit'] as Map<String, dynamic>? ?? {};
    final outfit = Recommendation(
      id:
          outfitData['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: outfitData['title']?.toString() ?? 'Unknown Outfit',
      imageUrl: outfitData['imageUrl']?.toString() ?? '',
      personalImageUrl:
          outfitData['personalImageUrl']?.toString() ??
          outfitData['imageUrl']?.toString() ??
          '',
      tags: List<String>.from(outfitData['tags'] ?? []),
      confidenceScore:
          (outfitData['confidenceScore'] as num?)?.toDouble() ?? 0.0,
      reasoning: outfitData['reasoning']?.toString() ?? '',
      source: outfitData['source']?.toString() ?? 'Unknown',
      sourceUrl: outfitData['sourceUrl']?.toString() ?? '',
    );

    return HistoryEntry(
      outfit: outfit,
      wornAt: json['wornAt'] != null
          ? DateTime.tryParse(json['wornAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

final historyProvider = NotifierProvider<HistoryNotifier, List<HistoryEntry>>(
  () {
    return HistoryNotifier();
  },
);
