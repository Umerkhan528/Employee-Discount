// auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with email and password
  Future<User?> signIn(String email, String password, String userType) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Verify user role in Firestore
      final userDoc =
          await _firestore.collection('users').doc(result.user?.uid).get();
      if (!userDoc.exists || userDoc.data()?['role'] != userType) {
        await _auth.signOut();
        throw 'This email is registered as a different user type';
      }

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // Sign up with email and password
  Future<User?> signUp(String email, String password, String userType) async {
    try {
      // 1. Check if email exists using Firebase Auth (more secure)
      final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(
        email,
      );
      if (methods.isNotEmpty) {
        throw 'This email is already registered';
      }

      // 2. Create user in Firebase Auth
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 3. Store user data in Firestore
      await _firestore.collection('users').doc(result.user?.uid).set({
        'email': email,
        'role': userType,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // Get current user data
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data();
  }

  // Helper method to convert Firebase errors to user-friendly messages
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is badly formatted';
      case 'user-disabled':
        return 'This user has been disabled';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'weak-password':
        return 'Password is too weak';
      default:
        return e.message ?? 'An authentication error occurred';
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
