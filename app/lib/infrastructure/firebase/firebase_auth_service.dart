/// Firebase Authentication Service.
///
/// Provides low-level Firebase Auth operations.
/// This is the infrastructure layer - called by data layer repositories.
library;

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

/// Service for Firebase Authentication operations.
///
/// This wraps Firebase Auth SDK to isolate infrastructure concerns.
/// The data layer will call this service and handle errors.
class FirebaseAuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  FirebaseAuthService({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  /// Gets the currently authenticated Firebase user.
  ///
  /// Returns null if no user is logged in.
  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  /// Stream of authentication state changes.
  ///
  /// Emits the current user when state changes (login/logout).
  Stream<firebase_auth.User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  /// Signs in a user with email and password.
  ///
  /// Throws [firebase_auth.FirebaseAuthException] on failure.
  Future<firebase_auth.UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Creates a new user account with email and password.
  ///
  /// Throws [firebase_auth.FirebaseAuthException] on failure.
  Future<firebase_auth.UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Signs out the current user.
  ///
  /// Throws [firebase_auth.FirebaseAuthException] on failure.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Sends a password reset email to the specified address.
  ///
  /// Throws [firebase_auth.FirebaseAuthException] on failure.
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// Updates the current user's display name.
  ///
  /// Throws [firebase_auth.FirebaseAuthException] on failure.
  Future<void> updateDisplayName(String displayName) async {
    await _firebaseAuth.currentUser?.updateDisplayName(displayName);
    await _firebaseAuth.currentUser?.reload();
  }

  /// Updates the current user's photo URL.
  ///
  /// Throws [firebase_auth.FirebaseAuthException] on failure.
  Future<void> updatePhotoUrl(String photoUrl) async {
    await _firebaseAuth.currentUser?.updatePhotoURL(photoUrl);
    await _firebaseAuth.currentUser?.reload();
  }

  /// Deletes the current user account.
  ///
  /// Throws [firebase_auth.FirebaseAuthException] on failure.
  /// Requires recent authentication.
  Future<void> deleteUser() async {
    await _firebaseAuth.currentUser?.delete();
  }

  /// Reloads the current user's data from Firebase.
  Future<void> reloadUser() async {
    await _firebaseAuth.currentUser?.reload();
  }
}
