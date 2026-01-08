import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Cache configuration for different data types
class CacheConfig {
  final Duration defaultExpiry;
  final int maxEntries;
  final String storageType; // 'shared_preferences' or 'sqflite'

  const CacheConfig({
    required this.defaultExpiry,
    this.maxEntries = 100,
    this.storageType = 'shared_preferences',
  });

  static const CacheConfig userData = CacheConfig(
    defaultExpiry: Duration(days: 7),
    maxEntries: 1000,
    storageType: 'sqflite',
  );

  static const CacheConfig apiResponse = CacheConfig(
    defaultExpiry: Duration(minutes: 30),
    maxEntries: 50,
    storageType: 'shared_preferences',
  );

  static const CacheConfig computedData = CacheConfig(
    defaultExpiry: Duration(hours: 1),
    maxEntries: 200,
    storageType: 'shared_preferences',
  );

  static const CacheConfig sessionData = CacheConfig(
    defaultExpiry: Duration(hours: 24),
    maxEntries: 100,
    storageType: 'shared_preferences',
  );
}

/// Cached item with metadata
class CacheItem<T> {
  final T data;
  final DateTime timestamp;
  final Duration? expiry;
  final String key;

  CacheItem({
    required this.data,
    required this.timestamp,
    this.expiry,
    required this.key,
  });

  bool get isExpired {
    if (expiry == null) return false;
    return DateTime.now().difference(timestamp) > expiry!;
  }

  Map<String, dynamic> toJson() => {
        'data': data,
        'timestamp': timestamp.toIso8601String(),
        'expiry': expiry?.inMilliseconds,
        'key': key,
      };

  factory CacheItem.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJson) => CacheItem<T>(
        data: fromJson(json['data']),
        timestamp: DateTime.parse(json['timestamp']),
        expiry: json['expiry'] != null ? Duration(milliseconds: json['expiry']) : null,
        key: json['key'],
      );
}

