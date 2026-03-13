import 'package:flutter/material.dart';
import '../../../../core/utils/feedback_utils.dart';

class InfluencerDetailScreen extends StatelessWidget {
  final String name;
  final String niche;
  final String followers;
  final String engagement;

  const InfluencerDetailScreen({
    super.key,
    required this.name,
    required this.niche,
    required this.followers,
    required this.engagement,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 32),
                  _buildStatsRow(),
                  const SizedBox(height: 40),
                  _buildSectionHeader('About Creator'),
                  const SizedBox(height: 12),
                  _buildBio(),
                  const SizedBox(height: 40),
                  _buildSectionHeader('Social Connectivity'),
                  const SizedBox(height: 16),
                  _buildSocialConnectivity(),
                  const SizedBox(height: 40),
                  _buildSectionHeader('Recent Collaborations'),
                  const SizedBox(height: 16),
                  _buildCollabGallery(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomBar(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          'https://api.dicebear.com/7.x/avataaars/png?seed=$name',
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
            child: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  niche.toUpperCase(),
                  style: const TextStyle(color: Color(0xFF16A34A), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.0),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: -0.5),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF16A34A), borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.verified_rounded, color: Colors.white, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Row(
          children: [
            Icon(Icons.location_on_rounded, size: 14, color: Colors.grey),
            SizedBox(width: 4),
            Text('Mumbai, Maharashtra', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatItem(followers, 'Followers'),
        _buildVerticalDivider(),
        _buildStatItem(engagement, 'Engagement'),
        _buildVerticalDivider(),
        _buildStatItem('120+', 'Sponsored'),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black)),
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 24, width: 1, color: Colors.grey[200]);
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black));
  }

  Widget _buildBio() {
    return Text(
      'Fashion forward creator with a passion for sustainable style. I love working with brands that value authenticity and high-quality storytelling.',
      style: TextStyle(color: Colors.grey[600], fontSize: 15, height: 1.6, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildSocialConnectivity() {
    return Row(
      children: [
        _buildSocialIcon(Icons.camera_alt_rounded, 'Instagram', Colors.pink),
        const SizedBox(width: 12),
        _buildSocialIcon(Icons.play_circle_fill_rounded, 'YouTube', Colors.red),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCollabGallery() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=200&q=80'),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.bookmark_border_rounded, color: Colors.black),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _showCampaignInviteModal(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Invite to Campaign', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _showCampaignInviteModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select Campaign', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Invite $name to one of your active campaigns.', style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 32),
            _buildCampaignItem(context, 'Summer Lookbook 2026', 'Barter', Icons.checkroom_rounded),
            _buildCampaignItem(context, 'Morning Routine Series', '₹450.00', Icons.wb_sunny_rounded),
            _buildCampaignItem(context, 'Sustainable Lifestyle', '₹1,200.00', Icons.eco_rounded),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignItem(BuildContext context, String title, String type, IconData campaignIcon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          _showInvitationSentSuccess(context);
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey[100]!),
          ),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Center(child: Icon(campaignIcon, color: Colors.black87)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(type, style: TextStyle(color: const Color(0xFF16A34A), fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.black26),
            ],
          ),
        ),
      ),
    );
  }

  void _showInvitationSentSuccess(BuildContext context) {
    AppFeedback.success(context, 'Invite Sent! Influence $name has been notified.');
  }
}
