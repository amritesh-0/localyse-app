import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class BusinessShortlistView extends StatefulWidget {
  const BusinessShortlistView({super.key});

  @override
  State<BusinessShortlistView> createState() => _BusinessShortlistViewState();
}

class _BusinessShortlistViewState extends State<BusinessShortlistView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildSeamlessHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildShortlistCard(index),
                childCount: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeamlessHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Shortlist',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: -1.0,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Creators you have bookmarked for future campaigns.',
            style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildShortlistCard(int index) {
    final names = ['Rohan Sharma', 'Ananya Iyer', 'Vikram Singh', 'Sanya Malhotra', 'Kabir Das', 'Meera Reddy'];
    final name = names[index % names.length];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=$name'),
                  backgroundColor: Colors.grey[100],
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  '120K Followers',
                  style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF16A34A), width: 1.5),
                    foregroundColor: const Color(0xFF16A34A),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Invite', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
                ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.bookmark_rounded, color: Color(0xFF16A34A), size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
