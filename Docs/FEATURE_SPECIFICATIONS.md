# ParKing - Feature Specifications

## Feature Overview

This document details the functional requirements for each feature in the ParKing POC.

---

## 1. User Authentication

### 1.1 User Registration

**Description**: New users can create an account using multiple methods.

**User Story**: As a new user, I want to create an account so I can use the app as either a provider or seeker.

**Authentication Methods**:
- Email/Password
- Google Sign-In
- Apple Sign-In (iOS)
- Phone Number (SMS verification)

**Acceptance Criteria**:
- ✅ User enters valid email and password (min 8 chars, 1 uppercase, 1 number)
- ✅ Email verification sent
- ✅ Password strength indicator shown
- ✅ Social login redirects work correctly
- ✅ Phone verification code received within 60 seconds
- ✅ User profile created in Firestore
- ✅ Error messages clear and helpful

**Technical Requirements**:
- Firebase Authentication
- Email verification via Firebase
- OAuth 2.0 for social login
- Phone Auth with reCAPTCHA

**Edge Cases**:
- Email already registered → Clear error message
- Weak password → Validation error with requirements
- Network failure during registration → Retry mechanism
- Verification email in spam → Resend option

**Test Cases**:
1. Valid email/password registration succeeds
2. Duplicate email registration fails with proper error
3. Weak password rejected
4. Social login creates user profile
5. Phone verification code validates correctly
6. Expired verification code handled gracefully

---

### 1.2 User Login

**Description**: Registered users can log in to access their account.

**User Story**: As a registered user, I want to log in securely so I can access my account.

**Login Methods**: Same as registration (email, social, phone)

**Acceptance Criteria**:
- ✅ Valid credentials grant access
- ✅ Invalid credentials show error
- ✅ "Remember me" option available
- ✅ "Forgot password" flow works
- ✅ Session persists across app restarts
- ✅ Biometric login option (fingerprint/face)

**Technical Requirements**:
- Firebase Auth persistence
- Secure token storage
- Biometric authentication (local_auth package)

**Test Cases**:
1. Correct credentials → successful login
2. Wrong password → error message
3. Unverified email → verification reminder
4. "Forgot password" sends reset email
5. Biometric auth works when enabled
6. Session persists after app restart

---

### 1.3 User Profile

**Description**: Users have a profile with basic information.

**Profile Fields**:
- Name (required)
- Email (from auth)
- Phone (optional)
- Profile photo (optional)
- Account created date
- Total spots published (provider)
- Total spots purchased (seeker)

**Acceptance Criteria**:
- ✅ Profile editable after registration
- ✅ Photo upload works (max 5MB)
- ✅ Profile syncs across devices
- ✅ Privacy settings available

---

## 2. Provider Features

### 2.1 Publish Parking Spot

**Description**: Provider publishes available parking spot with one click.

**User Story**: As a provider, I want to quickly publish my empty parking spot so I can earn money from it.

**Flow**:
1. Provider taps "Publish Spot" button
2. App captures GPS coordinates automatically
3. App shows confirmation with location preview
4. Provider confirms or adjusts location
5. Spot published to Firestore
6. Provider sees "Spot Active" status

**Acceptance Criteria**:
- ✅ GPS coordinates captured with high precision (<5m accuracy)
- ✅ Location permissions granted
- ✅ Coordinates validated (not null, within valid range)
- ✅ Spot appears in seeker searches immediately
- ✅ Provider can see their active spot on map
- ✅ Publish button disabled if spot already active
- ✅ Auto-expiry after X minutes (configurable)

**Technical Requirements**:
- **geolocator** package for GPS
- Location permissions (iOS: NSLocationWhenInUseUsageDescription)
- Firestore GeoPoint type
- Real-time Firestore updates
- Geohash for efficient location queries

**Data Model**:
```dart
class ParkingSpot {
  String id;
  String providerId;
  GeoPoint location;
  String geohash;
  DateTime publishedAt;
  DateTime? expiresAt;
  SpotStatus status; // active, sold, expired
  double? price; // Phase 2
}
```

**Edge Cases**:
- GPS unavailable → Show error, retry
- Low GPS accuracy → Warning, ask to retry
- Already has active spot → Prevent duplicate
- Indoor location → May have low accuracy warning
- Airplane mode → Network error handling

**Test Cases**:
1. GPS permission granted → location captured
2. GPS permission denied → error shown
3. High accuracy location (<5m) → publish succeeds
4. Low accuracy location (>50m) → warning shown
5. Network failure → retry mechanism
6. Spot auto-expires after X minutes
7. Provider can only have one active spot

---

### 2.2 View Active Spot

**Description**: Provider can see their active parking spot details.

**User Story**: As a provider, I want to see if my spot is active and when it expires.

**Display Info**:
- Spot location on map
- Published time
- Time until expiration
- Status (active/sold/expired)
- Seeker count nearby (Phase 2)

**Acceptance Criteria**:
- ✅ Real-time status updates
- ✅ Map shows precise location
- ✅ Countdown timer for expiration
- ✅ Push notification when spot sold (Phase 2)

---

### 2.3 Mark Spot Unavailable

