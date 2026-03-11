import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/influencer_models.dart';
import '../../data/services/campaign_service.dart';
import 'ad_details_screen.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  DateTime _selectedDate = DateTime.now();
  late List<DateTime> _weekDates;
  final CampaignService _campaignService = CampaignService();

  @override
  void initState() {
    super.initState();
    _generateWeekDates();
  }

  void _generateWeekDates() {
    final now = DateTime.now();
    // Start from 2 days ago to show some context
    _weekDates = List.generate(7, (index) => now.add(Duration(days: index - 2)));
    
    // Ensure now is in the list
    bool hasToday = _weekDates.any((d) => _isSameDay(d, now));
    if (!hasToday) {
       _weekDates = List.generate(7, (index) => now.add(Duration(days: index)));
    }
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  List<_PlannerTaskData> _getTasksForDate(DateTime date) {
    final campaigns = _campaignService.campaigns;
    final List<_PlannerTaskData> tasks = [];

    for (var campaign in campaigns) {
      if (campaign.deadline != null && _isSameDay(campaign.deadline!, date)) {
        if (campaign.status == AdStatus.ongoing) {
          tasks.add(_PlannerTaskData(
            time: '12:00',
            title: '${campaign.brandName} - Submit Proof',
            desc: 'Deadline for submitting campaign metrics.',
            icon: Icons.analytics_rounded,
            color: const Color(0xFFF97316),
            campaign: campaign,
          ));
        } else if (campaign.status == AdStatus.approved) {
          tasks.add(_PlannerTaskData(
            time: '10:00',
            title: '${campaign.brandName} - Content Production',
            desc: 'Start creating content as per the approved brief.',
            icon: Icons.camera_alt_rounded,
            color: const Color(0xFF7C3AED),
            campaign: campaign,
          ));
        } else if (campaign.status == AdStatus.pendingPayment) {
          tasks.add(_PlannerTaskData(
            time: '16:00',
            title: '${campaign.brandName} - Payment Status',
            desc: 'Check if payment has been processed.',
            icon: Icons.payment_rounded,
            color: const Color(0xFF10B981),
            campaign: campaign,
          ));
        }
      }
    }

    // Add some default tasks if today to make it look populated
    if (_isSameDay(date, DateTime.now()) && tasks.isEmpty) {
      tasks.add(const _PlannerTaskData(
        time: '09:00',
        title: 'Check New Opportunities',
        desc: 'Browse recently posted campaign discovery ads.',
        icon: Icons.search_rounded,
        color: Color(0xFF2563EB),
      ));
    }

    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _getTasksForDate(_selectedDate);

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
            icon: const Icon(Icons.calendar_month_rounded, color: Colors.black),
            onPressed: () {}, // Future: Open DatePicker
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
            _buildSectionHeader(_isSameDay(_selectedDate, DateTime.now()) ? 'TODAY\'S TASKS' : DateFormat('EEEE, MMM d').format(_selectedDate).toUpperCase()),
            const SizedBox(height: 16),
            if (tasks.isEmpty)
              _buildEmptyState()
            else
              ...tasks.map((task) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildPlannerTask(task),
                  )),
            const SizedBox(height: 32),
            _buildSectionHeader('UPCOMING DEADLINES'),
            const SizedBox(height: 16),
            ..._buildUpcomingDeadlines(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.calendar_today_outlined, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No tasks scheduled for this day',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildUpcomingDeadlines() {
    final campaigns = _campaignService.campaigns
        .where((c) => c.deadline != null && c.deadline!.isAfter(_selectedDate))
        .toList()
      ..sort((a, b) => a.deadline!.compareTo(b.deadline!));

    if (campaigns.isEmpty) {
      return [
        Text(
          'No upcoming deadlines found.',
          style: TextStyle(color: Colors.grey[400], fontSize: 13),
        )
      ];
    }

    return campaigns.take(3).map((c) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildPlannerTask(_PlannerTaskData(
          time: DateFormat('MMM d').format(c.deadline!),
          title: c.brandName,
          desc: c.title,
          icon: Icons.timelapse_rounded,
          color: Colors.blueGrey,
          isUnscheduled: true,
          campaign: c,
        )),
      );
    }).toList();
  }

  Widget _buildDateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _weekDates.map((date) => _buildDateItem(date)).toList(),
    );
  }

  Widget _buildDateItem(DateTime date) {
    final isSelected = _isSameDay(date, _selectedDate);
    final isToday = _isSameDay(date, DateTime.now());

    return GestureDetector(
      onTap: () => setState(() => _selectedDate = date),
      child: Container(
        width: 50,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isToday && !isSelected ? Border.all(color: AppColors.primary, width: 1.5) : null,
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))]
              : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Text(
              DateFormat('EEE').format(date).toUpperCase(),
              style: TextStyle(
                color: isSelected ? Colors.white.withOpacity(0.6) : Colors.grey[400],
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('d').format(date),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
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

  Widget _buildPlannerTask(_PlannerTaskData task) {
    return GestureDetector(
      onTap: task.campaign != null
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AdDetailsScreen(ad: task.campaign!),
                ),
              )
          : null,
      child: Container(
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
            SizedBox(
              width: 56,
              child: Column(
                children: [
                  Text(
                    task.isUnscheduled ? task.time.split(' ')[0] : task.time.split(':')[0],
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.black),
                  ),
                  Text(
                    task.isUnscheduled ? task.time.split(' ')[1] : task.time.split(':')[1],
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
                      Icon(task.icon, color: task.color, size: 16),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          task.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.desc,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(task.campaign == null ? Icons.info_outline_rounded : Icons.chevron_right_rounded, color: Colors.black12, size: 24),
          ],
        ),
      ),
    );
  }
}

class _PlannerTaskData {
  final String time;
  final String title;
  final String desc;
  final IconData icon;
  final Color color;
  final bool isDone;
  final bool isUnscheduled;
  final AdCampaign? campaign;

  const _PlannerTaskData({
    required this.time,
    required this.title,
    required this.desc,
    required this.icon,
    required this.color,
    this.isDone = false,
    this.isUnscheduled = false,
    this.campaign,
  });
}
