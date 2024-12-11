// lib/src/models/order_model.dart
import 'order_item.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double total;
  final DateTime date;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.date,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String docId) {
    var items = (map['items'] as List)
        .map((e) => OrderItem.fromMap(e))
        .toList();
    return OrderModel(
      id: docId,
      userId: map['userId'] ?? '',
      items: items,
      total: (map['total'] as num).toDouble(),
      date: DateTime.parse(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((e) => e.toMap()).toList(),
      'total': total,
      'date': date.toIso8601String(),
    };
  }
}
