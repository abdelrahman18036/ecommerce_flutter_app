// lib/src/screens/admin/manage_feedback_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/feedback_model.dart';
import '../../providers/feedback_provider.dart';

class ManageFeedbackScreen extends StatefulWidget {
  const ManageFeedbackScreen({Key? key}) : super(key: key);

  @override
  State<ManageFeedbackScreen> createState() => _ManageFeedbackScreenState();
}

class _ManageFeedbackScreenState extends State<ManageFeedbackScreen> {
  late Future<void> _fetchFeedbackFuture;

  @override
  void initState() {
    super.initState();
    _fetchFeedbackFuture = Provider.of<FeedbackProvider>(context, listen: false).fetchAllFeedback();
  }

  Future<void> _refreshFeedback() async {
    await Provider.of<FeedbackProvider>(context, listen: false).fetchAllFeedback();
  }

  Future<void> _deleteFeedback(String feedbackId) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Feedback'),
        content: const Text('Are you sure you want to delete this feedback?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm) {
      try {
        await Provider.of<FeedbackProvider>(context, listen: false).deleteFeedback(feedbackId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete feedback: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Feedback'),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _fetchFeedbackFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error fetching feedback: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return Consumer<FeedbackProvider>(
              builder: (context, feedbackProvider, child) {
                final feedbackList = feedbackProvider.feedbackList;

                if (feedbackList.isEmpty) {
                  return const Center(
                    child: Text(
                      'No feedback available',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshFeedback,
                  child: ListView.builder(
                    itemCount: feedbackList.length,
                    itemBuilder: (context, index) {
                      final feedback = feedbackList[index];
                      return Card(
                        color: Colors.grey[800],
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            'User ID: ${feedback.userId}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rating: ${feedback.rating}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Comments: ${feedback.comments ?? 'No comments'}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Date: ${feedback.date.toLocal().toString().split(' ')[0]}',
                                style: const TextStyle(color: Colors.white54, fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteFeedback(feedback.id),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
