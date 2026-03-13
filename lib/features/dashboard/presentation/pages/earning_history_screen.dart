import 'package:flutter/material.dart';

class EarningHistoryScreen extends StatelessWidget {
  const EarningHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Earning History',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -0.5),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        itemCount: 8,
        itemBuilder: (context, index) => _buildEarningTile(index),
      ),
    );
  }

  Widget _buildEarningTile(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
            child: const Center(child: Text('👟', style: TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nike Summer Run',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.black),
                ),
                Text(
                  'Completed • Mar 10, 2026',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+₹450.00',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF10B981)),
              ),
              Text(
                'Paid',
                style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
