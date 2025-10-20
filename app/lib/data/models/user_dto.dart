/// User Data Transfer Object.
///
/// Represents the user data structure in Firestore.
/// Maps between domain entities and Firestore documents.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

/// DTO for User data in Firestore.
class UserDto {
  final String id;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;
  final String role; // 'provider', 'seeker', or 'both'
  final Timestamp createdAt;
  final Timestamp lastLoginAt;
  final UserStatsDto stats;
  final UserSettingsDto settings;

  const UserDto({
    required this.id,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    required this.role,
    required this.createdAt,
    required this.lastLoginAt,
    required this.stats,
    required this.settings,
  });

  /// Creates a UserDto from Firestore document data.
  factory UserDto.fromFirestore(Map<String, dynamic> data, String id) {
    return UserDto(
      id: id,
      email: data['email'] as String,
      displayName: data['displayName'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
      photoUrl: data['photoUrl'] as String?,
      role: data['role'] as String? ?? 'both',
      createdAt: data['createdAt'] as Timestamp,
      lastLoginAt: data['lastLoginAt'] as Timestamp,
      stats: UserStatsDto.fromMap(
        data['stats'] as Map<String, dynamic>? ?? {},
      ),
      settings: UserSettingsDto.fromMap(
        data['settings'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  /// Converts UserDto to Firestore document data.
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'role': role,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
      'stats': stats.toMap(),
      'settings': settings.toMap(),
    };
  }
}

/// DTO for user statistics.
class UserStatsDto {
  final int spotsPublished;
  final int spotsPurchased;
  final int successfulTransactions;
  final int disputedTransactions;

  const UserStatsDto({
    this.spotsPublished = 0,
    this.spotsPurchased = 0,
    this.successfulTransactions = 0,
    this.disputedTransactions = 0,
  });

  factory UserStatsDto.fromMap(Map<String, dynamic> map) {
    return UserStatsDto(
      spotsPublished: map['spotsPublished'] as int? ?? 0,
      spotsPurchased: map['spotsPurchased'] as int? ?? 0,
      successfulTransactions: map['successfulTransactions'] as int? ?? 0,
      disputedTransactions: map['disputedTransactions'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'spotsPublished': spotsPublished,
      'spotsPurchased': spotsPurchased,
      'successfulTransactions': successfulTransactions,
      'disputedTransactions': disputedTransactions,
    };
  }
}

/// DTO for user settings.
class UserSettingsDto {
  final bool notificationsEnabled;
  final double defaultSearchRadius;
  final String preferredLanguage;
  final bool biometricEnabled;

  const UserSettingsDto({
    this.notificationsEnabled = true,
    this.defaultSearchRadius = 1.0,
    this.preferredLanguage = 'en',
    this.biometricEnabled = false,
  });

  factory UserSettingsDto.fromMap(Map<String, dynamic> map) {
    return UserSettingsDto(
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
      defaultSearchRadius:
          (map['defaultSearchRadius'] as num?)?.toDouble() ?? 1.0,
      preferredLanguage: map['preferredLanguage'] as String? ?? 'en',
      biometricEnabled: map['biometricEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'defaultSearchRadius': defaultSearchRadius,
      'preferredLanguage': preferredLanguage,
      'biometricEnabled': biometricEnabled,
    };
  }
}
