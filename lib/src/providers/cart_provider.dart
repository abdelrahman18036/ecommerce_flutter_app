import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  Map<String, int> cartItems = {}; // productId -> quantity

  void addToCart(ProductModel product) {
    if (cartItems.containsKey(product.id)) {
      cartItems[product.id] = cartItems[product.id]! + 1;
    } else {
      cartItems[product.id] = 1;
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    cartItems.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      cartItems.remove(productId);
    } else {
      cartItems[productId] = newQuantity;
    }
    notifyListeners();
  }

  double getTotal(List<ProductModel> allProducts) {
    double total = 0.0;
    for (var entry in cartItems.entries) {
      var product = allProducts.firstWhere((p) => p.id == entry.key);
      total += product.price * entry.value;
    }
    return total;
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }
}
