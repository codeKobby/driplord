import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/providers/recommendation_provider.dart';
import '../../closet/providers/closet_provider.dart';

class MirrorItem {
  final String imageUrl;
  final String name;

  MirrorItem({required this.imageUrl, required this.name});
}

class MirrorNotifier extends Notifier<MirrorItem?> {
  @override
  MirrorItem? build() {
    return null;
  }

  void setItemFromRecommendation(Recommendation reco) {
    state = MirrorItem(imageUrl: reco.imageUrl, name: reco.title);
  }

  void setItemFromClothingItem(ClothingItem item) {
    state = MirrorItem(imageUrl: item.imageUrl, name: item.name);
  }

  void reset() {
    state = null;
  }
}

final mirrorProvider = NotifierProvider<MirrorNotifier, MirrorItem?>(() {
  return MirrorNotifier();
});

