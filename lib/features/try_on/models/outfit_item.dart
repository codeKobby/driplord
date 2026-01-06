/// Represents the underlying clothing data for canvas and styling
class OutfitStackItem {
  final String id;
  final String category;
  final String name;
  final String imageUrl;
  final double? price;

  const OutfitStackItem({
    required this.id,
    required this.category,
    required this.name,
    required this.imageUrl,
    this.price,
  });

  factory OutfitStackItem.fromMap(Map<String, dynamic> map) {
    return OutfitStackItem(
      id: map['id'] ?? '',
      category: map['category'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: map['price']?.toDouble(),
    );
  }
}

