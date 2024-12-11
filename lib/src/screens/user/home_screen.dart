// lib/src/screens/user/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/categories_provider.dart';
import '../../widgets/categories_section.dart';
import '../../widgets/products_grid.dart';
import '../../widgets/custom_search_bar.dart';
import '../user/cart_screen.dart';
import '../user/profile_screen.dart';
import '../admin/admin_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of screens corresponding to bottom navigation items
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeContent(),
      const CartScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    final categoriesProvider = Provider.of<CategoriesProvider>(context);

    final products = productsProvider.products;
    final categories = categoriesProvider.categories;

    List<BottomNavigationBarItem> navItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ];

    if (auth.isAdmin) {
      navItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.admin_panel_settings),
        label: 'Admin',
      ));
      _screens.add(const AdminDashboardScreen());
    }

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: navItems,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}

// Separate widget for Home content to keep Scaffold clean
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final categoriesProvider = Provider.of<CategoriesProvider>(context);

    final products = productsProvider.products;
    final categories = categoriesProvider.categories;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          // Search Bar
          const CustomSearchBar(),
          const SizedBox(height: 10),
          // Categories Section
          CategoriesSection(categories: categories),
          const SizedBox(height: 10),
          // Products Grid
          ProductsGrid(products: products),
        ],
      ),
    );
  }
}
