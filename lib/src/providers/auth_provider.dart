// lib/src/providers/auth_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart'; // Import the UserModel

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserModel? _currentUser; // Use UserModel instead of User
  bool _isAdmin = false;

  UserModel? get currentUser => _currentUser;
  bool get isAdmin => _isAdmin;

  AuthProvider() {
    // Listen for auth state changes
    _auth.authStateChanges().listen((user) async {
      if (user == null) {
        _currentUser = null;
        _isAdmin = false;
      } else {
        await _loadUserData(user.uid);
      }
      notifyListeners();
    });
  }

  // Sign Up Method
  Future<void> signUp({
    required String email,
    required String password,
    String? name,
    DateTime? birthDate,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Create UserModel instance
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          name: name ?? '',
          birthDate: birthDate,
        );

        // Save to Firestore
        await _db.collection('users').doc(user.uid).set(newUser.toMap());

        // Update local state
        _currentUser = newUser;
        _isAdmin = false; // default non-admin
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Sign Up Failed: $e');
    }
  }

  // Login Method
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // _authStateChanges listener will handle loading user data
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  // Logout Method
  Future<void> logout() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      _isAdmin = false;
      notifyListeners();
    } catch (e) {
      throw Exception('Logout Failed: $e');
    }
  }

  // Send Password Reset Email
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Password Reset Failed: $e');
    }
  }

  // Update User Profile
  Future<void> updateUserProfile({
    String? name,
    DateTime? birthDate,
  }) async {
    if (_currentUser == null) {
      throw Exception('No user is currently logged in.');
    }

    Map<String, dynamic> updatedData = {};

    if (name != null) {
      updatedData['name'] = name;
    }

    if (birthDate != null) {
      updatedData['birthDate'] = birthDate.toIso8601String();
    }

    try {
      // Update Firestore
      await _db.collection('users').doc(_currentUser!.uid).update(updatedData);

      // Update local state
      _currentUser = UserModel(
        uid: _currentUser!.uid,
        email: _currentUser!.email,
        name: name ?? _currentUser!.name,
        birthDate: birthDate ?? _currentUser!.birthDate,
      );
      notifyListeners();
    } catch (e) {
      throw Exception('Update Profile Failed: $e');
    }
  }
  
  bool get isLoggedIn => currentUser != null;

  // Private method to load user data from Firestore
  Future<void> _loadUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        _currentUser = UserModel.fromMap(data, uid);
        _isAdmin = data['isAdmin'] == true;
      } else {
        _currentUser = null;
        _isAdmin = false;
      }
    } catch (e) {
      _currentUser = null;
      _isAdmin = false;
      throw Exception('Failed to load user data: $e');
    }
  }
}
