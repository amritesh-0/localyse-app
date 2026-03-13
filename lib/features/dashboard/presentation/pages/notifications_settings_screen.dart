import 'package:flutter/material.dart';

import '../../../../core/utils/feedback_utils.dart';
import '../../data/services/notification_service.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  final NotificationService _notificationService = NotificationService.instance;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
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
        centerTitle: true,
      ),
      body: StreamBuilder<NotificationPreferences>(
        stream: _notificationService.preferencesStream(),
        builder: (context, snapshot) {
          final NotificationPreferences preferences =
              snapshot.data ?? const NotificationPreferences.defaults();
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildNotificationCard(preferences),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationPreferences preferences) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          _buildToggleTile('New Campaigns', 'Get notified about new opportunities', preferences.newCampaigns, (value) {
            _save(preferences.copyWith(newCampaigns: value));
          }),
          _buildToggleTile('Direct Messages', 'When a brand sends you a message', preferences.directMessages, (value) {
            _save(preferences.copyWith(directMessages: value));
          }),
          _buildToggleTile('Payment Alerts', 'When funds hit your account', preferences.paymentAlerts, (value) {
            _save(preferences.copyWith(paymentAlerts: value));
          }),
          _buildToggleTile('Marketing', 'Stay updated with our latest news', preferences.marketing, (value) {
            _save(preferences.copyWith(marketing: value));
          }),
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: LinearProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildToggleTile(String title, String sub, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                Text(sub, style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeThumbColor: Colors.black,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Future<void> _save(NotificationPreferences preferences) async {
    setState(() => _isSaving = true);
    try {
      await _notificationService.updatePreferences(preferences);
    } catch (error) {
      if (mounted) {
        AppFeedback.error(context, 'Unable to save notification settings: $error');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

extension on NotificationPreferences {
  NotificationPreferences copyWith({
    bool? newCampaigns,
    bool? directMessages,
    bool? paymentAlerts,
    bool? marketing,
  }) {
    return NotificationPreferences(
      newCampaigns: newCampaigns ?? this.newCampaigns,
      directMessages: directMessages ?? this.directMessages,
      paymentAlerts: paymentAlerts ?? this.paymentAlerts,
      marketing: marketing ?? this.marketing,
    );
  }
}
