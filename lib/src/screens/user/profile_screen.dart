import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'order_history_screen.dart';
import '../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers for editable fields
  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedBirthDate;

  bool _isEditing = false;
  bool _isLoading = false;

  // Initialize controllers with current user data
  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.currentUser;
    if (user != null) {
      _nameController.text = user.name ?? '';
      _selectedBirthDate = user.birthDate;
    }
  }

  // Dispose controllers to free resources
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Function to select birth date
  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(), // Ensures the date picker matches the dark theme
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  // Function to save updated profile
  Future<void> _saveProfile() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user information available.')),
      );
      return;
    }

    // Basic validation
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Create updated user model
    try {
      await auth.updateUserProfile(
        name: _nameController.text.trim(),
        birthDate: _selectedBirthDate,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      setState(() {
        _isEditing = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to logout
  Future<void> _logout() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    try {
      await auth.logout();
      Navigator.pushReplacementNamed(context, '/login');
      // After logout, navigation is typically handled by the main app based on auth state
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout Failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white, 
          fontSize: 20, 
          fontWeight: FontWeight.bold,
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      backgroundColor: Colors.black,
      body: user == null
          ? const Center(
              child: Text(
                'No user information available.',
                style: TextStyle(fontSize: 18, color: Colors.white54),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blueAccent,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Email (Non-editable)
                        ListTile(
                          leading: const Icon(Icons.email, color: Colors.white),
                          title: const Text(
                            'Email',
                            style: TextStyle(color: Colors.white70),
                          ),
                          subtitle: Text(
                            user.email,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Name (Editable)
                        ListTile(
                          leading: const Icon(Icons.person, color: Colors.white),
                          title: const Text(
                            'Name',
                            style: TextStyle(color: Colors.white70),
                          ),
                          subtitle: _isEditing
                              ? TextField(
                                  controller: _nameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your name',
                                    hintStyle: TextStyle(color: Colors.white54),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white70),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blueAccent),
                                    ),
                                  ),
                                )
                              : Text(
                                  user.name ?? 'No Name',
                                  style: const TextStyle(color: Colors.white),
                                ),
                        ),
                        const SizedBox(height: 10),
                        // Birth Date (Editable)
                        ListTile(
                          leading: const Icon(Icons.cake, color: Colors.white),
                          title: const Text(
                            'Birth Date',
                            style: TextStyle(color: Colors.white70),
                          ),
                          subtitle: _isEditing
                              ? Row(
                                  children: [
                                    Text(
                                      _selectedBirthDate != null
                                          ? '${_selectedBirthDate!.day}/${_selectedBirthDate!.month}/${_selectedBirthDate!.year}'
                                          : 'No Date Selected',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.calendar_today, color: Colors.white),
                                      onPressed: () => _selectBirthDate(context),
                                    ),
                                  ],
                                )
                              : Text(
                                  user.birthDate != null
                                      ? '${user.birthDate!.day}/${user.birthDate!.month}/${user.birthDate!.year}'
                                      : 'No Birth Date',
                                  style: const TextStyle(color: Colors.white),
                                ),
                        ),
                        const SizedBox(height: 30),
                        // Order History ListTile
                        ListTile(
                          leading: const Icon(Icons.history, color: Colors.white),
                          title: const Text(
                            'Order History',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
                          onTap: () {
                            Navigator.pushNamed(context, '/order_history');
                          },
                        ),
                        const SizedBox(height: 20),
                        // Logout Button
                        ElevatedButton(
                          onPressed: _logout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text('Logout'),
                        ),
                        // Save Button (Visible Only When Editing)
                        if (_isEditing)
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: ElevatedButton(
                              onPressed: _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text('Save'),
                            ),
                          ),
                        // Cancel Edit Button
                        if (_isEditing)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                                // Reset fields to original values
                                final originalUser = auth.currentUser;
                                _nameController.text = originalUser?.name ?? '';
                                _selectedBirthDate = originalUser?.birthDate;
                              });
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white54),
                            ),
                          ),
                      ],
                    ),
            ),
        );
      }
    }