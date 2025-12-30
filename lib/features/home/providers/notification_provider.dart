import 'package:flutter_riverpod/flutter_riverpod.dart';

class DripNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  DripNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });
}

class NotificationNotifier extends Notifier<List<DripNotification>> {
  @override
  List<DripNotification> build() {
    return _mockNotifications;
  }

  static final List<DripNotification> _mockNotifications = [
    DripNotification(
      id: "1",
      title: "New Recommendation",
      message: "Check out today's 'Chill' look based on the sunny weather.",
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    DripNotification(
      id: "2",
      title: "Closet Insight",
      message:
          "You haven't worn your 'Leather Jacket' in a month. Try it today?",
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  void markAsRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id)
          DripNotification(
            id: n.id,
            title: n.title,
            message: n.message,
            timestamp: n.timestamp,
            isRead: true,
          )
        else
          n,
    ];
  }
}

final notificationProvider =
    NotifierProvider<NotificationNotifier, List<DripNotification>>(() {
      return NotificationNotifier();
    });
