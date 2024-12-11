// lib/src/widgets/category_chip.dart
import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryChip extends StatelessWidget {
  final CategoryModel category;
  const CategoryChip({super.key, required this.category});
  
  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(
        category.name,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blueAccent,
      onPressed: () {
        // Handle category selection, e.g., navigate to category-specific products
        Navigator.pushNamed(
          context,
          '/product_list',
          arguments: category.id,
        );
      },
    );
  }
}
