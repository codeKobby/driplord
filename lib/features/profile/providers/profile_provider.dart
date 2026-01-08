import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/cache_service.dart';

class UserProfile {
  final String id;
  final String? username;
  final String? avatarUrl;
  final List<String>? styleVibes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.id,
    this.username,
    this.avatarUrl,
    this.styleVibes,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      username: json['username'],
      avatarUrl: json['avatar_url'],
      styleVibes: json['style_vibes'] != null ? List<String>.from(json['style_vibes']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar_url': avatarUrl,
      'style_vibes': styleVibes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? username,
    String? avatarUrl,
    List<String>? styleVibes,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      styleVibes: styleVibes ?? this.styleVibes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ProfileNotifier extends Notifier<AsyncValue<UserProfile?>> {
  final CacheService _cacheService = CacheService();

  @override
  AsyncValue<UserProfile?> build() {
    _loadProfile();
    return const AsyncValue.loading();
  }

  Future<void> _loadProfile() async {
    try {
      // Check cache first
      final cachedProfile = await _cacheService.get<Map<String, dynamic>>('user_profile', config: CacheConfig.userData);
      if (cachedProfile != null) {
        final profile = UserProfile.fromJson(cachedProfile);
        state = AsyncValue.data(profile);
        // Refresh from server in background
        _refreshFromServer();
        return;
      }

      // If not in cache, fetch from server
      final profileData = await DatabaseService().getUserProfile();

      if (profileData != null) {
        final profile = UserProfile.fromJson(profileData);
        state = AsyncValue.data(profile);
        // Cache the fetched profile
        await _cacheService.set('user_profile', profile.toJson(), config: CacheConfig.userData);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e) {
      // Fall back to cache if available, otherwise error
      final cachedProfile = await _cacheService.get<Map<String, dynamic>>('user_profile', config: CacheConfig.userData);
      if (cachedProfile != null) {
        final profile = UserProfile.fromJson(cachedProfile);
        state = AsyncValue.data(profile);
      } else {
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }

  Future<void> _refreshFromServer() async {
    try {
      final profileData = await DatabaseService().getUserProfile();
      if (profileData != null) {
        final profile = UserProfile.fromJson(profileData);
        state = AsyncValue.data(profile);
        // Update cache with fresh data
        await _cacheService.set('user_profile', profile.toJson(), config: CacheConfig.userData);
      }
    } catch (e) {
      // Silently fail - we already have cached data
    }
  }

  Future<void> updateProfile({
    String? username,
    String? avatarUrl,
    List<String>? styleVibes,
  }) async {
    final currentProfile = state.value;
    if (currentProfile == null) return;

    try {
      // Update on server
      await DatabaseService().updateUserProfile(
        username: username,
        avatarUrl: avatarUrl,
        styleVibes: styleVibes,
      );

      // Update local state
      final updatedProfile = currentProfile.copyWith(
        username: username,
        avatarUrl: avatarUrl,
        styleVibes: styleVibes,
        updatedAt: DateTime.now(),
      );
      state = AsyncValue.data(updatedProfile);

      // Update cache
      await _cacheService.set('user_profile', updatedProfile.toJson(), config: CacheConfig.userData);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refreshProfile() async {
    state = const AsyncValue.loading();
    await _loadProfile();
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, AsyncValue<UserProfile?>>(
  () => ProfileNotifier(),
);
