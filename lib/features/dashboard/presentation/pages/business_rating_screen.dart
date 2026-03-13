import 'package:flutter/material.dart';
import '../../../../core/utils/feedback_utils.dart';

class BusinessRatingScreen extends StatefulWidget {
  final String influencerName;

  const BusinessRatingScreen({
    super.key,
    required this.influencerName,
  });

  @override
  State<BusinessRatingScreen> createState() => _BusinessRatingScreenState();
}

class _BusinessRatingScreenState extends State<BusinessRatingScreen> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Rate Influencer', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=${widget.influencerName}'),
              backgroundColor: Colors.grey[100],
            ),
            const SizedBox(height: 24),
            Text(
              'How was your experience working with ${widget.influencerName}?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, height: 1.3),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () => setState(() => _rating = index + 1),
                  icon: Icon(
                    index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: index < _rating ? const Color(0xFFF59E0B) : Colors.grey[300],
                    size: 48,
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Share your feedback...',
                hintStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w500),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _rating == 0 ? null : () => _submitRating(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  disabledBackgroundColor: Colors.grey[200],
                ),
                child: const Text('Submit Review', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitRating() {
    AppFeedback.success(context, 'Thank you for your feedback!');
    Navigator.pop(context);
  }
}
