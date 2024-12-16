// lib/src/screens/auth/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  DateTime? birthDate;
  bool isLoading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(), // Use dark theme for date picker
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        birthDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap outside
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo or App Icon
              Center(
                child: Icon(
                  Icons.shopping_bag,
                  color: Colors.blueAccent,
                  size: 100,
                ),
              ),
              const SizedBox(height: 40),
              // Name Field
              CustomTextField(
                controller: nameCtrl,
                hint: 'Name',
                prefixIcon: Icons.person, // Now valid
              ),
              const SizedBox(height: 20),
              // Email Field
              CustomTextField(
                controller: emailCtrl,
                hint: 'Email',
                keyboardType: TextInputType.emailAddress, // Now valid
                prefixIcon: Icons.email, // Now valid
              ),
              const SizedBox(height: 20),
              // Password Field
              CustomTextField(
                controller: passCtrl,
                hint: 'Password',
                obscureText: true,
                prefixIcon: Icons.lock, // Now valid
              ),
              const SizedBox(height: 20),
              // Birthdate Picker
              ElevatedButton(
                onPressed: _pickBirthDate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Updated from 'primary'
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  birthDate == null
                      ? 'Select Birthdate'
                      : 'Birthdate: ${birthDate!.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
              // Sign Up Button
              ElevatedButton(
                onPressed: isLoading ? null : () async {
                  setState(() { isLoading = true; });
                  try {
                    await auth.signUp(
                      email: emailCtrl.text.trim(),
                      password: passCtrl.text.trim(),
                      name: nameCtrl.text.trim().isEmpty ? null : nameCtrl.text.trim(),
                      birthDate: birthDate,
                    );
                    if (auth.isLoggedIn) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sign up failed: $e'))
                    );
                  } finally {
                    setState(() { isLoading = false; });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Updated from 'primary'
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2.0,
                        ),
                      )
                    : const Text('Sign Up'),
              ),
              const SizedBox(height: 20),
              // Login Prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? '),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
