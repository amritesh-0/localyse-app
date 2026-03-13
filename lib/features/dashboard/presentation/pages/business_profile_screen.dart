import 'package:flutter/material.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../onboarding/presentation/pages/role_selection_screen.dart';
import '../../../../core/utils/feedback_utils.dart';
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
              _buildPremiumHero(context),
              const SizedBox(height: 40),
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

  Widget _buildPremiumHero(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey[50],
                padding: const EdgeInsets.all(8),
              ),
            ),
            const SizedBox(width: 40), // Spacer to balance header
          ],
        ),
        const SizedBox(height: 20),
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: const Color(0xFF16A34A).withOpacity(0.1), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF16A34A).withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'L',
                    style: TextStyle(
                      color: Color(0xFF16A34A),
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_rounded, color: Colors.white, size: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Localize HQ',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.language_rounded, size: 12, color: Colors.blue),
            const SizedBox(width: 6),
            Text(
              'www.localize.app',
              style: TextStyle(
                color: Colors.blue[600],
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 3,
              width: 3,
              decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            const Text(
              'Premium Brand',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
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
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final AuthRepository authRepository = AuthRepositoryImpl();
            try {
              await authRepository.signOut();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                (route) => false,
              );
            } catch (_) {
              if (!context.mounted) return;
              AppFeedback.error(context, 'Unable to log out. Please try again.');
            }
          },
          borderRadius: BorderRadius.circular(24),
          child: const Center(
            child: Text(
              'Log Out',
              style: TextStyle(color: Color(0xFFF43F5E), fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
