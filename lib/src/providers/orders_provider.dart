import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/order_model.dart';

class OrdersProvider extends ChangeNotifier {
  final _service = FirestoreService();
  List<OrderModel> userOrders = [];

  Future<void> loadUserOrders(String userId) async {
    userOrders = await _service.getUserOrders(userId);
    notifyListeners();
  }

  Future<void> placeOrder(OrderModel order) async {
    await _service.addOrder(order.toMap());
    // Reload orders if needed
    await loadUserOrders(order.userId);
  }
}
