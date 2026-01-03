import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/outfit_recommendation.dart';
import 'recommendation_provider.dart'; // For Vibe enum

class DailyStylistState {
  final List<OutfitRecommendation> dailyOutfits;
  final Vibe currentVibe;
  final bool isLoading;

  DailyStylistState({
    required this.dailyOutfits,
    required this.currentVibe,
    this.isLoading = false,
  });

  DailyStylistState copyWith({
    List<OutfitRecommendation>? dailyOutfits,
    Vibe? currentVibe,
    bool? isLoading,
  }) {
    return DailyStylistState(
      dailyOutfits: dailyOutfits ?? this.dailyOutfits,
      currentVibe: currentVibe ?? this.currentVibe,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DailyStylistNotifier extends Notifier<DailyStylistState> {
  @override
  DailyStylistState build() {
    // Initial load
    final initialVibe = ref.watch(vibeProvider);
    return DailyStylistState(
      dailyOutfits: _generateMockOutfits(initialVibe),
      currentVibe: initialVibe,
      isLoading: false,
    );
  }

  void setVibe(Vibe vibe) {
    state = state.copyWith(isLoading: true, currentVibe: vibe);
    // Update the global vibe provider as well if needed, or just keep local.
    // Syncing with global vibe provider for consistency.
    ref.read(vibeProvider.notifier).setVibe(vibe);

    // Simulate API delay and regeneration
    Future.delayed(const Duration(milliseconds: 600), () {
      state = state.copyWith(
        dailyOutfits: _generateMockOutfits(vibe),
        isLoading: false,
      );
    });
  }

  Future<void> refreshDailyLooks() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      dailyOutfits: _generateMockOutfits(state.currentVibe),
      isLoading: false,
    );
  }

  List<OutfitRecommendation> _generateMockOutfits(Vibe vibe) {
    switch (vibe) {
      case Vibe.chill:
        return [
          const OutfitRecommendation(
            id: '1',
            title: 'Sunday Minimalist',
            imageUrl:
                'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800',
            confidenceScore: 0.94,
            occasionHint: 'Casual',
            reasoning:
                'Perfect for a relaxed day. The cotton blend offers breathability while the neutral tones keep it versatile.',
            tags: ['Cotton', 'Loose', 'Neutral'],
          ),
          const OutfitRecommendation(
            id: '2',
            title: 'Coffee Run',
            imageUrl:
                'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=800',
            confidenceScore: 0.88,
            occasionHint: 'Casual',
            reasoning:
                'Layers are key for the morning breeze. This denim jacket pairs effortlessly with basic tees.',
            tags: ['Denim', 'Layered', 'Comfy'],
          ),
        ];
      case Vibe.bold:
        return [
          const OutfitRecommendation(
            id: '3',
            title: 'Neon City',
            imageUrl:
                'https://images.unsplash.com/photo-1529139572894-3d2d93b3204b?w=800',
            confidenceScore: 0.91,
            occasionHint: 'Night Out',
            reasoning:
                'High contrast colors to stand out. The oversized fit adds a modern streetwear edge.',
            tags: ['Graphic', 'Oversized', 'Vibrant'],
          ),
          const OutfitRecommendation(
            id: '4',
            title: 'Statement Piece',
            imageUrl:
                'https://images.unsplash.com/photo-1509631179647-0177f0543f12?w=800',
            confidenceScore: 0.85,
            occasionHint: 'Event',
            reasoning:
                'A bold pattern that demands attention. Paired with simple accessories to let the outfit speak.',
            tags: ['Pattern', 'Bold', 'Chic'],
          ),
        ];
      case Vibe.work:
        return [
          const OutfitRecommendation(
            id: '5',
            title: 'Metropolitan',
            imageUrl:
                'https://images.unsplash.com/photo-1481325544415-bc49418e662c?w=800',
            confidenceScore: 0.96,
            occasionHint: 'Office',
            reasoning:
                'Sharp lines and monochrome palette invoke professionalism. The blazer is lightweight for all-day comfort.',
            tags: ['Tailored', 'Blazer', 'Monochrome'],
          ),
          const OutfitRecommendation(
            id: '6',
            title: 'Smart Casual',
            imageUrl:
                'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=800',
            confidenceScore: 0.90,
            occasionHint: 'Meeting',
            reasoning:
                'A balance of comfort and structure. Smart trousers with a relaxed polo.',
            tags: ['Smart', 'Polo', 'Clean'],
          ),
        ];
      case Vibe.hype:
        return [
          const OutfitRecommendation(
            id: '7',
            title: 'Street Icon',
            imageUrl:
                'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?w=800',
            confidenceScore: 0.93,
            occasionHint: 'Street',
            reasoning:
                'Sneaker-focused fit. The color coordination ties the shoes to the upper layers perfectly.',
            tags: ['Sneakers', 'Denim', 'Statement'],
          ),
          const OutfitRecommendation(
            id: '8',
            title: 'Track Star',
            imageUrl:
                'https://images.unsplash.com/photo-1515347619252-60a6bf4fffce?w=800',
            confidenceScore: 0.89,
            occasionHint: 'Active',
            reasoning:
                'Athleisure at its finest. Comfortable enough for movement, stylish enough for the gram.',
            tags: ['Athleisure', 'Tracksuit', 'Fresh'],
          ),
        ];
    }
  }
}

final dailyStylistProvider =
    NotifierProvider<DailyStylistNotifier, DailyStylistState>(() {
      return DailyStylistNotifier();
    });
