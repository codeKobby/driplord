import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/closet/providers/closet_provider.dart';
import '../../features/home/providers/recommendation_provider.dart';
import '../../features/outfits/providers/history_provider.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // ===========================================================================
  // AUTH HELPERS
  // ===========================================================================

  /// Returns true if a user is currently authenticated
  bool get isAuthenticated => _supabase.auth.currentUser != null;

  /// Returns the current user's ID, or null if not authenticated
  String? get currentUserId => _supabase.auth.currentUser?.id;

  // ===========================================================================
  // CLOSET ITEMS
  // ===========================================================================

  Future<List<ClothingItem>> getClosetItems() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('closet_items')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return response.map((item) => ClothingItem.fromJson(item)).toList();
  }

  Future<void> addClosetItem(ClothingItem item) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _supabase.from('closet_items').insert({
      'user_id': userId,
      'name': item.name,
      'category': item.category,
      'image_url': item.imageUrl,
      'brand': item.brand,
      'purchase_price': item.purchasePrice,
    });
  }

  Future<void> updateClosetItem(ClothingItem item) async {
    await _supabase
        .from('closet_items')
        .update({
          'name': item.name,
          'category': item.category,
          'image_url': item.imageUrl,
          'brand': item.brand,
          'purchase_price': item.purchasePrice,
        })
        .eq('id', item.id);
  }

  Future<void> deleteClosetItem(String itemId) async {
    await _supabase.from('closet_items').delete().eq('id', itemId);
  }

  // ===========================================================================
  // SAVED OUTFITS
  // ===========================================================================

  Future<List<Recommendation>> getSavedOutfits() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('saved_outfits')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return response.map((item) => _outfitFromJson(item)).toList();
  }

  Future<void> saveOutfit(Recommendation outfit) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _supabase.from('saved_outfits').insert({
      'user_id': userId,
      'title': outfit.title,
      'image_url': outfit.imageUrl,
      'meta_data': {
        'confidence_score': outfit.confidenceScore,
        'reasoning': outfit.reasoning,
        'tags': outfit.tags,
        'source': outfit.source,
      },
    });
  }

  Future<void> updateLastWorn(String outfitId) async {
    await _supabase
        .from('saved_outfits')
        .update({'last_worn_at': DateTime.now().toIso8601String()})
        .eq('id', outfitId);
  }

  Future<void> deleteOutfit(String outfitId) async {
    await _supabase.from('saved_outfits').delete().eq('id', outfitId);
  }

  // ===========================================================================
  // HISTORY / DAILY LOGS
  // ===========================================================================

  Future<List<HistoryEntry>> getHistory() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('daily_logs')
        .select('*, saved_outfits(*)')
        .eq('user_id', userId)
        .order('date', ascending: false)
        .limit(30); // Last 30 days

    return response.map((entry) => _historyEntryFromJson(entry)).toList();
  }

  Future<void> addToHistory(Recommendation outfit) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    // First, ensure the outfit exists in saved_outfits
    final existingOutfit = await _supabase
        .from('saved_outfits')
        .select('id')
        .eq('user_id', userId)
        .eq('title', outfit.title)
        .maybeSingle();

    String outfitId;
    if (existingOutfit != null) {
      outfitId = existingOutfit['id'];
      // Update last worn
      await updateLastWorn(outfitId);
    } else {
      // Save the outfit first
      final newOutfit = await _supabase
          .from('saved_outfits')
          .insert({
            'user_id': userId,
            'title': outfit.title,
            'image_url': outfit.imageUrl,
            'meta_data': {
              'confidence_score': outfit.confidenceScore,
              'reasoning': outfit.reasoning,
              'tags': outfit.tags,
              'source': outfit.source,
              'source_url': outfit.sourceUrl,
            },
            'last_worn_at': DateTime.now().toIso8601String(),
          })
          .select('id')
          .single();
      outfitId = newOutfit['id'];
    }

    // Add to daily log
    await _supabase.from('daily_logs').upsert({
      'user_id': userId,
      'outfit_id': outfitId,
      'date': DateTime.now().toIso8601String().split('T')[0], // YYYY-MM-DD
    });
  }

  // ===========================================================================
  // USER PROFILE
  // ===========================================================================

  Future<Map<String, dynamic>?> getUserProfile() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    return response;
  }

  Future<void> updateUserProfile({
    String? username,
    String? avatarUrl,
    List<String>? styleVibes,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final updates = <String, dynamic>{};
    if (username != null) updates['username'] = username;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
    if (styleVibes != null) updates['style_vibes'] = styleVibes;

    await _supabase.from('profiles').upsert({'id': userId, ...updates});
  }

  // ===========================================================================
  // HELPER METHODS
  // ===========================================================================

  Recommendation _outfitFromJson(Map<String, dynamic> json) {
    final metaData = json['meta_data'] as Map<String, dynamic>? ?? {};

    return Recommendation(
      id:
          json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title']?.toString() ?? 'Unknown Outfit',
      imageUrl: json['image_url']?.toString() ?? '',
      personalImageUrl:
          json['personal_image_url']?.toString() ?? json['image_url'] ?? '',
      tags: List<String>.from(metaData['tags'] ?? []),
      confidenceScore:
          (metaData['confidence_score'] as num?)?.toDouble() ?? 0.0,
      reasoning: metaData['reasoning']?.toString() ?? '',
      source: metaData['source']?.toString() ?? 'Unknown',
      sourceUrl: metaData['source_url']?.toString() ?? '',
    );
  }

  HistoryEntry _historyEntryFromJson(Map<String, dynamic> json) {
    final outfitData = json['saved_outfits'] as Map<String, dynamic>? ?? {};
    final outfit = _outfitFromJson(outfitData);

    return HistoryEntry(
      outfit: outfit,
      wornAt: DateTime.parse(json['created_at']),
    );
  }
}
