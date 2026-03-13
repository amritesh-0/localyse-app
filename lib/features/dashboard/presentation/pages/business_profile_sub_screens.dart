import 'package:flutter/material.dart';

class CompanyVerificationScreen extends StatelessWidget {
  const CompanyVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, 'Company Verification'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('Status: Not Verified', 'Upload documents to unlock all features.', Icons.warning_amber_rounded, Colors.orange),
            const SizedBox(height: 32),
            _buildUploadSection('Business Registration (BR)', 'Upload PDF or Image'),
            const SizedBox(height: 20),
            _buildUploadSection('GST Certificate', 'Upload PDF or Image'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Submit for Verification', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18)),
    );
  }

  Widget _buildInfoCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 15)),
                Text(subtitle, style: TextStyle(color: color.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[200]!, style: BorderStyle.none), // Should be dashed in real app
          ),
          child: Column(
            children: [
              Icon(Icons.cloud_upload_outlined, color: Colors.grey[400], size: 32),
              const SizedBox(height: 8),
              Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}

class BillingInvoicesScreen extends StatelessWidget {
  const BillingInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, 'Billing & Invoices'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildBalanceCard(),
          const SizedBox(height: 32),
          const Text('Recent Invoices', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 16),
          ...List.generate(3, (i) => _buildInvoiceItem('INV-00${i+1}', '1${i+1} Mar 2026', '₹1,200.00')),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18)),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Current Balance', style: TextStyle(color: Colors.white60, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          const Text('₹4,520.00', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildBalanceAction('Add Wallet', Icons.add_rounded),
              const SizedBox(width: 12),
              _buildBalanceAction('Auto-pay: ON', Icons.sync_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceAction(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildInvoiceItem(String id, String date, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.description_outlined, color: Colors.black87),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(id, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                Text(date, style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
          const SizedBox(width: 4),
          const Icon(Icons.file_download_outlined, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, 'Privacy & Security'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildToggleOption('Two-factor Authentication', 'Extra security for your account.', true),
          _buildToggleOption('Profile Visibility', 'Allow creators to find your brand.', true),
          _buildToggleOption('Data Sharing', 'Share usage data to improve service.', false),
          const SizedBox(height: 32),
          _buildClickOption('Change Password', Icons.lock_outline_rounded),
          _buildClickOption('Manage Trusted Devices', Icons.devices_rounded),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18)),
    );
  }

  Widget _buildToggleOption(String title, String subtitle, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Switch.adaptive(value: value, activeColor: const Color(0xFF16A34A), onChanged: (bool val) {}),
        ],
      ),
    );
  }

  Widget _buildClickOption(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(icon, color: Colors.black87, size: 20),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        ],
      ),
    );
  }
}

class SupportCenterScreen extends StatelessWidget {
  const SupportCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, 'Support Center'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('How can we help?', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
          const SizedBox(height: 24),
          _buildSupportAction('Live Chat', 'Average response: 2 mins', Icons.chat_bubble_rounded, Colors.blue),
          const SizedBox(height: 16),
          _buildSupportAction('Report an Issue', 'Get technical assistance', Icons.bug_report_rounded, Colors.red),
          const SizedBox(height: 32),
          const Text('Frequently Asked', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 16),
          ...['How do I hire an influencer?', 'Refund policy for campaigns', 'Verifying my business account'].map((q) => _buildFaqItem(q)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18)),
    );
  }

  Widget _buildSupportAction(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.black26),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const Icon(Icons.add_rounded, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
