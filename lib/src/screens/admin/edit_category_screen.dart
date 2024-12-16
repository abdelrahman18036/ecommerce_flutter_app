// lib/src/screens/admin/edit_category_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../models/category_model.dart';

class EditCategoryScreen extends StatefulWidget {
  final String categoryId;
  const EditCategoryScreen({super.key, required this.categoryId});
  
  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final nameCtrl = TextEditingController();
  
  bool _isLoading = false;
  CategoryModel? _category;
  
  @override
  void initState() {
    super.initState();
    _fetchCategory();
  }
  
  Future<void> _fetchCategory() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      _category = await adminProvider.getCategoryById(widget.categoryId);
      
      if (_category != null) {
        nameCtrl.text = _category!.name;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load category: $e')),
      );
      Navigator.pop(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _updateCategory() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      final updatedCategory = CategoryModel(
        id: _category!.id,
        name: nameCtrl.text.trim(),
      );
      
      try {
        final adminProvider = Provider.of<AdminProvider>(context, listen: false);
        await adminProvider.updateCategory(updatedCategory);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category updated successfully!')),
        );
        
        Navigator.pop(context);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update category: $e')),
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
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Category'),
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
            : _category == null
                ? const Center(
                    child: Text(
                      'Category not found.',
                      style: TextStyle(fontSize: 18, color: Colors.white54),
                    ),
                  )
                : Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Name Field
                        TextFormField(
                          controller: nameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Category Name',
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
                              return 'Please enter the category name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        
                        // Update Button
                        ElevatedButton(
                          onPressed: _updateCategory,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Update Category',
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
