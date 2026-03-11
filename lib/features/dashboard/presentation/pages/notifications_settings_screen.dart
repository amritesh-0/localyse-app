import 'package:flutter/material.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _newCampaigns = true;
  bool _directMessages = true;
  bool _paymentAlerts = true;
  bool _marketing = false;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildNotificationCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard() {
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
          _buildToggleTile('New Campaigns', 'Get notified about new opportunities', _newCampaigns, (v) => setState(() => _newCampaigns = v)),
          _buildToggleTile('Direct Messages', 'When a brand sends you a message', _directMessages, (v) => setState(() => _directMessages = v)),
          _buildToggleTile('Payment Alerts', 'When funds hit your account', _paymentAlerts, (v) => setState(() => _paymentAlerts = v)),
          _buildToggleTile('Marketing', 'Stay updated with our latest news', _marketing, (v) => setState(() => _marketing = v)),
        ],
      ),
    );
  }

  Widget _buildToggleTile(String title, String sub, bool value, Function(bool) onChanged) {
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
            activeColor: Colors.black,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
