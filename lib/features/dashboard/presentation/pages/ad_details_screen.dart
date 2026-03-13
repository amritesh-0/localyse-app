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
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Campaign Details',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -0.5, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildPremiumBottomBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 120), // Top padding for extendBodyBehindAppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPremiumHeroHeader(),
                  const SizedBox(height: 32),
                  _buildPremiumInfoRow(),
                  const SizedBox(height: 32),
                  _buildPremiumSectionCard(
                    title: 'About Campaign',
                    child: Text(
                      widget.ad.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildPremiumSectionCard(
                    title: 'Requirements',
                    child: Column(
                      children: widget.ad.requirements.map(_buildPremiumRequirementItem).toList(),
                    ),
                  ),
                  if (_currentStatus == AdStatus.paid || _currentStatus == AdStatus.pendingPayment) ...[
                    const SizedBox(height: 24),
                    _buildPremiumSectionCard(
                      title: 'Transaction Details',
                      child: _buildTransactionDetails(),
                    ),
                  ],
                  const SizedBox(height: 140), // Space for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumHeroHeader() {
    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.ad.brandLogo,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.verified_rounded, color: AppColors.primary, size: 24),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          widget.ad.brandName.toUpperCase(),
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.ad.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            letterSpacing: -1.0,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 20),
        _buildSleekStatusBadge(_currentStatus),
      ],
    );
  }

  Widget _buildSleekStatusBadge(AdStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case AdStatus.available: color = const Color(0xFF10B981); text = 'OPEN'; break;
      case AdStatus.applied: color = const Color(0xFFF59E0B); text = 'PENDING'; break;
      case AdStatus.approved: color = const Color(0xFF7C3AED); text = 'APPROVED'; break;
      case AdStatus.ongoing: color = const Color(0xFF3B82F6); text = 'ACTIVE'; break;
      case AdStatus.pendingPayment: color = const Color(0xFFEC4899); text = 'VERIFYING'; break;
      case AdStatus.paid: color = const Color(0xFF10B981); text = 'PAID'; break;
      default: color = Colors.grey; text = 'CLOSED';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildPremiumInfoRow() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            'PAYOUT',
            '₹${widget.ad.payout.toStringAsFixed(0)}',
            Icons.payments_rounded,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            'LOCATION',
            widget.ad.location,
            Icons.location_on_rounded,
            const Color(0xFF3B82F6),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildPremiumRequirementItem(String requirement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 12),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              requirement,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStatus != AdStatus.available)
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen(ad: widget.ad)),
                  );
                },
                icon: const Icon(Icons.chat_bubble_rounded, color: Colors.black, size: 20),
              ),
            ),
          if (_currentStatus != AdStatus.available) const SizedBox(width: 12),
          Expanded(child: _buildMainActionButton(context)),
        ],
      ),
    );
  }

  Widget _buildMainActionButton(BuildContext context) {
    switch (_currentStatus) {
      case AdStatus.available:
        return _buildLargeButton('Apply Now', AppColors.primary, () {
          _campaignService.updateCampaignStatus(widget.ad.id, AdStatus.applied);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Applied successfully!')));
        });
      case AdStatus.applied:
        return _buildLargeButton('Application Pending', Colors.grey[200]!, null, textColor: Colors.grey);
      case AdStatus.approved:
        return _buildLargeButton('Start Campaign', AppColors.primary, () {
          _campaignService.updateCampaignStatus(widget.ad.id, AdStatus.ongoing);
        });
      case AdStatus.ongoing:
        return _buildLargeButton('Submit Proof', Colors.black, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SubmitProofScreen(ad: widget.ad)),
          );
        });
      case AdStatus.pendingPayment:
        return _buildLargeButton('Verifying Content...', Colors.grey[200]!, null, textColor: Colors.grey);
      case AdStatus.paid:
        return _buildLargeButton('Download Receipt', Colors.black, () {});
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLargeButton(String label, Color color, VoidCallback? onTap, {Color textColor = Colors.white}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: onTap != null ? [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ] : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionDetails() {
    return Column(
      children: [
        _buildDetailRow('Amount', _currentStatus == AdStatus.paid ? '₹${widget.ad.payout.toStringAsFixed(2)}' : 'Processing...', _currentStatus == AdStatus.paid ? const Color(0xFF10B981) : Colors.black),
        const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: Color(0xFFF5F5F5))),
        _buildDetailRow('Status', _currentStatus == AdStatus.paid ? 'Completed' : 'Verifying', _currentStatus == AdStatus.paid ? const Color(0xFF10B981) : const Color(0xFFF59E0B)),
        const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: Color(0xFFF5F5F5))),
        _buildDetailRow('Date', widget.ad.paymentDate != null ? 'Mar 11, 2026' : 'TBD', Colors.black),
        const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: Color(0xFFF5F5F5))),
        _buildDetailRow('Ref ID', 'CAM-8829-PX', Colors.grey[400]!),
      ],
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
