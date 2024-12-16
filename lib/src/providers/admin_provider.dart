// lib/src/providers/admin_provider.dart

import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/order_model.dart'; // Import OrderModel

class AdminProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  // Products Methods
  Future<List<ProductModel>> getAllProducts() async {
    return await _service.getProducts();
  }


  Future<void> addProduct(ProductModel product) async {
    await _service.addProduct(product.toMap());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _service.updateProduct(product.id, product.toMap());
  }

  Future<void> deleteProduct(String productId) async {
    await _service.deleteProduct(productId);
  }

   Future<ProductModel?> getProductById(String productId) async {
    return await _service.getProductById(productId);
  }

  // Categories Methods
  Future<List<CategoryModel>> getAllCategories() async {
    return await _service.getCategories();
  }

  Future<void> addCategory(CategoryModel category) async {
    await _service.addCategory(category.toMap());
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _service.updateCategory(category.id, category.toMap());
  }

  Future<void> deleteCategory(String categoryId) async {
    await _service.deleteCategory(categoryId);
  }

  Future<CategoryModel?> getCategoryById(String categoryId) async {
    return await _service.getCategoryById(categoryId);
  }

  // Fetch all orders
  Future<List<OrderModel>> getAllOrders() async {
    try {
      List<OrderModel> orders = await _service.getAllOrders();
      return orders;
    } catch (e) {
      throw Exception('Failed to get all orders: $e');
    }
  }

  // Fetch orders by date
  Future<List<OrderModel>> getOrdersByDate(DateTime date) async {
    try {
      List<OrderModel> orders = await _service.getOrdersByDate(date);
      return orders;
    } catch (e) {
      throw Exception('Failed to get orders by date: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getBestSellingProducts() async {
    try {
      List<Map<String, dynamic>> bestSelling = await _service.getBestSellingProducts();
      return bestSelling;
    } catch (e) {
      throw Exception('Failed to get best-selling products: $e');
    }
  }
}
