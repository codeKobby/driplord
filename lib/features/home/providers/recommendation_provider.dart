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
  final String title;
  final String imageUrl;
  final List<String> tags;

  Recommendation({
    required this.title,
    required this.imageUrl,
    required this.tags,
  });
}

final recommendationProvider = Provider<Recommendation>((ref) {
  final vibe = ref.watch(vibeProvider);

  switch (vibe) {
    case Vibe.chill:
      return Recommendation(
        title: "Sunday Minimalist",
        imageUrl:
            "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800",
        tags: ["Cotton", "Loose", "Neutral"],
      );
    case Vibe.bold:
      return Recommendation(
        title: "Neon City Nights",
        imageUrl:
            "https://images.unsplash.com/photo-1529139572894-3d2d93b3204b?w=800",
        tags: ["Graphic", "Oversized", "Vibrant"],
      );
    case Vibe.work:
      return Recommendation(
        title: "Metropolitan Professional",
        imageUrl:
            "https://images.unsplash.com/photo-1481325544415-bc49418e662c?w=800",
        tags: ["Tailored", "Blazer", "Monochrome"],
      );
    case Vibe.hype:
      return Recommendation(
        title: "Street Culture Icon",
        imageUrl:
            "https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?w=800",
        tags: ["Sneakers", "Denim", "Statement"],
      );
  }
});
