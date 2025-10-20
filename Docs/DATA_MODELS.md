# ParKing - Data Models & Database Schema

## Database Technology

**Primary Database**: Firebase Firestore (NoSQL, real-time)

## Firestore Collections Structure

```
firestore/
├── users/
├── parking_spots/
├── transactions/
├── configurations/
└── disputes/ (Phase 2)
```

---

## 1. Users Collection

**Collection Path**: `/users/{userId}`

### Document Schema

```dart
class User {
  String id;                    // Firebase Auth UID
  String email;
  String? displayName;
  String? phoneNumber;
  String? photoUrl;
  UserRole role;                // provider, seeker, or both
  DateTime createdAt;
  DateTime lastLoginAt;
  UserStats stats;
  UserSettings settings;
  
  // Geolocation (for nearby user queries - optional)
  GeoPoint? lastKnownLocation;
  String? geohash;
}

enum UserRole {
  provider,
  seeker,
  both,  // Can switch between roles
}

class UserStats {
  int spotsPublished;
  int spotsPurchased;
  int successfulTransactions;
  int disputedTransactions;
  double totalEarned;          // Phase 2
  double totalSpent;           // Phase 2
}

class UserSettings {
  bool notificationsEnabled;    // Phase 2
  double defaultSearchRadius;   // in kilometers
  String preferredLanguage;     // Phase 2
  bool biometricEnabled;
}
```

### Indexes

```
- email (ascending)
- createdAt (descending)
- geohash (ascending) - for nearby user queries
```

### Security Rules

```javascript
match /users/{userId} {
  allow read: if request.auth != null;
  allow write: if request.auth != null && request.auth.uid == userId;
}
```

### Example Document

```json
{
  "id": "user_abc123",
  "email": "john@example.com",
  "displayName": "John Doe",
  "phoneNumber": "+1234567890",
  "photoUrl": "https://storage.googleapis.com/...",
  "role": "both",
  "createdAt": "2025-10-20T10:00:00Z",
  "lastLoginAt": "2025-10-20T14:30:00Z",
  "stats": {
    "spotsPublished": 12,
    "spotsPurchased": 8,
    "successfulTransactions": 7,
    "disputedTransactions": 1,
    "totalEarned": 0,
    "totalSpent": 0
  },
  "settings": {
    "notificationsEnabled": true,
    "defaultSearchRadius": 1.0,
    "preferredLanguage": "en",
    "biometricEnabled": true
  },
  "lastKnownLocation": {
    "latitude": 40.7128,
    "longitude": -74.0060
  },
  "geohash": "dr5regw"
}
```

---

## 2. Parking Spots Collection

**Collection Path**: `/parking_spots/{spotId}`

### Document Schema

```dart
class ParkingSpot {
  String id;
  String providerId;
  GeoPoint location;            // Firestore GeoPoint
  String geohash;               // For efficient geo queries
  DateTime publishedAt;
  DateTime expiresAt;           // Auto-calculated: publishedAt + X minutes
  SpotStatus status;
  LocationMetadata locationMetadata;
  
  // Phase 2 fields
  double? price;
  String? description;
  List<String>? photoUrls;
  SpotType? type;               // street, garage, driveway, etc.
}

enum SpotStatus {
  active,      // Published and available
  sold,        // Purchased by seeker
  expired,     // Expired without purchase
  cancelled,   // Manually cancelled by provider
}

enum SpotType {
  street,
  garage,
  driveway,
  lot,
  other,
}

class LocationMetadata {
  double accuracy;              // GPS accuracy in meters
  String? address;              // Reverse geocoded address (Phase 2)
  String? city;
  String? country;
}
```

### Indexes

```
Compound indexes:
- status (ascending) + geohash (ascending) + publishedAt (descending)
- providerId (ascending) + status (ascending) + publishedAt (descending)
- status (ascending) + expiresAt (ascending) - for cleanup queries
```

### Security Rules

