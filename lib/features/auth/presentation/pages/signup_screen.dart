import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/auth/app_user_role.dart';
import '../../../../core/navigation/auth_flow_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../widgets/header_clipper.dart';
import 'login_screen.dart';
import '../../../onboarding/presentation/pages/role_selection_screen.dart';
import '../../../../core/utils/feedback_utils.dart';

class SignupScreen extends StatefulWidget {
  final String? role;
  const SignupScreen({super.key, this.role});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthRepository _authRepository = AuthRepositoryImpl();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (widget.role == null || widget.role!.trim().isEmpty) {
      AppFeedback.error(context, 'Please select whether you are a business or influencer first.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
      );
      return;
    }

    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      AppFeedback.error(context, 'Please fill in all fields');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final AppUserRole role = appUserRoleFromValue(widget.role);

      await _authRepository.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
        role.value,
      );
      if (!mounted) return;

      final Map<String, dynamic> fallbackUserData = {
        'role': role.value,
        'isOnboarded': false,
        'businessProfileCompleted': false,
        'businessVerificationCompleted': false,
        'businessVerificationStatus': role == AppUserRole.business ? 'pending_submission' : null,
        'onboardingStep': role == AppUserRole.business ? 'business_profile' : 'profile',
      };

      final user = _authRepository.currentUser;
      final userData =
          user == null ? fallbackUserData : (await _authRepository.getUserData(user.uid)) ?? fallbackUserData;

      if (!mounted) return;

      AppFeedback.success(context, 'Registration Successful');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => buildPostAuthDestination(
            role: role,
            isOnboarded: userData['isOnboarded'] ?? false,
            userData: userData,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        AppFeedback.error(context, e.message ?? 'Registration failed');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (widget.role == null || widget.role!.trim().isEmpty) {
      AppFeedback.error(context, 'Please select whether you are a business or influencer first.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final AppUserRole role = appUserRoleFromValue(widget.role);
      await _authRepository.signInWithGoogle(role: role.value);
      if (mounted) {
        final user = _authRepository.currentUser;
        final userData =
            user == null ? null : await _authRepository.getUserData(user.uid);
        final AppUserRole resolvedRole =
            appUserRoleFromValue(userData?['role']?.toString());
        final bool isOnboarded = userData?['isOnboarded'] ?? false;

        if (!mounted) {
          return;
        }

        AppFeedback.success(context, 'Google Sign-In Successful');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => buildPostAuthDestination(
              role: resolvedRole,
              isOnboarded: isOnboarded,
              userData: userData,
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        AppFeedback.error(context, e.message ?? 'Google Sign-In failed');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        height: MediaQuery.of(context).size.height * 0.23,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary,
                              Color(0xFF8B5CF6),
                            ],
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
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  child: Column(
                    children: [
                       const Text(
                        'Join the hyperlocal movement today.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Social Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _isLoading ? null : _handleGoogleSignIn,
                            child: _socialButton(Icons.g_mobiledata_rounded, Colors.black, size: 32)
                          ),
                          const SizedBox(width: 20),
                          _socialButton(Icons.apple, Colors.black, size: 28),
                          const SizedBox(width: 20),
                          _socialButton(Icons.phone_android_rounded, Colors.black, size: 24),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'or use your email account',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      
                      // Form Fields
                      _buildTextField(
                        label: 'Full Name', 
                        hint: 'Amritesh Kumar',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        label: 'Email', 
                        hint: 'name@example.com',
                        controller: _emailController,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        label: 'Password', 
                        hint: '••••••••', 
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignup,
                        child: _isLoading 
                          ? const SizedBox(
                              height: 20, 
                              width: 20, 
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                            )
                          : const Text('REGISTER'),
                      ),
                      
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            child: const Text(
                              'Login here',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _socialButton(IconData icon, Color color, {double size = 24}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: size),
    );
  }

  Widget _buildTextField({
    required String label, 
    required String hint, 
    bool obscureText = false,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textHint),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
