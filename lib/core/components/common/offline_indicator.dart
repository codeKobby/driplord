import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

/// A small indicator widget that shows when the app is working offline or with cached data
class OfflineIndicator extends StatelessWidget {
  final bool isOffline;
  final String? message;
  final VoidCallback? onRetry;

  const OfflineIndicator({
    super.key,
    this.isOffline = false,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off,
            size: 16,
            color: AppColors.warning,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message ?? 'Working offline',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            InkWell(
              onTap: onRetry,
              child: Icon(
                Icons.refresh,
                size: 16,
                color: AppColors.warning,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A banner that appears at the top of the screen when offline
class OfflineBanner extends StatelessWidget {
  final bool isOffline;
  final String message;
  final VoidCallback? onRetry;

  const OfflineBanner({
    super.key,
    this.isOffline = false,
    this.message = 'You\'re currently offline. Some features may be limited.',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: AppColors.warning.withValues(alpha: 0.9),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.wifi_off,
            color: AppColors.surface,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.surface,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }
}

/// Provider for offline status
class OfflineNotifier extends Notifier<bool> {
  @override
  bool build() {
    // TODO: Implement actual connectivity checking using connectivity_plus
    // For now, return false (online)
    return false;
  }

  void setOffline(bool offline) {
    state = offline;
  }
}

final offlineProvider = NotifierProvider<OfflineNotifier, bool>(
  () => OfflineNotifier(),
);
