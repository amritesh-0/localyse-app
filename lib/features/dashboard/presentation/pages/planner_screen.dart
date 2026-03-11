import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PlannerScreen extends StatelessWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Campaign Planner',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: -0.5),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_rounded, color: Colors.black),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateSelector(),
            const SizedBox(height: 32),
            _buildSectionHeader('Today\'s Tasks'),
            const SizedBox(height: 16),
            _buildPlannerTask(
              time: '14:30',
              title: 'Nike Campaign Post',
              desc: 'Upload the 60s Reel for approval.',
              icon: Icons.video_collection_rounded,
              color: const Color(0xFF7C3AED),
              isDone: false,
            ),
            const SizedBox(height: 12),
            _buildPlannerTask(
              time: '18:00',
              title: 'Starbucks Briefing',
              desc: 'Call with the marketing team.',
              icon: Icons.phone_callback_rounded,
              color: const Color(0xFF10B981),
              isDone: true,
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Upcoming'),
            const SizedBox(height: 16),
            _buildPlannerTask(
              time: 'Mar 12',
              title: 'Adidas Shoot',
              desc: 'Downtown park location photo shoot.',
              icon: Icons.camera_alt_rounded,
              color: const Color(0xFF2563EB),
              isUnscheduled: true,
            ),
            const SizedBox(height: 12),
            _buildPlannerTask(
              time: 'Mar 15',
              title: 'Submit Proof',
              desc: 'Tech Expo campaign metrics due.',
              icon: Icons.analytics_rounded,
              color: const Color(0xFFF97316),
              isUnscheduled: true,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateItem('10', 'MON', false),
        _buildDateItem('11', 'TUE', true),
        _buildDateItem('12', 'WED', false),
        _buildDateItem('13', 'THU', false),
        _buildDateItem('14', 'FRI', false),
      ],
    );
  }

  Widget _buildDateItem(String day, String weekday, bool isSelected) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isSelected
            ? [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))]
            : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Text(
            weekday,
            style: TextStyle(
              color: isSelected ? Colors.white.withOpacity(0.6) : Colors.grey[400],
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            day,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: Colors.grey[400],
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildPlannerTask({
    required String time,
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    bool isDone = false,
    bool isUnscheduled = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            child: Column(
              children: [
                Text(
                  isUnscheduled ? time.split(' ')[0] : time.split(':')[0],
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.black),
                ),
                Text(
                  isUnscheduled ? time.split(' ')[1] : time.split(':')[1],
                  style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(height: 40, width: 1, color: Colors.grey[100]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: Colors.black,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (isDone)
            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 24)
          else
            const Icon(Icons.circle_outlined, color: Colors.black12, size: 24),
        ],
      ),
    );
  }
}
