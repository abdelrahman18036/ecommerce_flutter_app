import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  final String orderId;
  const FeedbackScreen({super.key, required this.orderId});
  @override
  Widget build(BuildContext context) {
    final ratingCtrl = TextEditingController();
    final commentsCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Rate your order $orderId'),
            TextField(
              controller: ratingCtrl,
              decoration: const InputDecoration(labelText: 'Rating (1-5)'),
            ),
            TextField(
              controller: commentsCtrl,
              decoration: const InputDecoration(labelText: 'Comments'),
            ),
            ElevatedButton(
              onPressed: () {
                // Save feedback to Firestore
              },
              child: const Text('Submit Feedback')
            )
          ],
        ),
      ),
    );
  }
}
