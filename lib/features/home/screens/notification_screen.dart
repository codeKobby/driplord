import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../core/components/common/fixed_app_bar.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String
  type; // 'outfit_suggestion', 'wardrobe_update', 'style_tip', etc.
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

  Color getIconColor(BuildContext context) {
    switch (type) {
      case 'outfit_suggestion':
        return Theme.of(context).colorScheme.primary;
      case 'wardrobe_update':
        return Theme.of(context).colorScheme.secondary;
      case 'style_tip':
        return Theme.of(context).colorScheme.tertiary;
      case 'weather_alert':
        return Theme.of(context).colorScheme.primary;
      default:
        return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
    }
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // State management for bulk actions
  final Set<String> _selectedNotificationIds = {};
  bool _isSelectionMode = false;

  // Add notification to selection
  void _toggleNotificationSelection(String notificationId) {
    setState(() {
      if (_selectedNotificationIds.contains(notificationId)) {
        _selectedNotificationIds.remove(notificationId);
      } else {
        _selectedNotificationIds.add(notificationId);
      }
    });
  }

  // Clear all selections
  void _clearSelection() {
    setState(() {
      _selectedNotificationIds.clear();
      _isSelectionMode = false;
    });
  }

  // Enter selection mode
  void _enterSelectionMode() {
    setState(() {
      _isSelectionMode = true;
    });
  }

  // Select all notifications
  void _selectAllNotifications() {
    setState(() {
      _selectedNotificationIds.clear();
      _selectedNotificationIds.addAll(_notifications.map((n) => n.id));
      _isSelectionMode = true;
    });
  }

  // Mark selected notifications as read
  void _markSelectedAsRead() {
    if (_selectedNotificationIds.isEmpty) return;

    setState(() {
      for (var notification in _notifications) {
        if (_selectedNotificationIds.contains(notification.id)) {
          final index = _notifications.indexWhere(
            (n) => n.id == notification.id,
          );
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
        }
      }
    });
    _clearSelection();
  }

  // Delete selected notifications with confirmation
  void _deleteSelectedNotifications() {
    if (_selectedNotificationIds.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Notifications',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${_selectedNotificationIds.length} notification(s)? This action cannot be undone.',
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.9),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notifications.removeWhere(
                  (n) => _selectedNotificationIds.contains(n.id),
                );
              });
              _clearSelection();
              Navigator.of(context).pop();

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${_selectedNotificationIds.length} notification(s) deleted',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bulk action bar for selected items
  Widget _buildBulkActionBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Text(
            '${_selectedNotificationIds.length} selected',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: _selectAllNotifications,
            child: Text(
              'Select All',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              LucideIcons.eye,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: _markSelectedAsRead,
            tooltip: 'Mark as read',
          ),
          IconButton(
            icon: Icon(
              LucideIcons.trash2,
              color: Theme.of(context).colorScheme.error,
            ),
            onPressed: _deleteSelectedNotifications,
            tooltip: 'Delete',
          ),
          IconButton(
            icon: const Icon(LucideIcons.x, color: Colors.grey),
            onPressed: _clearSelection,
            tooltip: 'Done',
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  // Mock data - in real app, this would come from a provider
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Perfect outfit for your meeting',
      message:
          'Based on your calendar, we suggest this professional look for your 2 PM meeting.',
      type: 'outfit_suggestion',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      actionUrl: '/try-on/outfit/123',
      metadata: {'outfitId': '123', 'occasion': 'meeting'},
    ),
    NotificationItem(
      id: '2',
      title: 'New items added to your closet',
      message:
          '5 new clothing items have been detected and added to your wardrobe.',
      type: 'wardrobe_update',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      actionUrl: '/closet/insights/recent',
      metadata: {'newItemsCount': 5},
    ),
    NotificationItem(
      id: '3',
      title: 'Style tip: Layering for fall',
      message:
          'Learn how to combine light layers for the perfect autumn outfit.',
      type: 'style_tip',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      actionUrl: '/home/vibes',
      metadata: {'season': 'fall', 'tipType': 'layering'},
    ),
    NotificationItem(
      id: '4',
      title: 'Weather alert: Rain expected',
      message:
          'Light rain expected this afternoon. Consider bringing an umbrella.',
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
      message:
          'Master the art of mixing colors that complement your skin tone.',
      type: 'style_tip',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      metadata: {'tipType': 'color_coordination'},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FixedAppBar(title: 'Notifications'),
      body: SafeArea(
        child: _notifications.isEmpty
            ? _buildEmptyState()
            : Column(
                children: [
                  // Bulk action bar if in selection mode
                  if (_selectedNotificationIds.isNotEmpty)
                    _buildBulkActionBar(),
                  // Notification list
                  Expanded(child: _buildNotificationList()),
                ],
              ),
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
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No notifications yet',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll notify you about outfit suggestions\nand wardrobe updates',
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
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
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        indent: 16,
        endIndent: 16,
      ),
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  void _showInsightsBottomSheet(String actionUrl) {
    if (actionUrl.contains('/closet/insights/recent')) {
      _showRecentItemsBottomSheet();
    } else if (actionUrl.contains('/closet/insights/unworn')) {
      _showUnwornItemsBottomSheet();
    } else {
      _showGeneralInsightsBottomSheet();
    }
  }

  void _showRecentItemsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildInsightsBottomSheet(
        title: 'Recently Added Items',
        content: _buildRecentItemsContent(),
      ),
    );
  }

  void _showUnwornItemsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildInsightsBottomSheet(
        title: 'Unworn Items',
        content: _buildUnwornItemsContent(),
      ),
    );
  }

  void _showGeneralInsightsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildInsightsBottomSheet(
        title: 'Closet Insights',
        content: _buildGeneralInsightsContent(),
      ),
    );
  }

  Widget _buildInsightsBottomSheet({
    required String title,
    required Widget content,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          // Handle and title
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(child: content),

          // Close button
          Container(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Close',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentItemsContent() {
    // Mock recent items - in real app this would come from provider
    final recentItems = [
      {
        'name': 'Blue Denim Jacket',
        'date': '2 days ago',
        'image': 'placeholder',
      },
      {'name': 'White Sneakers', 'date': '1 week ago', 'image': 'placeholder'},
      {'name': 'Black T-Shirt', 'date': '3 days ago', 'image': 'placeholder'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: recentItems.length,
      itemBuilder: (context, index) {
        final item = recentItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  LucideIcons.shirt,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] as String,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Added ${item['date']}',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUnwornItemsContent() {
    // Mock unworn items - in real app this would come from provider
    final unwornItems = [
      {'name': 'Red Dress', 'lastWorn': '45 days ago', 'image': 'placeholder'},
      {
        'name': 'Brown Boots',
        'lastWorn': '30 days ago',
        'image': 'placeholder',
      },
      {
        'name': 'Green Scarf',
        'lastWorn': '60 days ago',
        'image': 'placeholder',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: unwornItems.length,
      itemBuilder: (context, index) {
        final item = unwornItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  LucideIcons.shirt,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] as String,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Last worn ${item['lastWorn']}',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGeneralInsightsContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Stats cards
          Row(
            children: [
              Expanded(
                child: _buildInsightStatCard(
                  title: 'Total Items',
                  value: '127',
                  icon: LucideIcons.shirt,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInsightStatCard(
                  title: 'Recently Added',
                  value: '12',
                  icon: LucideIcons.plus,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInsightStatCard(
                  title: 'Unworn Items',
                  value: '23',
                  icon: LucideIcons.eyeOff,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInsightStatCard(
                  title: 'Most Worn',
                  value: '8',
                  icon: LucideIcons.trendingUp,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    // Check if notification is selected
    bool isSelected = _selectedNotificationIds.contains(notification.id);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Slidable(
          key: ValueKey(notification.id),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.5,
            children: [
              SlidableAction(
                onPressed: (context) {
                  // Mark as read action
                  setState(() {
                    final index = _notifications.indexWhere(
                      (n) => n.id == notification.id,
                    );
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

                  // Remove from selection if selected
                  if (isSelected) {
                    _selectedNotificationIds.remove(notification.id);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${notification.title} marked as read'),
                    ),
                  );
                },
                backgroundColor: const Color(0xFF1E88E5).withValues(alpha: 0.1),
                foregroundColor: const Color(0xFF1E88E5),
                icon: LucideIcons.eye,
                label: 'Read',
              ),
              SlidableAction(
                onPressed: (context) {
                  // Delete action
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
                            _notifications.insert(0, notification);
                          });
                        },
                      ),
                    ),
                  );
                },
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.error.withValues(alpha: 0.1),
                foregroundColor: Theme.of(context).colorScheme.error,
                icon: LucideIcons.trash2,
                label: 'Delete',
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              if (_isSelectionMode) {
                // Toggle selection
                _toggleNotificationSelection(notification.id);
              } else {
                // Normal tap behavior
                // Mark as read
                if (!notification.isRead) {
                  setState(() {
                    final index = _notifications.indexWhere(
                      (n) => n.id == notification.id,
                    );
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
                    context.push(notification.actionUrl!);
                  } else if (notification.actionUrl!.contains(
                    '/closet/insights/',
                  )) {
                    // Show insights as bottom sheets instead of navigating
                    _showInsightsBottomSheet(notification.actionUrl!);
                  } else if (notification.actionUrl!.contains('/closet/')) {
                    context.push(notification.actionUrl!);
                  } else if (notification.actionUrl!.contains('/home/')) {
                    context.push(notification.actionUrl!);
                  } else {
                    // Navigate to notification detail
                    context.push('/home/notifications/${notification.id}');
                  }
                } else {
                  // Navigate to notification detail
                  context.push('/home/notifications/${notification.id}');
                }
              }
            },
            onLongPress: () {
              // Enter selection mode and select this item
              _enterSelectionMode();
              _toggleNotificationSelection(notification.id);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: isSelected
                  ? BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selection checkbox
                  if (_isSelectionMode)
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 12),
                      child: Checkbox(
                        value: isSelected,
                        checkColor: Theme.of(context).colorScheme.onPrimary,
                        activeColor: Theme.of(context).colorScheme.primary,
                        onChanged: (bool? value) {
                          _toggleNotificationSelection(notification.id);
                        },
                      ),
                    ),
                  // Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: notification
                          .getIconColor(context)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      notification.icon,
                      color: notification.getIconColor(context),
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
                                      ? Theme.of(context).colorScheme.onSurface
                                            .withValues(alpha: 0.7)
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              notification.timeAgo,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.7),
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
                                ? Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withValues(alpha: 0.7)
                                : Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.9),
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
                              color: notification.getIconColor(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Unread indicator
                  if (!notification.isRead && !_isSelectionMode)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: notification.getIconColor(context),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
