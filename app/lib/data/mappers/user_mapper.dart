/// User Mapper.
///
/// Converts between User domain entities and UserDto data models.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';
import '../models/user_dto.dart';

/// Mapper for converting between User entities and DTOs.
class UserMapper {
  /// Converts UserDto to User domain entity.
  static User toDomain(UserDto dto) {
    return User(
      id: dto.id,
      email: dto.email,
      displayName: dto.displayName,
      phoneNumber: dto.phoneNumber,
      photoUrl: dto.photoUrl,
      role: _mapRole(dto.role),
      createdAt: dto.createdAt.toDate(),
      lastLoginAt: dto.lastLoginAt.toDate(),
      stats: _mapStatsToDomain(dto.stats),
      settings: _mapSettingsToDomain(dto.settings),
    );
  }

  /// Converts User domain entity to UserDto.
  static UserDto toDto(User user) {
    return UserDto(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      phoneNumber: user.phoneNumber,
      photoUrl: user.photoUrl,
      role: _mapRoleToString(user.role),
      createdAt: Timestamp.fromDate(user.createdAt),
      lastLoginAt: Timestamp.fromDate(user.lastLoginAt),
      stats: _mapStatsToDto(user.stats),
      settings: _mapSettingsToDto(user.settings),
    );
  }

  /// Maps role string to UserRole enum.
  static UserRole _mapRole(String role) {
    switch (role) {
      case 'provider':
        return UserRole.provider;
      case 'seeker':
        return UserRole.seeker;
      case 'both':
        return UserRole.both;
      default:
        return UserRole.both;
    }
  }

  /// Maps UserRole enum to string.
  static String _mapRoleToString(UserRole role) {
    switch (role) {
      case UserRole.provider:
        return 'provider';
      case UserRole.seeker:
        return 'seeker';
      case UserRole.both:
        return 'both';
    }
  }

  /// Maps UserStatsDto to UserStats domain entity.
  static UserStats _mapStatsToDomain(UserStatsDto dto) {
    return UserStats(
      spotsPublished: dto.spotsPublished,
      spotsPurchased: dto.spotsPurchased,
      successfulTransactions: dto.successfulTransactions,
      disputedTransactions: dto.disputedTransactions,
    );
  }

  /// Maps UserStats to UserStatsDto.
  static UserStatsDto _mapStatsToDto(UserStats stats) {
    return UserStatsDto(
      spotsPublished: stats.spotsPublished,
      spotsPurchased: stats.spotsPurchased,
      successfulTransactions: stats.successfulTransactions,
      disputedTransactions: stats.disputedTransactions,
    );
  }

  /// Maps UserSettingsDto to UserSettings domain entity.
  static UserSettings _mapSettingsToDomain(UserSettingsDto dto) {
    return UserSettings(
      notificationsEnabled: dto.notificationsEnabled,
      defaultSearchRadius: dto.defaultSearchRadius,
      preferredLanguage: dto.preferredLanguage,
      biometricEnabled: dto.biometricEnabled,
    );
  }

  /// Maps UserSettings to UserSettingsDto.
  static UserSettingsDto _mapSettingsToDto(UserSettings settings) {
    return UserSettingsDto(
      notificationsEnabled: settings.notificationsEnabled,
      defaultSearchRadius: settings.defaultSearchRadius,
      preferredLanguage: settings.preferredLanguage,
      biometricEnabled: settings.biometricEnabled,
    );
  }
}
