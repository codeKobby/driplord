import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

/// Model for a calendar event
class CalendarEvent {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final bool isAllDay;
  final String? colorId;

  CalendarEvent({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    this.isAllDay = false,
    this.colorId,
  });

  /// Create from Google Calendar Event
  factory CalendarEvent.fromGoogleEvent(calendar.Event event) {
    final start = event.start;
    final end = event.end;

    // Check if it's an all-day event (has date but no dateTime)
    final isAllDay = start?.date != null && start?.dateTime == null;

    DateTime startTime;
    DateTime endTime;

    if (isAllDay) {
      startTime = start?.date ?? DateTime.now();
      endTime = end?.date ?? DateTime.now();
    } else {
      startTime = start?.dateTime ?? DateTime.now();
      endTime = end?.dateTime ?? DateTime.now();
    }

    return CalendarEvent(
      id: event.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: event.summary ?? 'Untitled Event',
      description: event.description,
      startTime: startTime,
      endTime: endTime,
      location: event.location,
      isAllDay: isAllDay,
      colorId: event.colorId,
    );
  }

  /// Get formatted time string
  String get formattedTime {
    if (isAllDay) return 'All day';

    final startHour = startTime.hour;
    final startMinute = startTime.minute.toString().padLeft(2, '0');
    final startPeriod = startHour >= 12 ? 'PM' : 'AM';
    final displayHour = startHour > 12
        ? startHour - 12
        : (startHour == 0 ? 12 : startHour);

    return '$displayHour:$startMinute $startPeriod';
  }

  /// Get duration string
  String get durationString {
    final duration = endTime.difference(startTime);
    if (duration.inHours >= 24) {
      return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h';
    } else {
      return '${duration.inMinutes}m';
    }
  }
}

/// State for calendar integration
class GoogleCalendarState {
  final bool isConnected;
  final bool isLoading;
  final String? error;
  final Map<DateTime, List<CalendarEvent>> eventsByDate;

  const GoogleCalendarState({
    this.isConnected = false,
    this.isLoading = false,
    this.error,
    this.eventsByDate = const {},
  });

  GoogleCalendarState copyWith({
    bool? isConnected,
    bool? isLoading,
    String? error,
    Map<DateTime, List<CalendarEvent>>? eventsByDate,
  }) {
    return GoogleCalendarState(
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      eventsByDate: eventsByDate ?? this.eventsByDate,
    );
  }

  /// Get events for a specific date
  List<CalendarEvent> eventsForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return eventsByDate[normalizedDate] ?? [];
  }
}

/// Notifier for Google Calendar integration
class GoogleCalendarNotifier extends Notifier<GoogleCalendarState> {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [calendar.CalendarApi.calendarReadonlyScope],
  );

  calendar.CalendarApi? _calendarApi;

  @override
  GoogleCalendarState build() {
    // Check if already signed in
    _checkExistingAuth();
    return const GoogleCalendarState();
  }

  Future<void> _checkExistingAuth() async {
    try {
      final account = await _googleSignIn.signInSilently();
      if (account != null) {
        await _initializeCalendarApi();
        state = state.copyWith(isConnected: true);
        await fetchEvents();
      }
    } catch (e) {
      // Silent sign-in failed, user needs to explicitly connect
    }
  }

  /// Connect to Google Calendar
  Future<bool> connect() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        state = state.copyWith(isLoading: false, error: 'Sign in cancelled');
        return false;
      }

      await _initializeCalendarApi();
      state = state.copyWith(isConnected: true, isLoading: false);

      // Fetch events after connecting
      await fetchEvents();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to connect: ${e.toString()}',
      );
      return false;
    }
  }

  Future<void> _initializeCalendarApi() async {
    final httpClient = await _googleSignIn.authenticatedClient();
    if (httpClient != null) {
      _calendarApi = calendar.CalendarApi(httpClient);
    }
  }

  /// Disconnect from Google Calendar
  Future<void> disconnect() async {
    await _googleSignIn.signOut();
    _calendarApi = null;
    state = const GoogleCalendarState();
  }

  /// Fetch events for the current month
  Future<void> fetchEvents({DateTime? focusMonth}) async {
    if (_calendarApi == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final now = focusMonth ?? DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      final events = await _calendarApi!.events.list(
        'primary',
        timeMin: startOfMonth.toUtc(),
        timeMax: endOfMonth.toUtc(),
        singleEvents: true,
        orderBy: 'startTime',
      );

      final Map<DateTime, List<CalendarEvent>> eventsByDate = {};

      for (final event in events.items ?? []) {
        final calEvent = CalendarEvent.fromGoogleEvent(event);
        final dateKey = DateTime(
          calEvent.startTime.year,
          calEvent.startTime.month,
          calEvent.startTime.day,
        );

        if (!eventsByDate.containsKey(dateKey)) {
          eventsByDate[dateKey] = [];
        }
        eventsByDate[dateKey]!.add(calEvent);
      }

      state = state.copyWith(
        isLoading: false,
        eventsByDate: {...state.eventsByDate, ...eventsByDate},
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch events: ${e.toString()}',
      );
    }
  }

  /// Fetch events for a specific date range (for trip planning)
  Future<List<CalendarEvent>> fetchEventsForRange(
    DateTime start,
    DateTime end,
  ) async {
    if (_calendarApi == null) return [];

    try {
      final events = await _calendarApi!.events.list(
        'primary',
        timeMin: start.toUtc(),
        timeMax: end.toUtc(),
        singleEvents: true,
        orderBy: 'startTime',
      );

      return (events.items ?? [])
          .map((e) => CalendarEvent.fromGoogleEvent(e))
          .toList();
    } catch (e) {
      return [];
    }
  }
}

