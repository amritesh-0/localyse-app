import 'package:flutter/material.dart';
import '../../../../core/auth/app_user_role.dart';
import '../../../../core/navigation/auth_flow_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/widgets/header_clipper.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../../core/utils/feedback_utils.dart';

class SocialConnectScreen extends StatefulWidget {
  const SocialConnectScreen({super.key});

  @override
  State<SocialConnectScreen> createState() => _SocialConnectScreenState();
}

class _SocialConnectScreenState extends State<SocialConnectScreen> {
  final AuthRepository _authRepository = AuthRepositoryImpl();
  bool _isInstagramConnected = false;
  bool _isYouTubeConnected = false;
  bool _isLoading = false;

  Future<void> _handleFinish() async {
    setState(() => _isLoading = true);
    try {
      final user = _authRepository.currentUser;
      if (user != null) {
        await _authRepository.updateUserData(user.uid, {
          'role': AppUserRole.influencer.value,
          'socialConnectionsCompleted': true,
          'instagramConnected': _isInstagramConnected,
          'youtubeConnected': _isYouTubeConnected,
        });
        await _authRepository.completeOnboarding(user.uid);
      }
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => buildDashboardForRole(AppUserRole.influencer),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        AppFeedback.error(context, 'Error: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _connectPlatform(String platform) {
    // Simulate connection for now
    setState(() {
      if (platform == 'Instagram') {
        _isInstagramConnected = true;
      } else if (platform == 'YouTube') {
        _isYouTubeConnected = true;
      }
    });

    AppFeedback.success(context, '$platform connected!');
  }

  @override
  Widget build(BuildContext context) {
    bool isAnyConnected = _isInstagramConnected || _isYouTubeConnected;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Stack(
                  children: [
                    ClipPath(
                      clipper: HeaderClipper(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.28, // Increased height
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.primary, Color(0xFF8B5CF6)],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ),
                          const Center(
                            child: Icon(Icons.verified_user_rounded, color: Colors.white, size: 60),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Boost Your Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                  child: Column(
                    children: [
                      const Text(
                        'Connect your social platforms to unlock exclusive collaborations and build trust with top brands.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),

                      _socialConnectCard(
                        title: 'Connect Instagram',
                        subtitle: _isInstagramConnected ? 'Account linked successfully' : 'Showcase your aesthetic and reach.',
                        icon: Icons.camera_alt_rounded,
                        onTap: () => _connectPlatform('Instagram'),
                        isInstagram: true,
                        isConnected: _isInstagramConnected,
                      ),
                      const SizedBox(height: 20),

                      _socialConnectCard(
                        title: 'Connect YouTube',
                        subtitle: _isYouTubeConnected ? 'Channel linked successfully' : 'Share your video content and engagement.',
                        icon: Icons.play_circle_fill_rounded,
                        color: const Color(0xFFFF0000),
                        onTap: () => _connectPlatform('YouTube'),
                        isConnected: _isYouTubeConnected,
                      ),

                      const SizedBox(height: 60),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isAnyConnected ? _handleFinish : null,
                          child: const Text('FINISH'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _handleFinish,
                        child: const Text(
                          'Continue collab and connect later',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _socialConnectCard({
    required String title,
    required String subtitle,
    required IconData icon,
    Color color = AppColors.primary,
    required VoidCallback onTap,
    bool isInstagram = false,
    bool isConnected = false,
  }) {
    return GestureDetector(
      onTap: isConnected ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isConnected ? AppColors.primary.withAlpha(50) : Colors.grey.shade100,
            width: isConnected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isConnected ? 4 : 8),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: isInstagram 
                    ? const LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Color(0xFFF58529),
                          Color(0xFFFEDA77),
                          Color(0xFFDD2A7B),
                          Color(0xFF8134AF),
                          Color(0xFF515BD4),
                        ],
                      )
                    : null,
                color: isInstagram ? null : (isConnected ? color : color.withAlpha(25)),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon, 
                color: (isInstagram || isConnected) ? Colors.white : color, 
                size: 30
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isConnected ? title.replaceFirst('Connect ', '') : title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isConnected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isConnected ? Icons.check_circle_rounded : Icons.add_circle_outline, 
              color: isConnected ? AppColors.primary : AppColors.textHint
            ),
          ],
        ),
      ),
    );
  }
}
