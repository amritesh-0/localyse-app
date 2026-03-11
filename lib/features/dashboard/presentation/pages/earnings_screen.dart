import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildWalletHeader(context)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Earning Summary'),
                  const SizedBox(height: 16),
                  _buildSummaryGrid(),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Recent Transactions'),
                  const SizedBox(height: 16),
                  _buildTransactionList(),
                  const SizedBox(height: 100), // Background padding for nav bar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Lifetime Earning',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            '\$12,450.00',
            style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: -1),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn({
    required IconData icon,
    required String label,
    required Color color,
    Color textColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        border: color == Colors.white ? Border.all(color: Colors.grey[200]!) : null,
        boxShadow: color != Colors.white
            ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: Colors.grey[400],
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildSummaryGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            label: 'This Month',
            amount: '\$2,840',
            trend: '+12%',
            icon: Icons.trending_up_rounded,
            color: const Color(0xFF7C3AED),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            label: 'Pending',
            amount: '\$850',
            trend: '2 Ads',
            icon: Icons.timer_rounded,
            color: const Color(0xFFF97316),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            amount,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                trend,
                style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return Column(
      children: [
        _buildTransactionTile('Nike Campaign', 'Mar 10, 2026', '+\$800.00', true),
        const SizedBox(height: 12),
        _buildTransactionTile('Adidas Reel', 'Mar 08, 2026', '+\$1,200.00', true),
        const SizedBox(height: 12),
        _buildTransactionTile('Withdrawal to Bank', 'Mar 05, 2026', '-\$500.00', false),
        const SizedBox(height: 12),
        _buildTransactionTile('Starbucks Post', 'Mar 02, 2026', '+\$450.00', true),
      ],
    );
  }

  Widget _buildTransactionTile(String title, String date, String amount, bool isCredit) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCredit ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: isCredit ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.black),
                ),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: isCredit ? const Color(0xFF2E7D32) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