/// Provider for Google Calendar
final googleCalendarProvider =
    NotifierProvider<GoogleCalendarNotifier, GoogleCalendarState>(() {
      return GoogleCalendarNotifier();
    });

/// Provider for events on a specific date
final eventsForDateProvider = Provider.family<List<CalendarEvent>, DateTime>((
  ref,
  date,
) {
  final calendarState = ref.watch(googleCalendarProvider);
  return calendarState.eventsForDate(date);
});

/// Provider to check if calendar is connected
final isCalendarConnectedProvider = Provider<bool>((ref) {
  return ref.watch(googleCalendarProvider).isConnected;
});

// =============================================================================
// MOCK DATA FOR DEVELOPMENT (Used when not connected to Google Calendar)
// =============================================================================

/// Mock events provider for development/demo
final mockEventsProvider = Provider.family<List<CalendarEvent>, DateTime>((
  ref,
  date,
) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dateKey = DateTime(date.year, date.month, date.day);

  // Mock events for demo
  final mockEvents = <DateTime, List<CalendarEvent>>{
    today: [
      CalendarEvent(
        id: 'mock_1',
        title: 'Team Standup',
        description: 'Daily sync with the team',
        startTime: DateTime(now.year, now.month, now.day, 9, 0),
        endTime: DateTime(now.year, now.month, now.day, 9, 30),
        location: 'Zoom',
      ),
      CalendarEvent(
        id: 'mock_2',
        title: 'Client Presentation',
        description: 'Q1 Results presentation',
        startTime: DateTime(now.year, now.month, now.day, 14, 0),
        endTime: DateTime(now.year, now.month, now.day, 15, 30),
        location: 'Conference Room A',
      ),
    ],
    today.add(const Duration(days: 1)): [
      CalendarEvent(
        id: 'mock_3',
        title: 'Lunch with Sarah',
        startTime: DateTime(now.year, now.month, now.day + 1, 12, 30),
        endTime: DateTime(now.year, now.month, now.day + 1, 14, 0),
        location: 'The Grill House',
      ),
    ],
    today.add(const Duration(days: 2)): [
      CalendarEvent(
        id: 'mock_4',
        title: 'Wedding Rehearsal',
        description: 'Dress code: Semi-formal',
        startTime: DateTime(now.year, now.month, now.day + 2, 17, 0),
        endTime: DateTime(now.year, now.month, now.day + 2, 20, 0),
        location: 'St. Mary\'s Church',
      ),
    ],
    today.add(const Duration(days: 3)): [
      CalendarEvent(
        id: 'mock_5',
        title: 'Wedding',
        description: 'Dress code: Formal/Black Tie',
        startTime: DateTime(now.year, now.month, now.day + 3, 15, 0),
        endTime: DateTime(now.year, now.month, now.day + 3, 23, 0),
        location: 'Grand Ballroom',
        isAllDay: false,
      ),
    ],
    today.add(const Duration(days: 5)): [
      CalendarEvent(
        id: 'mock_6',
        title: 'Gym Session',
        startTime: DateTime(now.year, now.month, now.day + 5, 7, 0),
        endTime: DateTime(now.year, now.month, now.day + 5, 8, 30),
        location: 'FitLife Gym',
      ),
      CalendarEvent(
        id: 'mock_7',
        title: 'Date Night',
        startTime: DateTime(now.year, now.month, now.day + 5, 19, 0),
        endTime: DateTime(now.year, now.month, now.day + 5, 22, 0),
        location: 'Italian Restaurant',
      ),
    ],
  };

  return mockEvents[dateKey] ?? [];
});

/// Combined provider that uses real data when connected, mock data otherwise
final calendarEventsProvider = Provider.family<List<CalendarEvent>, DateTime>((
  ref,
  date,
) {
  final isConnected = ref.watch(isCalendarConnectedProvider);

  if (isConnected) {
    return ref.watch(eventsForDateProvider(date));
  } else {
    return ref.watch(mockEventsProvider(date));
  }
});
