// lib/src/config/routes.dart
import 'package:flutter/material.dart';

// Common Screens
import '../screens/common/splash_screen.dart';
import '../screens/common/not_found_screen.dart';

// Auth Screens
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';

// User Screens
import '../screens/user/home_screen.dart';
import '../screens/user/product_list_screen.dart';
import '../screens/user/product_detail_screen.dart';
import '../screens/user/cart_screen.dart';
import '../screens/user/checkout_screen.dart';
import '../screens/user/profile_screen.dart';
import '../screens/user/order_history_screen.dart';
import '../screens/user/feedback_screen.dart';
import '../screens/user/search_results_screen.dart';

// Admin Screens
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/add_product_screen.dart';
import '../screens/admin/edit_product_screen.dart';
import '../screens/admin/add_category_screen.dart';
import '../screens/admin/edit_category_screen.dart';
import '../screens/admin/reports_screen.dart';
import '../screens/admin/best_selling_chart_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print('Navigating to: ${settings.name} with arguments: ${settings.arguments}');
    switch (settings.name) {
      // Common Routes
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case '/forgot_password':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      // User Routes
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case '/search_results':
        return MaterialPageRoute(builder: (_) => const SearchResultsScreen());

      case '/product_list':
        // Expecting a String categoryId as argument
        if (settings.arguments is String) {
          final categoryId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => ProductListScreen(categoryId: categoryId),
          );
        }
        // If no arguments or wrong type, navigate to NotFoundScreen
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());

      case '/product_detail':
        // Expecting a String productId as argument
        if (settings.arguments is String) {
          final productId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: productId),
          );
        }
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());

      case '/cart':
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case '/checkout':
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      case '/order_history':
        return MaterialPageRoute(builder: (_) => const OrderHistoryScreen());
      case '/feedback':
        // Expecting an orderId (String) as argument
        if (settings.arguments is String) {
          final orderId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => FeedbackScreen(orderId: orderId),
          );
        }
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());

      // Admin Routes
      case '/admin':
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());
      case '/add_product':
        return MaterialPageRoute(builder: (_) => const AddProductScreen());
      case '/edit_product':
        // For editing product, expect productId as argument
        if (settings.arguments is String) {
          final productId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => EditProductScreen(productId: productId),
          );
        }
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());

      case '/add_category':
        return MaterialPageRoute(builder: (_) => const AddCategoryScreen());
      case '/edit_category':
        // For editing category, expect categoryId as argument
        if (settings.arguments is String) {
          final categoryId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => EditCategoryScreen(categoryId: categoryId),
          );
        }
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());

      case '/reports':
        return MaterialPageRoute(builder: (_) => const ReportsScreen());

      case '/best_selling_chart':
        return MaterialPageRoute(builder: (_) => const BestSellingChartScreen());

      default:
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());
    }
  }
}