```javascript
match /parking_spots/{spotId} {
  // Anyone can read active spots
  allow read: if request.auth != null && resource.data.status == 'active';
  
  // Provider can read their own spots
  allow read: if request.auth != null && request.auth.uid == resource.data.providerId;
  
  // Provider can create spots
  allow create: if request.auth != null 
                && request.resource.data.providerId == request.auth.uid
                && request.resource.data.status == 'active';
  
  // Provider can update their own spots
  allow update: if request.auth != null 
                && resource.data.providerId == request.auth.uid;
}
```

### Example Document

```json
{
  "id": "spot_xyz789",
  "providerId": "user_abc123",
  "location": {
    "_latitude": 40.7128,
    "_longitude": -74.0060
  },
  "geohash": "dr5regw3p",
  "publishedAt": "2025-10-20T14:00:00Z",
  "expiresAt": "2025-10-20T14:30:00Z",
  "status": "active",
  "locationMetadata": {
    "accuracy": 5.2,
    "address": "123 Main St",
    "city": "New York",
    "country": "USA"
  }
}
```

---

## 3. Transactions Collection

**Collection Path**: `/transactions/{transactionId}`

### Document Schema

```dart
class Transaction {
  String id;
  String spotId;
  String providerId;
  String seekerId;
  
  // Timestamps
  DateTime createdAt;           // When seeker purchased
  DateTime? verifiedAt;         // When photo uploaded
  DateTime? disputedAt;         // If disputed
  DateTime expiresAt;           // Y minutes from createdAt
  
  // Status
  TransactionStatus status;
  
  // Verification
  String? verificationPhotoUrl;
  VerificationResult? verificationResult;
  
  // Location snapshot (in case spot deleted)
  GeoPoint spotLocation;
  
  // Payment (Phase 2)
  PaymentInfo? payment;
  
  // Dispute (Phase 2)
  DisputeInfo? dispute;
}

enum TransactionStatus {
  pending,          // Purchased, waiting for verification
  verified,         // Photo uploaded and approved
  completed,        // Transaction successfully completed
  disputed,         // Seeker reported issue
  refunded,         // Refund issued
  expired,          // Verification deadline passed
}

enum VerificationResult {
  spotAvailable,    // Spot exists and is empty
  spotOccupied,     // Spot exists but occupied
  spotNotFound,     // Spot doesn't exist
  pending,          // Under review
}

class PaymentInfo {
  double amount;
  String currency;
  String paymentMethod;
  String? transactionId;
  DateTime? paidAt;
  DateTime? refundedAt;
}

class DisputeInfo {
  String reason;
  List<String> photoUrls;
  String seekerComment;
  String? providerResponse;
  String? aiAnalysis;         // Phase 2: AI-powered dispute resolution
  DisputeStatus status;
}

enum DisputeStatus {
  open,
  underReview,
  resolvedForSeeker,
  resolvedForProvider,
  escalated,
}
```

### Indexes

```
Compound indexes:
- seekerId (ascending) + createdAt (descending)
- providerId (ascending) + createdAt (descending)
- status (ascending) + createdAt (descending)
- status (ascending) + expiresAt (ascending) - for cleanup
```

### Security Rules

```javascript
match /transactions/{transactionId} {
  // Read: Only involved parties
  allow read: if request.auth != null 
              && (request.auth.uid == resource.data.seekerId 
                  || request.auth.uid == resource.data.providerId);
  
  // Create: Only seekers
  allow create: if request.auth != null 
                && request.resource.data.seekerId == request.auth.uid;
  
  // Update: Only involved parties
  allow update: if request.auth != null 
                && (request.auth.uid == resource.data.seekerId 
                    || request.auth.uid == resource.data.providerId);
}
```

### Example Document

```json
{
  "id": "txn_123abc",
  "spotId": "spot_xyz789",
  "providerId": "user_abc123",
  "seekerId": "user_def456",
  "createdAt": "2025-10-20T14:05:00Z",
  "verifiedAt": "2025-10-20T14:18:00Z",
  "expiresAt": "2025-10-20T14:20:00Z",
  "status": "verified",
  "verificationPhotoUrl": "https://storage.googleapis.com/parking-verification/photo123.jpg",
  "verificationResult": "spotAvailable",
  "spotLocation": {
    "_latitude": 40.7128,
    "_longitude": -74.0060
  }
}
```

