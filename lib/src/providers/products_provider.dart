import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/product_model.dart';

class ProductsProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  List<ProductModel> products = [];

  ProductsProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    products = await _service.getProducts();
    notifyListeners();
  }

  List<ProductModel> searchByText(String query) {
    if (query.isEmpty) {
      return products;
    }
    return products.where((p) =>
      p.name.toLowerCase().contains(query.toLowerCase()) ||
      p.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  ProductModel? getProductById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addProduct(ProductModel product) async {
    await _service.addProduct(product.toMap());
    await loadProducts();
  }

  Future<void> updateProduct(ProductModel product) async {
    await _service.updateProduct(product.id, product.toMap());
    await loadProducts();
  }

  Future<void> deleteProduct(String productId) async {
    await _service.deleteProduct(productId);
    await loadProducts();
  }
}
