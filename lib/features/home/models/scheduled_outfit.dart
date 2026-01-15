/// Model representing an outfit scheduled for a specific date
class ScheduledOutfit {
  final String id;
  final DateTime scheduledDate;
  final String outfitId; // Reference to Recommendation id
  final String outfitTitle;
  final String outfitImageUrl;
  final String? personalImageUrl;
  final List<String> tags;
  final String? notes;
  final DateTime createdAt;

  ScheduledOutfit({
    required this.id,
    required this.scheduledDate,
    required this.outfitId,
    required this.outfitTitle,
    required this.outfitImageUrl,
    this.personalImageUrl,
    this.tags = const [],
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create from a Recommendation
  factory ScheduledOutfit.fromRecommendation({
    required String id,
    required DateTime scheduledDate,
    required String outfitId,
    required String outfitTitle,
    required String outfitImageUrl,
    String? personalImageUrl,
    List<String> tags = const [],
    String? notes,
  }) {
    return ScheduledOutfit(
      id: id,
      scheduledDate: scheduledDate,
      outfitId: outfitId,
      outfitTitle: outfitTitle,
      outfitImageUrl: outfitImageUrl,
      personalImageUrl: personalImageUrl,
      tags: tags,
      notes: notes,
    );
  }

  /// Create a copy with updated values
  ScheduledOutfit copyWith({
    String? id,
    DateTime? scheduledDate,
    String? outfitId,
    String? outfitTitle,
    String? outfitImageUrl,
    String? personalImageUrl,
    List<String>? tags,
    String? notes,
    DateTime? createdAt,
  }) {
    return ScheduledOutfit(
      id: id ?? this.id,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      outfitId: outfitId ?? this.outfitId,
      outfitTitle: outfitTitle ?? this.outfitTitle,
      outfitImageUrl: outfitImageUrl ?? this.outfitImageUrl,
      personalImageUrl: personalImageUrl ?? this.personalImageUrl,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert to JSON for caching/storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheduledDate': scheduledDate.toIso8601String(),
      'outfitId': outfitId,
      'outfitTitle': outfitTitle,
      'outfitImageUrl': outfitImageUrl,
      'personalImageUrl': personalImageUrl,
      'tags': tags,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory ScheduledOutfit.fromJson(Map<String, dynamic> json) {
    return ScheduledOutfit(
      id: json['id'] as String,
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      outfitId: json['outfitId'] as String,
      outfitTitle: json['outfitTitle'] as String,
      outfitImageUrl: json['outfitImageUrl'] as String,
      personalImageUrl: json['personalImageUrl'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  /// Check if this outfit is scheduled for a specific date
  bool isOnDate(DateTime date) {
    return scheduledDate.year == date.year &&
        scheduledDate.month == date.month &&
        scheduledDate.day == date.day;
  }
}
