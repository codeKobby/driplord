import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

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

  Future<WeatherData?> getCurrentWeather() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null; // User denied permission
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null; // User denied forever
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      // Get weather data
      Weather weather = await _weatherFactory.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      return WeatherData(
        cityName: weather.areaName ?? 'Unknown',
        temperature: weather.temperature?.celsius ?? 20.0,
        condition: weather.weatherDescription ?? 'Unknown',
        iconCode: weather.weatherIcon ?? '01d',
        humidity: weather.humidity ?? 50.0,
        windSpeed: weather.windSpeed ?? 5.0,
        conditionCode: weather.weatherConditionCode ?? 800,
      );
    } catch (e) {
      // Return mock data for demo purposes
      return WeatherData(
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
}

class WeatherNotifier extends Notifier<AsyncValue<WeatherData?>> {
  final WeatherService _weatherService = WeatherService();

  @override
  AsyncValue<WeatherData?> build() {
    _loadWeather();
    return const AsyncValue.loading();
  }

  Future<void> _loadWeather() async {
    try {
      final weather = await _weatherService.getCurrentWeather();
      state = AsyncValue.data(weather);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshWeather() async {
    state = const AsyncValue.loading();
    await _loadWeather();
  }
}

final weatherProvider =
    NotifierProvider<WeatherNotifier, AsyncValue<WeatherData?>>(
      () => WeatherNotifier(),
    );