**Description**: Provider can manually mark spot as unavailable.

**User Story**: As a provider, I want to cancel my spot if I leave before it's purchased.

**Flow**:
1. Provider taps "Mark Unavailable"
2. Confirmation dialog shown
3. Spot status updated to "cancelled"
4. Spot removed from seeker searches

**Acceptance Criteria**:
- ✅ Confirmation required
- ✅ Immediate removal from searches
- ✅ Can publish again after cancellation

**Test Cases**:
1. Cancel button updates status
2. Spot disappears from seeker results
3. Provider can publish new spot after cancel

---

## 3. Seeker Features

### 3.1 Search Nearby Spots

**Description**: Seeker searches for parking spots around their location.

**User Story**: As a seeker, I want to find available parking near me without revealing exact locations until I pay.

**Search Criteria**:
- Current location (GPS)
- Search radius (default: 1km, adjustable)

**Display Format**:
- **Aggregated view** (privacy-first):
  - "5 spots within 500m"
  - "2 spots within 200m"
  - Distance ranges, not exact locations
- **Map view**: Heatmap or cluster markers (not individual pins)

**Ranking Algorithm**:
```
Score = (Time Weight × Time Since Published) + (Distance Weight × Distance)
```

**Configuration** (in config file):
```dart
const timeWeight = 0.4;
const distanceWeight = 0.6;
```

**Acceptance Criteria**:
- ✅ GPS location captured accurately
- ✅ Spots shown in order of relevance (time + distance)
- ✅ No exact locations visible before purchase
- ✅ Real-time updates as new spots published
- ✅ Expired spots automatically removed
- ✅ Search radius adjustable (500m - 5km)
- ✅ "No spots found" message if empty

**Technical Requirements**:
- Firestore geoqueries (geoflutterfire package)
- Real-time listeners
- Distance calculation (Haversine formula)
- Efficient pagination

**Edge Cases**:
- No spots available → Helpful message
- Poor GPS signal → Retry mechanism
- Too many spots → Pagination
- Network slow → Loading indicator

**Test Cases**:
1. Spots within radius displayed
2. Spots sorted by time + distance
3. Expired spots not shown
4. Real-time update when spot published
5. Adjusting radius updates results
6. No exact locations shown

---

### 3.2 Purchase Spot

**Description**: Seeker selects and "purchases" a spot (no payment in POC).

**User Story**: As a seeker, I want to claim a parking spot so I can see its exact location.

**Flow**:
1. Seeker taps on spot in list
2. Details shown: distance, time published
3. Seeker taps "Get This Spot"
4. Confirmation dialog with timer info
5. Transaction created
6. Exact location revealed
7. Timer starts (Y minutes to arrive)

**Acceptance Criteria**:
- ✅ First seeker to tap gets the spot
- ✅ Other seekers see "Spot Taken" if simultaneous
- ✅ Exact location shown on map
- ✅ Navigation option available (maps app)
- ✅ Timer starts immediately (Y minutes)
- ✅ Transaction recorded in Firestore

**Transaction Model**:
```dart
class Transaction {
  String id;
  String spotId;
  String providerId;
  String seekerId;
  DateTime purchasedAt;
  DateTime? verifiedAt;
  DateTime expiresAt; // Y minutes from purchase
  TransactionStatus status; // pending, verified, failed, refunded
  String? photoUrl;
}
```

**Race Condition Handling**:
- Use Firestore transaction to ensure atomicity
- Only one seeker can claim a spot
- Others get "Already taken" error

**Test Cases**:
1. First seeker successfully purchases
2. Second seeker gets "taken" error
3. Location revealed after purchase
4. Timer counts down correctly
5. Transaction created in database
6. Provider notified of sale (Phase 2)

---

### 3.3 Verify Spot (Photo Upload)

**Description**: Seeker uploads photo to verify parking spot condition.

**User Story**: As a seeker, I want to verify the spot is as described to complete the transaction or get a refund.

**Flow**:
1. Seeker arrives at location
2. App prompts "Take verification photo"
3. Seeker opens camera
4. Photo taken
5. Photo uploaded to Firebase Storage
6. Photo analyzed (basic checks)
7. Transaction marked as verified or disputed

**Acceptance Criteria**:
- ✅ Photo required within Z minutes
- ✅ Photo compressed before upload (max 2MB)
- ✅ Countdown timer shown
- ✅ Camera opens directly from app
- ✅ Upload progress indicator shown
- ✅ Success/failure feedback immediate

**Photo Validation** (Basic in POC):
- File size check
- Image format validation (JPEG/PNG)
- Timestamp verification
- GPS metadata (optional)

**Refund/Dispute Logic**:
- **If spot empty/as described**: Transaction completes successfully
- **If spot occupied/doesn't exist**: 
  - Seeker marks "Spot Not Available"
  - Photo submitted as proof
  - Transaction marked for review
  - Seeker gets refund (Phase 2: automated)
  - Seeker offered alternative spots

**Technical Requirements**:
- **image_picker** package
- **image** package for compression
- Firebase Storage upload
- Metadata extraction

