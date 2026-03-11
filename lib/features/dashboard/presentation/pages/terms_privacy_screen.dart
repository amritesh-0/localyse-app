import 'package:flutter/material.dart';

class TermsPrivacyScreen extends StatelessWidget {
  const TermsPrivacyScreen({super.key});

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
          'Terms & Privacy',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -0.5),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms of Service',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
              ),
              SizedBox(height: 16),
              Text(
                'Welcome to Localyse. By using our platform, you agree to comply with our terms of service regarding campaign participation and content creation...',
                style: TextStyle(height: 1.6, color: Colors.black87),
              ),
              SizedBox(height: 32),
              Text(
                'Privacy Policy',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
              ),
              SizedBox(height: 16),
              Text(
                'We take your privacy seriously. Your data is handled securely and used only to match you with the best brand opportunities...',
                style: TextStyle(height: 1.6, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
