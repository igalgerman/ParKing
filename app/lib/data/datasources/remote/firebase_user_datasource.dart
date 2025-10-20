/// Firebase Firestore User Data Source.
///
/// Handles Firestore operations for user data.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_dto.dart';

/// Data source for user operations in Firestore.
class FirebaseUserDataSource {
  final FirebaseFirestore _firestore;
  static const String _collectionName = 'users';

  FirebaseUserDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Gets a user document by ID.
  ///
  /// Returns null if user doesn't exist.
  Future<UserDto?> getUserById(String userId) async {
    try {
      final doc =
          await _firestore.collection(_collectionName).doc(userId).get();

      if (!doc.exists) {
        return null;
      }

      return UserDto.fromFirestore(doc.data()!, doc.id);
    } catch (e) {
      rethrow;
    }
  }

  /// Creates a new user document.
  Future<void> createUser(UserDto user) async {
    await _firestore
        .collection(_collectionName)
        .doc(user.id)
        .set(user.toFirestore());
  }

  /// Updates an existing user document.
  Future<void> updateUser(UserDto user) async {
    await _firestore
        .collection(_collectionName)
        .doc(user.id)
        .update(user.toFirestore());
  }

  /// Updates user's last login time.
  Future<void> updateLastLogin(String userId) async {
    await _firestore.collection(_collectionName).doc(userId).update({
      'lastLoginAt': FieldValue.serverTimestamp(),
    });
  }

  /// Deletes a user document.
  Future<void> deleteUser(String userId) async {
    await _firestore.collection(_collectionName).doc(userId).delete();
  }

  /// Stream of user document changes.
  Stream<UserDto?> watchUser(String userId) {
    return _firestore
        .collection(_collectionName)
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        return null;
      }
      return UserDto.fromFirestore(doc.data()!, doc.id);
    });
  }
}
