import 'package:flutter/material.dart';

import '../../../../core/auth/app_user_role.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../onboarding/presentation/pages/role_selection_screen.dart';
import '../pages/earnings_screen.dart';
import '../pages/planner_screen.dart';
import '../pages/chat_list_screen.dart';
import '../widgets/influencer_home_view.dart';
import '../widgets/my_ads_view.dart';
import '../widgets/business_home_view.dart';
import '../widgets/business_campaigns_view.dart';
import '../widgets/business_stats_view.dart';
import '../widgets/business_shortlist_view.dart';
import '../pages/business_profile_screen.dart';
import '../pages/business_campaign_detail_screen.dart';

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
    // Both roles now use the modern dashboard with floating nav bar
    if (widget.role == AppUserRole.user) {
      return _buildLegacyDashboard(context);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      extendBody: true,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: IndexedStack(
              index: _currentIndex,
              children: widget.role == AppUserRole.influencer 
                ? const [
                    InfluencerHomeView(),
                    MyAdsView(),
                    EarningsScreen(),
                    PlannerScreen(),
                  ]
                : [
                    const BusinessHomeView(),
                    const BusinessCampaignsView(),
                    const BusinessStatsView(),
                    const BusinessShortlistView(), // Renamed internally to OpeningsView
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
    final navItems = widget.role == AppUserRole.influencer
      ? [
          _buildNavItem(0, Icons.explore_rounded, 'Discover'),
          _buildNavItem(1, Icons.campaign_rounded, 'My Ads'),
          _buildNavItem(2, Icons.account_balance_wallet_rounded, 'Earnings'),
          _buildNavItem(3, Icons.calendar_today_rounded, 'Planner'),
        ]
      : [
          _buildNavItem(0, Icons.groups_rounded, 'Discover'),
          _buildNavItem(1, Icons.campaign_rounded, 'My Ads'),
          _buildNavItem(2, Icons.analytics_rounded, 'Stats'),
          _buildNavItem(3, Icons.event_available_rounded, 'Openings'),
        ];

    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems,
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A1A1A) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[700],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                letterSpacing: 0.1,
              ),
            ),
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
