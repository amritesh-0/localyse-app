import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class BusinessStatsView extends StatefulWidget {
  const BusinessStatsView({super.key});

  @override
  State<BusinessStatsView> createState() => _BusinessStatsViewState();
}

class _BusinessStatsViewState extends State<BusinessStatsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Campaign Stats',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: -1.0,
              ),
            ),
            const SizedBox(height: 32),
            _buildMainStatsCard(),
            const SizedBox(height: 32),
            _buildSectionHeader('Performance Breakdown'),
            const SizedBox(height: 16),
            _buildStatDetailCard('Total Spend', '\$12,450', '+12%', true),
            const SizedBox(height: 16),
            _buildStatDetailCard('Average ROI', '3.4x', '+5%', true),
            const SizedBox(height: 16),
            _buildStatDetailCard('Total Reach', '1.2M', '+18%', true),
            const SizedBox(height: 16),
            _buildStatDetailCard('Cost per Engagement', '\$0.45', '-2%', false),
          ],
        ),
      ),
    );
  }

  Widget _buildMainStatsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFF16A34A), width: 2),
        boxShadow: [
          BoxShadow(color: const Color(0xFF16A34A).withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TOTAL ROI',
            style: TextStyle(color: Color(0xFF16A34A), fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5),
          ),
          const SizedBox(height: 8),
          const Text(
            '4.2x',
            style: TextStyle(color: Colors.black, fontSize: 48, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSimpleStat('8 Active', 'Campaigns'),
              _buildSimpleStat('124', 'Influencers'),
              _buildSimpleStat('\$850', 'Daily Spend'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16)),
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black),
    );
  }

  Widget _buildStatDetailCard(String title, String value, String change, bool isPositive) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: (isPositive ? AppColors.primaryDark : const Color(0xFFEF4444)).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              change,
              style: TextStyle(
                color: isPositive ? AppColors.primaryDark : const Color(0xFFEF4444),
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
