// lib/src/screens/admin/admin_dashboard_screen.dart

import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a consistent button style
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.blueAccent, // Button background color
      foregroundColor: Colors.white, // Button text color
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      minimumSize: const Size(200, 50), // Ensures buttons have the same width
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Add Product Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add_product');
                },
                style: buttonStyle,
                child: const Text('Add Product'),
              ),
              const SizedBox(height: 20), // Spacing between buttons

              // Manage Products Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/manage_products');
                },
                style: buttonStyle,
                child: const Text('Manage Products'),
              ),
              const SizedBox(height: 20),

              // Add Category Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add_category');
                },
                style: buttonStyle,
                child: const Text('Add Category'),
              ),
              const SizedBox(height: 20),

              // Manage Categories Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/manage_categories');
                },
                style: buttonStyle,
                child: const Text('Manage Categories'),
              ),
              const SizedBox(height: 20),

              // View Reports Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/reports');
                },
                style: buttonStyle,
                child: const Text('View Reports'),
              ),
              const SizedBox(height: 20),

              // Best Selling Products Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/best_selling_chart');
                },
                style: buttonStyle,
                child: const Text('Best Selling Products'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
