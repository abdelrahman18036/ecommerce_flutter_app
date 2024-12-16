// lib/src/screens/admin/edit_product_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../models/product_model.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;
  const EditProductScreen({super.key, required this.productId});
  
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final nameCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final stockCtrl = TextEditingController();
  final imageUrlCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  
  bool _isLoading = false;
  ProductModel? _product;
  
  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }
  
  Future<void> _fetchProduct() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      _product = await adminProvider.getProductById(widget.productId);
      
      if (_product != null) {
        nameCtrl.text = _product!.name;
        categoryCtrl.text = _product!.categoryId;
        priceCtrl.text = _product!.price.toString();
        stockCtrl.text = _product!.stockQuantity.toString();
        imageUrlCtrl.text = _product!.imageUrl;
        descriptionCtrl.text = _product!.description;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load product: $e')),
      );
      Navigator.pop(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      final updatedProduct = ProductModel(
        id: _product!.id,
        name: nameCtrl.text.trim(),
        categoryId: categoryCtrl.text.trim(),
        description: descriptionCtrl.text.trim(),
        price: double.parse(priceCtrl.text.trim()),
        stockQuantity: int.parse(stockCtrl.text.trim()),
        imageUrl: imageUrlCtrl.text.trim(),
      );
      
      try {
        final adminProvider = Provider.of<AdminProvider>(context, listen: false);
        await adminProvider.updateProduct(updatedProduct);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully!')),
        );
        
        Navigator.pop(context);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update product: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  @override
  void dispose() {
    nameCtrl.dispose();
    categoryCtrl.dispose();
    priceCtrl.dispose();
    stockCtrl.dispose();
    imageUrlCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _product == null
                ? const Center(
                    child: Text(
                      'Product not found.',
                      style: TextStyle(fontSize: 18, color: Colors.white54),
                    ),
                  )
                : Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        // Name Field
                        TextFormField(
                          controller: nameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter the product name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Category ID Field
                        TextFormField(
                          controller: categoryCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Category ID',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter the category ID';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Description Field
                        TextFormField(
                          controller: descriptionCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter the product description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Price Field
                        TextFormField(
                          controller: priceCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter the price';
                            }
                            if (double.tryParse(value.trim()) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Stock Quantity Field
                        TextFormField(
                          controller: stockCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Stock Quantity',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter the stock quantity';
                            }
                            if (int.tryParse(value.trim()) == null) {
                              return 'Please enter a valid integer';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Image URL Field
                        TextFormField(
                          controller: imageUrlCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Image URL',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter the image URL';
                            }
                            // Basic URL validation
                            if (!Uri.parse(value.trim()).isAbsolute) {
                              return 'Please enter a valid URL';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        
                        // Update Button
                        ElevatedButton(
                          onPressed: _updateProduct,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Update Product',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
