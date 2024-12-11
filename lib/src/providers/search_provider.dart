// lib/src/providers/search_provider.dart
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/search_service.dart';

class SearchProvider extends ChangeNotifier {
  final SearchService _searchService = SearchService();
  
  List<ProductModel> _searchResults = [];
  bool _isLoading = false;

  List<ProductModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  // Perform text-based search
  Future<void> searchByText(List<ProductModel> products, String query) async {
    _isLoading = true;
    notifyListeners();
    
    _searchResults = _searchService.searchByText(products, query);
    
    _isLoading = false;
    notifyListeners();
  }

  // Perform barcode-based search
  Future<void> searchByBarcode(List<ProductModel> products, String barcode) async {
    _isLoading = true;
    notifyListeners();
    
    // Assuming barcode corresponds to product ID
    _searchResults = products.where((product) => product.id == barcode).toList();
    
    _isLoading = false;
    notifyListeners();
  }
}
