import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/order_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ProductModel>> getProducts() async {
    var snapshot = await _db.collection('products').get();
    return snapshot.docs.map((doc) => ProductModel.fromMap(doc.data(), doc.id)).toList();
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

  Future<List<CategoryModel>> getCategories() async {
    var snapshot = await _db.collection('categories').get();
    return snapshot.docs.map((doc) => CategoryModel.fromMap(doc.data(), doc.id)).toList();
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

  Future<void> addOrder(Map<String, dynamic> data) async {
    await _db.collection('orders').add(data);
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    var snapshot = await _db.collection('orders')
      .where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => OrderModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<Map<String, dynamic>>> getOrdersByDate(DateTime date) async {
    // This is a placeholder. You would query by date field.
    var snapshot = await _db.collection('orders')
      .where('date', isEqualTo: date.toIso8601String()).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getBestSellingProducts() async {
    // Placeholder logic:
    // Ideally, aggregate orders to find best-selling products.
    // Here we just return empty list.
    return [];
  }
}
