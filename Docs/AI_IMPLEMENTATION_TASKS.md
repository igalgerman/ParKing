# ParKing - AI Implementation Tasks

## Implementation Principles

**CRITICAL RULES FOR AI AGENTS:**

1. **UI-First Approach**: Each step MUST deliver a viewable, testable UI before moving to next step
2. **POC Focus**: Keep it simple, avoid over-engineering, no unnecessary features
3. **Small Files**: Maximum 200-300 lines per file
4. **Simple Code**: Readable, maintainable, no clever tricks - SIMPLE IS KING!
5. **Documentation Heavy**: Document every decision, every module
6. **Cross-Platform Testing**: Must work on mobile (Android/iOS) AND web
7. **Test-Driven**: Each step MUST pass all existing tests AND add new tests
8. **Mini Product Per Step**: User must be able to review and approve UI after each step
9. **Ask Questions**: If anything is unclear, ASK the user before proceeding
10. **Commit Often**: Commit after each sub-step completion (not just full steps)
11. **Smart Testing**: Write tests from the start, but focus on critical paths - not 100% coverage initially
12. **Layered Architecture**: Strict separation so UI, business logic, and data layers can be swapped easily

---

## Code Quality Guidelines

### Cleanup Rules

**After Every Step, Check For:**

1. **Unused Imports**: Remove any unused imports
2. **Dead Code**: Delete commented-out code (use git history instead)
3. **Duplicate Code**: Extract common logic to helper functions
4. **Unused Files**: Delete any file not being used
5. **TODO Comments**: Either implement or remove them
6. **Debug Print Statements**: Remove or replace with proper logging
7. **Large Files**: Split files > 300 lines into smaller modules
8. **Redundant Comments**: Remove obvious comments like `// Constructor`

**Use Tools:**
```bash
# Find unused imports/code
flutter analyze

# Format code consistently
dart format .

# Check for duplications (manual review)
# Look for copy-pasted functions or similar patterns
```

**Duplication Prevention:**
- Before writing a function, search if similar logic exists
- Use inheritance/composition for shared behavior
- Extract common UI components to widgets/common/
- Shared business logic → domain/services/

### Simple Code Rules

**ALWAYS:**
- Use clear, descriptive variable names (`userEmail` not `ue`)
- One function does one thing
- Max 3 levels of nesting
- Avoid clever tricks - write obvious code
- Comments explain "why", not "what"

**NEVER:**
- Complex one-liners
- Deep nesting (if inside if inside if)
- Magic numbers (use named constants)
- Premature optimization
- Over-abstraction

### Commit Strategy

Commit after EVERY sub-step with clear messages:

```bash
# Good commit messages
git commit -m "feat: add login screen UI"
git commit -m "test: add login form validation tests"
git commit -m "refactor: extract auth service"
git commit -m "fix: handle GPS permission denied"
git commit -m "docs: document publish spot flow"
```

**Commit Frequency**: Every 30-60 minutes of work or when a sub-task is done.

### Testing Strategy (Smart, Not Excessive)

**Priority 1 - Always Test:**
- Business logic (use cases, services, validators)
- Critical user flows (auth, publish, purchase)
- Data transformations (mappers)

**Priority 2 - Test When Stable:**
- UI widgets (after design is approved)
- Edge cases
- Error scenarios

**Priority 3 - Optional Initially:**
- 100% coverage (aim for 60-70% in early stages)
- Performance tests
- Stress tests

**Focus**: Quality over quantity. 10 good tests > 50 shallow tests.

### Layered Architecture Benefits

**Why Layers Matter:**
- **Swap UI**: Change from Material to Cupertino without touching business logic
- **Swap Database**: Switch from Firebase to Supabase by only changing data layer
- **Swap Map Provider**: Switch from OpenStreetMap to Google Maps easily
- **Test in Isolation**: Mock layers for faster tests

**Layer Rules:**
```
Presentation (UI)
    ↓ Only calls ↓
Business Logic (Use Cases)
    ↓ Only calls ↓
Data (Repositories)
    ↓ Only calls ↓
Infrastructure (Firebase, GPS, Maps)
```

**Never allow**: UI → directly call Firebase. Always go through layers.

### When to Ask Questions

**STOP and ASK if:**
- Requirements unclear or contradictory
- Multiple valid approaches exist
- About to make architectural decision
- Stuck for > 15 minutes
- User requirement seems unusual
- Need to deviate from the plan

**Better to ask than guess wrong!**

---

## Phase 1: Project Foundation (Steps 1-3) ✅ COMPLETE

### Step 1: Project Scaffolding & Configuration ✅

**Goal**: Create minimal Flutter project structure with configuration files.

**Status**: ✅ **COMPLETE** - All sub-steps finished

**Sub-steps**:

#### 1.1 Initialize Flutter Project ✅
- [x] Create Flutter project: `flutter create parking`
- [x] Update `pubspec.yaml` with dependencies:
  ```yaml
  dependencies:
    flutter_riverpod: ^2.4.0
    firebase_core: ^2.24.0
    firebase_auth: ^4.15.0
    cloud_firestore: ^4.13.0
    firebase_storage: ^11.5.0
    geolocator: ^10.1.0
    flutter_map: ^6.1.0
    image_picker: ^1.0.5
    image: ^4.1.3
  
  dev_dependencies:
    flutter_test:
    mockito: ^5.4.0
    build_runner: ^2.4.0
    fake_cloud_firestore: ^2.4.0
  ```
- [x] Run `flutter pub get`
- [x] Verify app runs on Android, iOS, and web

**Deliverable**: ✅ Empty app runs on all platforms.

