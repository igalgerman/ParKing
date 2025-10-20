/// Auth Repository Implementation.
///
/// Implements AuthRepository using Firebase Authentication and Firestore.
/// Handles error mapping from Firebase exceptions to domain errors.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../core/error/result.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../infrastructure/firebase/firebase_auth_service.dart';
import '../datasources/remote/firebase_user_datasource.dart';
import '../mappers/user_mapper.dart';
import '../models/user_dto.dart';

/// Implementation of AuthRepository using Firebase.
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _authService;
  final FirebaseUserDataSource _userDataSource;

  AuthRepositoryImpl({
    required FirebaseAuthService authService,
    required FirebaseUserDataSource userDataSource,
  })  : _authService = authService,
        _userDataSource = userDataSource;

  @override
  Future<Result<User>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Authenticate with Firebase Auth
      final credential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return const Failure(
          AuthenticationError('Login failed - no user returned'),
        );
      }

      // Update last login time
      await _userDataSource.updateLastLogin(credential.user!.uid);

      // Get user data from Firestore
      final userDto = await _userDataSource.getUserById(credential.user!.uid);

      if (userDto == null) {
        return const Failure(
          AuthenticationError('User data not found'),
        );
      }

      // Convert to domain entity
      final user = UserMapper.toDomain(userDto);
      return Success(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Failure(_mapFirebaseAuthError(e));
    } catch (e) {
      return Failure(NetworkError('Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Result<User>> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Create Firebase Auth account
      final credential = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return const Failure(
          AuthenticationError('Registration failed - no user returned'),
        );
      }

      // Update display name in Firebase Auth
      await _authService.updateDisplayName(displayName);
      await _authService.reloadUser();

      // Create user document in Firestore
      final now = Timestamp.now();
      final userDto = UserDto(
        id: credential.user!.uid,
        email: email,
        displayName: displayName,
        role: 'both', // Default role
        createdAt: now,
        lastLoginAt: now,
        stats: const UserStatsDto(),
        settings: const UserSettingsDto(),
      );

      await _userDataSource.createUser(userDto);

      // Convert to domain entity
      final user = UserMapper.toDomain(userDto);
      return Success(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Failure(_mapFirebaseAuthError(e));
    } catch (e) {
      return Failure(NetworkError('Registration failed: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _authService.signOut();
      return const Success(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Failure(_mapFirebaseAuthError(e));
    } catch (e) {
      return Failure(NetworkError('Logout failed: ${e.toString()}'));
    }
  }

  @override
  Future<Result<User?>> getCurrentUser() async {
    try {
      final firebaseUser = _authService.currentUser;

      if (firebaseUser == null) {
        return const Success(null);
      }

      final userDto = await _userDataSource.getUserById(firebaseUser.uid);

      if (userDto == null) {
        return const Success(null);
      }

      final user = UserMapper.toDomain(userDto);
      return Success(user);
    } catch (e) {
      return Failure(
          NetworkError('Failed to get current user: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> resetPassword({required String email}) async {
    try {
      await _authService.sendPasswordResetEmail(email: email);
      return const Success(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Failure(_mapFirebaseAuthError(e));
    } catch (e) {
      return Failure(NetworkError('Password reset failed: ${e.toString()}'));
    }
  }

  @override
  Future<Result<User>> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
  }) async {
    try {
      final currentFirebaseUser = _authService.currentUser;

      if (currentFirebaseUser == null) {
        return const Failure(
          AuthenticationError('No user logged in'),
        );
      }

      // Update Firebase Auth profile
      if (displayName != null) {
        await _authService.updateDisplayName(displayName);
      }
      if (photoUrl != null) {
        await _authService.updatePhotoUrl(photoUrl);
      }

      // Get current user data from Firestore
      final currentUserDto =
          await _userDataSource.getUserById(currentFirebaseUser.uid);

      if (currentUserDto == null) {
        return const Failure(
          AuthenticationError('User data not found'),
        );
      }

      // Update Firestore document
      final updatedDto = UserDto(
        id: currentUserDto.id,
        email: currentUserDto.email,
        displayName: displayName ?? currentUserDto.displayName,
        phoneNumber: phoneNumber ?? currentUserDto.phoneNumber,
        photoUrl: photoUrl ?? currentUserDto.photoUrl,
        role: currentUserDto.role,
        createdAt: currentUserDto.createdAt,
        lastLoginAt: currentUserDto.lastLoginAt,
        stats: currentUserDto.stats,
        settings: currentUserDto.settings,
      );

      await _userDataSource.updateUser(updatedDto);

      final user = UserMapper.toDomain(updatedDto);
      return Success(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Failure(_mapFirebaseAuthError(e));
    } catch (e) {
      return Failure(NetworkError('Profile update failed: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      final currentUser = _authService.currentUser;

      if (currentUser == null) {
        return const Failure(
          AuthenticationError('No user logged in'),
        );
      }

      // Delete Firestore document first
      await _userDataSource.deleteUser(currentUser.uid);

      // Delete Firebase Auth account
      await _authService.deleteUser();

      return const Success(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Failure(_mapFirebaseAuthError(e));
    } catch (e) {
      return Failure(NetworkError('Account deletion failed: ${e.toString()}'));
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return _authService.authStateChanges.asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }

      final userDto = await _userDataSource.getUserById(firebaseUser.uid);
      if (userDto == null) {
        return null;
      }

      return UserMapper.toDomain(userDto);
    });
  }

  /// Maps Firebase Auth exceptions to domain errors.
  AppError _mapFirebaseAuthError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return const AuthenticationError('No account found with this email');
      case 'wrong-password':
        return const AuthenticationError('Incorrect password');
      case 'email-already-in-use':
        return const AuthenticationError('Email already registered');
      case 'weak-password':
        return const ValidationError('Password is too weak');
      case 'invalid-email':
        return const ValidationError('Invalid email address');
      case 'user-disabled':
        return const AuthenticationError('Account has been disabled');
      case 'too-many-requests':
        return const NetworkError('Too many attempts. Try again later');
      case 'network-request-failed':
        return const NetworkError('Network error. Check your connection');
      default:
        return AuthenticationError(e.message ?? 'Authentication failed');
    }
  }
}