---

## 4. Configurations Collection

**Collection Path**: `/configurations/app_config`

### Document Schema

```dart
class AppConfiguration {
  TimingConfig timing;
  SearchConfig search;
  VerificationConfig verification;
  FeatureFlags features;
  DateTime lastUpdated;
}

class TimingConfig {
  int spotExpiryMinutes;        // X
  int arrivalTimeMinutes;       // Y
  int photoUploadMinutes;       // Z
  int searchRefreshSeconds;
  int autoCleanupIntervalHours;
}

class SearchConfig {
  double defaultRadiusKm;
  double maxRadiusKm;
  double minRadiusKm;
  int maxResultsPerQuery;
  double gpsAccuracyThreshold;
  
  // Ranking algorithm weights
  double timeWeight;
  double distanceWeight;
}

class VerificationConfig {
  int maxPhotoSizeMB;
  List<String> allowedFormats;
  bool requireGpsMetadata;
  double minPhotoQuality;
}

class FeatureFlags {
  bool paymentEnabled;
  bool notificationsEnabled;
  bool ratingsEnabled;
  bool aiDisputeResolution;
  bool advancedSearch;
}
```

### Example Document

```json
{
  "timing": {
    "spotExpiryMinutes": 30,
    "arrivalTimeMinutes": 15,
    "photoUploadMinutes": 5,
    "searchRefreshSeconds": 10,
    "autoCleanupIntervalHours": 1
  },
  "search": {
    "defaultRadiusKm": 1.0,
    "maxRadiusKm": 5.0,
    "minRadiusKm": 0.5,
    "maxResultsPerQuery": 50,
    "gpsAccuracyThreshold": 10.0,
    "timeWeight": 0.4,
    "distanceWeight": 0.6
  },
  "verification": {
    "maxPhotoSizeMB": 2,
    "allowedFormats": ["jpg", "jpeg", "png"],
    "requireGpsMetadata": false,
    "minPhotoQuality": 0.7
  },
  "features": {
    "paymentEnabled": false,
    "notificationsEnabled": false,
    "ratingsEnabled": false,
    "aiDisputeResolution": false,
    "advancedSearch": false
  },
  "lastUpdated": "2025-10-20T10:00:00Z"
}
```

### Security Rules

```javascript
match /configurations/{configId} {
  // Everyone can read
  allow read: if request.auth != null;
  
  // Only admins can write (set via Firebase Console)
  allow write: if false;  // Only through Firebase Console/Cloud Functions
}
```

---

## 5. Firebase Storage Structure

**Bucket**: `parking-app.appspot.com`

### Folder Structure

```
storage/
├── users/
│   └── {userId}/
│       └── profile.jpg
├── verifications/
│   └── {transactionId}/
│       ├── verification.jpg
│       └── dispute_photo_1.jpg
└── spots/ (Phase 2 - spot photos)
    └── {spotId}/
        └── photo.jpg
```

### Storage Rules

```javascript
service firebase.storage {
  match /b/{bucket}/o {
    // User profile photos
    match /users/{userId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId
                   && request.resource.size < 5 * 1024 * 1024  // 5MB limit
                   && request.resource.contentType.matches('image/.*');
    }
    
    // Verification photos - only involved parties can read/write
    match /verifications/{transactionId}/{fileName} {
      allow read: if request.auth != null && 
                   (request.auth.uid == get(/databases/$(database)/documents/transactions/$(transactionId)).data.seekerId ||
                    request.auth.uid == get(/databases/$(database)/documents/transactions/$(transactionId)).data.providerId);
      allow write: if request.auth != null
                   && request.resource.size < 2 * 1024 * 1024  // 2MB limit
                   && request.resource.contentType.matches('image/(jpeg|jpg|png)');
    }
  }
}
```

---

## 6. Data Relationships

### Entity Relationship Diagram

