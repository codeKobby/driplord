import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/providers/recommendation_provider.dart';
import '../../../core/services/database_service.dart';

class HistoryEntry {
  final Recommendation outfit;
  final DateTime wornAt;

  HistoryEntry({required this.outfit, required this.wornAt});
}

class HistoryNotifier extends Notifier<List<HistoryEntry>> {
  @override
  List<HistoryEntry> build() {
    _loadHistory();
    return [];
  }

  Future<void> _loadHistory() async {
    try {
      final history = await DatabaseService().getHistory();
      state = history;
    } catch (e) {
      // Fall back to mock data if Supabase fails
      state = _mockHistory;
    }
  }

  static final List<HistoryEntry> _mockHistory = [
    HistoryEntry(
      outfit: Recommendation(
        id: "history_1",
        title: "Monochrome Business",
        imageUrl:
            "https://images.unsplash.com/photo-1481325544415-bc49418e662c?w=400",
        tags: ["Work", "Blazer"],
        confidenceScore: 0.95,
        reasoning: "Professional look that commands respect in business settings.",
      ),
      wornAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    HistoryEntry(
      outfit: Recommendation(
        id: "history_2",
        title: "Weekend Casual",
        imageUrl:
            "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400",
        tags: ["Chill", "Cotton"],
        confidenceScore: 0.88,
        reasoning: "Relaxed weekend vibe with comfortable, breathable fabrics.",
      ),
      wornAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  Future<void> addEntry(Recommendation reco) async {
    // Add to local state immediately for UI responsiveness
    final newEntry = HistoryEntry(outfit: reco, wornAt: DateTime.now());
    state = [newEntry, ...state];

    // Save to Supabase in background
    try {
      await DatabaseService().addToHistory(reco);
    } catch (e) {
      // If Supabase fails, the local state will still be updated
      // In a production app, you might want to show an error or retry
    }
  }
}

final historyProvider = NotifierProvider<HistoryNotifier, List<HistoryEntry>>(
  () {
    return HistoryNotifier();
  },
);
