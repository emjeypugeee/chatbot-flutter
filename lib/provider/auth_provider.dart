import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  User? get currentUser => _auth.currentUser;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    setLoading(true);
    clearError();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      setError(_getErrorMessage(e.code));
      return false;
    }
  }

  // New method to read user data from Firestore
  // It returns a Map<String, dynamic> of the user's document data.
  Future<Map<String, dynamic>?> getUserData() async {
    final user = currentUser;
    if (user == null) {
      setError("User is not logged in.");
      return null;
    }

    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        // Return the data as a Map
        return docSnapshot.data();
      } else {
        // Document doesn't exist (e.g., deleted or registration failed silently)
        setError("User profile data not found.");
        return null;
      }
    } on FirebaseException catch (e) {
      // This will catch the 'permission-denied' error if rules are wrong
      setError("Failed to fetch user data: ${e.message}");
      return null;
    } catch (e) {
      setError("An unexpected error occurred: $e");
      return null;
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'invalid-email':
        return 'Email is not valid';
      case 'user-disabled':
        return 'This user has been disabled';
      default:
        return 'Login failed. Please try again';
    }
  }

  Future<bool> register(String name, String email, String password) async {
    setLoading(true);
    clearError();

    try {
      // Create user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Define local user variable for clarity and safety
      final user = userCredential.user;

      if (user != null) {
        // 1. Update user profile with name in Firebase Auth
        await user.updateDisplayName(name.trim());

        // 2. Save user data to Cloud Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name.trim(),
          'email': email.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      setLoading(false);
      return true; // Success
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      setError(_getRegisterErrorMessage(e.code));
      return false; // Failed
    }
  }

  String _getRegisterErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Email is not valid';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'weak-password':
        return 'Password is too weak';
      default:
        return 'Registration failed. Please try again';
    }
  }
}
