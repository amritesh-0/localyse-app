import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Seamless background
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
            onPressed: () {},
            child: const Text(
              'Mark all read',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
        ],
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader('TODAY'),
          const SizedBox(height: 16),
          _buildNotificationTile(
            title: 'New Campaign Match!',
            subtitle: 'Nike is looking for lifestyle creators in New York.',
            time: '2h ago',
            icon: Icons.auto_awesome_rounded,
            color: const Color(0xFF7C3AED),
            isUnread: true,
          ),
          const SizedBox(height: 12),
          _buildNotificationTile(
            title: 'Message from Adidas',
            subtitle: '"We loved your latest reel! Let\'s discuss..."',
            time: '5h ago',
            icon: Icons.chat_bubble_rounded,
            color: const Color(0xFF10B981),
            isUnread: true,
          ),
          const SizedBox(height: 32),
          _buildSectionHeader('YESTERDAY'),
          const SizedBox(height: 16),
          _buildNotificationTile(
            title: 'Payment Received',
            subtitle: 'Your payment for "Starbucks Summer" has been processed.',
            time: '1d ago',
            icon: Icons.payments_rounded,
            color: const Color(0xFFF97316),
            isUnread: false,
          ),
          const SizedBox(height: 12),
          _buildNotificationTile(
            title: 'Campaign Approved',
            subtitle: 'Your proof for "Tech Expo" was verified by the brand.',
            time: '1d ago',
            icon: Icons.check_circle_rounded,
            color: const Color(0xFF2563EB),
            isUnread: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: Colors.grey[400],
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color color,
    required bool isUnread,
  }) {
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
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    if (isUnread)
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
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
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
}
