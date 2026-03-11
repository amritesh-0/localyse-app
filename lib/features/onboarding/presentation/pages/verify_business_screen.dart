import 'package:flutter/material.dart';
import '../../../../core/auth/app_user_role.dart';
import '../../../../core/navigation/auth_flow_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/widgets/header_clipper.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../../core/utils/feedback_utils.dart';

class VerifyBusinessScreen extends StatefulWidget {
  const VerifyBusinessScreen({super.key});

  @override
  State<VerifyBusinessScreen> createState() => _VerifyBusinessScreenState();
}

class _VerifyBusinessScreenState extends State<VerifyBusinessScreen> {
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;
  
  // Simulated upload states
  bool _hasLogo = false;
  bool _hasSupportingDoc = false;

  @override
  void dispose() {
    _gstController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleFinish() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final AuthRepository authRepository = AuthRepositoryImpl();
      final user = authRepository.currentUser;
      if (user == null) {
        throw StateError('No authenticated user found.');
      }

      await authRepository.updateUserData(user.uid, {
        'gstNumber': _gstController.text.trim(),
        'businessAddress': _addressController.text.trim(),
        'hasLogo': _hasLogo,
        'hasSupportingDoc': _hasSupportingDoc,
        'businessVerificationCompleted': true,
        'businessVerificationStatus': 'submitted',
        'verificationSubmittedAt': DateTime.now().toIso8601String(),
        'onboardingStep': 'dashboard',
      });
      await authRepository.completeOnboarding(user.uid);
      
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => buildDashboardForRole(AppUserRole.business),
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

  Future<void> _handleSetupLater() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final AuthRepository authRepository = AuthRepositoryImpl();
      final user = authRepository.currentUser;
      if (user == null) {
        throw StateError('No authenticated user found.');
      }

      await authRepository.updateUserData(user.uid, {
        'businessVerificationCompleted': false,
        'businessVerificationStatus': 'deferred',
        'onboardingStep': 'dashboard',
      });
      await authRepository.completeOnboarding(user.uid);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => buildDashboardForRole(AppUserRole.business),
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

  @override
  Widget build(BuildContext context) {
    // Finish is enabled only if required fields are provided
    final bool isFormValid = _gstController.text.trim().isNotEmpty && 
                              _addressController.text.trim().isNotEmpty &&
                              _hasLogo;

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
                        height: MediaQuery.of(context).size.height * 0.20,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 12, top: 8),
                              child: Text(
                                'Verify Your Business',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'This helps build trust with influencers and secures your account.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
                      ),
                      const SizedBox(height: 32),

                      _buildUploadBox(
                        title: 'Brand Logo',
                        isUploaded: _hasLogo,
                        icon: Icons.image_rounded,
                        onTap: () {
                          setState(() => _hasLogo = !_hasLogo);
                        },
                      ),
                      const SizedBox(height: 24),

                      _buildTextField(
                        label: 'GST Number',
                        hint: 'e.g. 22AAAAA0000A1Z5',
                        controller: _gstController,
                      ),
                      const SizedBox(height: 24),

                      _buildUploadBox(
                        title: 'Supporting Document (Optional)',
                        isUploaded: _hasSupportingDoc,
                        icon: Icons.auto_awesome_motion_rounded,
                        onTap: () {
                          setState(() => _hasSupportingDoc = !_hasSupportingDoc);
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      _buildTextField(
                        label: 'Business Address',
                        hint: 'Enter your full business address',
                        controller: _addressController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 48),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isFormValid ? _handleFinish : null,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isLoading 
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Finish', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: _isLoading ? null : _handleSetupLater,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            foregroundColor: AppColors.primary,
                          ),
                          child: const Text(
                            'Setup later (Get verified badge)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
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

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionTitle(label),
            if (label == 'GST Number')
              const Icon(Icons.verified_user_rounded, color: Colors.green, size: 16)
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textHint),
            filled: true,
            fillColor: Colors.grey.shade50,
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

  Widget _buildUploadBox({
    required String title,
    required bool isUploaded,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(title),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 64,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isUploaded ? AppColors.primary.withOpacity(0.05) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isUploaded ? AppColors.primary.withOpacity(0.5) : Colors.grey.shade200,
                width: isUploaded ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isUploaded ? AppColors.primary.withOpacity(0.1) : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (!isUploaded)
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                    ],
                  ),
                  child: Icon(
                    isUploaded ? Icons.check_circle_rounded : icon,
                    color: isUploaded ? AppColors.primary : AppColors.textSecondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    isUploaded ? 'Document Uploaded' : 'Tap to upload $title',
                    style: TextStyle(
                      color: isUploaded ? AppColors.textPrimary : AppColors.textSecondary,
                      fontWeight: isUploaded ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (!isUploaded)
                  Icon(Icons.upload_file_rounded, color: Colors.grey.shade400, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
