/// Transaction entity - Core domain model
///
/// Represents a parking spot transaction between provider and seeker.
/// Includes verification status and timing information.
class Transaction {
  final String id;
  final String spotId;
  final String providerId;
  final String seekerId;
  final DateTime createdAt;
  final DateTime? verifiedAt;
  final DateTime? disputedAt;
  final DateTime expiresAt;
  final TransactionStatus status;
  final String? verificationPhotoUrl;
  final VerificationResult? verificationResult;

  const Transaction({
    required this.id,
    required this.spotId,
    required this.providerId,
    required this.seekerId,
    required this.createdAt,
    this.verifiedAt,
    this.disputedAt,
    required this.expiresAt,
    required this.status,
    this.verificationPhotoUrl,
    this.verificationResult,
  });

  /// Creates a copy with updated fields
  Transaction copyWith({
    String? id,
    String? spotId,
    String? providerId,
    String? seekerId,
    DateTime? createdAt,
    DateTime? verifiedAt,
    DateTime? disputedAt,
    DateTime? expiresAt,
    TransactionStatus? status,
    String? verificationPhotoUrl,
    VerificationResult? verificationResult,
  }) {
    return Transaction(
      id: id ?? this.id,
      spotId: spotId ?? this.spotId,
      providerId: providerId ?? this.providerId,
      seekerId: seekerId ?? this.seekerId,
      createdAt: createdAt ?? this.createdAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      disputedAt: disputedAt ?? this.disputedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
      verificationPhotoUrl: verificationPhotoUrl ?? this.verificationPhotoUrl,
      verificationResult: verificationResult ?? this.verificationResult,
    );
  }

  /// Whether verification is still pending
  bool get isPending => status == TransactionStatus.pending;

  /// Whether transaction is completed successfully
  bool get isCompleted => status == TransactionStatus.completed;

  /// Whether transaction is disputed
  bool get isDisputed => status == TransactionStatus.disputed;

  /// Whether verification deadline has passed
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Minutes remaining for verification
  int get minutesRemaining {
    final diff = expiresAt.difference(DateTime.now());
    return diff.inMinutes.clamp(0, double.infinity).toInt();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Transaction(id: $id, status: $status)';
}

/// Transaction status lifecycle
enum TransactionStatus {
  pending, // Purchased, waiting for verification
  verified, // Photo uploaded and approved
  completed, // Transaction successfully completed
  disputed, // Seeker reported issue
  refunded, // Refund issued
  expired, // Verification deadline passed
}

/// Verification result from photo upload
enum VerificationResult {
  spotAvailable, // Spot exists and is empty
  spotOccupied, // Spot exists but occupied
  spotNotFound, // Spot doesn't exist
  pending, // Under review
}
