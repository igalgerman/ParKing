/// Centralized timing configuration for ParKing POC.
/// All timing values are in minutes/seconds for easy adjustment during testing.
class TimingConfig {
  // Spot expiry time (X minutes)
  static const int spotExpiryMinutes = 30;

  // Time to reach spot after purchase (Y minutes)
  static const int arrivalTimeMinutes = 15;

  // Time to upload verification photo (Z minutes)
  static const int photoUploadMinutes = 5;

  // Search refresh interval (seconds)
  static const int searchRefreshSeconds = 10;

  // GPS accuracy threshold (meters)
  static const double gpsAccuracyThreshold = 10.0;
}
