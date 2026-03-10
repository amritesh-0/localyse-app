import 'package:flutter/material.dart';
import '../../../../core/auth/app_user_role.dart';
import '../../../../core/navigation/auth_flow_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/widgets/header_clipper.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../../core/utils/feedback_utils.dart';

class BusinessInfoScreen extends StatefulWidget {
  const BusinessInfoScreen({super.key});

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _citySearchController = TextEditingController();
  String? _selectedIndustry;
  String? _selectedCity;
  bool _isLoading = false;

  final List<String> _industries = [
    'Fashion & Apparel', 'Food & Beverage', 'Technology',
    'Beauty & Cosmetics', 'E-commerce', 'Health & Wellness',
    'Travel & Tourism', 'Education', 'Real Estate', 'Entertainment'
  ];

  final List<String> _cities = [
    'Delhi', 'Mumbai', 'Bangalore', 'Hyderabad', 'Pune', 
    'Ahmed Ahmedabad', 'Chennai', 'Kolkata', 'Surat', 'Jaipur'
  ];

  List<String> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _filteredCities = _cities;
    _citySearchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _brandNameController.dispose();
    _websiteController.dispose();
    _citySearchController.removeListener(_onSearchChanged);
    _citySearchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredCities = _cities
          .where((city) => city.toLowerCase().contains(_citySearchController.text.toLowerCase()))
          .toList();
    });
  }

  Future<void> _handleCompleteOnboarding() async {
    setState(() => _isLoading = true);
    try {
      final AuthRepository authRepository = AuthRepositoryImpl();
      final user = authRepository.currentUser;
      if (user != null) {
        await authRepository.updateUserData(user.uid, {
          'role': AppUserRole.business.value,
          'brandName': _brandNameController.text.trim(),
          'website': _websiteController.text.trim(),
          'industry': _selectedIndustry,
          'city': _selectedCity,
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
    final bool isFormValid = _brandNameController.text.isNotEmpty && 
                              _selectedIndustry != null && 
                              _selectedCity != null;

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
                                'Complete Your Brand Profile',
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
                        'Help us tailor the best influencer matches for your brand.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
                      ),
                      const SizedBox(height: 32),

                      _buildTextField(
                        label: 'Brand/Business Name',
                        hint: 'e.g. Localyse Inc.',
                        controller: _brandNameController,
                      ),
                      const SizedBox(height: 24),

                      _buildTextField(
                        label: 'Website (Optional)',
                        hint: 'www.example.com',
                        controller: _websiteController,
                      ),
                      const SizedBox(height: 24),

                      _buildDropdownField(
                        label: 'Industry',
                        hint: 'Select Industry',
                        items: _industries,
                        value: _selectedIndustry,
                        onChanged: (val) => setState(() => _selectedIndustry = val),
                      ),
                      const SizedBox(height: 24),

                      _sectionTitle('Where is your brand based?'),
                      const SizedBox(height: 12),
                      _buildCitySelector(),
                      const SizedBox(height: 48),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isFormValid ? _handleCompleteOnboarding : null,
                          child: _isLoading 
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('GET STARTED'),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
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

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(label),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(hint, style: const TextStyle(color: AppColors.textHint)),
              isExpanded: true,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCitySelector() {
    return Column(
      children: [
        TextField(
          controller: _citySearchController,
          decoration: InputDecoration(
            hintText: 'Search city...',
            prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
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
        if (_citySearchController.text.isNotEmpty && _selectedCity != _citySearchController.text)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredCities.length,
              itemBuilder: (context, index) {
                final city = _filteredCities[index];
                return ListTile(
                  title: Text(city),
                  onTap: () {
                    setState(() {
                      _selectedCity = city;
                      _citySearchController.text = city;
                      _filteredCities = [];
                    });
                    FocusScope.of(context).unfocus();
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