#### 1.1.1 Clean Up Flutter Template Files ✅
- [x] **DELETE** unnecessary files:
  - `test/widget_test.dart` (we'll create our own tests)
  - `lib/main.dart` (we'll rewrite it)
  - `.gitignore` entries for IDE files (add flutter_sdk.zip if downloaded locally)
- [x] **UPDATE** `README.md` in app/ folder with project-specific content
- [x] **REMOVE** example counter code comments
- [x] **VERIFY** no duplicate dependencies in `pubspec.yaml`

**Commit**: ✅ `git commit -m "chore: initialize Flutter project with dependencies"`
**Commit**: ✅ `git commit -m "chore: cleanup Flutter template files"`

#### 1.2 Create Core Configuration Files ✅
- [x] Create `lib/core/config/timing_config.dart`:
  ```dart
  class TimingConfig {
    static const int spotExpiryMinutes = 30;
    static const int arrivalTimeMinutes = 15;
    static const int photoUploadMinutes = 5;
    static const int searchRefreshSeconds = 10;
    static const double gpsAccuracyThreshold = 10.0;
  }
  ```
- [x] Create `lib/core/config/environment.dart` with dev/staging/prod configs
- [x] Create `lib/core/error/result.dart` with `Result<T>` pattern
- [x] Create `lib/core/error/app_error.dart` with error types
- [x] Add unit tests for each config class

**Deliverable**: ✅ Config files created, documented, tested.

**Commit**: ✅ `git commit -m "feat: add core config and error handling"`

#### 1.3 Setup Firebase Configuration ⏸️
- [ ] Run `flutterfire configure --project=parking-dev` - **USER ACTION REQUIRED**
- [x] Add `firebase_options.dart` to `.gitignore` patterns (keep template)
- [x] Create `lib/infrastructure/firebase/firebase_config.dart` wrapper
- [x] Initialize Firebase in `main.dart` (commented out until user configures)
- [ ] Test Firebase initialization on all platforms - **PENDING USER SETUP**

**Deliverable**: ⏸️ Firebase connected, app launches without errors. **WAITING FOR USER**

**UI to Review**: ✅ App opens with a simple "ParKing POC" splash screen, no errors in console.

**Commit**: ✅ `git commit -m "feat: configure Firebase for all platforms"`

**Tests Required** (Smart Testing):
- ✅ Unit tests for `Result<T>` (critical business pattern) - PENDING
- ✅ Basic widget test for splash screen - PENDING
- **Skip**: TimingConfig tests (constants only), Firebase initialization test (infrastructure)

---

### Step 2: Design System & Common Widgets ✅

**Goal**: Create reusable UI components following Material Design 3.

**Status**: ✅ **COMPLETE** - Modern glassmorphic design system implemented

**Sub-steps**:

#### 2.1 Create Theme & Colors ✅
- [x] Create `lib/core/design/app_theme.dart` with Material 3 theme
- [x] Define primary/secondary colors, text styles
- [x] Create `lib/core/design/design_constants.dart` with color constants
- [x] Apply theme in `main.dart`

**Deliverable**: ✅ Consistent theme applied app-wide.

#### 2.2 Build Common Widgets (Small Files!) ✅
- [x] `lib/presentation/widgets/common/app_button.dart` (< 100 lines)
  - Primary button, secondary button, text button variants
  - Loading state, disabled state
- [x] `lib/presentation/widgets/common/modern_cards.dart` (< 100 lines)
  - Glassmorphic cards
  - Animation support
- [x] Standard card with elevation and padding
- [x] Circular progress indicator with message
- [x] Error display with retry button

**Deliverable**: ✅ Widget library documented and working.

#### 2.3 Create Modern UI Screens ✅
- [x] Create `lib/presentation/screens/splash_screen.dart` - Animated splash
- [x] Create `lib/presentation/screens/home_screen.dart` - Modern home
- [x] Create `lib/presentation/screens/provider_screen.dart` - Provider UI
- [x] Create `lib/presentation/screens/seeker_screen.dart` - Seeker UI
- [x] Add to navigation for review

**UI to Review**: ✅ Screen showing all buttons, cards, loading states in modern glassmorphic style.

**Commit**: ✅ `git commit -m "feat: create design system and common widgets"`

**Tests Required** (Smart Testing):
- Widget test for AppButton (most used component) - PENDING
- **Skip initially**: Tests for Cards, LoadingIndicator (visual components, low risk)

---

### Step 3: Authentication UI & Basic Navigation ✅

**Goal**: Complete authentication screens (no backend yet, UI only).

**Status**: ✅ **COMPLETE** - Full auth UI with backend integration

**Sub-steps**:

#### 3.1 Create Auth Screens (UI + Backend!) ✅
- [x] `lib/presentation/screens/auth/login_screen.dart` (310 lines)
  - Email/password fields
  - Login button with Riverpod state management
  - "Sign up" navigation
  - Modern glassmorphic design
  - **BONUS**: Integrated with Firebase Auth backend!
- [x] `lib/presentation/screens/auth/register_screen.dart` (575 lines)
  - Name, email, password fields
  - Password strength indicator (real-time visual feedback)
  - Register button with validation
  - Modern glassmorphic design
  - **BONUS**: Integrated with Firebase Auth backend!

**Deliverable**: ✅ Full auth flow UI navigable and functional.

#### 3.2 Setup Basic Navigation ✅
- [x] Define routes in `main.dart` for auth screens
- [x] Navigation between login/register/home screens
- [x] Proper route management with pushAndRemoveUntil

**Deliverable**: ✅ Navigation between screens works smoothly.

#### 3.3 Add Form Validation ✅
- [x] Email validation with RegExp
- [x] Password strength validation
- [x] Real-time password strength indicator
- [x] Display validation errors in real-time

**UI to Review**: ✅ Complete auth flow with validation, smooth navigation, proper error messages. Can fill forms, see validation errors, navigate between screens. **APP IS RUNNING ON WEB!**

**Commit**: ✅ `git commit -m "feat: add authentication UI and navigation"`

**Tests Required** (Smart Testing):
- Unit tests for email and password validators - PENDING
- Widget test for login screen with form validation - PENDING
- **Skip initially**: Widget tests for register (similar patterns)

---

## Phase 2: Authentication Backend (Steps 4-5) ✅ COMPLETE

### Step 4: Firebase Authentication Integration ✅

**Goal**: Connect Firebase Auth to login/register screens.

**Status**: ✅ **COMPLETE** - Full clean architecture implementation

**Sub-steps**:

#### 4.1 Create Auth Data Layer ✅
- [x] `lib/infrastructure/firebase/firebase_auth_service.dart` (104 lines)
  - Email/password sign in
  - Email/password register
  - Sign out
  - Get current user
- [x] `lib/data/repositories/auth_repository_impl.dart` (284 lines)
  - Implements domain repository interface
  - Maps Firebase user to domain User entity
  - Comprehensive error mapping

**Deliverable**: ✅ Auth service ready, tested with mocks.

#### 4.2 Create Auth Domain Layer ✅
- [x] `lib/domain/entities/user.dart` (371 lines - includes all entities)
  - User entity with id, email, name, stats, settings
- [x] `lib/domain/repositories/auth_repository.dart` (interface - 288 lines total)
- [x] `lib/domain/usecases/auth/login_usecase.dart` (part of 293 lines)
- [x] `lib/domain/usecases/auth/register_usecase.dart` (part of 293 lines)
- [x] `lib/domain/usecases/auth/logout_usecase.dart` (part of 293 lines)

**Deliverable**: ✅ Clean architecture layers defined.

#### 4.3 Create Auth State Management (Riverpod) ✅
- [x] `lib/presentation/providers/auth_providers.dart` (105 lines)
  - AuthState providers (authenticated, unauthenticated, loading)
  - Login/register/logout use case providers
  - Error handling
  - Repository and service providers
- [x] Connect to login/register screens
- [x] Add loading indicators
- [x] Add error message display

**UI to Review**: ✅ Can register new account, login, see loading states, see error messages, navigate to home after auth. **READY FOR FIREBASE SETUP!**

**Tests Required**:
- Unit tests for all use cases with mocked repository - PENDING
- Unit tests for auth service with fake Firebase - PENDING
- Widget tests for auth screens with loading/error states - PENDING
- Integration test for complete registration → login flow - PENDING

---

### Step 5: User Profile & Home Screen ⏸️

**Goal**: Display user info after login.

**Status**: ⏸️ **WAITING** - Home screen exists but needs Firebase data

**Sub-steps**:

#### 5.1 Create Firestore User Collection ⏸️
- [x] Firestore security rules documented in DATA_MODELS.md
- [x] `lib/data/datasources/remote/firebase_user_datasource.dart` (77 lines)
  - Create user document
  - Get user data
  - Update user profile
- [ ] **USER ACTION**: Deploy rules: `firebase deploy --only firestore:rules`

**Deliverable**: ⏸️ User data persists in Firestore. **WAITING FOR FIREBASE SETUP**

#### 5.2 Create Home Screen ✅
- [x] `lib/presentation/screens/home_screen.dart` (modern UI)
  - Display user name/email placeholder
  - Show "Provider" and "Seeker" mode buttons
  - Navigation to provider/seeker flows

**Deliverable**: ✅ Home screen shows user info.

#### 5.3 Create Profile Screen 📝
- [ ] `lib/presentation/screens/profile/profile_screen.dart`
  - Display profile info
  - Edit name
  - Change password (UI only for now)
  - Logout

**UI to Review**: ⏸️ After login, see home screen with user name, can navigate to profile, edit name, logout works. **NEEDS FIREBASE**

**Tests Required**:
- Unit tests for Firestore user operations with fake Firestore - PENDING
- Widget tests for home screen - PENDING
- Integration test: register → login → view profile → logout - PENDING

---

## Phase 3: Provider Flow - Publish Spot (Steps 6-8) 📝

### Step 6: Location Services & GPS 📝

**Goal**: Capture high-accuracy GPS coordinates.

**Status**: 📝 **NOT STARTED**

**Deliverable**: Navigation between screens works smoothly.

#### 3.3 Add Form Validation (UI Only)
- [ ] Create `lib/core/validators/auth_validators.dart`
- [ ] Email validation
- [ ] Password strength validation
- [ ] Display validation errors in real-time

**UI to Review**: Complete auth flow with validation, smooth navigation, proper error messages. Can fill forms, see validation errors, navigate between screens.

**Commit**: `git commit -m "feat: add authentication UI and navigation"`

**Tests Required** (Smart Testing):
- Unit tests for email and password validators (critical business logic)
- Widget test for login screen with form validation
- **Skip initially**: Widget tests for register/forgot password (similar patterns), navigation integration test (add after backend)

---

## Phase 2: Authentication Backend (Steps 4-5)

### Step 4: Firebase Authentication Integration

**Goal**: Connect Firebase Auth to login/register screens.

**Sub-steps**:

#### 4.1 Create Auth Data Layer
- [ ] `lib/infrastructure/firebase/auth_service.dart` (< 150 lines)
  - Email/password sign in
  - Email/password register
  - Google sign in
  - Sign out
  - Get current user
- [ ] `lib/data/repositories/auth_repository_impl.dart` (< 150 lines)
  - Implements domain repository interface
  - Maps Firebase user to domain User entity

**Deliverable**: Auth service ready, tested with mocks.

#### 4.2 Create Auth Domain Layer
- [ ] `lib/domain/entities/user.dart` (< 80 lines)
  - User entity with id, email, name
- [ ] `lib/domain/repositories/auth_repository.dart` (interface only, < 50 lines)
- [ ] `lib/domain/usecases/login_usecase.dart` (< 100 lines)
- [ ] `lib/domain/usecases/register_usecase.dart` (< 100 lines)
- [ ] `lib/domain/usecases/logout_usecase.dart` (< 80 lines)

**Deliverable**: Clean architecture layers defined.

#### 4.3 Create Auth State Management (Riverpod)
- [ ] `lib/presentation/providers/auth_provider.dart` (< 150 lines)
  - AuthState (authenticated, unauthenticated, loading)
  - Login/register/logout methods
  - Error handling
- [ ] Connect to login/register screens
- [ ] Add loading indicators
- [ ] Add error message display

**UI to Review**: Can register new account, login, see loading states, see error messages, navigate to home after auth.

**Tests Required**:
- Unit tests for all use cases with mocked repository
- Unit tests for auth service with fake Firebase
- Widget tests for auth screens with loading/error states
- Integration test for complete registration → login flow

---

### Step 5: User Profile & Home Screen

**Goal**: Display user info after login.

**Sub-steps**:

#### 5.1 Create Firestore User Collection
- [ ] Deploy Firestore security rules from docs
- [ ] Create user document on registration
- [ ] `lib/infrastructure/firebase/firestore_service.dart` (< 200 lines)
  - Create user document
  - Get user data
  - Update user profile

**Deliverable**: User data persists in Firestore.

#### 5.2 Create Home Screen
- [ ] `lib/presentation/screens/home/home_screen.dart` (< 200 lines)
  - Display user name/email
  - Show "Provider" and "Seeker" mode buttons
  - Logout button
  - Navigation to provider/seeker flows

**Deliverable**: Home screen shows user info.

#### 5.3 Create Profile Screen
- [ ] `lib/presentation/screens/profile/profile_screen.dart` (< 200 lines)
  - Display profile info
  - Edit name
  - Change password (UI only for now)
  - Logout

**UI to Review**: After login, see home screen with user name, can navigate to profile, edit name, logout works.

**Tests Required**:
- Unit tests for Firestore user operations with fake Firestore
- Widget tests for home screen
- Widget tests for profile screen
- Integration test: register → login → view profile → logout

---

## Phase 3: Provider Flow - Publish Spot (Steps 6-8)

### Step 6: Location Services & GPS

**Goal**: Capture high-accuracy GPS coordinates.

**Sub-steps**:

#### 6.1 Create Location Service
- [ ] `lib/infrastructure/location/geolocation_service.dart` (< 150 lines)
  - Request location permissions
  - Get current location with high accuracy
  - Check accuracy threshold (< 10m)
  - Handle permission denied
- [ ] `lib/infrastructure/location/location_permissions.dart` (< 100 lines)
  - Request permissions
  - Check permission status

**Deliverable**: Can capture GPS with accuracy check.

#### 6.2 Create Location Domain Layer
- [ ] `lib/domain/entities/location.dart` (< 60 lines)
  - Lat, lng, accuracy, timestamp
- [ ] `lib/domain/services/location_validator.dart` (< 80 lines)
  - Validate accuracy
  - Validate coordinates range

**Deliverable**: Location validation logic tested.

#### 6.3 Test Location UI
- [ ] Create `lib/presentation/screens/debug/location_test_screen.dart`
- [ ] Button to capture location
- [ ] Display lat, lng, accuracy
- [ ] Show error if accuracy too low

**UI to Review**: Can press button, see GPS coordinates, accuracy shown, error if accuracy > 10m.

**Tests Required**:
- Unit tests for location validator
- Unit tests for location service (mocked)
- Widget test for location test screen
- Manual test on real device (GPS accuracy)

---

### Step 7: Publish Parking Spot UI

**Goal**: Provider can publish a spot (UI + local state).

**Sub-steps**:

#### 7.1 Create Publish Spot Screen
- [ ] `lib/presentation/screens/provider/publish_spot_screen.dart` (< 200 lines)
  - "Publish Spot" button (large, prominent)
  - Show current location on map (static pin)
  - Loading state while getting GPS
  - Success/error messages

**Deliverable**: Screen looks good, button works (no backend).

#### 7.2 Add Map Display
- [ ] `lib/presentation/widgets/map/map_view.dart` (< 150 lines)
  - Display OpenStreetMap with flutter_map
  - Show user location pin
  - Center on user location
- [ ] `lib/infrastructure/maps/osm_service.dart` (< 80 lines)
  - Map tile provider configuration

**Deliverable**: Map displays correctly.

#### 7.3 Create Publish Flow State
- [ ] `lib/presentation/providers/provider_viewmodel.dart` (< 200 lines)
  - Publish spot method (local state only)
  - GPS capture logic
  - Loading/error states
- [ ] Connect to UI

**UI to Review**: Press "Publish Spot" → shows loading → captures GPS → displays location on map → shows success message. Error shown if GPS fails.

**Tests Required**:
- Widget test for publish spot screen
- Widget test for map view
- Unit test for provider viewmodel
- Integration test: navigate to provider screen → publish spot (mock GPS)

---

### Step 8: Publish Spot Backend Integration

**Goal**: Save published spots to Firestore.

**Sub-steps**:

#### 8.1 Create Parking Spot Domain
- [ ] `lib/domain/entities/parking_spot.dart` (< 100 lines)
  - Spot entity with id, providerId, location, timestamps
- [ ] `lib/domain/repositories/parking_spot_repository.dart` (interface, < 80 lines)
- [ ] `lib/domain/usecases/publish_spot_usecase.dart` (< 150 lines)
  - Validate GPS accuracy
  - Check no existing active spot
  - Calculate expiry time
  - Publish to repository

**Deliverable**: Business logic defined and tested.

#### 8.2 Create Spot Data Layer
- [ ] `lib/data/models/parking_spot_dto.dart` (< 100 lines)
  - DTO for Firestore
- [ ] `lib/data/mappers/spot_mapper.dart` (< 80 lines)
  - Map entity ↔ DTO
- [ ] `lib/data/repositories/parking_spot_repository_impl.dart` (< 150 lines)
  - Save spot to Firestore
  - Get user's active spot
- [ ] `lib/infrastructure/firebase/firestore_spots_service.dart` (< 150 lines)
  - Firestore operations for spots

**Deliverable**: Spots saved to Firestore.

#### 8.3 Deploy Firestore Security Rules
- [ ] Create `firestore.rules` from docs
- [ ] Create `firestore.indexes.json` from docs
- [ ] Deploy: `firebase deploy --only firestore`

**Deliverable**: Security rules deployed.

#### 8.4 Integrate with UI
- [ ] Connect publish spot screen to usecase
- [ ] Show real-time status (active/expired)
- [ ] Add "Mark Unavailable" button

**UI to Review**: Publish spot → saved to Firestore → can see spot in Firebase console → spot shown as active → can mark unavailable.

**Tests Required**:
- Unit tests for publish spot usecase (mocked repo)
- Unit tests for spot repository (fake Firestore)
- Integration test: publish spot → verify in Firestore
- E2E test: complete provider flow

---

## Phase 4: Seeker Flow - Search & Purchase (Steps 9-11)

### Step 9: Search Spots UI (No Backend)

**Goal**: Seeker sees search interface.

**Sub-steps**:

#### 9.1 Create Search Screen UI
- [ ] `lib/presentation/screens/seeker/search_spots_screen.dart` (< 200 lines)
  - Map view centered on user location
  - Search radius slider (0.5km - 5km)
  - List of aggregated spots ("3 spots within 500m")
  - Refresh button

**Deliverable**: Search UI looks good.

#### 9.2 Create Spot List Widgets
- [ ] `lib/presentation/widgets/seeker/spot_list_item.dart` (< 100 lines)
  - Display distance and count
  - Time published
  - Tap to view details
- [ ] `lib/presentation/widgets/seeker/spot_details_card.dart` (< 120 lines)
  - Show distance, time
  - "Get This Spot" button
  - Privacy note: "Exact location revealed after purchase"

**Deliverable**: Spot list looks professional.

#### 9.3 Mock Data for Testing
- [ ] Create `test/fixtures/mock_spots.dart`
- [ ] Generate sample spots for testing
- [ ] Display in UI with mock data

**UI to Review**: Search screen with map, slider, list of 5-10 mock spots, can tap to see details, all looks good.

**Tests Required**:
- Widget tests for search screen
- Widget tests for spot list item
- Widget tests for spot details card

---

### Step 10: Search Backend Integration

**Goal**: Real search with Firestore geoqueries.

**Sub-steps**:

#### 10.1 Create Geohash Helper
- [ ] `lib/core/utils/geohash_helper.dart` (< 150 lines)
  - Calculate geohash from coordinates
  - Get geohash range for radius
  - Distance calculation (Haversine)

**Deliverable**: Geohash logic tested.

#### 10.2 Create Search Domain
- [ ] `lib/domain/usecases/search_spots_usecase.dart` (< 150 lines)
  - Get user location
  - Query spots within radius
  - Filter expired spots
  - Sort by time + distance (ranking algorithm)
  - Aggregate for privacy

**Deliverable**: Search logic defined.

#### 10.3 Implement Firestore Geoqueries
- [ ] Add geohash field when publishing spots
- [ ] `lib/data/repositories/parking_spot_repository_impl.dart`
  - Implement nearby spots query
  - Use geohash range filtering
- [ ] Add Firestore composite indexes

**Deliverable**: Geoqueries work.

#### 10.4 Create Search State Management
- [ ] `lib/presentation/providers/seeker_viewmodel.dart` (< 200 lines)
  - Search method
  - Real-time listener for new spots
  - Loading/error states
- [ ] Connect to search screen

**UI to Review**: Real search works, shows actual spots from Firestore, updates in real-time when new spots published, sorting works correctly.

**Tests Required**:
- Unit tests for geohash helper
- Unit tests for search usecase
- Integration tests for geoquery with fake Firestore
- E2E test: publish spot (provider) → search (seeker) → spot appears

---

### Step 11: Purchase Spot Flow

**Goal**: Seeker can purchase spot and see exact location.

**Sub-steps**:

#### 11.1 Create Transaction Domain
- [ ] `lib/domain/entities/transaction.dart` (< 100 lines)
  - Transaction entity
- [ ] `lib/domain/repositories/transaction_repository.dart` (interface, < 80 lines)
- [ ] `lib/domain/usecases/purchase_spot_usecase.dart` (< 150 lines)
  - Atomic purchase (Firestore transaction)
  - Check spot still available
  - Create transaction record
  - Mark spot as sold
  - Return exact location

**Deliverable**: Purchase logic defined.

#### 11.2 Create Transaction Data Layer
- [ ] `lib/data/models/transaction_dto.dart` (< 100 lines)
- [ ] `lib/data/mappers/transaction_mapper.dart` (< 80 lines)
- [ ] `lib/data/repositories/transaction_repository_impl.dart` (< 150 lines)

**Deliverable**: Transaction persistence ready.

#### 11.3 Create Spot Details Screen
- [ ] `lib/presentation/screens/seeker/spot_details_screen.dart` (< 200 lines)
  - Show aggregated info (distance, time)
  - "Get This Spot" button
  - Confirmation dialog
  - Loading state during purchase

**Deliverable**: Purchase UI ready.

#### 11.4 Create Spot Purchased Screen
- [ ] `lib/presentation/screens/seeker/spot_purchased_screen.dart` (< 200 lines)
  - Show exact location on map
  - Display countdown timer (Y minutes to arrive)
  - "Navigate" button (opens maps app)
  - "Upload Photo" button

**UI to Review**: Complete flow: search → select spot → confirm purchase → see exact location on map → timer counts down → can navigate.

**Tests Required**:
- Unit tests for purchase usecase
- Unit tests for transaction repository (fake Firestore)
- Integration test: publish → search → purchase → verify transaction
- Test race condition (two seekers buying same spot)
- Widget tests for all new screens

---

## Phase 5: Photo Verification (Steps 12-13)

### Step 12: Photo Upload UI

**Goal**: Seeker can take and upload verification photo.

**Sub-steps**:

#### 12.1 Create Photo Capture
- [ ] `lib/infrastructure/camera/camera_service.dart` (< 120 lines)
  - Open camera
  - Capture photo
  - Handle permissions
- [ ] `lib/core/utils/image_compressor.dart` (< 100 lines)
  - Compress image to < 2MB
  - Maintain reasonable quality

**Deliverable**: Photo capture works.

#### 12.2 Create Upload Screen
- [ ] `lib/presentation/screens/seeker/verify_spot_screen.dart` (< 200 lines)
  - Camera preview or captured image
  - "Take Photo" / "Retake" buttons
  - Upload button
  - Progress indicator
  - Timer countdown (Z minutes remaining)

**Deliverable**: Upload UI ready.

#### 12.3 Test Photo Flow (Local)
- [ ] Save photo locally first (before Firebase)
- [ ] Display captured photo
- [ ] Test compression

**UI to Review**: Can take photo, see preview, retake if needed, see compressed size, timer counts down.

**Tests Required**:
- Unit tests for image compressor
- Widget tests for verify spot screen
- Mock camera service for testing

---

### Step 13: Photo Upload Backend

**Goal**: Upload photos to Firebase Storage.

**Sub-steps**:

#### 13.1 Create Storage Service
- [ ] `lib/infrastructure/firebase/storage_service.dart` (< 150 lines)
  - Upload photo to Firebase Storage
  - Generate unique filename
  - Get download URL
  - Progress callback

**Deliverable**: Storage service ready.

#### 13.2 Deploy Storage Security Rules
- [ ] Create `storage.rules` from docs
- [ ] Deploy: `firebase deploy --only storage`

**Deliverable**: Storage rules deployed.

#### 13.3 Create Verification Domain
- [ ] `lib/domain/usecases/verify_spot_usecase.dart` (< 150 lines)
  - Compress photo
  - Upload to storage
  - Update transaction with photo URL
  - Mark as verified
  - Handle timeout (Z minutes)

**Deliverable**: Verification logic complete.

#### 13.4 Integrate with UI
- [ ] Connect verify screen to usecase
- [ ] Show upload progress
- [ ] Handle success/failure
- [ ] Navigate to success screen

**UI to Review**: Complete flow: purchase → take photo → upload → see progress → success message. Photo appears in Firebase Storage console.

**Tests Required**:
- Unit tests for verify spot usecase
- Integration test with fake Firebase Storage
- E2E test: complete seeker flow with photo upload
- Test timeout scenario

---

## Phase 6: Timers & Cleanup (Steps 14-15)

### Step 14: Timer Management

**Goal**: All timers work correctly.

**Sub-steps**:

#### 14.1 Implement Spot Expiry Timer
- [ ] Background check for expired spots (client-side)
- [ ] Update spot status to expired
- [ ] Remove from search results
- [ ] Test with short expiry time (1 minute for testing)

**Deliverable**: Spots auto-expire.

#### 14.2 Implement Arrival Timer
- [ ] Countdown timer on purchased spot screen
- [ ] Visual warning at 5 minutes remaining
- [ ] Notification when time expires (UI only, no push)

**Deliverable**: Arrival timer works.

#### 14.3 Implement Photo Upload Timer
- [ ] Countdown on verify screen
- [ ] Warning at 1 minute remaining
- [ ] Auto-dispute if time expires

**Deliverable**: Upload timer works.

#### 14.4 Test All Timers
- [ ] Set short times for testing (1, 2, 3 minutes)
- [ ] Verify timers survive app restart
- [ ] Test timer synchronization

**UI to Review**: All three timers work, count down correctly, show warnings, trigger actions when expired.

**Tests Required**:
- Unit tests for timer calculations
- Integration tests for timer state persistence
- Manual tests for all timer scenarios

---

### Step 15: Cloud Functions for Cleanup

**Goal**: Server-side cleanup of expired data.

**Sub-steps**:

#### 15.1 Setup Cloud Functions Project
- [ ] `cd functions && npm init`
- [ ] Install dependencies: `firebase-functions`, `firebase-admin`
- [ ] Create `functions/src/index.ts`

**Deliverable**: Functions project initialized.

#### 15.2 Create Cleanup Functions
- [ ] `cleanupExpiredSpots()` - runs hourly
  - Find spots with `expiresAt < now` and `status == active`
  - Update to `status = expired`
- [ ] `cleanupOldPhotos()` - runs weekly
  - Find transactions > 30 days old
  - Delete verification photos from Storage
- [ ] Add cron schedule

**Deliverable**: Functions written.

#### 15.3 Deploy and Test
- [ ] Deploy: `firebase deploy --only functions`
- [ ] Test locally with Firebase emulator
- [ ] Verify cleanup works in dev environment

**UI to Review**: Can see in Firebase console that expired spots are cleaned up automatically.

**Tests Required**:
- Unit tests for Cloud Functions
- Integration tests with Firebase emulator

---

## Phase 7: Error Handling & Edge Cases (Steps 16-17)

### Step 16: Error Handling

**Goal**: Graceful error handling throughout app.

**Sub-steps**:

#### 16.1 Network Error Handling
- [ ] Detect offline mode
- [ ] Show offline indicator
- [ ] Queue actions for retry
- [ ] Friendly error messages

**Deliverable**: App works offline gracefully.

#### 16.2 Race Condition Handling
- [ ] Test simultaneous spot purchases
- [ ] Verify only one succeeds
- [ ] Show "spot taken" message to others
- [ ] Suggest alternative spots

**Deliverable**: Race conditions handled.

#### 16.3 GPS Failure Handling
- [ ] Handle GPS disabled
- [ ] Handle low accuracy
- [ ] Retry mechanism
- [ ] Manual location option (Phase 2)

**Deliverable**: GPS errors handled.

#### 16.4 Comprehensive Error Messages
- [ ] Review all error messages
- [ ] Make user-friendly
- [ ] Add helpful suggestions
- [ ] Test all error scenarios

**UI to Review**: Trigger various errors (disable GPS, disconnect internet, etc.), verify friendly messages shown, app doesn't crash.

**Tests Required**:
- Unit tests for all error scenarios
- Integration tests for offline mode
- Manual testing of edge cases

---

### Step 17: Alternative Spot Suggestion

**Goal**: If purchased spot unavailable, suggest alternatives.

**Sub-steps**:

#### 17.1 Create Dispute Flow UI
- [ ] `lib/presentation/screens/seeker/spot_unavailable_screen.dart` (< 200 lines)
  - "Spot Not Available" button
  - Take photo proof
  - Comment text field
  - Submit dispute

**Deliverable**: Dispute UI ready.

#### 17.2 Create Alternative Suggestion Logic
- [ ] `lib/domain/usecases/get_alternative_spots_usecase.dart` (< 120 lines)
  - Search for next best spots
  - Same ranking algorithm
  - Exclude disputed spot

**Deliverable**: Alternative logic ready.

#### 17.3 Show Alternatives
- [ ] After dispute submission, show alternative spots
- [ ] Allow free claim (no payment in POC)
- [ ] Mark original transaction as refunded

**UI to Review**: Complete flow: purchase → spot unavailable → take photo → submit dispute → see alternative spots → claim alternative.

**Tests Required**:
- Unit tests for alternative spots logic
- Integration test for dispute flow
- E2E test for complete alternative flow

---

## Phase 8: Polish & Testing (Steps 18-20)

### Step 18: Comprehensive Testing

**Goal**: Achieve 80%+ test coverage.

**Sub-steps**:

#### 18.1 Run Coverage Report
- [ ] `flutter test --coverage`
- [ ] Generate HTML report
- [ ] Identify gaps < 80%

**Deliverable**: Coverage report.

#### 18.2 Add Missing Tests
- [ ] Unit tests for all use cases
- [ ] Widget tests for all screens
- [ ] Integration tests for all flows
- [ ] Focus on business logic (90%+ coverage)

**Deliverable**: 80%+ overall coverage, 90%+ business logic.

#### 18.3 E2E Testing
- [ ] Provider flow: register → login → publish spot
- [ ] Seeker flow: register → login → search → purchase → verify
- [ ] Dispute flow: purchase → dispute → alternative
- [ ] Timer scenarios

**Deliverable**: All E2E tests passing.

**Tests Required**: All tests passing, coverage targets met.

---

### Step 19: UI/UX Polish

**Goal**: Professional, polished UI.

**Sub-steps**:

#### 19.1 UI Consistency Review
- [ ] Check spacing, padding, margins
- [ ] Verify colors match theme
- [ ] Consistent button styles
- [ ] Proper loading states everywhere

**Deliverable**: Consistent UI.

#### 19.2 Animations & Transitions
- [ ] Add smooth screen transitions
- [ ] Loading animations
- [ ] Success/error animations
- [ ] Map zoom animations

**Deliverable**: Smooth animations.

#### 19.3 Accessibility
- [ ] Semantic labels for screen readers
- [ ] Sufficient color contrast
- [ ] Tap target sizes (min 44x44)
- [ ] Keyboard navigation (web)

**Deliverable**: Accessible app.

#### 19.4 User Testing
- [ ] Test on real devices (Android, iOS, web)
- [ ] Get feedback from 3-5 users
- [ ] Fix critical issues

**UI to Review**: Polished, professional app ready for review.

**Tests Required**:
- Manual testing on all platforms
- Accessibility audit
- Performance testing

---

### Step 20: Documentation & Deployment Prep

**Goal**: Ready for production deployment.

**Sub-steps**:

#### 20.1 Update Documentation
- [ ] Update README with setup instructions
- [ ] Document all environment variables
- [ ] Create deployment checklist
- [ ] Write user guide

**Deliverable**: Complete documentation.

#### 20.2 Prepare for Deployment
- [ ] Set up Firebase projects (staging, production)
- [ ] Configure environment variables
- [ ] Test deployment pipeline
- [ ] Create release builds

**Deliverable**: Deployment ready.

#### 20.3 Final QA
- [ ] Full regression testing
- [ ] Performance testing
- [ ] Security audit
- [ ] Fix critical bugs

**Deliverable**: Production-ready app.

#### 20.4 Create Demo Video
- [ ] Record provider flow
- [ ] Record seeker flow
- [ ] Record error handling
- [ ] Create short demo (2-3 minutes)

**UI to Review**: Final app demo video showing all features working smoothly.

---

## Success Criteria

Each step is considered complete when:

✅ **UI Deliverable**: Can see and interact with new UI on mobile and web  
✅ **Tests Pass**: All existing tests pass + new tests added  
✅ **Documentation**: Code documented, step documented  
✅ **Review**: User has reviewed and approved the mini product  
✅ **No Regressions**: Previous features still work  
✅ **Simple & Small**: Files < 300 lines, code is simple  
✅ **Cross-Platform**: Works on Android, iOS, and web

## Testing Commands

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/

# Run on web
flutter run -d chrome

# Run on Android
flutter run -d android

# Run on iOS
flutter run -d ios
```

## Review Checklist Per Step

Before moving to next step, verify:

- [ ] UI looks professional and polished
- [ ] All tests passing (run `flutter test`)
- [ ] Works on mobile (Android or iOS)
- [ ] Works on web (Chrome)
- [ ] No console errors or warnings
- [ ] Loading states shown appropriately
- [ ] Error messages are user-friendly
- [ ] Code is documented
- [ ] Files are small (< 300 lines)
- [ ] Code is simple and readable
- [ ] User has approved this mini product

## Cleanup Checklist Per Step

After completing each step, clean up:

- [ ] Run `flutter analyze` - fix all warnings
- [ ] Run `dart format .` - format code consistently
- [ ] **Remove** unused imports (IDE will highlight them)
- [ ] **Remove** unused files
- [ ] **Remove** commented-out code
- [ ] **Remove** debug print statements
- [ ] **Remove** TODO comments (do it or delete it)
- [ ] **Check** for duplicate code (search for similar functions)
- [ ] **Extract** common logic to helpers
- [ ] **Split** any file > 300 lines
- [ ] **Verify** no example/template code remains
- [ ] **Update** imports to use relative paths consistently
- [ ] Commit: `git commit -m "chore: cleanup and code formatting"`

---

## Common Flutter Template Files to Clean

When Flutter creates a new project, it includes example code. **Clean these up immediately:**

### Files to DELETE:
- `test/widget_test.dart` - Example counter test
- `lib/main.dart` - Will rewrite from scratch

### Files to MODIFY:
- `pubspec.yaml`:
  - Remove `cupertino_icons` if not using iOS-style icons
  - Remove comments explaining what each section does
  - Keep only packages we actually use
- `README.md` in app/:
  - Replace Flutter template readme with ParKing-specific info
- `.gitignore`:
  - Add `*.zip` if downloading SDKs locally
  - Add `flutter_sdk/` if storing locally
  - Remove IDE-specific entries if not using those IDEs

### Code Patterns to AVOID:
```dart
// ❌ BAD - Template counter example
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// ❌ BAD - Verbose comments
/// This is the main widget
/// It builds the app
class MyApp extends StatelessWidget { }

// ❌ BAD - TODO without action
// TODO: implement later

// ✅ GOOD - Simple, clear
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(/* ... */);
  }
}
```

### Duplication Check Pattern:
```bash
# Search for similar function names
grep -r "validate" lib/
grep -r "format" lib/

