// lib/src/services/search_service.dart
import '../models/product_model.dart';

class SearchService {
  List<ProductModel> searchByText(List<ProductModel> products, String query) {
    if (query.isEmpty) {
      return products;
    }
    return products.where((product) =>
      product.name.toLowerCase().contains(query.toLowerCase()) ||
      product.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
