import 'package:flutter/material.dart';
import '../pages/post_ad_screen.dart';
import '../pages/business_campaign_detail_screen.dart';

class BusinessCampaignsView extends StatefulWidget {
  const BusinessCampaignsView({super.key});

  @override
  State<BusinessCampaignsView> createState() => _BusinessCampaignsViewState();
}

class _BusinessCampaignsViewState extends State<BusinessCampaignsView> {
  int _selectedTabIndex = 0;
  String _selectedFilter = 'Latest';

  final List<Map<String, dynamic>> _allCampaigns = [
    {
      'title': 'Summer Beach Collection',
      'desc': 'Targeting Gen-Z for our new swimwear line.',
      'status': 'Active',
      'applicants': '12',
      'active': '0',
      'spent': '\$0',
      'type': 'Barter',
      'date': '12 Mar',
    },
    {
      'title': 'Morning Routine Series',
      'desc': 'Wellness campaign for skincare products.',
      'status': 'Active',
      'applicants': '8',
      'active': '2',
      'spent': '\$320',
      'type': 'Paid',
      'date': '10 Mar',
    },
    {
      'title': 'Tech Unboxing Series',
      'desc': 'Reviewing the latest Loco S1 Pro Headphones.',
      'status': 'Ongoing',
      'influencer': 'Rohan Sharma',
      'fee': '\$450.00',
      'type': 'Paid',
      'date': '8 Mar',
    },
    {
      'title': 'Healthy Smoothies Launch',
      'desc': 'Pan-India awareness for vitamin boosters.',
      'status': 'Completed',
      'influencer': 'Ananya Iyer',
      'rating': '4.8',
      'type': 'Paid',
      'date': '1 Mar',
    },
    {
      'title': 'Fitness Gear Collab',
      'desc': 'Showcasing new gym accessories with micro-influencers.',
      'status': 'Completed',
      'influencer': 'Vikram Singh',
      'rating': '4.5',
      'type': 'Barter',
      'date': '20 Feb',
    },
  ];

  List<String> get _tabs => ['Active', 'Ongoing', 'Completed'];

  int _countByStatus(String status) => _allCampaigns.where((c) => c['status'] == status).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(),
          _buildCategoryTabs(),
          Expanded(child: _buildCampaignsList()),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PostAdScreen())),
          backgroundColor: Colors.black,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text('Post New Ad', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Campaigns',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: -1.0),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_allCampaigns.length} total campaigns',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _showFilterSheet,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.filter_list_rounded, size: 18, color: Colors.black87),
                  const SizedBox(width: 6),
                  Text(_selectedFilter, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.black87)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    final filters = ['Latest', 'Oldest', 'This Week', 'This Month'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
            const Text('Sort By', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 24),
            ...filters.map((f) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(f, style: TextStyle(fontWeight: _selectedFilter == f ? FontWeight.w800 : FontWeight.w500)),
              trailing: _selectedFilter == f ? const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A)) : null,
              onTap: () {
                setState(() => _selectedFilter = f);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final isSelected = _selectedTabIndex == index;
            final count = _countByStatus(_tabs[index]);
            return Padding(
              padding: EdgeInsets.only(right: index == _tabs.length - 1 ? 0 : 10),
              child: GestureDetector(
                onTap: () => setState(() => _selectedTabIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? Colors.black : Colors.grey[200]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _tabs[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[600],
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCampaignsList() {
    final filtered = _allCampaigns.where((c) => c['status'] == _tabs[_selectedTabIndex]).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No ${_tabs[_selectedTabIndex].toLowerCase()} campaigns', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
      itemCount: filtered.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final campaign = filtered[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BusinessCampaignDetailScreen(campaign: campaign)),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCardHeader(campaign),
                  const SizedBox(height: 14),
                  Text(campaign['title'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: Colors.black)),
                  const SizedBox(height: 6),
                  Text(campaign['desc'], style: TextStyle(color: Colors.grey[500], fontSize: 13, height: 1.4, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 20),
                  if (campaign['status'] == 'Active')
                    _buildActiveStats(campaign)
                  else
                    _buildInfluencerSummary(campaign),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardHeader(Map<String, dynamic> campaign) {
    Color statusColor = const Color(0xFF3B82F6);
    if (campaign['status'] == 'Ongoing') statusColor = const Color(0xFFF59E0B);
    if (campaign['status'] == 'Completed') statusColor = const Color(0xFF16A34A);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Text(campaign['status'].toUpperCase(), style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
              child: Text(campaign['type'], style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w700, fontSize: 10)),
            ),
          ],
        ),
        Text(campaign['date'] ?? '', style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w600, fontSize: 11)),
      ],
    );
  }

  Widget _buildActiveStats(Map<String, dynamic> campaign) {
    return Row(
      children: [
        _buildStatItem(
          campaign['applicants'],
          'Applicants',
          const Color(0xFF3B82F6),
        ),
        const SizedBox(width: 12),
        _buildStatItem(
          campaign['active'],
          'Active',
          const Color(0xFFF59E0B),
        ),
        const SizedBox(width: 12),
        _buildStatItem(
          campaign['spent'],
          'Spent',
          const Color(0xFF16A34A),
        ),
      ],
    );
  }

  Widget _buildInfluencerSummary(Map<String, dynamic> campaign) {
    bool isCompleted = campaign['status'] == 'Completed';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=${campaign['influencer']}'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign['influencer'],
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Colors.black),
                ),
                Text(
                  isCompleted ? 'Campaign Finished' : 'Assigned Creator',
                  style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          if (isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    campaign['rating'],
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFFD97706)),
                  ),
                ],
              ),
            )
          else
            Text(
              campaign['fee'],
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF16A34A)),
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.12), width: 1),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: color,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: color.withOpacity(0.6),
                fontSize: 8,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