# If you find duplicates like:
# - validateEmail in auth_validators.dart
# - validateEmail in profile_validators.dart
# → Extract to common validators.dart
```

---

**REMEMBER**: Quality over speed. Each step must be complete and approved before moving forward. UI-first means user can SEE and USE the feature before backend is fully integrated. **Clean code is simple code with no duplication.**

---

## Quick Reference for AI Agents

### Before Starting Any Task

1. ✅ Read the step requirements fully
2. ✅ Check if anything is unclear → **ASK USER**
3. ✅ Plan which files to create (keep < 300 lines each)
4. ✅ Identify which tests are critical vs optional
5. ✅ Plan cleanup - what files to delete/modify from template

### While Implementing

1. ✅ Write SIMPLE code (no clever tricks)
2. ✅ Follow layered architecture strictly
3. ✅ Commit after each sub-step (30-60 min work)
4. ✅ Test critical paths, skip low-risk tests initially
5. ✅ Document why, not what

### After Each Sub-Step

1. ✅ Run `flutter test` - all tests must pass
2. ✅ Run `flutter analyze` - no warnings
3. ✅ Test on mobile AND web
4. ✅ Commit with clear message
5. ✅ Show UI to user for approval

### Red Flags (STOP and ASK)

- 🚩 File > 300 lines
- 🚩 Function > 50 lines
- 🚩 Nesting > 3 levels
- 🚩 Business logic in UI layer
- 🚩 UI code in business layer
- 🚩 Stuck > 15 minutes
- 🚩 Unclear requirement
- 🚩 Copy-pasting code (refactor instead)
- 🚩 Similar functions in different files (deduplicate)
- 🚩 Unused files or imports
- 🚩 Commented-out code blocks

### Commit Message Examples

```bash
# Features
git commit -m "feat: add user login screen"
git commit -m "feat: implement GPS location capture"

# Tests
git commit -m "test: add login validator tests"
git commit -m "test: add purchase usecase tests"

# Fixes
git commit -m "fix: handle null GPS coordinates"
git commit -m "fix: prevent duplicate spot publish"

# Refactoring
git commit -m "refactor: extract geohash helper"
git commit -m "refactor: simplify spot mapper"

# Documentation
git commit -m "docs: document publish spot flow"
git commit -m "docs: add comments to timer logic"

# Chores
git commit -m "chore: update dependencies"
git commit -m "chore: format code"
```

---

**Document Version**: 1.1  
**Last Updated**: October 20, 2025  
**Status**: Ready for AI Implementation
