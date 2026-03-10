import 'package:flutter/material.dart';
import '../../../../core/auth/app_user_role.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/widgets/header_clipper.dart';
import 'social_connect_screen.dart';
import '../../../../core/utils/feedback_utils.dart';

class InfluencerInfoScreen extends StatefulWidget {
  const InfluencerInfoScreen({super.key});

  @override
  State<InfluencerInfoScreen> createState() => _InfluencerInfoScreenState();
}

class _InfluencerInfoScreenState extends State<InfluencerInfoScreen> {
  String? _selectedGender;
  String? _selectedCity;
  final List<String> _selectedCategories = [];
  final TextEditingController _citySearchController = TextEditingController();
  bool _isLoading = false;

  final List<String> _cities = [
    'Delhi', 'Mumbai', 'Bangalore', 'Hyderabad', 'Pune', 
    'Ahmedabad', 'Chennai', 'Kolkata', 'Surat', 'Jaipur',
    'Lucknow', 'Kanpur', 'Nagpur', 'Indore', 'Thane'
  ];

  final List<String> _categories = [
    'Food Vlogger', 'Tech Influencer', 'Fashion & Lifestyle',
    'Travel Blogger', 'Fitness Enthusiast', 'Gaming',
    'Education', 'Entertainment', 'Beauty', 'Business'
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

  Future<void> _handleContinue() async {
    setState(() => _isLoading = true);

    try {
      final AuthRepository authRepository = AuthRepositoryImpl();
      final user = authRepository.currentUser;

      if (user == null) {
        throw StateError('No authenticated user found.');
      }

      await authRepository.updateUserData(user.uid, {
        'role': AppUserRole.influencer.value,
        'gender': _selectedGender,
        'city': _selectedCity,
        'categories': _selectedCategories,
      });

      if (!mounted) {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SocialConnectScreen()),
      );
    } catch (e) {
      if (mounted) {
        AppFeedback.error(context, 'Unable to save your profile: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                            'Tell us about you',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
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
                  _sectionTitle('What is your gender?'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _genderChip('Male'),
                      const SizedBox(width: 12),
                      _genderChip('Female'),
                      const SizedBox(width: 12),
                      _genderChip('Other'),
                    ],
                  ),
                  const SizedBox(height: 32),

                  _sectionTitle('Where are you located?'),
                  const SizedBox(height: 12),
                  _buildCitySelector(),
                  const SizedBox(height: 32),

                  _sectionTitle('What content do you create?'),
                  const SizedBox(height: 4),
                  Text(
                    'Select categories that best describe your content',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((cat) => _categoryChip(cat)).toList(),
                  ),
                  const SizedBox(height: 48),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_selectedGender != null &&
                              _selectedCity != null &&
                              _selectedCategories.isNotEmpty &&
                              !_isLoading)
                          ? _handleContinue
                          : null,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('NEXT'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _genderChip(String gender) {
    final isSelected = _selectedGender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = gender),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade200,
              width: 2,
            ),
            boxShadow: isSelected
                ? [BoxShadow(color: AppColors.primary.withAlpha(51), blurRadius: 10, offset: const Offset(0, 4))]
                : [],
          ),
          child: Center(
            child: Text(
              gender,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryChip(String category) {
    final isSelected = _selectedCategories.contains(category);
    return GestureDetector(
      onTap: () => _toggleCategory(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
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
          onTap: () {
            // Show dropdown or list
          },
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
