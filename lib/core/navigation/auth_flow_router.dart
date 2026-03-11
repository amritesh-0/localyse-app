import 'package:flutter/widgets.dart';

import '../auth/app_user_role.dart';
import '../../features/dashboard/presentation/pages/dashboard_screen.dart';
import '../../features/onboarding/presentation/pages/business_info_screen.dart';
import '../../features/onboarding/presentation/pages/influencer_info_screen.dart';
import '../../features/onboarding/presentation/pages/verify_business_screen.dart';

Widget buildDashboardForRole(AppUserRole role) {
  return DashboardScreen(role: role);
}

Widget buildOnboardingForRole(AppUserRole role) {
  switch (role) {
    case AppUserRole.influencer:
      return const InfluencerInfoScreen();
    case AppUserRole.business:
      return const BusinessInfoScreen();
    case AppUserRole.user:
      return buildDashboardForRole(role);
  }
}

Widget buildPostAuthDestination({
  required AppUserRole role,
  required bool isOnboarded,
  Map<String, dynamic>? userData,
}) {
  if (role == AppUserRole.business) {
    final bool profileCompleted =
        userData?['businessProfileCompleted'] == true ||
        ((userData?['brandName']?.toString().trim().isNotEmpty ?? false) &&
            (userData?['industry']?.toString().trim().isNotEmpty ?? false) &&
            (userData?['city']?.toString().trim().isNotEmpty ?? false));

    final bool verificationCompleted =
        userData?['businessVerificationCompleted'] == true ||
        ((userData?['gstNumber']?.toString().trim().isNotEmpty ?? false) &&
            (userData?['businessAddress']?.toString().trim().isNotEmpty ?? false) &&
            (userData?['hasLogo'] == true));

    if (isOnboarded && verificationCompleted) {
      return buildDashboardForRole(role);
    }

    if (profileCompleted) {
      return const VerifyBusinessScreen();
    }

    return const BusinessInfoScreen();
  }

  if (isOnboarded) {
    return buildDashboardForRole(role);
  }

  return buildOnboardingForRole(role);
}
