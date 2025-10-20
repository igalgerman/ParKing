/// Authentication State Management with Riverpod
///
/// Provides auth state, use cases, and repository instances.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/domain/repositories/auth_repository.dart';
import 'package:app/domain/usecases/auth/login_usecase.dart';
import 'package:app/domain/usecases/auth/register_usecase.dart';
import 'package:app/domain/usecases/auth/logout_usecase.dart';
import 'package:app/infrastructure/firebase/firebase_auth_service.dart';
import 'package:app/data/datasources/remote/firebase_user_datasource.dart';
import 'package:app/data/repositories/auth_repository_impl.dart';

// ============================================================================
// INFRASTRUCTURE PROVIDERS
// ============================================================================

/// Firebase Auth instance provider
final firebaseAuthProvider = Provider<firebase_auth.FirebaseAuth>((ref) {
  return firebase_auth.FirebaseAuth.instance;
});

/// Firestore instance provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Firebase Auth Service provider
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthService(firebaseAuth: firebaseAuth);
});

/// Firebase User DataSource provider
final firebaseUserDataSourceProvider = Provider<FirebaseUserDataSource>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebaseUserDataSource(firestore: firestore);
});

// ============================================================================
// REPOSITORY PROVIDERS
// ============================================================================

/// Auth Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(firebaseAuthServiceProvider);
  final userDataSource = ref.watch(firebaseUserDataSourceProvider);
  return AuthRepositoryImpl(
    authService: authService,
    userDataSource: userDataSource,
  );
});

// ============================================================================
// USE CASE PROVIDERS
// ============================================================================

/// Login UseCase provider
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

/// Register UseCase provider
final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
});

/// Logout UseCase provider
final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
});

// ============================================================================
// AUTH STATE PROVIDERS
// ============================================================================

/// Current authenticated user stream
final authStateProvider = StreamProvider<User?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

/// Current user provider (nullable)
final currentUserProvider = FutureProvider<User?>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  final result = await repository.getCurrentUser();
  
  return result.when(
    success: (user) => user,
    failure: (_) => null,
  );
});

/// Is user authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );
});
