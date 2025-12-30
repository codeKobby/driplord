import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/providers/recommendation_provider.dart';

class HistoryEntry {
  final Recommendation outfit;
  final DateTime wornAt;

  HistoryEntry({required this.outfit, required this.wornAt});
}

class HistoryNotifier extends Notifier<List<HistoryEntry>> {
  @override
  List<HistoryEntry> build() {
    return _mockHistory;
  }

  static final List<HistoryEntry> _mockHistory = [
    HistoryEntry(
      outfit: Recommendation(
        title: "Monochrome Business",
        imageUrl:
            "https://images.unsplash.com/photo-1481325544415-bc49418e662c?w=400",
        tags: ["Work", "Blazer"],
      ),
      wornAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    HistoryEntry(
      outfit: Recommendation(
        title: "Weekend Casual",
        imageUrl:
            "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400",
        tags: ["Chill", "Cotton"],
      ),
      wornAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  void addEntry(Recommendation reco) {
    state = [HistoryEntry(outfit: reco, wornAt: DateTime.now()), ...state];
  }
}

final historyProvider = NotifierProvider<HistoryNotifier, List<HistoryEntry>>(
  () {
    return HistoryNotifier();
  },
);
