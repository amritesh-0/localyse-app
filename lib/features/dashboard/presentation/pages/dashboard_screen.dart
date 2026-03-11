import 'package:flutter/material.dart';

import '../../../../core/auth/app_user_role.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../onboarding/presentation/pages/role_selection_screen.dart';
import '../widgets/influencer_home_view.dart';
import '../widgets/my_ads_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.role,
  });

  final AppUserRole role;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // If not an influencer, show the legacy layout or appropriate business layout
    if (widget.role != AppUserRole.influencer) {
      return _buildLegacyDashboard(context);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      extendBody: true, // Allows content to be visible behind the floating nav
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: IndexedStack(
              index: _currentIndex,
              children: [
                InfluencerHomeView(),
                MyAdsView(),
                Center(child: Text('Influencer Stats (Coming Soon)')),
                Center(child: Text('Profile Settings')),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: _buildFloatingNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.explore_outlined, Icons.explore_rounded, 'Discover'),
          _buildNavItem(1, Icons.campaign_outlined, Icons.campaign_rounded, 'My Ads'),
          _buildNavItem(2, Icons.bar_chart_rounded, Icons.bar_chart_rounded, 'Stats'),
          _buildNavItem(3, Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(35),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : Colors.grey[400],
              size: 26,
            ),
            if (isSelected) ...[
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLegacyDashboard(BuildContext context) {
    final AuthRepository authRepository = AuthRepositoryImpl();
    final _DashboardContent content = _contentForRole(widget.role);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: Text(content.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authRepository.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RoleSelectionScreen(),
                  ),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [content.primaryColor, content.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(content.icon, color: Colors.white, size: 36),
                  const SizedBox(height: 16),
                  Text(
                    content.heroTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content.heroSubtitle,
                    style: TextStyle(
                      color: Colors.white.withAlpha(230),
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ...content.sections.map(_buildSectionCard),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(_DashboardSection section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: section.color.withAlpha(24),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(section.icon, color: section.color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    section.subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _DashboardContent _contentForRole(AppUserRole role) {
    switch (role) {
      case AppUserRole.influencer:
        return const _DashboardContent(
          title: 'Influencer Dashboard',
          heroTitle: 'Your creator pipeline is live.',
          heroSubtitle: 'Track profile readiness, grow your brand presence, and stay ready for local campaign opportunities.',
          primaryColor: AppColors.primary,
          secondaryColor: Color(0xFF7C3AED),
          icon: Icons.campaign_rounded,
          sections: [
            _DashboardSection(
              title: 'Profile Strength',
              subtitle: 'Keep your niche, city, and socials current so brands can discover you faster.',
              icon: Icons.verified_user_rounded,
              color: AppColors.primary,
            ),
            _DashboardSection(
              title: 'Campaign Opportunities',
              subtitle: 'Review nearby collaborations that align with your audience and content style.',
              icon: Icons.explore_rounded,
              color: Color(0xFF0EA5E9),
            ),
            _DashboardSection(
              title: 'Audience Insights',
              subtitle: 'Monitor the engagement signals that matter when pitching your creator profile.',
              icon: Icons.insights_rounded,
              color: Color(0xFFF97316),
            ),
          ],
        );
      case AppUserRole.business:
        return const _DashboardContent(
          title: 'Business Dashboard',
          heroTitle: 'Your brand workspace is ready.',
          heroSubtitle: 'Shortlist the right influencers, manage outreach, and keep your local campaign pipeline organized.',
          primaryColor: Color(0xFF0F766E),
          secondaryColor: Color(0xFF14B8A6),
          icon: Icons.storefront_rounded,
          sections: [
            _DashboardSection(
              title: 'Brand Brief',
              subtitle: 'Refine your business profile so creator recommendations stay relevant and local.',
              icon: Icons.description_rounded,
              color: Color(0xFF0F766E),
            ),
            _DashboardSection(
              title: 'Creator Discovery',
              subtitle: 'Browse influencer matches by category, geography, and campaign fit.',
              icon: Icons.groups_rounded,
              color: Color(0xFF2563EB),
            ),
            _DashboardSection(
              title: 'Campaign Tracking',
              subtitle: 'Stay on top of outreach, approvals, and campaign momentum in one place.',
              icon: Icons.track_changes_rounded,
              color: Color(0xFFEA580C),
            ),
          ],
        );
      case AppUserRole.user:
        return const _DashboardContent(
          title: 'Dashboard',
          heroTitle: 'Your account is active.',
          heroSubtitle: 'Complete your profile details as needed and continue exploring the app.',
          primaryColor: AppColors.primary,
          secondaryColor: Color(0xFF2563EB),
          icon: Icons.dashboard_rounded,
          sections: [
            _DashboardSection(
              title: 'Account Status',
              subtitle: 'Your authentication flow is complete and your session is ready.',
              icon: Icons.check_circle_rounded,
              color: AppColors.primary,
            ),
          ],
        );
    }
  }
}

class _DashboardContent {
  const _DashboardContent({
    required this.title,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
    required this.sections,
  });

  final String title;
  final String heroTitle;
  final String heroSubtitle;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;
  final List<_DashboardSection> sections;
}

class _DashboardSection {
  const _DashboardSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}
