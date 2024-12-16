// lib/src/screens/auth/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../user/home_screen.dart';
import 'login_screen.dart';




class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        // While checking the auth state, show a loading indicator
        if (auth.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If the user is logged in, show HomeScreen
        if (auth.isLoggedIn) {
          return const HomeScreen();
        }

        // Otherwise, show LoginScreen
        return const LoginScreen();
      },
    );
  }
}
