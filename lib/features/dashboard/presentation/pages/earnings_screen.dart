import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/influencer_models.dart';
import '../../data/services/campaign_service.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
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
    final List<AdCampaign> campaigns = _campaignService.campaigns;
    final List<AdCampaign> paidCampaigns =
        campaigns.where((campaign) => campaign.status == AdStatus.paid).toList();
    final List<AdCampaign> lockedCampaigns = campaigns
        .where((campaign) =>
            campaign.status == AdStatus.pendingPayment ||
            campaign.status == AdStatus.ongoing ||
            campaign.status == AdStatus.approved)
        .toList();
    final DateTime now = DateTime.now();
    final double totalBalance =
        paidCampaigns.fold<double>(0, (sum, campaign) => sum + campaign.payout);
    final double monthlyRevenue = paidCampaigns
        .where((campaign) =>
            campaign.paymentDate != null &&
            campaign.paymentDate!.year == now.year &&
            campaign.paymentDate!.month == now.month)
        .fold<double>(0, (sum, campaign) => sum + campaign.payout);
    final double lockedAmount = lockedCampaigns.fold<double>(
      0,
      (sum, campaign) => sum + campaign.payout,
    );
    final List<AdCampaign> activity = List<AdCampaign>.from(campaigns)
      ..sort((left, right) {
        final DateTime leftDate =
            left.paymentDate ?? left.proofSubmittedDate ?? left.deadline ?? now;
        final DateTime rightDate =
            right.paymentDate ?? right.proofSubmittedDate ?? right.deadline ?? now;
        return rightDate.compareTo(leftDate);
      });

    return Scaffold(
      backgroundColor: Colors.white,
      body: _campaignService.isLoading && campaigns.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Earnings',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Track settled payouts, locked amounts, and campaign revenue in one place.',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildWalletHeader(
                    totalBalance: totalBalance,
                    paidCampaignsCount: paidCampaigns.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        _buildSectionHeader('Performance'),
                        const SizedBox(height: 16),
                        _buildSummaryGrid(
                          monthlyRevenue: monthlyRevenue,
                          lockedAmount: lockedAmount,
                        ),
                        const SizedBox(height: 40),
                        _buildSectionHeader('Activity Log'),
                        const SizedBox(height: 20),
                        if (activity.isEmpty)
                          _buildEmptyState()
                        else
                          _buildTransactionList(activity.take(6).toList()),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildWalletHeader({
    required double totalBalance,
    required int paidCampaignsCount,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.primary, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_balance_wallet_rounded, color: AppColors.primary, size: 12),
                  SizedBox(width: 8),
                  Text(
                    'TOTAL BALANCE',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '₹${totalBalance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: -1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$paidCampaignsCount payouts settled',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: Colors.black,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSummaryGrid({
    required double monthlyRevenue,
    required double lockedAmount,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            label: 'This Month',
            amount: '₹${monthlyRevenue.toStringAsFixed(0)}',
            trend: 'Paid out',
            icon: Icons.auto_graph_rounded,
            color: const Color(0xFF6366F1),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            label: 'Locked',
            amount: '₹${lockedAmount.toStringAsFixed(0)}',
            trend: 'In progress',
            icon: Icons.lock_clock_rounded,
            color: const Color(0xFFF59E0B),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required String amount,
    required String trend,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 20),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                trend,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<AdCampaign> activity) {
    return Column(
      children: activity.map(_buildTransactionTile).toList(),
    );
  }

  Widget _buildTransactionTile(AdCampaign campaign) {
    final bool isCredit = campaign.status == AdStatus.paid;
    final String label = isCredit
        ? 'Paid'
        : campaign.status == AdStatus.pendingPayment
            ? 'Verifying'
            : campaign.status == AdStatus.ongoing
                ? 'Active'
                : 'Approved';
    final DateTime? referenceDate =
        campaign.paymentDate ?? campaign.proofSubmittedDate ?? campaign.deadline;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey[50]!),
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: isCredit ? Colors.grey[50] : Colors.amber[50],
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                campaign.brandLogo,
                style: TextStyle(
                  color: isCredit ? Colors.black : const Color(0xFFF59E0B),
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign.brandName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '${campaign.title} • ${_formatDate(referenceDate)}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : ''}₹${campaign.payout.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: isCredit ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        'Your payouts and earning activity will appear here.',
        style: TextStyle(
          color: Colors.grey[500],
          fontWeight: FontWeight.w600,
        ),
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
