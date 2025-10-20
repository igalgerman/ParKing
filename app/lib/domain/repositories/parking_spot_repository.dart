/// Parking spot repository interface.
///
/// Defines the contract for parking spot operations including publishing,
/// searching, updating, and managing parking spots.
library;

import '../../core/error/result.dart';
import '../entities/parking_spot.dart';

/// Repository for parking spot operations.
abstract class ParkingSpotRepository {
  /// Publishes a new parking spot.
  ///
  /// Creates a new active spot with the provider's current location.
  /// A provider can only have ONE active spot at a time.
  ///
  /// Returns [Result<ParkingSpot>] with the published spot on success,
  /// or [Failure] if:
  /// - Provider already has an active spot
  /// - Location accuracy is below threshold
  /// - Network error occurs
  ///
  /// Example:
  /// ```dart
  /// final spot = ParkingSpot(...);
  /// final result = await repository.publishSpot(spot);
  /// ```
  Future<Result<ParkingSpot>> publishSpot(ParkingSpot spot);

  /// Searches for nearby parking spots within a radius.
  ///
  /// Uses geohash for efficient spatial queries.
  /// Only returns ACTIVE spots (not sold/expired/cancelled).
  ///
  /// Parameters:
  /// - [location]: Center point for search
  /// - [radiusKm]: Search radius in kilometers (default: 1.0)
  /// - [limit]: Maximum results to return (default: 50)
  ///
  /// Returns [Result<List<ParkingSpot>>] with nearby spots sorted by:
  /// Score = (0.4 × time) + (0.6 × distance)
  Future<Result<List<ParkingSpot>>> searchNearbySpots({
    required Location location,
    double radiusKm = 1.0,
    int limit = 50,
  });

  /// Gets a specific parking spot by ID.
  ///
  /// Returns [Result<ParkingSpot>] with the spot if found,
  /// or [Failure] if spot doesn't exist.
  Future<Result<ParkingSpot>> getSpotById(String spotId);

  /// Gets all spots published by a specific provider.
  ///
  /// Includes all statuses (active, sold, expired, cancelled).
  /// Sorted by most recent first.
  Future<Result<List<ParkingSpot>>> getProviderSpots(String providerId);

  /// Marks a spot as unavailable (cancelled by provider).
  ///
  /// Can only be called by the spot's provider.
  /// Changes status from 'active' to 'cancelled'.
  ///
  /// Returns [Result<void>] indicating success or failure.
  Future<Result<void>> cancelSpot(String spotId);

  /// Updates spot status (used when purchased by seeker).
  ///
  /// Internal method called during transaction creation.
  /// Changes status from 'active' to 'sold'.
  Future<Result<ParkingSpot>> updateSpotStatus({
    required String spotId,
    required SpotStatus status,
  });

  /// Stream of real-time nearby spots.
  ///
  /// Listens to Firestore changes and emits updated spot lists.
  /// Automatically filters expired spots.
  ///
  /// Use this for reactive UI that updates as spots are published/sold.
  Stream<List<ParkingSpot>> watchNearbySpots({
    required Location location,
    double radiusKm = 1.0,
  });

  /// Gets the provider's currently active spot (if any).
  ///
  /// Returns [Result<ParkingSpot?>] with the active spot or null.
  /// A provider can only have one active spot at a time.
  Future<Result<ParkingSpot?>> getActiveSpot(String providerId);
}
