import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'recommendation_provider.dart';

class SavedOutfitsNotifier extends Notifier<List<Recommendation>> {
  @override
  List<Recommendation> build() {
    return [];
  }

  void toggleFavorite(Recommendation reco) {
    if (state.any((item) => item.title == reco.title)) {
      state = state.where((item) => item.title != reco.title).toList();
    } else {
      state = [...state, reco];
    }
  }

  bool isFavorite(Recommendation reco) {
    return state.any((item) => item.title == reco.title);
  }

  void saveVariant(Recommendation variant) {
    // Check if checks already exists to avoid duplicates
    if (!state.any((item) => item.id == variant.id)) {
      state = [variant, ...state];
    }
  }
}

final savedOutfitsProvider =
    NotifierProvider<SavedOutfitsNotifier, List<Recommendation>>(() {
      return SavedOutfitsNotifier();
    });

class DailyOutfitNotifier extends Notifier<Recommendation?> {
  @override
  Recommendation? build() {
    return null;
  }

  void setActive(Recommendation outfit) {
    state = outfit;
  }
}

final dailyOutfitProvider =
    NotifierProvider<DailyOutfitNotifier, Recommendation?>(() {
      return DailyOutfitNotifier();
    });
