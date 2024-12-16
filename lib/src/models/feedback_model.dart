// lib/src/models/feedback_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String id;
  final String userId;
  final int rating;
  final String? comments;
  final DateTime date;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.rating,
    this.comments,
    required this.date,
  });

  // Factory constructor to create FeedbackModel from Firestore document
  factory FeedbackModel.fromMap(Map<String, dynamic> map, String docId) {
    return FeedbackModel(
      id: docId,
      userId: map['userId'] ?? '',
      rating: (map['rating'] as num).toInt(),
      comments: map['comments'],
      date: (map['date'] as Timestamp).toDate(),
    );
  }

  // Convert FeedbackModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rating': rating,
      'comments': comments,
      'date': Timestamp.fromDate(date),
    };
  }

  // CopyWith method for immutability
  FeedbackModel copyWith({
    String? id,
    String? userId,
    int? rating,
    String? comments,
    DateTime? date,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      comments: comments ?? this.comments,
      date: date ?? this.date,
    );
  }
}
