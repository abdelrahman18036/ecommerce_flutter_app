// lib/src/widgets/categories_section.dart
import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoriesSection extends StatelessWidget {
  final List<CategoryModel> categories;

  const CategoriesSection({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to ProductListScreen with categoryId
                    Navigator.pushNamed(
                      context,
                      '/product_list',
                      arguments: category.id, // Pass categoryId as String
                    );
                  },
                  child: CircleAvatar(
                    radius: 30, // Adjust size as needed
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      category.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  category.name,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
