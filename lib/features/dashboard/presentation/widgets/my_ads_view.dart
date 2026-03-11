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
      child: Scaffold(
        backgroundColor: Colors.grey[50], // Seamless light background
        body: Column(
          children: [
            _buildSeamlessHeader(),
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
      ),
    );
  }

  Widget _buildSeamlessHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Campaigns',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 24),
          _buildFloatingTabBar(),
        ],
      ),
    );
  }

  Widget _buildFloatingTabBar() {
    final pendingCount = _campaignService.campaigns.where((ad) => ad.status == AdStatus.applied).length;
    final activeCount = _campaignService.campaigns.where((ad) => 
      ad.status == AdStatus.approved || 
      ad.status == AdStatus.ongoing || 
      ad.status == AdStatus.pendingPayment
    ).length;
    final pastCount = _campaignService.campaigns.where((ad) => 
      ad.status == AdStatus.completed || 
      ad.status == AdStatus.paid || 
      ad.status == AdStatus.rejected
    ).length;

    return Container(
      height: 58,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[500],
        labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: [
          _buildTab('Pending', pendingCount),
          _buildTab('Active', activeCount),
          _buildTab('Past', pastCount),
        ],
      ),
    );
  }

  Tab _buildTab(String label, int count) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$count',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
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

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 120),
      itemCount: filteredAds.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => _buildPremiumMyAdCard(context, filteredAds[index]),
    );
  }

  Widget _buildPremiumMyAdCard(BuildContext context, AdCampaign ad) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(32),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdDetailsScreen(ad: ad),
              ),
            );
          },
          borderRadius: BorderRadius.circular(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          ad.brandLogo,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
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
                            ad.brandName.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ad.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: Colors.black,
                              letterSpacing: -0.5,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildModernStatusBadge(ad.status),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.payments_rounded, size: 16, color: Colors.black),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ad.status == AdStatus.paid ? 'PAYMENT RECEIVED' : 'ESTIMATED PAYOUT',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              Text(
                                '\$${ad.payout.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                  color: ad.status == AdStatus.paid ? const Color(0xFF10B981) : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildActionButtonForStatus(ad),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtonForStatus(AdCampaign ad) {
    switch (ad.status) {
      case AdStatus.applied:
        return _buildActionPill('Chat', Icons.chat_bubble_rounded, Colors.black, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(ad: ad)));
        });
      case AdStatus.approved:
        return _buildActionPill('Start', Icons.play_arrow_rounded, AppColors.primary, () {});
      case AdStatus.ongoing:
        return _buildActionPill('Submit', Icons.upload_file_rounded, AppColors.primary, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitProofScreen(ad: ad)));
        });
      case AdStatus.pendingPayment:
        return _buildActionPill('Verifying', Icons.hourglass_top_rounded, Colors.grey[600]!, () {});
      case AdStatus.paid:
        return _buildActionPill('Receipt', Icons.receipt_long_rounded, Colors.grey[800]!, () {});
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActionPill(String label, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernStatusBadge(AdStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case AdStatus.applied:
        color = const Color(0xFFF59E0B);
        text = 'PENDING';
        break;
      case AdStatus.approved:
        color = const Color(0xFF7C3AED);
        text = 'APPROVED';
        break;
      case AdStatus.ongoing:
        color = const Color(0xFF3B82F6);
        text = 'ACTIVE';
        break;
      case AdStatus.pendingPayment:
        color = const Color(0xFFEC4899);
        text = 'VERIFYING';
        break;
      case AdStatus.paid:
        color = const Color(0xFF10B981);
        text = 'PAID';
        break;
      case AdStatus.rejected:
        color = const Color(0xFFEF4444);
        text = 'CLOSED';
        break;
      default:
        color = Colors.grey;
        text = 'UNKNOWN';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
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
        sub = 'Your pending requests will appear here.';
        icon = Icons.hourglass_empty_rounded;
        break;
      case AdStatus.ongoing: 
        title = 'No Active Ads'; 
        sub = 'Get started with a new campaign!';
        icon = Icons.auto_awesome_rounded;
        break;
      case AdStatus.completed: 
        title = 'No History'; 
        sub = 'Your past successes will show up here.';
        icon = Icons.history_rounded;
        break;
      default: 
        title = 'Empty'; 
        sub = 'Nothing here yet';
        icon = Icons.inbox_rounded;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(icon, size: 48, color: Colors.grey[200]),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            sub,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
