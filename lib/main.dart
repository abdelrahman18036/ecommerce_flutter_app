import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/config/theme.dart';
import 'src/config/routes.dart';
import 'src/providers/auth_provider.dart';
import 'src/providers/products_provider.dart';
import 'src/providers/categories_provider.dart';
import 'src/providers/cart_provider.dart';
import 'src/providers/orders_provider.dart';
import 'src/providers/admin_provider.dart';
import 'src/providers/search_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: MaterialApp(
        title: 'My E-commerce App',
        theme: buildThemeData(),
        initialRoute: '/',
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