```
┌─────────────┐
│    Users    │
└──────┬──────┘
       │
       ├─────────────────┐
       │                 │
       ▼                 ▼
┌─────────────┐   ┌──────────────┐
│ParkingSpots │   │Transactions  │
│(as provider)│   │(as seeker)   │
└─────────────┘   └──────────────┘
       │                 │
       └────────┬────────┘
                ▼
         ┌──────────────┐
         │Transactions  │
         └──────────────┘
```

### Relationships

1. **User → ParkingSpots**: One-to-many (provider)
2. **User → Transactions**: One-to-many (seeker)
3. **ParkingSpot → Transaction**: One-to-one (spot can only be sold once)
4. **Transaction → User**: Many-to-one (many transactions per user)

---

## 7. Data Access Patterns

### Common Queries

#### 1. Find Nearby Active Spots

```dart
// Using geohash for efficient geoqueries
Future<List<ParkingSpot>> getNearbySpots(
  GeoPoint center, 
  double radiusKm
) async {
  final geohashes = calculateGeohashRange(center, radiusKm);
  
  return firestore
    .collection('parking_spots')
    .where('status', isEqualTo: 'active')
    .where('geohash', isGreaterThanOrEqualTo: geohashes.lower)
    .where('geohash', isLessThanOrEqualTo: geohashes.upper)
    .orderBy('geohash')
    .orderBy('publishedAt', descending: true)
    .get();
}
```

#### 2. Get User's Active Spot

```dart
Future<ParkingSpot?> getUserActiveSpot(String userId) async {
  final snapshot = await firestore
    .collection('parking_spots')
    .where('providerId', isEqualTo: userId)
    .where('status', isEqualTo: 'active')
    .limit(1)
    .get();
  
  return snapshot.docs.isNotEmpty ? snapshot.docs.first.data() : null;
}
```

#### 3. Get User's Pending Transactions

```dart
Future<List<Transaction>> getPendingTransactions(String userId) async {
  return firestore
    .collection('transactions')
    .where('seekerId', isEqualTo: userId)
    .where('status', isEqualTo: 'pending')
    .orderBy('createdAt', descending: true)
    .get();
}
```

#### 4. Cleanup Expired Spots (Cloud Function)

```dart
// Runs every hour via Cloud Scheduler
Future<void> cleanupExpiredSpots() async {
  final now = DateTime.now();
  
  final expiredSpots = await firestore
    .collection('parking_spots')
    .where('status', isEqualTo: 'active')
    .where('expiresAt', isLessThan: now)
    .get();
  
  for (var doc in expiredSpots.docs) {
    await doc.reference.update({'status': 'expired'});
  }
}
```

---

## 8. Data Migration & Versioning

### Schema Versioning

Each document includes a `schemaVersion` field for future migrations:

```dart
class BaseModel {
  int schemaVersion = 1;
}
```

### Migration Strategy

1. Add new fields as optional
2. Maintain backward compatibility
3. Use Cloud Functions for bulk migrations
4. Version API responses

---

## 9. Data Retention & Cleanup

### Retention Policy

| Data Type | Retention Period | Cleanup Method |
|-----------|------------------|----------------|
| Active spots | Until sold/expired | Auto (status change) |
| Expired spots | 7 days | Cloud Function |
| Completed transactions | 90 days | Cloud Function |
| Disputed transactions | 1 year | Manual review |
| User accounts | Until deleted | User action |
| Verification photos | 30 days | Cloud Function |

### Cleanup Cloud Functions

- `cleanupExpiredSpots`: Hourly
- `archiveOldTransactions`: Daily
- `deleteOldVerificationPhotos`: Weekly

---

## 10. Performance Optimization

### Strategies

1. **Indexing**: Compound indexes for common queries
2. **Geohashing**: Efficient location queries
3. **Pagination**: Limit query results
4. **Caching**: Client-side caching for config
5. **Denormalization**: Store frequently accessed data redundantly
6. **Real-time Listeners**: Use wisely to avoid excessive reads

### Firestore Limits

- Max document size: 1MB
- Max write rate: 1 write/second per document
- Max query results: 50,000 docs (use pagination)

---

**Document Version**: 1.0  
**Last Updated**: October 20, 2025  
**Status**: Draft - Under Review
