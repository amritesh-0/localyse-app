import 'package:flutter/material.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../onboarding/presentation/pages/role_selection_screen.dart';
import '../pages/personal_info_screen.dart';
import '../pages/payout_methods_screen.dart';
import '../pages/earning_history_screen.dart';
import '../pages/notifications_settings_screen.dart';
import '../pages/help_center_screen.dart';
import '../pages/terms_privacy_screen.dart';

class InfluencerProfileView extends StatelessWidget {
  const InfluencerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Seamless light background
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeroHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  _buildPremiumSection(
                    title: 'CONNECTED ACCOUNTS',
                    child: Column(
                      children: [
                        _buildSocialTile('Instagram', '@stef_reels', '124K Followers', Icons.camera_alt_rounded, const Color(0xFFE4405F), true),
                        _buildSocialTile('TikTok', '@steffany_vlogs', '89K Followers', Icons.music_note_rounded, Colors.black, true),
                        _buildSocialTile('YouTube', 'Not connected', '', Icons.play_arrow_rounded, const Color(0xFFFF0000), false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildPremiumSection(
                    title: 'ACCOUNT SETTINGS',
                    child: Column(
                      children: [
                        _buildMenuTile(Icons.person_rounded, 'Personal Information', 'Edit bio and contact info',
                            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalInfoScreen()))),
                        _buildMenuTile(Icons.payments_rounded, 'Payout Methods', 'Manage bank accounts',
                            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PayoutMethodsScreen()))),
                        _buildMenuTile(Icons.history_rounded, 'Earning History', 'View past transactions',
                            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EarningHistoryScreen()))),
                        _buildMenuTile(Icons.notifications_rounded, 'Notifications', 'Customize alerts',
                            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsSettingsScreen()))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildPremiumSection(
                    title: 'SUPPORT',
                    child: Column(
                      children: [
                        _buildMenuTile(Icons.help_center_rounded, 'Help Center', 'FAQs and contact info',
                            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpCenterScreen()))),
                        _buildMenuTile(Icons.shield_rounded, 'Terms & Privacy', 'Legal information',
                            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsPrivacyScreen()))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildLogoutButton(context),
                  const SizedBox(height: 120), // Padding for bottom navbar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
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
              const SizedBox(width: 44), // Spacer to balance or add more actions
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 46,
                  backgroundColor: AppColors.primaryLight,
                  backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=Steffany'),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit_rounded, color: Colors.white, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard('Engagement', '4.8%', Icons.favorite_rounded, const Color(0xFFF43F5E)),
        const SizedBox(width: 16),
        _buildStatCard('Avg. Views', '62K', Icons.visibility_rounded, AppColors.primary),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black),
            ),
            Text(
              label.toUpperCase(),
              style: TextStyle(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Colors.grey[400],
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildSocialTile(String platform, String username, String followers, IconData icon, Color color, bool isConnected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: isConnected ? Colors.grey[50] : Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isConnected ? color.withOpacity(0.1) : Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: isConnected ? color : Colors.grey[400], size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        platform,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.black),
                      ),
                      if (isConnected)
                        Text(
                          username,
                          style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w600),
                        )
                      else
                        Text(
                          'Not connected',
                          style: TextStyle(color: Colors.grey[400], fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                    ],
                  ),
                ),
                if (isConnected)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      followers.split(' ')[0], // Just the number
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Colors.black),
                    ),
                  )
                else
                  const Icon(Icons.add_circle_outline_rounded, color: Colors.black, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.black, size: 18),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.black),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey[300], size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final AuthRepository authRepository = AuthRepositoryImpl();

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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Unable to log out. Please try again.')),
              );
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
