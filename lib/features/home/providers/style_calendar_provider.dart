import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scheduled_outfit.dart';
import 'recommendation_provider.dart';
import 'saved_outfits_provider.dart';

/// Notifier for managing scheduled outfits (calendar planning)
class StyleCalendarNotifier extends Notifier<List<ScheduledOutfit>> {
  @override
  List<ScheduledOutfit> build() {
    // Initialize with mock data for demo purposes
    return _generateMockScheduledOutfits();
  }

  /// Schedule a new outfit for a specific date
  void scheduleOutfit({
    required DateTime date,
    required Recommendation outfit,
    String? notes,
  }) {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Remove any existing outfit for this date
    final filtered = state.where((s) => !s.isOnDate(normalizedDate)).toList();

    // Add the new scheduled outfit
    final scheduledOutfit = ScheduledOutfit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scheduledDate: normalizedDate,
      outfitId: outfit.id,
      outfitTitle: outfit.title,
      outfitImageUrl: outfit.imageUrl,
      personalImageUrl: outfit.personalImageUrl,
      tags: outfit.tags,
      notes: notes,
    );

    state = [...filtered, scheduledOutfit];
  }

  /// Remove a scheduled outfit
  void removeScheduledOutfit(String id) {
    state = state.where((s) => s.id != id).toList();
  }

  /// Remove outfit for a specific date
  void removeOutfitForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    state = state.where((s) => !s.isOnDate(normalizedDate)).toList();
  }

  /// Update notes for a scheduled outfit
  void updateNotes(String id, String? notes) {
    state = state.map((s) {
      if (s.id == id) {
        return s.copyWith(notes: notes);
      }
      return s;
    }).toList();
  }

  /// Get outfit for a specific date
  ScheduledOutfit? getOutfitForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    try {
      return state.firstWhere((s) => s.isOnDate(normalizedDate));
    } catch (_) {
      return null;
    }
  }

  /// Get all outfits for a specific month
  List<ScheduledOutfit> getOutfitsForMonth(DateTime month) {
    return state
        .where(
          (s) =>
              s.scheduledDate.year == month.year &&
              s.scheduledDate.month == month.month,
        )
        .toList();
  }

  /// Generate mock data for demo purposes
  List<ScheduledOutfit> _generateMockScheduledOutfits() {
    final now = DateTime.now();
    return [
      ScheduledOutfit(
        id: 'mock_1',
        scheduledDate: DateTime(now.year, now.month, now.day),
        outfitId: 'chill_1',
        outfitTitle: 'Sunday Minimalist',
        outfitImageUrl:
            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800',
        personalImageUrl:
            'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=400',
        tags: ['Cotton', 'Loose', 'Neutral'],
        notes: 'Perfect for today\'s weather',
      ),
      ScheduledOutfit(
        id: 'mock_2',
        scheduledDate: now.add(const Duration(days: 2)),
        outfitId: 'work_1',
        outfitTitle: 'Metropolitan Professional',
        outfitImageUrl:
            'https://images.unsplash.com/photo-1481325544415-bc49418e662c?w=800',
        personalImageUrl:
            'https://images.unsplash.com/photo-1481325544415-bc49418e662c?w=400',
        tags: ['Tailored', 'Blazer', 'Monochrome'],
        notes: 'Meeting day',
      ),
      ScheduledOutfit(
        id: 'mock_3',
        scheduledDate: now.add(const Duration(days: 5)),
        outfitId: 'hype_1',
        outfitTitle: 'Street Culture Icon',
        outfitImageUrl:
            'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?w=800',
        personalImageUrl:
            'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?w=400',
        tags: ['Sneakers', 'Denim', 'Statement'],
        notes: 'Weekend hangout',
      ),
      ScheduledOutfit(
        id: 'mock_4',
        scheduledDate: now.subtract(const Duration(days: 1)),
        outfitId: 'bold_1',
        outfitTitle: 'Neon City Nights',
        outfitImageUrl:
            'https://images.unsplash.com/photo-1529139572894-3d2d93b3204b?w=800',
        personalImageUrl:
            'https://images.unsplash.com/photo-1520975661595-6453be3f7070?w=400',
        tags: ['Graphic', 'Oversized', 'Vibrant'],
      ),
    ];
  }
}

/// Provider for scheduled outfits
final styleCalendarProvider =
    NotifierProvider<StyleCalendarNotifier, List<ScheduledOutfit>>(() {
      return StyleCalendarNotifier();
    });

/// Provider for today's scheduled outfit
final todaysOutfitProvider = Provider<ScheduledOutfit?>((ref) {
  final scheduledOutfits = ref.watch(styleCalendarProvider);
  final today = DateTime.now();
  final normalizedToday = DateTime(today.year, today.month, today.day);

  try {
    return scheduledOutfits.firstWhere((s) => s.isOnDate(normalizedToday));
  } catch (_) {
    return null;
  }
});

/// Provider for outfits in a specific month (family provider)
final outfitsForMonthProvider =
    Provider.family<List<ScheduledOutfit>, DateTime>((ref, month) {
      final scheduledOutfits = ref.watch(styleCalendarProvider);
      return scheduledOutfits
          .where(
            (s) =>
                s.scheduledDate.year == month.year &&
                s.scheduledDate.month == month.month,
          )
          .toList();
    });

/// Provider for checking if a date has a scheduled outfit
final hasOutfitForDateProvider = Provider.family<bool, DateTime>((ref, date) {
  final scheduledOutfits = ref.watch(styleCalendarProvider);
  final normalizedDate = DateTime(date.year, date.month, date.day);
  return scheduledOutfits.any((s) => s.isOnDate(normalizedDate));
});

/// Provider for getting outfit for a specific date
final outfitForDateProvider = Provider.family<ScheduledOutfit?, DateTime>((
  ref,
  date,
) {
  final scheduledOutfits = ref.watch(styleCalendarProvider);
  final normalizedDate = DateTime(date.year, date.month, date.day);
  try {
    return scheduledOutfits.firstWhere((s) => s.isOnDate(normalizedDate));
  } catch (_) {
    return null;
  }
});

/// Combined provider for outfit picker (recommendations + saved outfits)
final outfitPickerProvider = Provider<List<Recommendation>>((ref) {
  final recommendations = ref.watch(recommendationProvider);
  final savedOutfits = ref.watch(savedOutfitsProvider);

  // Combine both, avoiding duplicates by id
  final Set<String> addedIds = {};
  final List<Recommendation> combined = [];

  for (final outfit in savedOutfits) {
    if (!addedIds.contains(outfit.id)) {
      combined.add(outfit);
      addedIds.add(outfit.id);
    }
  }

  for (final outfit in recommendations) {
    if (!addedIds.contains(outfit.id)) {
      combined.add(outfit);
      addedIds.add(outfit.id);
    }
  }

  return combined;
});
