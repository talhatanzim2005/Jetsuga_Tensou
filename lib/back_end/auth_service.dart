import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream of authentication state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Current logged-in user.
  User? get currentUser => _auth.currentUser;

  /// Register user with Email & Password.
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (credential.user != null) {
      await credential.user!.updateDisplayName(displayName.trim());
      await saveUserProfile(credential.user!, name: displayName.trim());
    }

    return credential;
  }

  /// Sign in user with Email & Password.
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (credential.user != null) {
      await saveUserProfile(credential.user!);
    }

    return credential;
  }

  /// Sign in with Google / Gmail popup or redirect.
  Future<UserCredential> signInWithGoogle() async {
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();
    googleProvider.addScope('email');
    googleProvider.addScope('profile');

    UserCredential credential;
    if (kIsWeb) {
      credential = await _auth.signInWithPopup(googleProvider);
    } else {
      credential = await _auth.signInWithProvider(googleProvider);
    }

    if (credential.user != null) {
      await saveUserProfile(credential.user!);
    }

    return credential;
  }

  /// Save or update user profile details in Firestore (`users/{uid}`).
  Future<void> saveUserProfile(User user, {String? name}) async {
    try {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final snapshot = await userDoc.get();

      final String resolvedName = (name != null && name.trim().isNotEmpty)
          ? name.trim()
          : (user.displayName != null && user.displayName!.trim().isNotEmpty)
              ? user.displayName!.trim()
              : emailToName(user.email ?? '');

      final data = {
        'uid': user.uid,
        'email': user.email ?? '',
        'displayName': resolvedName,
        'photoURL': user.photoURL ?? '',
        'lastLogin': FieldValue.serverTimestamp(),
      };

      if (!snapshot.exists) {
        data['createdAt'] = FieldValue.serverTimestamp();
        await userDoc.set(data);
      } else {
        await userDoc.update(data);
      }
    } catch (e) {
      debugPrint('Error saving user profile to Firestore: $e');
    }
  }

  /// Helper to derive display name from email if name is empty.
  static String emailToName(String email) {
    if (email.contains('@')) {
      final parts = email.split('@').first.split('.');
      return parts.map((p) => p.isEmpty ? '' : p[0].toUpperCase() + p.substring(1)).join(' ');
    }
    return email.isEmpty ? 'Student' : email;
  }

  /// Sign out current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
