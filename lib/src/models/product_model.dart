class ProductModel {
  final String id;
  final String name;
  final String categoryId;
  final double price;
  final int stockQuantity;
  final String imageUrl;
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.stockQuantity,
    required this.imageUrl,
    required this.description,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProductModel(
      id: docId,
      name: map['name'] ?? '',
      categoryId: map['category_id'] ?? '',
      price: (map['price'] as num).toDouble(),
      stockQuantity: map['stockQuantity'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category_id': categoryId,
      'price': price,
      'stockQuantity': stockQuantity,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}