**Edge Cases**:
- Photo upload fails → Retry option
- Timer expires → Transaction disputed
- No camera permission → Error message
- Photo too large → Auto-compress
- Network slow → Upload queue

**Test Cases**:
1. Photo taken and uploaded successfully
2. Compressed to under 2MB
3. Upload within Z minutes succeeds
4. Upload after Z minutes triggers dispute
5. Failed upload allows retry
6. "Spot not available" triggers refund flow

---

### 3.4 Get Alternative Spot

**Description**: If purchased spot is unavailable, seeker gets another suggestion.

**User Story**: As a seeker, if my spot is taken, I want to quickly get another option without starting over.

**Flow**:
1. Seeker marks spot as "Not Available"
2. Photo proof uploaded
3. App automatically searches for next best spot
4. Alternative spots shown
5. Seeker can claim alternative (free - no charge)

**Acceptance Criteria**:
- ✅ Alternative suggestions immediate
- ✅ Sorted by same algorithm (time + distance)
- ✅ No additional payment (Phase 2)
- ✅ Original transaction refunded (Phase 2)

**Test Cases**:
1. Dispute triggers alternative search
2. Next best spot suggested
3. Seeker can claim alternative
4. Original transaction marked refunded

---

## 4. Real-Time Features

### 4.1 Spot Availability Updates

**Description**: Real-time updates when spots are published, sold, or expired.

**Technical Implementation**:
- Firestore real-time listeners
- Stream-based updates in UI
- Efficient query subscriptions

**Acceptance Criteria**:
- ✅ New spots appear within 2 seconds
- ✅ Sold spots removed immediately
- ✅ Expired spots cleaned up automatically

---

### 4.2 Timer Management

**Description**: Multiple countdown timers for different scenarios.

**Timers**:
1. **Spot Expiry Timer** (X minutes): Auto-expires unpurchased spots
2. **Arrival Timer** (Y minutes): Time to reach purchased spot
3. **Photo Upload Timer** (Z minutes): Time to upload verification

**Acceptance Criteria**:
- ✅ Timers sync with server time (prevent client manipulation)
- ✅ Visual countdown shown
- ✅ Actions triggered automatically on expiry
- ✅ Notifications sent near expiry (Phase 2)

**Technical Requirements**:
- Server-side timestamps (Firestore server timestamp)
- Background timer handling
- Timer persistence across app restarts

---

## 5. Configuration Management

### 5.1 Timing Configuration

**Description**: All timing values stored in configuration file for easy adjustment.

**Config File** (`lib/core/config/timing_config.dart`):
```dart
class TimingConfig {
  // Spot expiry time (minutes)
  static const int spotExpiryMinutes = 30;
  
  // Time to reach spot after purchase (minutes)
  static const int arrivalTimeMinutes = 15;
  
  // Time to upload verification photo (minutes)
  static const int photoUploadMinutes = 5;
  
  // Search refresh interval (seconds)
  static const int searchRefreshSeconds = 10;
  
  // GPS accuracy threshold (meters)
  static const double gpsAccuracyThreshold = 10.0;
}
```

**Acceptance Criteria**:
- ✅ Single source of truth for all timings
- ✅ No hardcoded values in code
- ✅ Easy to modify for testing
- ✅ Can be overridden by environment (dev/staging/prod)

---

## 6. Map Integration

### 6.1 Map Display

**Description**: Interactive map showing parking locations.

**Features**:
- Current user location
- Cluster view for seekers (before purchase)
- Precise pin for provider/purchased spot
- Distance circles
- Map controls (zoom, center)

**Technical Requirements**:
- **flutter_map** package
- OpenStreetMap tiles
- Custom markers
- Geolocation overlay

**Acceptance Criteria**:
- ✅ Map loads quickly (<2 seconds)
- ✅ User location shown accurately
- ✅ Smooth pan and zoom
- ✅ Works offline (cached tiles)

---

## 7. Error Handling & User Feedback

### 7.1 Error Messages

**Principles**:
- User-friendly language
- Actionable suggestions
- No technical jargon

**Examples**:
- ❌ "Firebase exception: permission-denied"
- ✅ "Unable to publish spot. Please check your internet connection."

### 7.2 Loading States

**Requirements**:
- Loading indicators for all async operations
- Skeleton screens for list views
- Progress bars for uploads
- Pull-to-refresh for search

### 7.3 Success Feedback

**Requirements**:
- Confirmation messages
- Visual feedback (animations)
- Sound/haptic feedback (optional)

---

## Feature Priority Matrix

### Must Have (POC)
- ✅ Authentication (email + social)
- ✅ Publish spot
- ✅ Search spots
- ✅ Purchase spot
- ✅ Photo verification
- ✅ Real-time updates
- ✅ Timers

### Should Have (POC)
- Profile editing
- Transaction history
- Mark spot unavailable
- Alternative spot suggestion

### Nice to Have (Phase 2)
- Push notifications
- Payment integration
- Rating system
- AI dispute resolution
- Turn-by-turn navigation

### Won't Have (POC)
- Chat between users
- Advanced analytics
- Multi-language
- Dark mode

---

**Document Version**: 1.0  
**Last Updated**: October 20, 2025  
**Status**: Draft - Under Review
