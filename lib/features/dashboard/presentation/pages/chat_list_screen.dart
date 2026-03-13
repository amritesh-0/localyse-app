import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/influencer_models.dart';
import '../../data/services/campaign_service.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
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
    final activeCampaigns = _campaignService.campaigns.where((ad) {
      return ad.status == AdStatus.approved ||
          ad.status == AdStatus.ongoing ||
          ad.status == AdStatus.pendingPayment ||
          ad.status == AdStatus.paid;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildPremiumHeader(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: _buildSearchBar(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: _campaignService.isLoading && activeCampaigns.isEmpty
                ? const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : activeCampaigns.isEmpty
                    ? SliverFillRemaining(child: _buildEmptyState())
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildChatTile(context, activeCampaigns[index]),
                          childCount: activeCampaigns.length,
                        ),
                      ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      pinned: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      title: const Text(
        'Direct Messages',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w900,
          fontSize: 18,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search conversations...',
          hintStyle: TextStyle(
            color: Colors.grey[300],
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[400], size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.chat_bubble_outline_rounded, size: 48, color: Colors.grey[200]),
          ),
          const SizedBox(height: 24),
          const Text(
            'Quiet in here...',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Text(
            'Approved and active campaigns show up here.',
            style: TextStyle(fontSize: 14, color: Colors.grey[400], fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(BuildContext context, AdCampaign ad) {
    final String preview = ad.status == AdStatus.pendingPayment
        ? 'We are reviewing your proof submission.'
        : ad.status == AdStatus.paid
            ? 'Payment has been settled for this campaign.'
            : 'Campaign coordination and brief updates appear here.';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey[50]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ChatScreen(ad: ad)),
          ),
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(22),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ad.brandName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: Colors.black,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            _statusLabel(ad.status),
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        preview,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _statusLabel(AdStatus status) {
    switch (status) {
      case AdStatus.approved:
        return 'Approved';
      case AdStatus.ongoing:
        return 'Active';
      case AdStatus.pendingPayment:
        return 'Reviewing';
      case AdStatus.paid:
        return 'Paid';
      default:
        return 'Open';
    }
  }
}
