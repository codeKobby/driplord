import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import '../../../core/services/cache_service.dart';

class WeatherData {
  final String cityName;
  final double temperature;
  final String condition;
  final String iconCode;
  final double humidity;
  final double windSpeed;
  final int conditionCode;

  const WeatherData({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.conditionCode,
  });

  String get temperatureString => '${temperature.round()}°C';

  String get weatherDescription {
    if (conditionCode >= 200 && conditionCode < 300) return 'Thunderstorm';
    if (conditionCode >= 300 && conditionCode < 400) return 'Drizzle';
    if (conditionCode >= 500 && conditionCode < 600) return 'Rain';
    if (conditionCode >= 600 && conditionCode < 700) return 'Snow';
    if (conditionCode >= 700 && conditionCode < 800) return 'Atmosphere';
    if (conditionCode == 800) return 'Clear sky';
    if (conditionCode > 800) return 'Clouds';
    return condition;
  }

  String get clothingSuggestion {
    if (temperature < 10) return 'Layer up with warm clothing';
    if (temperature < 15) return 'Consider a light jacket';
    if (temperature < 20) return 'Comfortable for light layers';
    if (temperature < 25) return 'Perfect for casual wear';
    return 'Great weather for any outfit';
  }

  bool get isCold => temperature < 15;
  bool get isWarm => temperature > 20;
  bool get isRainy => conditionCode >= 500 && conditionCode < 600;
  bool get isSunny => conditionCode == 800;
}

class WeatherService {
  static const String _apiKey =
      'YOUR_OPENWEATHERMAP_API_KEY'; // Replace with actual API key
  final WeatherFactory _weatherFactory = WeatherFactory(_apiKey);
  final CacheService _cacheService = CacheService();

  Future<WeatherData?> getCurrentWeather({bool forceRefresh = false}) async {
    try {
      // Try to get current location for cache key
      Position? position;
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission != LocationPermission.deniedForever) {
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
            ),
          );
        }
      } catch (e) {
        // Location not available, use general cache key
      }

      // Generate cache key based on location
      final cacheKey = position != null
          ? CacheUtils.generateWeatherKey('current_location', position.latitude, position.longitude)
          : 'weather_general';

      // Check cache first (unless force refresh)
      if (!forceRefresh) {
        final cachedWeather = await _cacheService.get<Map<String, dynamic>>(cacheKey, config: CacheConfig.apiResponse);
        if (cachedWeather != null) {
          return WeatherData(
            cityName: cachedWeather['cityName'],
            temperature: cachedWeather['temperature'],
            condition: cachedWeather['condition'],
            iconCode: cachedWeather['iconCode'],
            humidity: cachedWeather['humidity'],
            windSpeed: cachedWeather['windSpeed'],
            conditionCode: cachedWeather['conditionCode'],
          );
        }
      }

      // Check location permission again if needed
      if (position == null) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            return _getMockWeather();
          }
        }

        if (permission == LocationPermission.deniedForever) {
          return _getMockWeather();
        }

        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
          ),
        );
      }

      // Get weather data from API
      Weather weather = await _weatherFactory.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      final weatherData = WeatherData(
        cityName: weather.areaName ?? 'Unknown',
        temperature: weather.temperature?.celsius ?? 20.0,
        condition: weather.weatherDescription ?? 'Unknown',
        iconCode: weather.weatherIcon ?? '01d',
        humidity: weather.humidity ?? 50.0,
        windSpeed: weather.windSpeed ?? 5.0,
        conditionCode: weather.weatherConditionCode ?? 800,
      );

      // Cache the result
      final weatherJson = {
        'cityName': weatherData.cityName,
        'temperature': weatherData.temperature,
        'condition': weatherData.condition,
        'iconCode': weatherData.iconCode,
        'humidity': weatherData.humidity,
        'windSpeed': weatherData.windSpeed,
        'conditionCode': weatherData.conditionCode,
      };
      await _cacheService.set(cacheKey, weatherJson, config: CacheConfig.apiResponse);

      return weatherData;
    } catch (e) {
      // Try to return cached data even if API fails
      try {
        final cachedWeather = await _cacheService.get<Map<String, dynamic>>('weather_general', config: CacheConfig.apiResponse);
        if (cachedWeather != null) {
          return WeatherData(
            cityName: cachedWeather['cityName'],
            temperature: cachedWeather['temperature'],
            condition: cachedWeather['condition'],
            iconCode: cachedWeather['iconCode'],
            humidity: cachedWeather['humidity'],
            windSpeed: cachedWeather['windSpeed'],
            conditionCode: cachedWeather['conditionCode'],
          );
        }
      } catch (cacheError) {
        // Cache also failed
      }

      // Return mock data as last resort
      return _getMockWeather();
    }
  }

  WeatherData _getMockWeather() {
    return const WeatherData(
      cityName: 'Demo City',
      temperature: 22.0,
      condition: 'Clear sky',
      iconCode: '01d',
      humidity: 65.0,
      windSpeed: 3.5,
      conditionCode: 800,
    );
  }
}

class WeatherNotifier extends Notifier<AsyncValue<WeatherData?>> {
  final WeatherService _weatherService = WeatherService();

  @override
  AsyncValue<WeatherData?> build() {
    _loadWeather();
    return const AsyncValue.loading();
  }

  Future<void> _loadWeather({bool forceRefresh = false}) async {
    try {
      final weather = await _weatherService.getCurrentWeather(forceRefresh: forceRefresh);
      state = AsyncValue.data(weather);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshWeather() async {
    state = const AsyncValue.loading();
    await _loadWeather(forceRefresh: true);
  }
}

final weatherProvider =
    NotifierProvider<WeatherNotifier, AsyncValue<WeatherData?>>(
      () => WeatherNotifier(),
    );
