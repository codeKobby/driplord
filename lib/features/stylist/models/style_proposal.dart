import '../../try_on/models/outfit_item.dart';

class StyleProposal {
  final String id;
  final String title;
  final String description;
  final List<OutfitStackItem> items;
  final double confidenceScore;

  StyleProposal({
    required this.id,
    required this.title,
    required this.description,
    required this.items,
    this.confidenceScore = 1.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'items': items
          .map(
            (i) => {
              'id': i.id,
              'category': i.category,
              'name': i.name,
              'imageUrl': i.imageUrl,
              'price': i.price,
            },
          )
          .toList(),
      'confidenceScore': confidenceScore,
    };
  }
}
