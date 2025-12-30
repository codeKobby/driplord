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
}

final savedOutfitsProvider =
    NotifierProvider<SavedOutfitsNotifier, List<Recommendation>>(() {
      return SavedOutfitsNotifier();
    });
