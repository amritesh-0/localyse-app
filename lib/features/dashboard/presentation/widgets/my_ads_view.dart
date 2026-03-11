import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/influencer_models.dart';
import '../pages/ad_details_screen.dart';
import '../../data/services/campaign_service.dart';
import '../pages/submit_proof_screen.dart';
import '../pages/chat_screen.dart';

class MyAdsView extends StatefulWidget {
  const MyAdsView({super.key});

  @override
  State<MyAdsView> createState() => _MyAdsViewState();
}

class _MyAdsViewState extends State<MyAdsView> {
  final _campaignService = CampaignService();

  @override
  void initState() {
    super.initState();
    _campaignService.addListener(_handleServiceUpdate);
  }

  @override
  void dispose() {
    _campaignService.removeListener(_handleServiceUpdate);
    super.dispose();
  }

  void _handleServiceUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          _buildPremiumTabBarHeader(),
          Expanded(
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildAdsList(AdStatus.applied),
                _buildAdsList(AdStatus.ongoing),
                _buildAdsList(AdStatus.completed),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumTabBarHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Campaigns',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 52,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary.withOpacity(0.7),
              labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.2),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: 'Pending (${_campaignService.campaigns.where((ad) => ad.status == AdStatus.applied).length})'),
                Tab(text: 'Active (${_campaignService.campaigns.where((ad) => ad.status == AdStatus.approved || ad.status == AdStatus.ongoing || ad.status == AdStatus.pendingPayment).length})'),
                Tab(text: 'Past (${_campaignService.campaigns.where((ad) => ad.status == AdStatus.completed || ad.status == AdStatus.paid || ad.status == AdStatus.rejected).length})'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdsList(AdStatus tabStatus) {
    final List<AdCampaign> allAds = _campaignService.campaigns;
    final List<AdCampaign> filteredAds;

    switch (tabStatus) {
      case AdStatus.applied: // Pending
        filteredAds = allAds.where((ad) => ad.status == AdStatus.applied).toList();
        break;
      case AdStatus.ongoing: // Active
        filteredAds = allAds.where((ad) => 
          ad.status == AdStatus.approved || 
          ad.status == AdStatus.ongoing || 
          ad.status == AdStatus.pendingPayment
        ).toList();
        break;
      case AdStatus.completed: // Past
        filteredAds = allAds.where((ad) => 
          ad.status == AdStatus.completed || 
          ad.status == AdStatus.paid || 
          ad.status == AdStatus.rejected
        ).toList();
        break;
      default:
        filteredAds = [];
    }

    if (filteredAds.isEmpty) {
      return _buildEmptyState(tabStatus);
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
      itemCount: filteredAds.length,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) => _buildEnhancedMyAdCard(context, filteredAds[index]),
    );
  }

  Widget _buildEnhancedMyAdCard(BuildContext context, AdCampaign ad) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey.shade50),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdDetailsScreen(ad: ad),
            ),
          );
        },
        borderRadius: BorderRadius.circular(28),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        ad.brandLogo,
                        style: const TextStyle(
                          color: AppColors.primary,
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
                          ad.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          ad.brandName,
                          style: TextStyle(
                            color: AppColors.textSecondary.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildModernStatusBadge(ad.status),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.payments_rounded,
                            size: 16,
                            color: AppColors.primary.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ad.status == AdStatus.paid ? 'Payment Received' : 'Estimated Payout',
                              style: TextStyle(
                                color: AppColors.textSecondary.withOpacity(0.6),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              '\$${ad.payout.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: ad.status == AdStatus.paid ? const Color(0xFF10B981) : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _buildActionButtonForStatus(ad),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtonForStatus(AdCampaign ad) {
    switch (ad.status) {
      case AdStatus.applied:
        return _buildPillButton('Chat', Icons.chat_bubble_rounded, Colors.black, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen(ad: ad)),
          );
        });
      case AdStatus.approved:
        return _buildPillButton('Get Started', Icons.play_arrow_rounded, AppColors.primary, () {});
      case AdStatus.ongoing:
        return _buildPillButton('Submit Proof', Icons.upload_file_rounded, AppColors.primary, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SubmitProofScreen(ad: ad)),
          );
        });
      case AdStatus.pendingPayment:
        return _buildPillButton('Verifying...', Icons.hourglass_top_rounded, Colors.grey[700] ?? Colors.grey, () {});
      case AdStatus.paid:
        return _buildPillButton('Receipt', Icons.receipt_long_rounded, Colors.grey[800] ?? Colors.grey, () {});
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPillButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
    );
  }

  Widget _buildModernStatusBadge(AdStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case AdStatus.applied:
        color = const Color(0xFFF59E0B);
        text = 'Pending';
        break;
      case AdStatus.approved:
        color = const Color(0xFF7C3AED);
        text = 'Approved';
        break;
      case AdStatus.ongoing:
        color = const Color(0xFF3B82F6);
        text = 'Active';
        break;
      case AdStatus.pendingPayment:
        color = const Color(0xFFEC4899);
        text = 'Verifying';
        break;
      case AdStatus.paid:
        color = const Color(0xFF10B981);
        text = 'Paid';
        break;
      case AdStatus.rejected:
        color = const Color(0xFFEF4444);
        text = 'Closed';
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildEmptyState(AdStatus status) {
    String title = '';
    String sub = '';
    IconData icon;

    switch (status) {
      case AdStatus.applied: 
        title = 'No Applications'; 
        sub = 'Your pending campaign requests will appear here.';
        icon = Icons.hourglass_empty_rounded;
        break;
      case AdStatus.ongoing: 
        title = 'No Active Campaigns'; 
        sub = 'Find campaigns in discovery to get started!';
        icon = Icons.auto_awesome_rounded;
        break;
      case AdStatus.completed: 
        title = 'Clean Slate'; 
        sub = 'You haven\'t completed any campaigns yet.';
        icon = Icons.history_rounded;
        break;
      default: 
        title = 'Empty'; 
        sub = 'Nothing here yet';
        icon = Icons.inbox_rounded;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              sub,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
