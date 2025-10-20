/// ParkingSpot entity - Core domain model
///
/// Represents a parking spot published by a provider.
/// Contains location, status, and timing information.
class ParkingSpot {
  final String id;
  final String providerId;
  final Location location;
  final String geohash; // For efficient geoqueries
  final DateTime publishedAt;
  final DateTime expiresAt;
  final SpotStatus status;

  const ParkingSpot({
    required this.id,
    required this.providerId,
    required this.location,
    required this.geohash,
    required this.publishedAt,
    required this.expiresAt,
    required this.status,
  });

  /// Creates a copy with updated fields
  ParkingSpot copyWith({
    String? id,
    String? providerId,
    Location? location,
    String? geohash,
    DateTime? publishedAt,
    DateTime? expiresAt,
    SpotStatus? status,
  }) {
    return ParkingSpot(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      location: location ?? this.location,
      geohash: geohash ?? this.geohash,
      publishedAt: publishedAt ?? this.publishedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
    );
  }

  /// Whether the spot is currently available
  bool get isAvailable =>
      status == SpotStatus.active && DateTime.now().isBefore(expiresAt);

  /// Whether the spot has expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Minutes remaining until expiry
  int get minutesRemaining {
    final diff = expiresAt.difference(DateTime.now());
    return diff.inMinutes.clamp(0, double.infinity).toInt();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParkingSpot &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ParkingSpot(id: $id, providerId: $providerId, status: $status)';
}

/// Parking spot status
enum SpotStatus {
  active, // Published and available
  sold, // Purchased by seeker
  expired, // Expired without purchase
  cancelled, // Manually cancelled by provider
}

/// Geographic location with accuracy
class Location {
  final double latitude;
  final double longitude;
  final double accuracy; // in meters
  final DateTime timestamp;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
  });

  /// Whether the location has acceptable accuracy
  bool isAccurate(double thresholdMeters) => accuracy <= thresholdMeters;

  /// Validates latitude and longitude are within valid ranges
  bool get isValid =>
      latitude >= -90 &&
      latitude <= 90 &&
      longitude >= -180 &&
      longitude <= 180;

  Location copyWith({
    double? latitude,
    double? longitude,
    double? accuracy,
    DateTime? timestamp,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() =>
      'Location(lat: ${latitude.toStringAsFixed(6)}, lng: ${longitude.toStringAsFixed(6)}, accuracy: ${accuracy.toStringAsFixed(1)}m)';
}
