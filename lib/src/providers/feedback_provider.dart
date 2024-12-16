// lib/src/providers/feedback_provider.dart

import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/feedback_model.dart';

class FeedbackProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<FeedbackModel> _feedbackList = [];

  List<FeedbackModel> get feedbackList => _feedbackList;

  // Submit Feedback
  Future<void> submitFeedback(FeedbackModel feedback) async {
    Map<String, dynamic> feedbackMap = feedback.toMap(); // Convert to Map
    String feedbackId = await _firestoreService.addFeedback(feedbackMap);
    FeedbackModel feedbackWithId = feedback.copyWith(id: feedbackId);
    _feedbackList.add(feedbackWithId);
    notifyListeners();
  }

  // Fetch All Feedback (for Admin)
  Future<void> fetchAllFeedback() async {
    _feedbackList = await _firestoreService.getAllFeedback();
    notifyListeners();
  }

  // Delete Feedback (for Admin)
  Future<void> deleteFeedback(String feedbackId) async {
    await _firestoreService.deleteFeedback(feedbackId);
    _feedbackList.removeWhere((feedback) => feedback.id == feedbackId);
    notifyListeners();
  }
}