/// Comprehensive caching service supporting multiple storage backends
class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  SharedPreferences? _prefs;
  Database? _database;
  bool _initialized = false;

  /// Initialize the cache service
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();

    // Initialize SQLite database
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = path.join(directory.path, 'cache.db');

    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cache_items (
            key TEXT PRIMARY KEY,
            data TEXT NOT NULL,
            timestamp TEXT NOT NULL,
            expiry INTEGER,
            config TEXT NOT NULL
          )
        ''');
      },
    );

    _initialized = true;

    // Clean up expired items on startup
    await _cleanupExpiredItems();
  }

  /// Get data from cache
  Future<T?> get<T>(String key, {CacheConfig? config}) async {
    await _ensureInitialized();

    final cacheKey = _generateCacheKey(key, config);

    if (config?.storageType == 'sqflite' || config == null) {
      final result = await _database?.query(
        'cache_items',
        where: 'key = ?',
        whereArgs: [cacheKey],
        limit: 1,
      );

      if (result != null && result.isNotEmpty) {
        final item = result.first;
        final timestamp = DateTime.parse(item['timestamp'] as String);
        final expiryMs = item['expiry'] as int?;
        final expiry = expiryMs != null ? Duration(milliseconds: expiryMs) : null;

        if (!_isExpired(timestamp, expiry)) {
          final dataJson = jsonDecode(item['data'] as String);
          return dataJson as T;
        } else {
          // Remove expired item
          await _database?.delete('cache_items', where: 'key = ?', whereArgs: [cacheKey]);
        }
      }
    }

    // Fallback to SharedPreferences
    final prefsKey = 'cache_$cacheKey';
    final cachedJson = _prefs?.getString(prefsKey);
    if (cachedJson != null) {
      final cached = jsonDecode(cachedJson);
      final timestamp = DateTime.parse(cached['timestamp']);
      final expiryMs = cached['expiry'];
      final expiry = expiryMs != null ? Duration(milliseconds: expiryMs) : null;

      if (!_isExpired(timestamp, expiry)) {
        return cached['data'] as T;
      } else {
        // Remove expired item
        await _prefs?.remove(prefsKey);
      }
    }

    return null;
  }

  /// Set data in cache
  Future<void> set<T>(String key, T data, {CacheConfig? config}) async {
    await _ensureInitialized();

    final cacheConfig = config ?? CacheConfig.apiResponse;
    final cacheKey = _generateCacheKey(key, config);
    final timestamp = DateTime.now();
    final expiry = cacheConfig.defaultExpiry;

    final cacheItem = {
      'data': data,
      'timestamp': timestamp.toIso8601String(),
      'expiry': expiry.inMilliseconds,
      'key': cacheKey,
    };

    if (cacheConfig.storageType == 'sqflite') {
      await _database?.insert(
        'cache_items',
        {
          'key': cacheKey,
          'data': jsonEncode(data),
          'timestamp': timestamp.toIso8601String(),
          'expiry': expiry.inMilliseconds,
          'config': cacheConfig.storageType,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      // Use SharedPreferences
      final prefsKey = 'cache_$cacheKey';
      await _prefs?.setString(prefsKey, jsonEncode(cacheItem));
    }

    // Enforce max entries limit
    await _enforceMaxEntries(cacheConfig);
  }

  /// Remove data from cache
  Future<void> remove(String key, {CacheConfig? config}) async {
    await _ensureInitialized();

    final cacheKey = _generateCacheKey(key, config);

    if (config?.storageType == 'sqflite' || config == null) {
      await _database?.delete('cache_items', where: 'key = ?', whereArgs: [cacheKey]);
    }

    final prefsKey = 'cache_$cacheKey';
    await _prefs?.remove(prefsKey);
  }

  /// Clear all cache data
  Future<void> clear({CacheConfig? config}) async {
    await _ensureInitialized();

    if (config?.storageType == 'sqflite' || config == null) {
      await _database?.delete('cache_items');
    }

    // Clear SharedPreferences cache items
    final keys = _prefs?.getKeys().where((key) => key.startsWith('cache_')).toList() ?? [];
    for (final key in keys) {
      await _prefs?.remove(key);
    }
  }

  /// Check if key exists in cache and is not expired
  Future<bool> has(String key, {CacheConfig? config}) async {
    return await get(key, config: config) != null;
  }

  /// Get cache size information
  Future<Map<String, int>> getCacheStats() async {
    await _ensureInitialized();

    final sqfliteCount = Sqflite.firstIntValue(
      await _database?.rawQuery('SELECT COUNT(*) FROM cache_items') ?? [],
    ) ?? 0;

    final prefsKeys = _prefs?.getKeys().where((key) => key.startsWith('cache_')).length ?? 0;

    return {
      'sqflite_entries': sqfliteCount,
      'shared_preferences_entries': prefsKeys,
      'total_entries': sqfliteCount + prefsKeys,
    };
  }

  /// Invalidate cache by pattern
  Future<void> invalidateCache(String pattern) async {
    await _ensureInitialized();

    // SQLite invalidation
    await _database?.delete(
      'cache_items',
      where: 'key LIKE ?',
      whereArgs: ['%$pattern%'],
    );

    // SharedPreferences invalidation
    final keysToRemove = _prefs?.getKeys()
        .where((key) => key.startsWith('cache_') && key.contains(pattern))
        .toList() ?? [];

    for (final key in keysToRemove) {
      await _prefs?.remove(key);
    }
  }

  /// Clear expired cache entries manually
  Future<void> clearExpiredCache() async {
    await _cleanupExpiredItems();
  }

  /// Invalidate user-specific cache (useful on logout)
  Future<void> invalidateUserCache() async {
    final userId = 'current_user'; // TODO: Get from auth service
    await invalidateCache(userId);
  }

  /// Warm up cache with frequently accessed data
  Future<void> warmUpCache() async {
    // This could be extended to preload critical data
    // For now, just ensure expired items are cleaned up
    await clearExpiredCache();
  }

  /// Check if we're in offline mode (no network connectivity)
  Future<bool> isOffline() async {
    // This is a simplified check - in production you'd use connectivity_plus
    // For now, we'll assume online unless explicitly handling errors
    return false;
  }

  /// Get offline fallback data for critical features
  Future<Map<String, dynamic>> getOfflineFallbacks() async {
    final fallbacks = <String, dynamic>{};

    // Try to get cached data for critical features
    final closetData = await get<List>('closet_items', config: CacheConfig.userData);
    if (closetData != null) {
      fallbacks['closet_items'] = closetData;
    }

    final profileData = await get<Map<String, dynamic>>('user_profile', config: CacheConfig.userData);
    if (profileData != null) {
      fallbacks['user_profile'] = profileData;
    }

    final historyData = await get<List>('outfit_history', config: CacheConfig.sessionData);
    if (historyData != null) {
      fallbacks['outfit_history'] = historyData;
    }

    return fallbacks;
  }

  /// Handle network errors gracefully by falling back to cache
  Future<T?> handleNetworkError<T>(
    Future<T> Function() networkCall,
    String cacheKey, {
    CacheConfig? config,
    T? defaultValue,
  }) async {
    try {
      final result = await networkCall();
      // If successful, cache the result
      if (result != null) {
        await set(cacheKey, result, config: config);
      }
      return result;
    } catch (e) {
      // Network failed, try cache
      final cached = await get<T>(cacheKey, config: config);
      return cached ?? defaultValue;
    }
  }

  /// Get cache entry metadata
  Future<Map<String, dynamic>?> getCacheMetadata(String key, {CacheConfig? config}) async {
    await _ensureInitialized();

    final cacheKey = _generateCacheKey(key, config);

    // Check SQLite first
    final result = await _database?.query(
      'cache_items',
      where: 'key = ?',
      whereArgs: [cacheKey],
      limit: 1,
    );

    if (result != null && result.isNotEmpty) {
      final item = result.first;
      return {
        'key': item['key'],
        'timestamp': item['timestamp'],
        'expiry': item['expiry'],
        'size_bytes': (item['data'] as String).length * 2, // Rough estimate
        'storage_type': 'sqflite',
      };
    }

    // Check SharedPreferences
    final prefsKey = 'cache_$cacheKey';
    final data = _prefs?.getString(prefsKey);
    if (data != null) {
      final cached = jsonDecode(data);
      return {
        'key': cacheKey,
        'timestamp': cached['timestamp'],
        'expiry': cached['expiry'],
        'size_bytes': data.length * 2,
        'storage_type': 'shared_preferences',
      };
    }

    return null;
  }

  // Helper methods

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }

  String _generateCacheKey(String key, CacheConfig? config) {
    // Add user-specific prefix for multi-user support
    final userId = 'current_user'; // TODO: Get from auth service
    return '${userId}_$key';
  }

  bool _isExpired(DateTime timestamp, Duration? expiry) {
    if (expiry == null) return false;
    return DateTime.now().difference(timestamp) > expiry;
  }

  Future<void> _cleanupExpiredItems() async {
    await _ensureInitialized();

    final now = DateTime.now();

    // Clean SQLite
    await _database?.delete(
      'cache_items',
      where: 'expiry IS NOT NULL AND (julianday(?) - julianday(timestamp)) * 86400000 > expiry',
      whereArgs: [now.toIso8601String()],
    );

    // Clean SharedPreferences
    final keys = _prefs?.getKeys().where((key) => key.startsWith('cache_')).toList() ?? [];
    for (final key in keys) {
      final cachedJson = _prefs?.getString(key);
      if (cachedJson != null) {
        final cached = jsonDecode(cachedJson);
        final timestamp = DateTime.parse(cached['timestamp']);
        final expiryMs = cached['expiry'];
        if (expiryMs != null && _isExpired(timestamp, Duration(milliseconds: expiryMs))) {
          await _prefs?.remove(key);
        }
      }
    }
  }

  Future<void> _enforceMaxEntries(CacheConfig config) async {
    if (config.storageType == 'sqflite') {
      final count = Sqflite.firstIntValue(
        await _database?.rawQuery('SELECT COUNT(*) FROM cache_items WHERE config = ?', [config.storageType]) ?? [],
      ) ?? 0;

      if (count > config.maxEntries) {
        // Remove oldest entries
        final excess = count - config.maxEntries;
        await _database?.rawDelete('''
          DELETE FROM cache_items
          WHERE key IN (
            SELECT key FROM cache_items
            WHERE config = ?
            ORDER BY timestamp ASC
            LIMIT ?
          )
        ''', [config.storageType, excess]);
      }
    } else {
      // For SharedPreferences, we'd need to track entries differently
      // This is a simplified version - in production, you might want a separate index
    }
  }
}

/// Utility functions for common cache operations
class CacheUtils {
  static String generateWeatherKey(String cityName, double lat, double lon) {
    return 'weather_${cityName}_${lat.toStringAsFixed(2)}_${lon.toStringAsFixed(2)}';
  }

  static String generateUserDataKey(String userId, String dataType) {
    return 'user_${userId}_$dataType';
  }

  static String generateApiResponseKey(String endpoint, Map<String, dynamic>? params) {
    final paramStr = params != null ? '_${params.toString()}' : '';
    return 'api_$endpoint$paramStr';
  }

  static String generateImageAnalysisKey(String imagePath) {
    // Create a hash of the image path for uniqueness
    return 'ai_analysis_${imagePath.hashCode}';
  }
}
