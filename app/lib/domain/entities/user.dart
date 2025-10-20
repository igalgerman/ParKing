/// User entity - Core domain model
///
/// Represents a user in the ParKing system.
/// Can act as both provider (publishing spots) and seeker (finding spots).
class User {
  final String id;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;
  final UserRole role;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final UserStats stats;
  final UserSettings settings;

  const User({
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

  /// Creates a copy with updated fields
  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
    UserRole? role,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    UserStats? stats,
    UserSettings? settings,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      stats: stats ?? this.stats,
      settings: settings ?? this.settings,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;

  @override
  String toString() => 'User(id: $id, email: $email, role: $role)';
}

/// User role in the system
enum UserRole {
  provider, // Publishes parking spots
  seeker, // Searches for parking spots
  both, // Can switch between roles
}

/// User statistics
class UserStats {
  final int spotsPublished;
  final int spotsPurchased;
  final int successfulTransactions;
  final int disputedTransactions;

  const UserStats({
    this.spotsPublished = 0,
    this.spotsPurchased = 0,
    this.successfulTransactions = 0,
    this.disputedTransactions = 0,
  });

  UserStats copyWith({
    int? spotsPublished,
    int? spotsPurchased,
    int? successfulTransactions,
    int? disputedTransactions,
  }) {
    return UserStats(
      spotsPublished: spotsPublished ?? this.spotsPublished,
      spotsPurchased: spotsPurchased ?? this.spotsPurchased,
      successfulTransactions:
          successfulTransactions ?? this.successfulTransactions,
      disputedTransactions: disputedTransactions ?? this.disputedTransactions,
    );
  }
}

/// User settings/preferences
class UserSettings {
  final bool notificationsEnabled;
  final double defaultSearchRadius; // in kilometers
  final String preferredLanguage;
  final bool biometricEnabled;

  const UserSettings({
    this.notificationsEnabled = true,
    this.defaultSearchRadius = 1.0,
    this.preferredLanguage = 'en',
    this.biometricEnabled = false,
  });

  UserSettings copyWith({
    bool? notificationsEnabled,
    double? defaultSearchRadius,
    String? preferredLanguage,
    bool? biometricEnabled,
  }) {
    return UserSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      defaultSearchRadius: defaultSearchRadius ?? this.defaultSearchRadius,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}
