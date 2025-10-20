/// Transaction repository interface.
///
/// Defines the contract for transaction operations including creating,
/// verifying, and managing transactions between providers and seekers.
library;

import '../../core/error/result.dart';
import '../entities/transaction.dart';

/// Repository for transaction operations.
abstract class TransactionRepository {
  /// Creates a new transaction (seeker purchases a spot).
  ///
  /// This is the "purchase" action where a seeker claims a parking spot.
  /// The transaction starts in 'pending' status awaiting photo verification.
  ///
  /// Atomically updates:
  /// 1. Creates transaction record
  /// 2. Updates spot status to 'sold'
  /// 3. Prevents race conditions (only one seeker can purchase)
  ///
  /// Returns [Result<Transaction>] with the created transaction,
  /// or [Failure] if:
  /// - Spot already sold (race condition)
  /// - Spot doesn't exist
  /// - Network error
  ///
  /// Example:
  /// ```dart
  /// final result = await repository.createTransaction(
  ///   spotId: 'spot_123',
  ///   seekerId: 'user_456',
  /// );
  /// ```
  Future<Result<Transaction>> createTransaction({
    required String spotId,
    required String seekerId,
  });

  /// Verifies a transaction with photo proof.
  ///
  /// Seeker uploads photo to confirm spot condition.
  /// Updates transaction status based on verification result.
  ///
  /// Parameters:
  /// - [transactionId]: The transaction to verify
  /// - [photoUrl]: URL of uploaded verification photo
  /// - [result]: Verification result (spotAvailable, spotOccupied, spotNotFound)
  ///
  /// Returns [Result<Transaction>] with updated transaction.
  Future<Result<Transaction>> verifyTransaction({
    required String transactionId,
    required String photoUrl,
    required VerificationResult result,
  });

  /// Creates a dispute for a transaction.
  ///
  /// Called when seeker reports spot as unavailable/not as described.
  /// Uploads proof photos and marks transaction for review.
  ///
  /// Parameters:
  /// - [transactionId]: Transaction to dispute
  /// - [reason]: Dispute reason
  /// - [photoUrls]: Evidence photos
  ///
  /// Returns [Result<Transaction>] with disputed transaction.
  Future<Result<Transaction>> disputeTransaction({
    required String transactionId,
    required String reason,
    required List<String> photoUrls,
  });

  /// Gets a specific transaction by ID.
  ///
  /// Returns [Result<Transaction>] with the transaction if found.
  Future<Result<Transaction>> getTransactionById(String transactionId);

  /// Gets all transactions for a seeker.
  ///
  /// Returns transactions sorted by most recent first.
  Future<Result<List<Transaction>>> getSeekerTransactions(String seekerId);

  /// Gets all transactions for a provider.
  ///
  /// Returns transactions sorted by most recent first.
  Future<Result<List<Transaction>>> getProviderTransactions(String providerId);

  /// Gets the seeker's currently pending transaction (if any).
  ///
  /// A seeker can only have one pending transaction at a time.
  /// Returns null if no pending transaction exists.
  Future<Result<Transaction?>> getPendingTransaction(String seekerId);

  /// Completes a transaction (successful verification).
  ///
  /// Changes status from 'verified' to 'completed'.
  /// Triggered after photo verification confirms spot is available.
  Future<Result<Transaction>> completeTransaction(String transactionId);

  /// Marks transaction as expired (verification deadline passed).
  ///
  /// Called by Cloud Function when photo upload timer expires.
  /// Changes status to 'expired', may trigger refund in Phase 2.
  Future<Result<Transaction>> expireTransaction(String transactionId);

  /// Stream of real-time transaction updates.
  ///
  /// Listens to changes for a specific user (as seeker or provider).
  /// Useful for notifications and reactive UI.
  Stream<List<Transaction>> watchUserTransactions(String userId);
}
