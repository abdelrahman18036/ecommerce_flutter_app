class FeedbackModel {
  final String orderId;
  final String userId;
  final int rating;
  final String comments;

  FeedbackModel({
    required this.orderId,
    required this.userId,
    required this.rating,
    required this.comments,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      orderId: map['orderId'],
      userId: map['userId'],
      rating: map['rating'],
      comments: map['comments'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'rating': rating,
      'comments': comments,
    };
  }
}
