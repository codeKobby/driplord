
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'cache_service.dart';

/// Represents a detected clothing item from AI analysis
class DetectedClothingItem {
  final String id;
  final String name;
  final String category;
  final String color;
  final String? brand;
  final String? description;
  final Map<String, dynamic>? boundingBox; // For future segmentation
  final double confidence;

  DetectedClothingItem({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    this.brand,
    this.description,
    this.boundingBox,
    required this.confidence,
  });

  factory DetectedClothingItem.fromJson(Map<String, dynamic> json) {
    return DetectedClothingItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      color: json['color'] ?? '',
      brand: json['brand'],
      description: json['description'],
      boundingBox: json['boundingBox'],
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'color': color,
      'brand': brand,
      'description': description,
      'boundingBox': boundingBox,
      'confidence': confidence,
    };
  }
}

/// Result of AI image analysis
class ImageAnalysisResult {
  final List<DetectedClothingItem> items;
  final String? error;
  final bool success;

  ImageAnalysisResult({
    required this.items,
    this.error,
    this.success = true,
  });

  factory ImageAnalysisResult.success(List<DetectedClothingItem> items) {
    return ImageAnalysisResult(items: items, success: true);
  }

  factory ImageAnalysisResult.error(String error) {
    return ImageAnalysisResult(items: [], error: error, success: false);
  }
}

/// Service for AI-powered clothing detection and analysis
class AiImageService {
  static final AiImageService _instance = AiImageService._internal();
  factory AiImageService() => _instance;

  AiImageService._internal();

  GenerativeModel? _model;
  final CacheService _cacheService = CacheService();

  /// Initialize the AI model (call this in main.dart or app initialization)
  void initialize(String apiKey) {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  /// Analyze an image file for clothing items
  Future<ImageAnalysisResult> analyzeImageFile(XFile imageFile, {bool forceRefresh = false}) async {
    if (_model == null) {
      return ImageAnalysisResult.error('AI service not initialized');
    }

    try {
      // Generate cache key based on image path/hash
      final cacheKey = CacheUtils.generateImageAnalysisKey(imageFile.path);

      // Check cache first (unless force refresh)
      if (!forceRefresh) {
        final cachedResult = await _cacheService.get<Map<String, dynamic>>(cacheKey, config: CacheConfig.apiResponse);
        if (cachedResult != null) {
          final items = (cachedResult['items'] as List<dynamic>?)
              ?.map((item) => DetectedClothingItem.fromJson(item as Map<String, dynamic>))
              .toList() ?? [];
          return ImageAnalysisResult.success(items);
        }
      }

      // Read image bytes
      final bytes = await imageFile.readAsBytes();

      // Create image part for Gemini
      final imagePart = DataPart('image/jpeg', bytes);

      // Create detailed prompt for clothing analysis
      final prompt = '''
Analyze this image and identify all clothing items and accessories visible.

For each item, provide:
- name: A descriptive name (e.g., "Blue Cotton T-Shirt")
- category: Choose from [tops, bottoms, shoes, outerwear, accessories, hats, bags, jewelry]
- color: Primary color(s) of the item
- brand: If visible or recognizable, otherwise omit
- description: Brief description of style, material, or notable features
- confidence: Your confidence level (0.0 to 1.0)

Return ONLY a valid JSON array of objects with these fields. If no clothing items are detected, return an empty array.

Example format:
[
  {
    "name": "White Cotton T-Shirt",
    "category": "tops",
    "color": "white",
    "brand": "Nike",
    "description": "Plain white crew neck t-shirt",
    "confidence": 0.95
  }
]
''';

      // Generate content
      final response = await _model!.generateContent([
        Content.multi([
          TextPart(prompt),
          imagePart,
        ])
      ]);

      final responseText = response.text?.trim() ?? '';

      if (responseText.isEmpty) {
        return ImageAnalysisResult.error('No response from AI service');
      }

      // Parse JSON response
      final List<dynamic> itemsJson = jsonDecode(responseText);

      final items = itemsJson
          .map((item) => DetectedClothingItem.fromJson({
                ...item as Map<String, dynamic>,
                'id': '${DateTime.now().millisecondsSinceEpoch}_${itemsJson.indexOf(item)}',
              }))
          .where((item) => item.confidence > 0.5) // Filter low confidence items
          .toList();

      final result = ImageAnalysisResult.success(items);

      // Cache the successful result
      if (result.success) {
        final cacheData = {
          'items': items.map((item) => item.toJson()).toList(),
          'timestamp': DateTime.now().toIso8601String(),
        };
        await _cacheService.set(cacheKey, cacheData, config: CacheConfig.apiResponse);
      }

      return result;

    } catch (e) {
      debugPrint('AI Image Analysis Error: $e');
      return ImageAnalysisResult.error('Failed to analyze image: $e');
    }
  }

  /// Analyze an image from URL
  Future<ImageAnalysisResult> analyzeImageUrl(String imageUrl) async {
    if (_model == null) {
      return ImageAnalysisResult.error('AI service not initialized');
    }

    try {
      // For URLs, we'll need to fetch the image first
      // This is a simplified version - in production you'd want proper image fetching
      final prompt = '''
Analyze the clothing image at this URL: $imageUrl

For each clothing item visible, provide:
- name: A descriptive name
- category: Choose from [tops, bottoms, shoes, outerwear, accessories, hats, bags, jewelry]
- color: Primary color(s)
- brand: If recognizable
- description: Brief style/material description
- confidence: Your confidence level (0.0 to 1.0)

Return ONLY a valid JSON array. If no clothing detected, return empty array.

Format:
[
  {
    "name": "Item Name",
    "category": "tops",
    "color": "blue",
    "description": "Description",
    "confidence": 0.9
  }
]
''';

      final response = await _model!.generateContent([
        Content.text(prompt)
      ]);

      final responseText = response.text?.trim() ?? '';

      if (responseText.isEmpty) {
        return ImageAnalysisResult.error('No response from AI service');
      }

      final List<dynamic> itemsJson = jsonDecode(responseText);

      final items = itemsJson
          .map((item) => DetectedClothingItem.fromJson({
                ...item as Map<String, dynamic>,
                'id': '${DateTime.now().millisecondsSinceEpoch}_${itemsJson.indexOf(item)}',
              }))
          .where((item) => item.confidence > 0.5)
          .toList();

      return ImageAnalysisResult.success(items);

    } catch (e) {
      debugPrint('AI URL Analysis Error: $e');
      return ImageAnalysisResult.error('Failed to analyze image URL: $e');
    }
  }

  /// Validate if AI service is properly initialized
  bool get isInitialized => _model != null;
}
