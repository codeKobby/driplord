import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Vibe { chill, bold, work, hype }

class VibeNotifier extends Notifier<Vibe> {
  @override
  Vibe build() {
    return Vibe.chill;
  }

  void setVibe(Vibe vibe) {
    state = vibe;
  }
}

final vibeProvider = NotifierProvider<VibeNotifier, Vibe>(() {
  return VibeNotifier();
});

// Mock data for recommendations based on vibe
class Recommendation {
  final String id;
  final String title;
  final String imageUrl; // Online Inspiration
  final String personalImageUrl; // User's Canvas/Wardrobe Version
  final List<String> tags;
  final double confidenceScore;
  final String reasoning;
  final String source; // Image source for copyright attribution
  final String? _sourceUrl; // Nullable for safe migration

  String get sourceUrl => _sourceUrl ?? '';

  Recommendation({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.personalImageUrl,
    required this.tags,
    required this.confidenceScore,
    required this.reasoning,
    required this.source,
    String? sourceUrl,
  }) : _sourceUrl = sourceUrl;
}

final recommendationProvider = Provider<List<Recommendation>>((ref) {
  final vibe = ref.watch(vibeProvider);

  switch (vibe) {
    case Vibe.chill:
      return [
        Recommendation(
          id: "chill_1",
          title: "Sunday Minimalist",
          imageUrl:
              "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800",
          personalImageUrl:
              "https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=400", // Black hoodie/sweats translation
          tags: ["Cotton", "Loose", "Neutral"],
          confidenceScore: 0.94,
          reasoning: "Perfect for today's forecast. Clean lines, zero stress.",
          source: "Unsplash",
          sourceUrl:
              "https://unsplash.com/photos/woman-wearing-white-tank-top-X_M_U9Y6-oY",
        ),
        Recommendation(
          id: "chill_2",
          title: "Coffee Run Texture",
          imageUrl:
              "https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=800",
          personalImageUrl:
              "https://images.unsplash.com/photo-1544966503-7cc5ac882d5e?w=400", // Denim jacket translation
          tags: ["Layered", "Soft", "Earthy"],
          confidenceScore: 0.88,
          reasoning: "A bit more warmth if the breeze picks up.",
          source: "Unsplash",
          sourceUrl:
              "https://unsplash.com/photos/gray-and-black-textile-P4i-O7_9zsc",
        ),
      ];
    case Vibe.bold:
      return [
        Recommendation(
          id: "bold_1",
          title: "Neon City Nights",
          imageUrl:
              "https://images.unsplash.com/photo-1529139572894-3d2d93b3204b?w=800",
          personalImageUrl:
              "https://images.unsplash.com/photo-1520975661595-6453be3f7070?w=400", // Leather jacket translation
          tags: ["Graphic", "Oversized", "Vibrant"],
          confidenceScore: 0.96,
          reasoning: "Stand out without trying too hard.",
          source: "Unsplash",
          sourceUrl:
              "https://unsplash.com/photos/woman-in-white-and-black-striped-long-sleeve-shirt-looking-at-mirror-mEZ3ToAat_4",
        ),
        Recommendation(
          id: "bold_2",
          title: "Industrial Contrast",
          imageUrl:
              "https://images.unsplash.com/photo-1504198458649-3128b932f49e?w=800",
          personalImageUrl:
              "https://images.unsplash.com/photo-1481325544415-bc49418e662c?w=400", // Sharp blazer translation
          tags: ["Tech", "Sharp", "Monochrome"],
          confidenceScore: 0.91,
          reasoning: "High impact, modern silhouette.",
          source: "Unsplash",
          sourceUrl:
              "https://unsplash.com/photos/grayscale-photo-of-man-in-white-dress-shirt-and-black-suit-y_A_S7S-oY",
        ),
      ];
    case Vibe.work:
      return [
        Recommendation(
          id: "work_1",
          title: "Metropolitan Professional",
          imageUrl:
              "https://images.unsplash.com/photo-1481325544415-bc49418e662c?w=800",
          personalImageUrl:
              "https://images.unsplash.com/photo-1481325544415-bc49418e662c?w=400",
          tags: ["Tailored", "Blazer", "Monochrome"],
          confidenceScore: 0.95,
          reasoning: "Commands respect, but comfortable enough for 8 hours.",
          source: "Unsplash",
          sourceUrl:
              "https://unsplash.com/photos/man-wearing-black-blazer-and-white-dress-shirt-X_M_U9Y6-oY",
        ),
        Recommendation(
          id: "work_2",
          title: "Smart Casual Flow",
          imageUrl:
              "https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=800",
          personalImageUrl:
              "https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=400",
          tags: ["Structured", "Navy", "Crisp"],
          confidenceScore: 0.89,
          reasoning: "Professional without the stiffness.",
          source: "Unsplash",
          sourceUrl:
              "https://unsplash.com/photos/man-in-blue-blazer-standing-on-road-P4i-O7_9zsc",
        ),
      ];
    case Vibe.hype:
      return [
        Recommendation(
          id: "hype_1",
          title: "Street Culture Icon",
          imageUrl:
              "https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?w=800",
          personalImageUrl:
              "https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?w=400",
          tags: ["Sneakers", "Denim", "Statement"],
          confidenceScore: 0.98,
          reasoning: "On trend. The silhouette everyone's after right now.",
          source: "Unsplash",
          sourceUrl:
              "https://unsplash.com/photos/woman-in-white-denim-jacket-and-blue-denim-jeans-standing-on-gray-concrete-floor-during-daytime-mEZ3ToAat_4",
        ),
        Recommendation(
          id: "hype_2",
          title: "Utility Future",
          imageUrl:
              "https://images.unsplash.com/photo-1512413314640-c3fa08f1b623?w=800",
          personalImageUrl:
              "https://images.unsplash.com/photo-1512413314640-c3fa08f1b623?w=400",
          tags: ["Cargo", "Oversized", "Techwear"],
          confidenceScore: 0.92,
          reasoning: "Functional, heavy-duty, clean.",
          source: "Unsplash",
          sourceUrl:
              "https://unsplash.com/photos/man-in-black-jacket-standing-near-green-leaf-plants-y_A_S7S-oY",
        ),
      ];
  }
});
