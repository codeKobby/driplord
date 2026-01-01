import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/components/cards/glass_card.dart';
import '../../../core/components/common/fixed_app_bar.dart';
import '../../../core/theme/app_colors.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type; // 'outfit_suggestion', 'wardrobe_update', 'style_tip', etc.
  final DateTime timestamp;
  final bool isRead;
  final String? actionUrl; // Route to navigate to when tapped
  final Map<String, dynamic>? metadata;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.actionUrl,
    this.metadata,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  IconData get icon {
    switch (type) {
      case 'outfit_suggestion':
        return LucideIcons.shirt;
      case 'wardrobe_update':
        return LucideIcons.package;
      case 'style_tip':
        return LucideIcons.lightbulb;
      case 'weather_alert':
        return LucideIcons.cloudRain;
      default:
        return LucideIcons.bell;
    }
  }

  Color get iconColor {
    switch (type) {
      case 'outfit_suggestion':
        return AppColors.primary;
      case 'wardrobe_update':
        return AppColors.success;
      case 'style_tip':
        return AppColors.warning;
      case 'weather_alert':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Mock data - in real app, this would come from a provider
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Perfect outfit for your meeting',
      message: 'Based on your calendar, we suggest this professional look for your 2 PM meeting.',
      type: 'outfit_suggestion',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      actionUrl: '/try-on/outfit/123',
      metadata: {'outfitId': '123', 'occasion': 'meeting'},
    ),
    NotificationItem(
      id: '2',
      title: 'New items added to your closet',
      message: '5 new clothing items have been detected and added to your wardrobe.',
      type: 'wardrobe_update',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      actionUrl: '/closet/insights/recent',
      metadata: {'newItemsCount': 5},
    ),
    NotificationItem(
      id: '3',
      title: 'Style tip: Layering for fall',
      message: 'Learn how to combine light layers for the perfect autumn outfit.',
      type: 'style_tip',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      actionUrl: '/home/vibes',
      metadata: {'season': 'fall', 'tipType': 'layering'},
    ),
    NotificationItem(
      id: '4',
      title: 'Weather alert: Rain expected',
      message: 'Light rain expected this afternoon. Consider bringing an umbrella.',
      type: 'weather_alert',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      actionUrl: '/home/weather',
      metadata: {'weatherType': 'rain', 'severity': 'light'},
    ),
    NotificationItem(
      id: '5',
      title: 'Outfit worn 3 times this week',
      message: 'Your favorite blue shirt and jeans combo has been a hit!',
      type: 'wardrobe_update',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      actionUrl: '/outfits/456',
      metadata: {'outfitId': '456', 'wearCount': 3},
    ),
    NotificationItem(
      id: '6',
      title: 'Style tip: Color coordination',
      message: 'Master the art of mixing colors that complement your skin tone.',
      type: 'style_tip',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      metadata: {'tipType': 'color_coordination'},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: const FixedAppBar(title: 'Notifications'),
      body: SafeArea(
        child: _notifications.isEmpty
            ? _buildEmptyState()
            : _buildNotificationList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.bell,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No notifications yet',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll notify you about outfit suggestions\nand wardrobe updates',
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: _notifications.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: AppColors.glassBorder,
        indent: 16,
        endIndent: 16,
      ),
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          LucideIcons.trash2,
          color: AppColors.error,
          size: 24,
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          _notifications.removeWhere((n) => n.id == notification.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${notification.title} deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  // In a real app, you'd restore from a backup or undo stack
                  _notifications.insert(0, notification);
                });
              },
            ),
          ),
        );
      },
      child: InkWell(
        onTap: () {
          // Mark as read
          if (!notification.isRead) {
            setState(() {
              final index = _notifications.indexWhere((n) => n.id == notification.id);
              if (index != -1) {
                _notifications[index] = NotificationItem(
                  id: notification.id,
                  title: notification.title,
                  message: notification.message,
                  type: notification.type,
                  timestamp: notification.timestamp,
                  isRead: true,
                  actionUrl: notification.actionUrl,
                  metadata: notification.metadata,
                );
              }
            });
          }

          // Navigate to action URL if available
          if (notification.actionUrl != null) {
            if (notification.actionUrl!.contains('/outfits/') ||
                notification.actionUrl!.contains('/try-on/')) {
              context.go(notification.actionUrl!);
            } else if (notification.actionUrl!.contains('/closet/')) {
              context.go(notification.actionUrl!);
            } else if (notification.actionUrl!.contains('/home/')) {
              context.go(notification.actionUrl!);
            } else {
              // Navigate to notification detail
              context.go('/home/notifications/${notification.id}');
            }
          } else {
            // Navigate to notification detail
            context.go('/home/notifications/${notification.id}');
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: notification.iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  notification.icon,
                  color: notification.iconColor,
                  size: 20,
                ),
              ),

              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and time
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: notification.isRead
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          notification.timeAgo,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Message
                    Text(
                      notification.message,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: notification.isRead
                            ? AppColors.textSecondary.withValues(alpha: 0.7)
                            : AppColors.textPrimary.withValues(alpha: 0.9),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Action hint (if applicable)
                    if (notification.actionUrl != null)
                      Text(
                        'Tap to view',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: notification.iconColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),

              // Unread indicator
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: notification.iconColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
