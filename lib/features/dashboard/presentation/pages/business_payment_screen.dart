import 'package:flutter/material.dart';

class BusinessPaymentScreen extends StatelessWidget {
  final String campaignTitle;
  final String amount;

  const BusinessPaymentScreen({
    super.key,
    required this.campaignTitle,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Secure Payment', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAmountCard(),
            const SizedBox(height: 32),
            const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 16),
            _buildPaymentOption('Google Pay / UPI', Icons.account_balance_wallet_rounded, true),
            _buildPaymentOption('Credit / Debit Card', Icons.credit_card_rounded, false),
            _buildPaymentOption('Net Banking', Icons.account_balance_rounded, false),
            const Spacer(),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        children: [
          Text(campaignTitle, style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(amount, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.black)),
          const SizedBox(height: 16),
          _buildDetailRow('Campaign Fee', amount),
          _buildDetailRow('Service Fee (5%)', '₹${(double.parse(amount.replaceAll('₹', '').replaceAll(',', '')) * 0.05).toStringAsFixed(2)}'),
          const Divider(height: 32),
          _buildDetailRow('Total Payable', '₹${(double.parse(amount.replaceAll('₹', '').replaceAll(',', '')) * 1.05).toStringAsFixed(2)}', isBold: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isBold ? Colors.black : Colors.grey[600], fontWeight: isBold ? FontWeight.w800 : FontWeight.w500, fontSize: 14)),
          Text(value, style: TextStyle(color: Colors.black, fontWeight: isBold ? FontWeight.w900 : FontWeight.w700, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? Colors.black : Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.black87, size: 24),
          const SizedBox(width: 16),
          Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.w800, fontSize: 15)),
          const Spacer(),
          if (isSelected) const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 20),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _showSuccessDialog(context),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF16A34A), width: 2),
          foregroundColor: const Color(0xFF16A34A),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: const Text('Pay Now', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(color: Color(0xFFF0FDF4), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 64),
              ),
              const SizedBox(height: 24),
              const Text('Payment Success!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Text(
                'Your payment for $campaignTitle has been confirmed. The influencer has been notified.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.5, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Back to campaigns
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Back to Dashboard', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
