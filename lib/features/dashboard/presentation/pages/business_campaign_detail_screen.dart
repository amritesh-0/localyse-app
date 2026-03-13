import 'package:flutter/material.dart';
import '../pages/business_payment_screen.dart';
import '../pages/business_rating_screen.dart';

class BusinessCampaignDetailScreen extends StatelessWidget {
  final Map<String, dynamic> campaign;

  const BusinessCampaignDetailScreen({
    super.key,
    required this.campaign,
  });

  @override
  Widget build(BuildContext context) {
    final status = campaign['status'] ?? 'Active';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Campaign Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share_rounded, color: Colors.black), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCampaignPoster(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleAndStatus(),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Key Performance'),
                  const SizedBox(height: 16),
                  _buildMetricsRow(),
                  const SizedBox(height: 32),
                  if (status == 'Active') ...[
                    _buildSectionHeader('Influencer Applicants'),
                    const SizedBox(height: 16),
                    _buildApplicantsList(),
                  ] else ...[
                    _buildSectionHeader('Influencer Contribution'),
                    const SizedBox(height: 16),
                    _buildInfluencerContribution(context),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignPoster() {
    return Container(
      width: double.infinity,
      height: 240,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(32),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1523381235312-8388cb72fb9f?auto=format&fit=crop&w=800&q=80'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTitleAndStatus() {
    final status = campaign['status'] ?? 'Active';
    final title = campaign['title'] ?? 'Campaign Title';
    final desc = campaign['desc'] ?? 'No description provided.';

    Color statusColor = const Color(0xFF3B82F6);
    if (status == 'Ongoing') statusColor = const Color(0xFFF59E0B);
    if (status == 'Completed') statusColor = const Color(0xFF16A34A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: -0.5),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          desc,
          style: TextStyle(color: Colors.grey[500], fontSize: 14, height: 1.5, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black),
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      children: [
        _buildMetricItem('124K', 'Total Reach', Icons.groups_rounded, const Color(0xFF7C3AED)),
        const SizedBox(width: 16),
        _buildMetricItem('8.2K', 'Engagements', Icons.favorite_rounded, const Color(0xFFEF4444)),
      ],
    );
  }

  Widget _buildMetricItem(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.1), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black)),
                Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicantsList() {
    return Column(
      children: [
        _buildApplicantCard('Sanya Malhotra', '120K Followers', '4.5% Engagement'),
        _buildApplicantCard('Vikram Singh', '85K Followers', '5.2% Engagement'),
        _buildApplicantCard('Ananya Iyer', '210K Followers', '3.8% Engagement'),
      ],
    );
  }

  Widget _buildApplicantCard(String name, String followers, String eng) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=$name'),
            backgroundColor: Colors.grey[100],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Colors.black)),
                Text('$followers • $eng', style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Hire', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfluencerContribution(BuildContext context) {
    final influencerName = campaign['influencer'] ?? 'Rohan Sharma';
    final status = campaign['status'] ?? 'Ongoing';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=$influencerName'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(influencerName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  Text('Campaign Lead', style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Submitted Content', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildContentThumbnail('https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=200'),
              const SizedBox(width: 12),
              _buildContentThumbnail('https://images.unsplash.com/photo-1539109132382-381bb3f1c2b5?w=200'),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'The influencer has posted the required reel and stories. Performance metrics are updated in the overview.',
            style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.5, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          if (status == 'Ongoing')
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BusinessPaymentScreen(
                        campaignTitle: campaign['title'],
                        amount: campaign['fee'] ?? '\$0',
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF16A34A), width: 2),
                  foregroundColor: const Color(0xFF16A34A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Make Payment', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          if (status == 'Completed')
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BusinessRatingScreen(
                        influencerName: influencerName,
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  side: const BorderSide(color: Colors.black, width: 2),
                ),
                child: const Text('Rate Performance', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContentThumbnail(String url) {
    return Container(
      width: 80,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
      child: Center(
        child: Icon(Icons.play_circle_fill_rounded, color: Colors.white.withOpacity(0.8), size: 24),
      ),
    );
  }
}
