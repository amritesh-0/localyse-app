import 'dart:async';
import 'package:flutter/material.dart';
import '../pages/notifications_screen.dart';
import '../pages/chat_list_screen.dart';
import '../pages/business_profile_screen.dart';
import '../pages/influencer_detail_screen.dart';
import '../pages/post_ad_screen.dart';
import '../pages/post_opening_screen.dart';

class BusinessHomeView extends StatefulWidget {
  const BusinessHomeView({super.key});

  @override
  State<BusinessHomeView> createState() => _BusinessHomeViewState();
}

class _BusinessHomeViewState extends State<BusinessHomeView> {
  String selectedLocation = 'Mumbai, India';
  String selectedCategory = 'All';
  final List<String> locations = ['Mumbai, India', 'Delhi, India', 'Bangalore, India', 'All India'];
  final List<String> categories = ['All', 'Lifestyle', 'Tech', 'Food', 'Fashion', 'Fitness'];

  final PageController _bannerController = PageController();
  Timer? _bannerTimer;
  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _startBannerTimer();
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_bannerController.hasClients) {
        _currentBannerIndex = (_currentBannerIndex + 1) % 5; // Updated to 5 banners
        _bannerController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredInfluencers = _getFilteredInfluencers();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildSeamlessHeader()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 8),
                child: _buildBannerCarousel(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: _buildCategoryChips(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: _buildSectionHeader('Top Influencers'),
              ),
            ),
            if (filteredInfluencers.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Text('No influencers found in $selectedLocation', style: TextStyle(color: Colors.grey)),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildInfluencerCard(filteredInfluencers[index]),
                    childCount: filteredInfluencers.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getFilteredInfluencers() {
    final all = [
      {'name': 'Rohan Sharma', 'niche': 'Tech & Lifestyle', 'followers': '120K', 'eng': '4.2%', 'loc': 'Mumbai, India'},
      {'name': 'Ananya Iyer', 'niche': 'Fashion & Beauty', 'followers': '85K', 'eng': '5.1%', 'loc': 'Delhi, India'},
      {'name': 'Vikram Singh', 'niche': 'Fitness & Health', 'followers': '210K', 'eng': '3.8%', 'loc': 'Bangalore, India'},
      {'name': 'Sanya Malhotra', 'niche': 'Travel & Food', 'followers': '150K', 'eng': '4.5%', 'loc': 'Mumbai, India'},
      {'name': 'Kabir Das', 'niche': 'Education', 'followers': '65K', 'eng': '6.2%', 'loc': 'Delhi, India'},
    ];

    return all.where((inf) {
      final locMatch = selectedLocation == 'All India' || inf['loc'] == selectedLocation;
      final catMatch = selectedCategory == 'All' || inf['niche']!.contains(selectedCategory);
      return locMatch && catMatch;
    }).toList();
  }

  Widget _buildSeamlessHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BusinessProfileScreen()),
                    ),
                    child: Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF16A34A).withOpacity(0.1), width: 1),
                      ),
                      child: const Center(
                        child: Text(
                          'L',
                          style: TextStyle(
                            color: Color(0xFF16A34A),
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find Talent,',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Discovery 🤝',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  _buildHeaderIcon(Icons.notifications_none_rounded, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                  }),
                  const SizedBox(width: 12),
                  _buildHeaderIcon(Icons.chat_bubble_outline_rounded, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ChatListScreen()));
                  }),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),
          _buildFloatingLocationPill(),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black, size: 24),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildFloatingLocationPill() {
    return InkWell(
      onTap: () => _showLocationSelector(),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Color(0xFFF0FDF4), shape: BoxShape.circle),
              child: const Icon(Icons.search_rounded, color: Color(0xFF16A34A), size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Search influencers in',
                    style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedLocation,
                    style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black87, fontSize: 15),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey[50], shape: BoxShape.circle),
              child: const Icon(Icons.tune_rounded, color: Colors.black87, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationSelector() {
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
            const Text('Select Target Location', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 24),
            ...locations.map((loc) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(loc, style: TextStyle(fontWeight: selectedLocation == loc ? FontWeight.w800 : FontWeight.w500)),
              trailing: selectedLocation == loc ? const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A)) : null,
              onTap: () {
                setState(() => selectedLocation = loc);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return SizedBox(
      height: 180,
      child: PageView(
        controller: _bannerController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentBannerIndex = index;
          });
        },
        children: [
          _buildPremiumBanner(
            title: 'Launch your\nNext Campaign',
            subtitle: 'Reach 1M+ local creators instantly. Set your budget and goals.',
            icon: Icons.rocket_launch_rounded,
            colors: [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)], // Lighter Indigo
            textColor: Colors.black87,
            iconColor: const Color(0xFF6366F1).withOpacity(0.05),
            tag: 'QUICK START',
            tagColor: const Color(0xFF4F46E5),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PostAdScreen())),
          ),
          _buildPremiumBanner(
            title: 'Host an\nOpening Ceremony',
            subtitle: 'Invite local influencers to promote your grand opening or seminar.',
            icon: Icons.event_available_rounded,
            colors: [const Color(0xFFFDF2F8), const Color(0xFFFCE7F3)], // Pastel Pink
            textColor: Colors.black87,
            iconColor: const Color(0xFFDB2777).withOpacity(0.05),
            tag: 'NEW FEATURE',
            tagColor: const Color(0xFFDB2777),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PostOpeningScreen())),
          ),
          _buildPremiumBanner(
            title: 'Verified\nBrand Badge',
            subtitle: 'Upload your business documents to get the "Verified" badge and 2x applicants.',
            icon: Icons.verified_rounded,
            colors: [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)], // Light blue
            textColor: Colors.black87,
            iconColor: const Color(0xFF3B82F6).withOpacity(0.05),
            tag: 'REACTION REQUIRED',
            tagColor: const Color(0xFF3B82F6),
          ),
          _buildPremiumBanner(
            title: 'Market\nInsights 2026',
            subtitle: 'Lifestyle campaigns see 30% higher ROI this month. See trending creators.',
            icon: Icons.auto_graph_rounded,
            colors: [const Color(0xFFF0FDF4), const Color(0xFFDCFCE7)], // Light Emerald
            textColor: Colors.black87,
            iconColor: const Color(0xFF16A34A).withOpacity(0.05),
            tag: 'TRENDING',
            tagColor: const Color(0xFF16A34A),
          ),
          _buildPremiumBanner(
            title: 'Dedicated\nAccount Manager',
            subtitle: 'Upgrade to Business Plus for direct support and custom creator matching.',
            icon: Icons.support_agent_rounded,
            colors: [const Color(0xFFFAF5FF), const Color(0xFFF3E8FF)], // Light Purple
            textColor: Colors.black87,
            iconColor: const Color(0xFF9333EA).withOpacity(0.05),
            tag: 'UPGRADE',
            tagColor: const Color(0xFF9333EA),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBanner({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> colors,
    required String tag,
    Color textColor = Colors.white,
    Color? iconColor,
    Color? tagColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                icon,
                size: 140,
                color: iconColor ?? Colors.white.withOpacity(0.1),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: tagColor?.withOpacity(0.2) ?? Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: tagColor ?? textColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: textColor.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: isSelected ? Colors.black : Colors.grey[200]!),
                  boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4))] : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  cat,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: -0.5),
        ),
        const Icon(Icons.sort_rounded, color: Colors.black54),
      ],
    );
  }

  Widget _buildInfluencerCard(Map<String, String> influencer) {
    final name = influencer['name']!;
    final niche = influencer['niche']!;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => InfluencerDetailScreen(
          name: name,
          niche: niche,
          followers: influencer['followers']!,
          engagement: influencer['eng']!,
        )),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF16A34A).withOpacity(0.2), width: 2),
              ),
              child: CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=$name'),
                backgroundColor: Colors.grey[200],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    niche.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF16A34A),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildStatPill(Icons.people_alt_rounded, influencer['followers']!),
                      const SizedBox(width: 8),
                      _buildStatPill(Icons.bar_chart_rounded, influencer['eng']!),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.black26),
          ],
        ),
      ),
    );
  }

  Widget _buildStatPill(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
