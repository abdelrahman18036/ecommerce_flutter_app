// lib/src/providers/categories_provider.dart
import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/category_model.dart';

class CategoriesProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  CategoriesProvider() {
    loadCategories();
  }

  Future<void> loadCategories() async {
    _categories = await _service.getCategories();
    notifyListeners();
  }
}
