import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/components/cards/glass_card.dart';
import '../../../core/components/buttons/primary_button.dart';
import '../../../core/components/buttons/secondary_button.dart';
import '../../../core/components/common/fixed_app_bar.dart';
import '../../../core/theme/app_colors.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key, required this.id});

  final String id;

  // Mock data - in real app, this would come from a provider
  NotificationItem? get _notification {
    final notifications = [
      NotificationItem(
        id: '1',
        title: 'Perfect outfit for your meeting',
        message: 'Based on your calendar, we suggest this professional look for your 2 PM meeting. The navy blazer and gray trousers combination provides a polished, confident appearance that\'s perfect for client presentations.',
        type: 'outfit_suggestion',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        actionUrl: '/try-on/outfit/123',
        metadata: {
          'outfitId': '123',
          'occasion': 'meeting',
          'confidence': 0.95,
          'reasoning': 'Professional setting detected in calendar'
        },
      ),
      NotificationItem(
        id: '2',
        title: 'New items added to your closet',
        message: '5 new clothing items have been detected and added to your wardrobe. We found 3 shirts, 1 pair of jeans, and 1 jacket that complement your existing style perfectly.',
        type: 'wardrobe_update',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        actionUrl: '/closet/insights/recent',
        metadata: {
          'newItemsCount': 5,
          'categories': ['tops', 'bottoms', 'outerwear'],
          'source': 'gallery_scan'
        },
      ),
      NotificationItem(
        id: '3',
        title: 'Style tip: Layering for fall',
        message: 'Master the art of layering this fall season. Combine lightweight knits under structured blazers for a sophisticated look that transitions from office to evening effortlessly.',
        type: 'style_tip',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        actionUrl: '/home/vibes',
        metadata: {
          'season': 'fall',
          'tipType': 'layering',
          'difficulty': 'intermediate',
          'tags': ['professional', 'versatile', 'seasonal']
        },
      ),
      NotificationItem(
        id: '4',
        title: 'Weather alert: Rain expected',
        message: 'Light rain expected this afternoon (60% chance, 2-5mm). Consider water-resistant options or bring an umbrella. We recommend your trench coat or waterproof jacket for outdoor activities.',
        type: 'weather_alert',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        actionUrl: '/home/weather',
        metadata: {
          'weatherType': 'rain',
          'severity': 'light',
          'probability': 60,
          'amount': '2-5mm',
          'recommendedItems': ['trench_coat', 'waterproof_jacket']
        },
      ),
    ];

    return notifications.firstWhere(
      (n) => n.id == id,
      orElse: () => notifications.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final notification = _notification;
    if (notification == null) {
      return Scaffold(
        appBar: const FixedAppBar(title: 'Notification'),
        body: const Center(
          child: Text('Notification not found'),
        ),
      );
    }

    return Scaffold(
      appBar: const FixedAppBar(title: 'Notification Details'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and type
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: notification.iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      notification.icon,
                      color: notification.iconColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTypeLabel(notification.type),
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: notification.iconColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ).copyWith(
                            color: notification.iconColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.timeAgo,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                notification.title,
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 16),

              // Message
              Text(
                notification.message,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: AppColors.textPrimary.withValues(alpha: 0.9),
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 32),

              // Metadata section
              if (notification.metadata != null && notification.metadata!.isNotEmpty)
                _buildMetadataSection(notification),

              const SizedBox(height: 32),

              // Action buttons
              _buildActionButtons(context, notification),
            ],
          ),
        ),
      ),
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'outfit_suggestion':
        return 'OUTFIT SUGGESTION';
      case 'wardrobe_update':
        return 'WARDROBE UPDATE';
      case 'style_tip':
        return 'STYLE TIP';
      case 'weather_alert':
        return 'WEATHER ALERT';
      default:
        return 'NOTIFICATION';
    }
  }

  Widget _buildMetadataSection(NotificationItem notification) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.info,
                size: 20,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Details',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...notification.metadata!.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      _formatKey(entry.key),
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _formatValue(entry.value),
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatKey(String key) {
    return key.split('_').map((word) =>
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : word
    ).join(' ');
  }

  String _formatValue(dynamic value) {
    if (value is List) {
      return value.join(', ');
    } else if (value is double && value > 0 && value < 1) {
      return '${(value * 100).round()}%';
    } else {
      return value.toString();
    }
  }

  Widget _buildActionButtons(BuildContext context, NotificationItem notification) {
    final actions = <Widget>[];

    // Primary action based on notification type
    if (notification.actionUrl != null) {
      actions.add(
        PrimaryButton(
          text: _getPrimaryActionText(notification.type),
          onPressed: () => _handlePrimaryAction(context, notification),
          icon: _getPrimaryActionIcon(notification.type),
        ),
      );
    }

    // Secondary actions
    actions.add(
      SecondaryButton(
        text: 'Mark as Read',
        onPressed: () {
          // In real app, update notification status
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification marked as read')),
          );
        },
        icon: LucideIcons.check,
      ),
    );

    actions.add(
      SecondaryButton(
        text: 'Delete',
        onPressed: () {
          // In real app, delete notification
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification deleted')),
          );
          context.pop();
        },
        icon: LucideIcons.trash2,
      ),
    );

    return Column(
      children: actions.map((action) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: action,
      )).toList(),
    );
  }

  String _getPrimaryActionText(String type) {
    switch (type) {
      case 'outfit_suggestion':
        return 'Try This Outfit';
      case 'wardrobe_update':
        return 'View New Items';
      case 'style_tip':
        return 'Explore Vibes';
      case 'weather_alert':
        return 'Check Weather';
      default:
        return 'View Details';
    }
  }

  IconData _getPrimaryActionIcon(String type) {
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
        return LucideIcons.eye;
    }
  }

  void _handlePrimaryAction(BuildContext context, NotificationItem notification) {
    if (notification.actionUrl != null) {
      if (notification.actionUrl!.contains('/outfits/') ||
          notification.actionUrl!.contains('/try-on/')) {
        context.go(notification.actionUrl!);
      } else if (notification.actionUrl!.contains('/closet/')) {
        context.go(notification.actionUrl!);
      } else if (notification.actionUrl!.contains('/home/')) {
        context.go(notification.actionUrl!);
      }
    }
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime timestamp;
  final bool isRead;
  final String? actionUrl;
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
