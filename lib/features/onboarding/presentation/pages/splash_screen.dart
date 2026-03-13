import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/auth/app_user_role.dart';
import '../../../../core/navigation/auth_flow_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );

    _slideAnimation = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );

    _controller.forward();
    _navigateToNext();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final AuthRepository authRepository = AuthRepositoryImpl();
    final user = authRepository.currentUser;

    if (user != null) {
      final userData = await authRepository.getUserData(user.uid);
      final bool isOnboarded = userData?['isOnboarded'] ?? false;
      final AppUserRole role =
          appUserRoleFromValue(userData?['role']?.toString());
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => buildPostAuthDestination(
              role: role,
              isOnboarded: isOnboarded,
              userData: userData,
            ),
          ),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background soft ambient glows
          Positioned(
            top: -200,
            right: -100,
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.05),
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Floating Feature Icons
                    ..._buildFloatingIcons(),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 140,
                              width: 140,
                              child: SvgPicture.asset(
                                'assets/images/logo.svg',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 32),
                            const Text(
                              'Localyse',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'HYPERLOCAL INFLUENCER MARKETING',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Progress Indicator at Bottom
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 40,
                height: 2,
                child: LinearProgressIndicator(
                  backgroundColor: AppColors.primaryLight,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary.withOpacity(0.3)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingIcons() {
    final icons = [
      {'icon': Icons.camera_alt_rounded, 'color': Colors.pink[400], 'x': -140.0, 'y': -140.0, 'delay': 0.2},
      {'icon': Icons.campaign_rounded, 'color': Colors.blue[400], 'x': 140.0, 'y': -100.0, 'delay': 0.4},
      {'icon': Icons.group_rounded, 'color': AppColors.primary, 'x': -150.0, 'y': 80.0, 'delay': 0.6},
      {'icon': Icons.trending_up_rounded, 'color': Colors.amber[600], 'x': 130.0, 'y': 120.0, 'delay': 0.8},
    ];

    return icons.map((data) {
      final delay = data['delay'] as double;
      final animation = CurvedAnimation(
        parent: _controller,
        curve: Interval(delay, delay + 0.4 > 1.0 ? 1.0 : delay + 0.4, curve: Curves.easeOut),
      );

      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(data['x'] as double, (data['y'] as double) - (10 * (1 - animation.value))),
            child: Opacity(
              opacity: animation.value,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (data['color'] as Color).withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  data['icon'] as IconData,
                  color: data['color'] as Color,
                  size: 20,
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }
}
