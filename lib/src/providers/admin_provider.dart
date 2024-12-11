// lib/src/providers/admin_provider.dart
import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

class AdminProvider extends ChangeNotifier {
  final _service = FirestoreService();

  Future<void> addProduct(ProductModel product) async {
    await _service.addProduct(product.toMap());
    notifyListeners();
  }

  Future<void> editProduct(String productId, Map<String, dynamic> data) async {
    await _service.updateProduct(productId, data);
    notifyListeners();
  }

  Future<void> deleteProduct(String productId) async {
    await _service.deleteProduct(productId);
    notifyListeners();
  }

  Future<void> addCategory(CategoryModel category) async {
    await _service.addCategory(category.toMap());
    notifyListeners();
  }

  Future<void> editCategory(String categoryId, Map<String, dynamic> data) async {
    await _service.updateCategory(categoryId, data);
    notifyListeners();
  }

  Future<void> deleteCategory(String categoryId) async {
    await _service.deleteCategory(categoryId);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getReportByDate(DateTime date) async {
    // Placeholder implementation
    return _service.getOrdersByDate(date);
  }

  Future<List<Map<String, dynamic>>> getBestSellingProducts() async {
    return _service.getBestSellingProducts();
  }
}
