// lib/src/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/feedback_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Products Methods
  Future<List<ProductModel>> getProducts() async {
    var snapshot = await _db.collection('products').get();
    return snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> addProduct(Map<String, dynamic> data) async {
    await _db.collection('products').add(data);
  }

  Future<void> updateProduct(String productId, Map<String, dynamic> data) async {
    await _db.collection('products').doc(productId).update(data);
  }

  Future<void> deleteProduct(String productId) async {
    await _db.collection('products').doc(productId).delete();
  }

  Future<ProductModel?> getProductById(String productId) async {
    var doc = await _db.collection('products').doc(productId).get();
    if (doc.exists) {
      return ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // Categories Methods
  Future<List<CategoryModel>> getCategories() async {
    var snapshot = await _db.collection('categories').get();
    return snapshot.docs
        .map((doc) => CategoryModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> addCategory(Map<String, dynamic> data) async {
    await _db.collection('categories').add(data);
  }

  Future<void> updateCategory(String categoryId, Map<String, dynamic> data) async {
    await _db.collection('categories').doc(categoryId).update(data);
  }

  Future<void> deleteCategory(String categoryId) async {
    await _db.collection('categories').doc(categoryId).delete();
  }

  Future<CategoryModel?> getCategoryById(String categoryId) async {
    var doc = await _db.collection('categories').doc(categoryId).get();
    if (doc.exists) {
      return CategoryModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // Orders Methods
  Future<void> addOrder(Map<String, dynamic> data) async {
    await _db.collection('orders').add(data);
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    var snapshot = await _db.collection('orders')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Fetch orders by date using a date range for flexibility
  Future<List<OrderModel>> getOrdersByDate(DateTime date) async {
    try {
      // Define the start and end of the day for the given date
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));

      Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
      Timestamp endTimestamp = Timestamp.fromDate(endOfDay);

      QuerySnapshot snapshot = await _db
          .collection('orders')
          .where('date', isGreaterThanOrEqualTo: startTimestamp)
          .where('date', isLessThan: endTimestamp)
          .get();

      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch orders by date: $e');
    }
  }

  // Fetch all orders
  Future<List<OrderModel>> getAllOrders() async {
    try {
      QuerySnapshot snapshot = await _db.collection('orders').get();
      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch all orders: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getBestSellingProducts() async {
    try {
      // Fetch all orders
      QuerySnapshot ordersSnapshot = await _db.collection('orders').get();

      // Map to hold productId and total quantity sold
      Map<String, int> productSales = {};

      // Iterate through each order and its items
      for (var doc in ordersSnapshot.docs) {
        OrderModel order = OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        for (var item in order.items) {
          if (productSales.containsKey(item.productId)) {
            productSales[item.productId] = productSales[item.productId]! + item.quantity;
          } else {
            productSales[item.productId] = item.quantity;
          }
        }
      }

      // Convert the map to a list of maps with product details
      List<Map<String, dynamic>> bestSellingProducts = [];

      for (var entry in productSales.entries) {
        // Fetch product details
        DocumentSnapshot productDoc = await _db.collection('products').doc(entry.key).get();
        if (productDoc.exists) {
          Map<String, dynamic> productData = productDoc.data() as Map<String, dynamic>;
          bestSellingProducts.add({
            'productId': entry.key,
            'name': productData['name'] ?? 'Unknown Product',
            'quantity': entry.value,
          });
        }
      }

      // Sort the list by quantity in descending order
      bestSellingProducts.sort((a, b) => b['quantity'].compareTo(a['quantity']));

      return bestSellingProducts;
    } catch (e) {
      throw Exception('Failed to fetch best-selling products: $e');
    }
  }

   Future<String> addFeedback(Map<String, dynamic> data) async {
    DocumentReference docRef = await _db.collection('feedback').add(data);
    return docRef.id;
  }

  // Get All Feedback (for admin)
  Future<List<FeedbackModel>> getAllFeedback() async {
    QuerySnapshot snapshot = await _db.collection('feedback').orderBy('date', descending: true).get();
    return snapshot.docs
        .map((doc) => FeedbackModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Delete Feedback (for admin)
  Future<void> deleteFeedback(String feedbackId) async {
    await _db.collection('feedback').doc(feedbackId).delete();
  }
}
