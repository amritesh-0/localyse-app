import 'package:flutter/material.dart';
import '../../../../core/utils/feedback_utils.dart';

class PostOpeningScreen extends StatefulWidget {
  const PostOpeningScreen({super.key});

  @override
  State<PostOpeningScreen> createState() => _PostOpeningScreenState();
}

class _PostOpeningScreenState extends State<PostOpeningScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  
  // Form Controllers
  final _titleController = TextEditingController();
  final _areaController = TextEditingController();
  final _rewardController = TextEditingController();
  final _slotsController = TextEditingController();
  
  String _selectedCategory = 'Ceremony';
  String _selectedCity = 'Mumbai';
  
  final List<String> _categories = ['Ceremony', 'Seminar', 'Experience', 'Workshop'];
  final List<String> _cities = ['Mumbai', 'Delhi', 'Bangalore', 'Hyderabad', 'Pune'];

  @override
  void dispose() {
    _titleController.dispose();
    _areaController.dispose();
    _rewardController.dispose();
    _slotsController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _handlePublish();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _handlePublish() {
    // Mock publish logic
    Navigator.pop(context);
    AppFeedback.success(context, 'Opening Published Successfully!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Opening',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          _buildStepProgress(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildCurrentStepView(),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildStepProgress() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(3, (index) {
          final isCompleted = _currentStep > index;
          final isActive = _currentStep == index;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isCompleted || isActive ? Colors.black : Colors.grey[200],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStepView() {
    switch (_currentStep) {
      case 0: return _buildEventDetailsStep();
      case 1: return _buildLocationStep();
      case 2: return _buildRecruitmentStep();
      default: return const SizedBox();
    }
  }

  Widget _buildEventDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Event Details', 'What kind of opening are you hosting?'),
        const SizedBox(height: 24),
        _buildTextField('opening Title', 'e.g., Grand Store Launch', _titleController),
        const SizedBox(height: 24),
        const Text('Category', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _categories.map((cat) {
            final isSelected = _selectedCategory == cat;
            return ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (val) => setState(() => _selectedCategory = cat),
              selectedColor: Colors.black,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              backgroundColor: Colors.grey[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        _buildTextField('Date & Time', 'e.g., 20th March, 4:00 PM onwards', null),
      ],
    );
  }

  Widget _buildLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Location', 'Where is the event taking place?'),
        const SizedBox(height: 24),
        const Text('Select City', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCity,
              isExpanded: true,
              items: _cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
              onChanged: (val) => setState(() => _selectedCity = val!),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildTextField('Area / Venue', 'e.g., Bandra West, Near Carter Road', _areaController),
      ],
    );
  }

  Widget _buildRecruitmentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Recruitment', 'Set your influencer budget and slots.'),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildTextField('Total Slots', 'e.g., 10', _slotsController, isNumber: true)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Reward', 'e.g., ₹2,500', _rewardController)),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Perks (Custom)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFDCFCE7)),
          ),
          child: Row(
            children: const [
              Icon(Icons.auto_awesome_rounded, color: Color(0xFF16A34A), size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Exclusive access to premium creators for this opening.',
                  style: TextStyle(color: Color(0xFF15803D), fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController? controller, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[300], fontSize: 14),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[100]!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                onPressed: _prevStep,
                icon: const Icon(Icons.arrow_back_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          Expanded(
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                _currentStep == 2 ? 'Publish Opening' : 'Continue',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
