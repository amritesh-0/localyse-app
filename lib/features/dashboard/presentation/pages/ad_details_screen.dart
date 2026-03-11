import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/influencer_models.dart';

import '../../data/services/campaign_service.dart';
import 'submit_proof_screen.dart';
import 'chat_screen.dart';

class AdDetailsScreen extends StatefulWidget {
  final AdCampaign ad;

  const AdDetailsScreen({super.key, required this.ad});

  @override
  State<AdDetailsScreen> createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  final _campaignService = CampaignService();
  late AdStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.ad.status;
    _campaignService.addListener(_handleServiceUpdate);
  }

  @override
  void dispose() {
    _campaignService.removeListener(_handleServiceUpdate);
    super.dispose();
  }

  void _handleServiceUpdate() {
    final updatedAd = _campaignService.campaigns.firstWhere((c) => c.id == widget.ad.id, orElse: () => widget.ad);
    if (mounted && updatedAd.status != _currentStatus) {
      setState(() {
        _currentStatus = updatedAd.status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Campaign Details',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -0.5),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      bottomNavigationBar: _buildPremiumBottomBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPremiumHeader(),
            const SizedBox(height: 32),
            _buildInfoCard(),
            const SizedBox(height: 32),
            _buildSectionHeader('About Campaign'),
            const SizedBox(height: 12),
            Text(
              widget.ad.description,
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.8),
                fontSize: 15,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Requirements'),
            const SizedBox(height: 16),
            ...widget.ad.requirements.map(_buildRequirementItem),
            if (_currentStatus == AdStatus.paid || _currentStatus == AdStatus.pendingPayment) ...[
              const SizedBox(height: 32),
              _buildSectionHeader('Transaction Details'),
              const SizedBox(height: 16),
              _buildTransactionDetails(),
            ],
            const SizedBox(height: 120), // Space for bottom bar
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatusBadge(_currentStatus),
            if (widget.ad.deadline != null)
              Text(
                'Ends in 2 days',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  widget.ad.brandLogo,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.ad.brandName,
                        style: TextStyle(
                          color: AppColors.primary.withOpacity(0.8),
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.verified_rounded, size: 14, color: AppColors.primary.withOpacity(0.8)),
                    ],
                  ),
                  Text(
                    widget.ad.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(AdStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case AdStatus.available: color = const Color(0xFF10B981); text = 'Open to Apply'; break;
      case AdStatus.applied: color = const Color(0xFFF59E0B); text = 'Pending Review'; break;
      case AdStatus.approved: color = const Color(0xFF7C3AED); text = 'Approved'; break;
      case AdStatus.ongoing: color = const Color(0xFF3B82F6); text = 'Active Campaign'; break;
      case AdStatus.pendingPayment: color = const Color(0xFFEC4899); text = 'Verifying Work'; break;
      case AdStatus.paid: color = const Color(0xFF10B981); text = 'Payment Received'; break;
      default: color = Colors.grey; text = 'Closed';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildRequirementItem(String requirement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[100] ?? Colors.grey),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: AppColors.primary, size: 16),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                requirement,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey[50] ?? Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem('PAYOUT', '\$${widget.ad.payout.toStringAsFixed(0)}', Icons.payments_rounded),
          Container(height: 40, width: 1, color: Colors.grey[100]),
          _buildInfoItem('LOCATION', widget.ad.location, Icons.location_on_rounded),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.5),
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumBottomBar(BuildContext context) {
    if (_currentStatus == AdStatus.paid) {
      return Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        decoration: const BoxDecoration(color: Colors.white),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.receipt_long_rounded),
          label: const Text('Download Payment Receipt'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 64),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStatus != AdStatus.available)
            Expanded(
              flex: 2,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen(ad: widget.ad)),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  side: BorderSide(color: Colors.grey[200] ?? Colors.grey),
                  foregroundColor: Colors.black,
                ),
                child: const Icon(Icons.chat_bubble_rounded, size: 20),
              ),
            ),
          if (_currentStatus != AdStatus.available) const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: _buildMainActionButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMainActionButton(BuildContext context) {
    switch (_currentStatus) {
      case AdStatus.available:
        return ElevatedButton(
          onPressed: () {
            _campaignService.updateCampaignStatus(widget.ad.id, AdStatus.applied);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Applied successfully!')));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
          ),
          child: const Text('Apply Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
        );
      case AdStatus.applied:
        return ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[100],
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Application Pending', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w800)),
        );
      case AdStatus.approved:
        return ElevatedButton(
          onPressed: () {
            _campaignService.updateCampaignStatus(widget.ad.id, AdStatus.ongoing);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Start Campaign', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
        );
      case AdStatus.ongoing:
        return ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SubmitProofScreen(ad: widget.ad)),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Submit Proof', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
        );
      case AdStatus.pendingPayment:
        return ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[100],
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey[400])),
              const SizedBox(width: 12),
              const Text('Verifying Content...', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w800)),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTransactionDetails() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100] ?? Colors.grey),
      ),
      child: Column(
        children: [
          _buildDetailRow('Amount', _currentStatus == AdStatus.paid ? '\$${widget.ad.payout.toStringAsFixed(2)}' : 'Processing...', _currentStatus == AdStatus.paid ? const Color(0xFF10B981) : Colors.black),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
          _buildDetailRow('Status', _currentStatus == AdStatus.paid ? 'Completed' : 'Pending Verification', _currentStatus == AdStatus.paid ? const Color(0xFF10B981) : const Color(0xFFF59E0B)),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
          _buildDetailRow('Date', widget.ad.paymentDate != null ? 'Mar 11, 2026' : 'TBD', Colors.black),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
          _buildDetailRow('Ref ID', 'CAM-8829-PX', Colors.grey[600] ?? Colors.grey),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w700)),
        Text(value, style: TextStyle(color: valueColor, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: -0.2)),
      ],
    );
  }
}
