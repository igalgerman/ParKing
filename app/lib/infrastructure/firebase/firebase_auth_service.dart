/// Firebase Authentication Service.
///
/// Provides low-level Firebase Auth operations.
/// This is the infrastructure layer - called by data layer repositories.
library;

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

/// Service for Firebase Authentication operations.
///
/// This wraps Firebase Auth SDK to isolate infrastructure concerns.
/// The data layer will call this service and handle errors.
class FirebaseAuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthService({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

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

  /// Signs in with Google account.
  ///
  /// Opens Google Sign-In flow and returns Firebase credential.
  /// Throws [firebase_auth.FirebaseAuthException] or [GoogleSignIn] exceptions on failure.
  Future<firebase_auth.UserCredential> signInWithGoogle() async {
    // Trigger the Google Sign-In flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      // User cancelled the sign-in
      throw firebase_auth.FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credential
    return await _firebaseAuth.signInWithCredential(credential);
  }

  /// Verifies a phone number and triggers SMS code sending.
  ///
  /// This method initiates phone authentication. Firebase will send an SMS
  /// with a verification code to the provided phone number.
  ///
  /// Parameters:
  /// - [phoneNumber]: Phone number in E.164 format (e.g., +1234567890)
  /// - [onCodeSent]: Callback when SMS code is sent successfully
  /// - [onVerificationCompleted]: Callback for auto-verification (Android only)
  /// - [onVerificationFailed]: Callback when verification fails
  ///
  /// Returns the verification ID needed to complete sign-in.
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(firebase_auth.PhoneAuthCredential credential)
        onVerificationCompleted,
    required void Function(firebase_auth.FirebaseAuthException error)
        onVerificationFailed,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out
      },
    );
  }

  /// Signs in with phone number using verification code.
  ///
  /// Completes the phone authentication flow by verifying the SMS code.
  ///
  /// Parameters:
  /// - [verificationId]: ID received in onCodeSent callback
  /// - [smsCode]: 6-digit code sent to user's phone
  Future<firebase_auth.UserCredential> signInWithPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    // Create a PhoneAuthCredential with the code
    final credential = firebase_auth.PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    // Sign in to Firebase with the phone credential
    return await _firebaseAuth.signInWithCredential(credential);
  }
}

