import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

import 'package:mess_manager/core/services/firebase_service.dart';

/// Firebase Authentication Service
/// Handles all authentication operations securely
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Current user stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Current user
  static User? get currentUser => _auth.currentUser;

  /// Check if user is logged in
  static bool get isAuthenticated => currentUser != null;

  /// Sign up with email and password
  static Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Update display name if provided
      if (displayName != null && credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
      }

      // Log analytics event
      await FirebaseService.logEvent(
        name: 'sign_up',
        parameters: {'method': 'email'},
      );
      await FirebaseService.setUserId(credential.user?.uid);

      return AuthResult.success(credential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e.code));
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Sign up failed',
      );
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  /// Sign in with email and password
  static Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await FirebaseService.logEvent(
        name: 'login',
        parameters: {'method': 'email'},
      );
      await FirebaseService.setUserId(credential.user?.uid);

      return AuthResult.success(credential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e.code));
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Sign in failed',
      );
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  /// Sign in with Google
  static Future<AuthResult> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return AuthResult.failure('Google sign in cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      await FirebaseService.logEvent(
        name: 'login',
        parameters: {'method': 'google'},
      );
      await FirebaseService.setUserId(userCredential.user?.uid);

      return AuthResult.success(userCredential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e.code));
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Google sign in failed',
      );
      return AuthResult.failure('Google sign in failed');
    }
  }

  /// Sign out
  static Future<void> signOut() async {
    try {
      await FirebaseService.logEvent(name: 'logout');
      await _googleSignIn.signOut();
      await _auth.signOut();
      await FirebaseService.setUserId(null);
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Sign out failed',
      );
    }
  }

  /// Send password reset email
  static Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      await FirebaseService.logEvent(name: 'password_reset_requested');
      return AuthResult.success(null, message: 'Password reset email sent');
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_mapAuthError(e.code));
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Password reset failed',
      );
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  /// Update user display name
  static Future<void> updateDisplayName(String name) async {
    await currentUser?.updateDisplayName(name);
    await currentUser?.reload();
  }

  /// Delete user account
  static Future<AuthResult> deleteAccount() async {
    try {
      await FirebaseService.logEvent(name: 'account_deleted');
      await currentUser?.delete();
      return AuthResult.success(null, message: 'Account deleted');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return AuthResult.failure(
          'Please sign in again to delete your account',
        );
      }
      return AuthResult.failure(_mapAuthError(e.code));
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Delete account failed',
      );
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  /// Map Firebase auth error codes to user-friendly messages
  static String _mapAuthError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'operation-not-allowed':
        return 'This sign in method is not enabled';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      default:
        if (kDebugMode) {
          debugPrint('Unmapped auth error: $code');
        }
        return 'Authentication failed';
    }
  }
}

/// Auth operation result
class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? message;
  final String? error;

  AuthResult._({required this.isSuccess, this.user, this.message, this.error});

  factory AuthResult.success(User? user, {String? message}) {
    return AuthResult._(isSuccess: true, user: user, message: message);
  }

  factory AuthResult.failure(String error) {
    return AuthResult._(isSuccess: false, error: error);
  }
}
