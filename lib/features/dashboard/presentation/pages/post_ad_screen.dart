import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PostAdScreen extends StatefulWidget {
  const PostAdScreen({super.key});

  @override
  State<PostAdScreen> createState() => _PostAdScreenState();
}

class _PostAdScreenState extends State<PostAdScreen> {
  String campaignType = 'Paid';
  String locationType = 'Cities';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _reqController = TextEditingController();

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
          'Create Campaign',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: -0.5),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextButton(
              onPressed: () {
                // Mock success and go back
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Campaign Posted Successfully!')),
                );
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Post', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Visual Identity'),
            const SizedBox(height: 16),
            _buildPosterUploadMock(),
            const SizedBox(height: 32),
            _buildSectionHeader('Campaign Details'),
            const SizedBox(height: 16),
            _buildTextField('Campaign Name', 'e.g. Summer Beach Collection', _nameController),
            const SizedBox(height: 16),
            _buildTextField('Description', 'What is this campaign about?', _descController, maxLines: 4),
            const SizedBox(height: 32),
            _buildSectionHeader('Campaign Type'),
            const SizedBox(height: 16),
            _buildTypeSelector(),
            if (campaignType == 'Paid') ...[
              const SizedBox(height: 16),
              _buildTextField('Budget per Influencer', 'Enter amount in USD', _amountController, keyboardType: TextInputType.number),
            ] else ...[
              const SizedBox(height: 16),
              _buildTextField('Product for Barter', 'e.g. Organic Face Wash Set', _productController),
            ],
            const SizedBox(height: 32),
            _buildSectionHeader('Target Location'),
            const SizedBox(height: 16),
            _buildLocationSelector(),
            if (locationType == 'Cities') ...[
              const SizedBox(height: 16),
              _buildTextField('Selected Cities', 'e.g. Mumbai, Delhi, Bangalore', TextEditingController()),
            ],
            const SizedBox(height: 32),
            _buildSectionHeader('Requirements'),
            const SizedBox(height: 16),
            _buildTextField('What do you expect?', 'e.g. 1 Reel, 2 Stories, Must tag brand', _reqController, maxLines: 3),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: Colors.grey[400],
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildPosterUploadMock() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!, width: 2, style: BorderStyle.solid), // In a real app, use dashed border
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_rounded, size: 32, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'Upload Campaign Poster',
            style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            'Recommended 1080x1350px',
            style: TextStyle(color: Colors.grey[300], fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.w500),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.all(20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey[100]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.black, width: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: [
        _buildChoiceChip('Paid', Icons.payments_rounded),
        const SizedBox(width: 12),
        _buildChoiceChip('Barter', Icons.inventory_2_rounded),
      ],
    );
  }

  Widget _buildLocationSelector() {
    return Row(
      children: [
        _buildLocationChip('Cities', Icons.location_city_rounded),
        const SizedBox(width: 12),
        _buildLocationChip('All India', Icons.public_rounded),
      ],
    );
  }

  Widget _buildChoiceChip(String label, IconData icon) {
    final isSelected = campaignType == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => campaignType = label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? Colors.black : Colors.grey[200]!),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.black54),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationChip(String label, IconData icon) {
    final isSelected = locationType == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => locationType = label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? Colors.black : Colors.grey[200]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.black54),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
