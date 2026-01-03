class OutfitRecommendation {
  final String id;
  final String title;
  final String imageUrl;
  final double confidenceScore; // e.g., 0.92 for 92%
  final String occasionHint; // e.g., "Casual", "Work"
  final String reasoning; // "Why this works" text
  final List<String> tags;

  const OutfitRecommendation({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.confidenceScore,
    required this.occasionHint,
    required this.reasoning,
    required this.tags,
  });
}
