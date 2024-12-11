// lib/src/widgets/products_grid.dart
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'product_card.dart'; // Correct import

class ProductsGrid extends StatelessWidget {
  final List<ProductModel> products;

  const ProductsGrid({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No products available.',
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product); // Use the single ProductCard
      },
    );
  }
}
