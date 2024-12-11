import 'package:flutter/material.dart';

class EditCategoryScreen extends StatelessWidget {
  final String categoryId;
  const EditCategoryScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Category')),
      body: const Center(child: Text('Edit category form here')),
    );
  }
}
