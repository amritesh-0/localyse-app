import 'package:flutter/material.dart';
import '../pages/post_opening_screen.dart';
import '../pages/manage_applicants_screen.dart';

class BusinessShortlistView extends StatefulWidget {
  const BusinessShortlistView({super.key});

  @override
  State<BusinessShortlistView> createState() => _BusinessShortlistViewState();
}

class _BusinessShortlistViewState extends State<BusinessShortlistView> {
  final List<Map<String, dynamic>> _openings = [
    {
      'title': 'Grand Opening: Bandra Flagship',
      'category': 'Ceremony',
      'city': 'Mumbai',
      'area': 'Bandra West',
      'date': 'Sat, 20 Mar',
      'applicants': 14,
      'slots': 10,
      'reward': '₹2,500',
      'status': 'Open',
    },
    {
      'title': 'Sustainable Beauty Seminar',
      'category': 'Seminar',
      'city': 'Bangalore',
      'area': 'Indiranagar',
      'date': 'Sun, 25 Mar',
      'applicants': 8,
      'slots': 5,
      'reward': 'Hamper + ₹1,500',
      'status': 'Full',
    },
    {
      'title': 'Product Trial: Loco S1 Headphones',
      'category': 'Experience',
      'city': 'Delhi',
      'area': 'Hauz Khas',
      'date': '28 - 30 Mar',
      'applicants': 42,
      'slots': 20,
      'reward': '₹4,000',
      'status': 'Open',
    },
  ];

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
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildOpeningCard(_openings[index]),
                childCount: _openings.length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PostOpeningScreen())),
          backgroundColor: Colors.black,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text('New Opening', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  Widget _buildSeamlessHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Openings',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your active invitations for local events and semianrs.',
            style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildOpeningCard(Map<String, dynamic> opening) {
    final bool isFull = opening['status'] == 'Full';
    final Color categoryColor = _getCategoryColor(opening['category']);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: categoryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Text(opening['category'].toUpperCase(), style: TextStyle(color: categoryColor, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                ),
                Text(opening['date'], style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w700, fontSize: 11)),
              ],
            ),
            const SizedBox(height: 16),
            Text(opening['title'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.black)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_rounded, size: 14, color: Colors.redAccent),
                const SizedBox(width: 4),
                Text('${opening['city']}, ${opening['area']}', style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('APPLICANTS', style: TextStyle(color: Colors.grey[400], fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('${opening['applicants']}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                          Text(' / ${opening['slots']} slots', style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('REWARD', style: TextStyle(color: Colors.grey[400], fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                      const SizedBox(height: 4),
                      Text(opening['reward'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF16A34A))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isFull ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => ManageApplicantsScreen(opening: opening))),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[200],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(isFull ? 'Lineup Full' : 'Manage Applicants', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Ceremony': return const Color(0xFF7C3AED);
      case 'Seminar': return const Color(0xFFF59E0B);
      case 'Experience': return const Color(0xFF16A34A);
      default: return Colors.blue;
    }
  }
}
