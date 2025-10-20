/// Environment configuration for ParKing POC.
/// Supports local, staging, and production environments.
enum Environment {
  local,
  staging,
  production,
}

/// Environment configuration helper.
class EnvironmentConfig {
  /// Gets the current environment from dart-define.
  static Environment get current {
    const envString = String.fromEnvironment('ENV', defaultValue: 'local');
    return Environment.values.firstWhere(
      (e) => e.name == envString,
      orElse: () => Environment.local,
    );
  }
  
  /// Whether app is running in development mode.
  static bool get isDevelopment => current == Environment.local;
  
  /// Whether app is running in staging mode.
  static bool get isStaging => current == Environment.staging;
  
  /// Whether app is running in production mode.
  static bool get isProduction => current == Environment.production;
}
