import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/influencer_models.dart';
import '../../data/services/campaign_service.dart';

class SubmitProofScreen extends StatefulWidget {
  final AdCampaign ad;

  const SubmitProofScreen({super.key, required this.ad});

  @override
  State<SubmitProofScreen> createState() => _SubmitProofScreenState();
}

class _SubmitProofScreenState extends State<SubmitProofScreen> {
  final _campaignService = CampaignService();
  final _linkController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _linkController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_linkController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide at least one campaign link')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    _campaignService.updateCampaignStatus(widget.ad.id, AdStatus.pendingPayment);
    
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Proof submitted successfully! We\'ll notify you once verified.'),
          backgroundColor: AppColors.success,
        ),
      );
    }
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
          'Submit Proof',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCampaignBrief(),
              const SizedBox(height: 32),
              _buildSectionTitle('CAMPAIGN CONTENT LINKS'),
              const SizedBox(height: 12),
              _buildLinkInput(),
              const SizedBox(height: 24),
              _buildSectionTitle('SCREENSHOTS (OPTIONAL)'),
              const SizedBox(height: 12),
              _buildFileUploadArea(),
              const SizedBox(height: 24),
              _buildSectionTitle('ADDITIONAL NOTES'),
              const SizedBox(height: 12),
              _buildNotesInput(),
              const SizedBox(height: 40),
              _buildGuidelines(),
              const SizedBox(height: 100), // Space for fab-like button
            ],
          ),
        ),
      ),
      bottomSheet: _buildBottomActions(),
    );
  }

  Widget _buildCampaignBrief() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.ad.brandLogo,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.ad.brandName,
                  style: TextStyle(
                    color: AppColors.primary.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  widget.ad.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildLinkInput() {
    return TextField(
      controller: _linkController,
      decoration: InputDecoration(
        hintText: 'Paste your post or video link here...',
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIcon: Icon(Icons.link_rounded, color: AppColors.primary.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey[100] ?? Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildFileUploadArea() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey[200] ?? Colors.grey,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(Icons.cloud_upload_rounded, color: AppColors.primary, size: 32),
          ),
          const SizedBox(height: 16),
          const Text(
            'Upload screenshots or videos',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            'Max file size: 10MB',
            style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesInput() {
    return TextField(
      controller: _notesController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Any specific details about your post...',
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey[100] ?? Colors.grey),
        ),
      ),
    );
  }

  Widget _buildGuidelines() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.lightbulb_outline_rounded, color: Colors.amber, size: 18),
              SizedBox(width: 8),
              Text(
                'Submission Guidelines',
                style: TextStyle(fontWeight: FontWeight.w900, color: Colors.amber, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _guildlineItem('Ensure links are public and accessible.'),
          _guildlineItem('Posts must remain live for at least 30 days.'),
          _guildlineItem('Show accurate engagement metrics in screenshots.'),
        ],
      ),
    );
  }

  Widget _guildlineItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.amber.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
              )
            : const Text(
                'Submit for Review',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
              ),
      ),
    );
  }
}
