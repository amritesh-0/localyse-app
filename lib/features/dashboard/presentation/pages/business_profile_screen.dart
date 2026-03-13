import 'package:flutter/material.dart';
import '../pages/business_profile_sub_screens.dart';

class BusinessProfileScreen extends StatelessWidget {
  const BusinessProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildBrandInfo(),
              const SizedBox(height: 48),
              _buildSectionHeader('Account Settings'),
              const SizedBox(height: 16),
              _buildSettingsList(context),
              const SizedBox(height: 40),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF16A34A).withOpacity(0.1), width: 1),
              ),
              child: const Center(
                child: Text(
                  'L', // Loco logo placeholder
                  style: TextStyle(
                    color: Color(0xFF16A34A),
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Localize HQ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black),
                ),
                Text(
                  'Premium Brand',
                  style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.edit_note_rounded, color: Colors.black),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildBrandInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('About'),
        const SizedBox(height: 12),
        Text(
          'Connecting premium brands with top-tier local influencers. We specialize in lifestyle and fashion campaigns across metropolitan India.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 15,
            height: 1.6,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.language_rounded, size: 16, color: Colors.black54),
            const SizedBox(width: 8),
            Text(
              'www.localize.app',
              style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 30, width: 1, color: Colors.grey[200]);
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    final settings = [
      {
        'icon': Icons.business_center_rounded,
        'title': 'Company Verification',
        'subtitle': 'GST & Registration details',
        'screen': const CompanyVerificationScreen(),
      },
      {
        'icon': Icons.payments_rounded,
        'title': 'Billing & Invoices',
        'subtitle': 'Tax reports and payment history',
        'screen': const BillingInvoicesScreen(),
      },
      {
        'icon': Icons.security_rounded,
        'title': 'Privacy & Security',
        'subtitle': 'Password and data control',
        'screen': const PrivacySecurityScreen(),
      },
      {
        'icon': Icons.help_outline_rounded,
        'title': 'Support Center',
        'subtitle': 'FAQs and direct assistance',
        'screen': const SupportCenterScreen(),
      },
    ];

    return Column(
      children: settings.map((s) => _buildSettingsItem(
        context,
        s['icon'] as IconData,
        s['title'] as String,
        s['subtitle'] as String,
        s['screen'] as Widget,
      )).toList(),
    );
  }

  Widget _buildSettingsItem(BuildContext context, IconData icon, String title, String subtitle, Widget destination) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => destination)),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 20, color: Colors.black87),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Colors.black)),
                    Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.black12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.red[50]!, width: 1),
          ),
        ),
        child: Text(
          'Logout Account',
          style: TextStyle(color: Colors.red[400], fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ),
    );
  }
}
