import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/services/notification_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationService service = NotificationService.instance;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -0.5),
        ),
        actions: [
          TextButton(
            onPressed: () => service.markAllRead(),
            child: const Text(
              'Mark all read',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
        ],
        centerTitle: true,
      ),
      body: StreamBuilder<List<AppNotification>>(
        stream: service.notificationsStream(),
        builder: (context, snapshot) {
          final List<AppNotification> notifications = snapshot.data ?? const <AppNotification>[];
          if (snapshot.connectionState == ConnectionState.waiting && notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notifications.isEmpty) {
            return Center(
              child: Text(
                'No notifications yet.',
                style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600),
              ),
            );
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            itemBuilder: (context, index) {
              final AppNotification notification = notifications[index];
              return InkWell(
                onTap: () => service.markRead(notification.id),
                borderRadius: BorderRadius.circular(24),
                child: _buildNotificationTile(notification),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: notifications.length,
          );
        },
      ),
    );
  }

  Widget _buildNotificationTile(AppNotification notification) {
    final _NotificationStyle style = _styleForType(notification.type);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: style.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(style.icon, color: style.color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        height: 8,
                        width: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatRelative(notification.createdAt),
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _NotificationStyle _styleForType(String type) {
    switch (type) {
      case 'campaign_approved':
        return const _NotificationStyle(Icons.check_circle_rounded, Color(0xFF2563EB));
      case 'payment':
        return const _NotificationStyle(Icons.payments_rounded, Color(0xFFF97316));
      case 'proof_submission':
        return const _NotificationStyle(Icons.upload_file_rounded, Color(0xFF7C3AED));
      case 'campaign_rejected':
        return const _NotificationStyle(Icons.cancel_rounded, Color(0xFFEF4444));
      default:
        return const _NotificationStyle(Icons.notifications_active_rounded, Color(0xFF10B981));
    }
  }

  String _formatRelative(DateTime? createdAt) {
    if (createdAt == null) {
      return 'Just now';
    }
    final Duration diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) {
      return 'Just now';
    }
    if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inDays < 1) {
      return '${diff.inHours}h ago';
    }
    return '${diff.inDays}d ago';
  }
}

class _NotificationStyle {
  const _NotificationStyle(this.icon, this.color);

  final IconData icon;
  final Color color;
}
