import 'package:flutter/material.dart';

import '../../data/models/influencer_models.dart';
import '../../data/services/campaign_service.dart';

class EarningHistoryScreen extends StatefulWidget {
  const EarningHistoryScreen({super.key});

  @override
  State<EarningHistoryScreen> createState() => _EarningHistoryScreenState();
}

class _EarningHistoryScreenState extends State<EarningHistoryScreen> {
  final CampaignService _campaignService = CampaignService();

  @override
  void initState() {
    super.initState();
    _campaignService.addListener(_handleUpdate);
  }

  @override
  void dispose() {
    _campaignService.removeListener(_handleUpdate);
    super.dispose();
  }

  void _handleUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<AdCampaign> campaigns = _campaignService.campaigns
        .where((campaign) =>
            campaign.status == AdStatus.paid ||
            campaign.status == AdStatus.pendingPayment ||
            campaign.status == AdStatus.ongoing ||
            campaign.status == AdStatus.approved)
        .toList()
      ..sort((left, right) {
        final DateTime leftDate =
            left.paymentDate ?? left.proofSubmittedDate ?? left.deadline ?? DateTime.now();
        final DateTime rightDate =
            right.paymentDate ?? right.proofSubmittedDate ?? right.deadline ?? DateTime.now();
        return rightDate.compareTo(leftDate);
      });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
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
        title: const Text(
          'Earning History',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -0.5),
        ),
        centerTitle: true,
      ),
      body: _campaignService.isLoading && campaigns.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : campaigns.isEmpty
              ? Center(
                  child: Text(
                    'No earning records yet.',
                    style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(24),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const Text(
                      'Payout Timeline',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'A full record of your approved, active, and settled campaign earnings.',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...campaigns.map(_buildEarningTile),
                  ],
                ),
    );
  }

  Widget _buildEarningTile(AdCampaign campaign) {
    final bool isPaid = campaign.status == AdStatus.paid;
    final String stateLabel = isPaid
        ? 'Paid'
        : campaign.status == AdStatus.pendingPayment
            ? 'Pending verification'
            : campaign.status == AdStatus.ongoing
                ? 'Active'
                : 'Approved';
    final DateTime? referenceDate =
        campaign.paymentDate ?? campaign.proofSubmittedDate ?? campaign.deadline;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
            child: Center(
              child: Text(
                campaign.brandLogo,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign.title,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.black),
                ),
                Text(
                  '$stateLabel • ${_formatDate(referenceDate)}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${campaign.payout.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: isPaid ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                ),
              ),
              Text(
                isPaid ? 'Paid' : 'Pending',
                style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Awaiting update';
    }
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
