import 'package:flutter/material.dart';
import '../../../../core/utils/feedback_utils.dart';

class ManageApplicantsScreen extends StatefulWidget {
  final Map<String, dynamic> opening;

  const ManageApplicantsScreen({super.key, required this.opening});

  @override
  State<ManageApplicantsScreen> createState() => _ManageApplicantsScreenState();
}

class _ManageApplicantsScreenState extends State<ManageApplicantsScreen> {
  final List<Map<String, dynamic>> _applicants = [
    {
      'name': 'Sanya Malhotra',
      'followers': '120K',
      'niche': 'Fashion',
      'engagement': '4.5%',
      'status': 'Pending',
    },
    {
      'name': 'Vikram Singh',
      'followers': '85K',
      'niche': 'Lifestyle',
      'engagement': '5.2%',
      'status': 'Approved',
    },
    {
      'name': 'Ananya Iyer',
      'followers': '210K',
      'niche': 'Wellness',
      'engagement': '3.8%',
      'status': 'Pending',
    },
    {
      'name': 'Rohan Sharma',
      'followers': '45K',
      'niche': 'Tech',
      'engagement': '6.1%',
      'status': 'Rejected',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text(
              'Manage Applicants',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16),
            ),
            Text(
              widget.opening['title'],
              style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _applicants.length,
        itemBuilder: (context, index) {
          final applicant = _applicants[index];
          return _buildApplicantCard(applicant);
        },
      ),
    );
  }

  Widget _buildApplicantCard(Map<String, dynamic> applicant) {
    bool isPending = applicant['status'] == 'Pending';
    bool isApproved = applicant['status'] == 'Approved';
    bool isRejected = applicant['status'] == 'Rejected';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=${applicant['name']}'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(applicant['name'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      '${applicant['followers']} Followers • ${applicant['engagement']} Eng.',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(applicant['status']),
            ],
          ),
          if (isPending) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => applicant['status'] = 'Rejected');
                      AppFeedback.error(context, 'Applicant Rejected');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFEF4444)),
                      foregroundColor: const Color(0xFFEF4444),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Reject', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => applicant['status'] = 'Approved');
                      AppFeedback.success(context, 'Applicant Approved!');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF16A34A), width: 2),
                      foregroundColor: const Color(0xFF16A34A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Approve', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.grey;
    if (status == 'Approved') color = const Color(0xFF16A34A);
    if (status == 'Rejected') color = const Color(0xFFEF4444);
    if (status == 'Pending') color = const Color(0xFFF59E0B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5),
      ),
    );
  }
}
