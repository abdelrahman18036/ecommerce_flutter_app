// lib/src/models/category_model.dart
class CategoryModel {
  final String id;
  final String name;

  CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromMap(Map<String, dynamic> map, String docId) {
    return CategoryModel(
      id: docId,
      name: map['name'] ?? 'Unnamed Category', // Provide a default value
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      // Add other fields if necessary
    };
  }
}
