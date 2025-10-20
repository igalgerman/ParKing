# ParKing AI Agent Instructions

This guide helps AI agents understand and work effectively with the ParKing codebase.

## Project Overview

**ParKing** is a peer-to-peer parking marketplace mobile application connecting parking spot providers with seekers in real-time. Built with Flutter for cross-platform compatibility (Android & iOS), the app focuses on simplicity, privacy, and fraud prevention through photo verification.

### Vision

Create the simplest, most reliable peer-to-peer parking marketplace that eliminates the frustration of finding parking in busy areas.

### Current Phase

**Documentation & Architecture Planning** - Ready to begin POC development.

## Tech Stack (Confirmed)

### Frontend
- **Framework**: Flutter 3.24+ (Dart)
- **UI Design**: Material Design 3
- **State Management**: TBD (Provider/Riverpod/Bloc - to be decided during development)
- **Maps**: flutter_map + OpenStreetMap tiles
- **Geolocation**: geolocator package
- **Image Handling**: image_picker, image compression

### Backend
- **BaaS**: Firebase (complete ecosystem)
  - **Authentication**: Firebase Auth (email, Google, Apple, phone)
  - **Database**: Cloud Firestore (NoSQL, real-time)
  - **Storage**: Firebase Storage (verification photos)
  - **Functions**: Cloud Functions (cleanup, automation)
  - **Monitoring**: Crashlytics + Analytics + Performance Monitoring

### DevOps
- **CI/CD**: GitHub Actions
- **Version Control**: Git + GitHub
- **Testing**: flutter_test, mockito, integration_test

## Project Structure

```
ParKing/
├── .github/                 # GitHub config, workflows, copilot instructions
├── Docs/                    # Comprehensive documentation
│   ├── PROJECT_OVERVIEW.md
│   ├── TECHNICAL_ARCHITECTURE.md
│   ├── FEATURE_SPECIFICATIONS.md
│   ├── DATA_MODELS.md
│   ├── TESTING_STRATEGY.md
│   ├── DEPLOYMENT_GUIDE.md
│   └── DEVELOPER_QUICKSTART.md
├── lib/
│   ├── core/               # Shared utilities, constants, errors
│   ├── features/           # Feature-first organization
│   │   ├── auth/          # Authentication feature
│   │   │   ├── data/      # Repositories, data sources
│   │   │   ├── domain/    # Entities, use cases
│   │   │   └── presentation/  # Widgets, screens, view models
│   │   ├── provider/      # Provider features (publish spots)
│   │   └── seeker/        # Seeker features (search, purchase)
│   └── infrastructure/     # External services (Firebase, maps)
├── test/                   # Unit & widget tests
├── integration_test/       # Integration & E2E tests
└── README.md              # Project overview and quick start
```

## Core Concepts

### User Flows

#### Provider (Seller) Flow
1. One-click publish parking spot
2. GPS coordinates captured automatically (HIGH PRECISION required <10m)
3. Spot listed in real-time marketplace
4. Notified when seeker purchases (Phase 2)
5. Receives payment via platform (Phase 2)

#### Seeker (Buyer) Flow
1. Search for parking around current location
2. See aggregated data: "X spots within Y meters" (privacy-first)
3. Select and "purchase" spot (no payment in POC)
4. Exact location revealed
5. Navigate to spot (Y minutes to arrive)
6. Take verification photo (Z minutes to upload)
7. Complete or dispute transaction

### Key Features

1. **Privacy-First Design**: No exact locations shown until purchase
2. **Photo Verification**: Mandatory verification to prevent fraud
3. **Configurable Timers**: X, Y, Z minutes stored in config file
4. **Real-Time Updates**: Firestore real-time listeners
5. **GPS Precision**: High-accuracy location capture (<10m)
6. **Ranking Algorithm**: `Score = (0.4 × Time) + (0.6 × Distance)`

### Phase Breakdown

**Phase 1: POC (Current)**
- Core marketplace mechanics
- NO payment processing
- NO push notifications
- NO ratings/reputation
- Focus: Validate concept

**Phase 2: Production MVP**
- Payment integration (Stripe/PayPal)
- Revenue split (Platform ↔ Provider)
- Push notifications (FCM)
- Rating/reputation system
- AI-powered dispute resolution

**Phase 3: Scale**
- Advanced analytics
- Dynamic pricing
- Multi-language
- Enhanced features

## Development Philosophy

### Core Principles (CRITICAL - Follow These!)

1. **Simple is Better**: Avoid over-engineering, choose the simplest solution
2. **Test-Driven Development (TDD)**: Write tests BEFORE implementation
3. **Small Modules**: Single-responsibility, focused components
4. **OOD/OOP**: Object-oriented design principles
5. **Quality Over Speed**: Build it right, not fast
6. **Layered Architecture**: Clear separation of concerns
7. **Small Files**: Maximum ~200-300 lines per file
8. **Extensive Documentation**: Document the "why", not just the "what"

### Code Quality Standards

#### File Organization
- Keep functions small (max ~30-40 lines)
- Maximum nesting depth of 3 levels
- One class per file (generally)
- Meaningful, descriptive names
- Clear module boundaries

#### Testing Requirements
- **Coverage Target**: 80%+ overall, 90%+ for business logic
- Unit tests for all use cases, services, validators
- Widget tests for UI components
- Integration tests for Firebase operations
- E2E tests for critical user flows
- **TDD Workflow**: Red → Green → Refactor

#### Documentation Standards
- Every public API has docstring
- Comments explain "why", not "what"
- Complex algorithms documented
- README in each major folder
- Keep documentation up-to-date

#### Performance & Security
- Optimize Firestore queries (use indexes)
- Validate input at all boundaries
- No hardcoded secrets (use environment variables)
- Compress images before upload
- Handle errors gracefully
- Monitor performance metrics

## Architecture Guidelines

### Layered Architecture

```
Presentation Layer (UI)
    ↓ (calls)
Business Logic Layer (Use Cases)
    ↓ (calls)
Data Layer (Repositories)
    ↓ (calls)
External Services (Firebase, GPS, Maps)
```

**Rules**:
1. Outer layers depend on inner layers (NEVER reverse)
2. Use interfaces for layer boundaries
3. Dependency injection via constructors
4. No business logic in presentation layer
5. No UI code in business logic layer

### Naming Conventions

```dart
// Files: snake_case
user_repository.dart
publish_spot_usecase.dart

// Classes: PascalCase
class UserRepository { }
class PublishSpotUseCase { }

// Variables/Functions: camelCase
final userId = '123';
void publishSpot() { }

// Constants: SCREAMING_SNAKE_CASE
const MAX_PHOTO_SIZE_MB = 2;

// Private: _prefix
final _privateField = 'value';
void _privateMethod() { }
```

### Error Handling

Use `Result<T>` pattern:
```dart
sealed class Result<T> { }
class Success<T> extends Result<T> { final T data; }
class Failure<T> extends Result<T> { final AppError error; }
```

Always handle errors gracefully with user-friendly messages.

## Firebase Specifics

### Firestore Collections
- `users` - User profiles
- `parking_spots` - Published parking spots
- `transactions` - Purchase transactions
- `configurations` - App config (timers, settings)

### Security Rules
- Always validate auth: `request.auth != null`
- Check ownership: `request.auth.uid == resource.data.userId`
- Validate data types and required fields
- Test rules before deployment

### Real-Time Listeners
- Use wisely to avoid excessive reads
- Clean up listeners in `dispose()`
- Handle connection states
- Implement retry logic

## Testing Guidelines

### TDD Workflow (MANDATORY)

1. **RED**: Write failing test
2. **GREEN**: Write minimal code to pass
3. **REFACTOR**: Improve code quality
4. Repeat

### Test Structure (AAA Pattern)

```dart
test('should do something when condition', () {
  // Arrange: Set up test data and mocks
  final input = TestData.create();
  
  // Act: Execute the code under test
  final result = useCase.execute(input);
  
  // Assert: Verify the outcome
  expect(result, expectedValue);
});
```

### What to Test
- ✅ Business logic (use cases, validators)
- ✅ Data transformations (mappers)
- ✅ Error handling
- ✅ Edge cases
- ✅ User interactions (widget tests)
- ❌ Framework internals
- ❌ Third-party libraries

## Common Patterns

### Use Case Pattern
```dart
class PublishSpotUseCase {
  final ParkingSpotRepository _repository;
  final GeolocationService _geolocation;
  
  Future<Result<ParkingSpot>> execute() async {
    // 1. Get location
    // 2. Validate accuracy
    // 3. Create spot
    // 4. Save to repository
    // 5. Return result
  }
}
```

### Repository Pattern
```dart
abstract class ParkingSpotRepository {
  Future<Result<ParkingSpot>> publishSpot(ParkingSpot spot);
  Stream<List<ParkingSpot>> watchNearbySpots(Location location);
}

class ParkingSpotRepositoryImpl implements ParkingSpotRepository {
  // Implementation with Firebase
}
```

### ViewModel Pattern
```dart
class ProviderViewModel extends ChangeNotifier {
  final PublishSpotUseCase _publishSpotUseCase;
  
  bool _isLoading = false;
  String? _error;
  
  Future<void> publishSpot() async {
    _isLoading = true;
    notifyListeners();
    
    final result = await _publishSpotUseCase.execute();
    
    result.when(
      success: (spot) => _handleSuccess(spot),
      failure: (error) => _handleError(error),
    );
  }
}
```

## Configuration Management

### Timing Configuration
All timing values in `lib/core/config/timing_config.dart`:
```dart
class TimingConfig {
  static const int spotExpiryMinutes = 30;      // X
  static const int arrivalTimeMinutes = 15;     // Y
  static const int photoUploadMinutes = 5;      // Z
}
```

### Environment Configuration
Use `--dart-define` for environment-specific values:
```bash
flutter run --dart-define=ENV=local
flutter run --dart-define=ENV=staging
flutter run --dart-define=ENV=production
```

## Git Workflow

### Branch Naming
```
feature/user-authentication
bugfix/fix-gps-accuracy
hotfix/critical-crash
refactor/improve-repository
docs/update-readme
```

### Commit Messages (Conventional Commits)
```
feat: add photo verification feature
fix: resolve GPS accuracy issue
test: add unit tests for PublishSpotUseCase
docs: update architecture documentation
refactor: simplify repository implementation
chore: update dependencies
```

### Pull Request Checklist
- [ ] All tests passing
- [ ] Code reviewed
- [ ] Documentation updated
- [ ] No lint warnings
- [ ] Coverage maintained/improved
- [ ] Tested on Android & iOS

## Important Reminders for AI Agents

1. **Read Documentation First**: Check `Docs/` folder before making assumptions
2. **Follow TDD**: Write tests before implementation
3. **Keep It Simple**: Don't over-engineer solutions
4. **Small Changes**: Make focused, reviewable PRs
5. **Document Why**: Explain design decisions
6. **Test Coverage**: Maintain 80%+ coverage
7. **Ask Questions**: If unclear, ask the user
8. **Respect Layers**: Don't violate architecture boundaries
9. **User-Friendly**: Focus on user experience
10. **Quality First**: Never compromise on quality for speed

## Reference Documentation

For detailed information, consult:
- [PROJECT_OVERVIEW.md](../Docs/PROJECT_OVERVIEW.md) - Vision and goals
- [TECHNICAL_ARCHITECTURE.md](../Docs/TECHNICAL_ARCHITECTURE.md) - System design
- [FEATURE_SPECIFICATIONS.md](../Docs/FEATURE_SPECIFICATIONS.md) - Feature details
- [DATA_MODELS.md](../Docs/DATA_MODELS.md) - Database schema
- [TESTING_STRATEGY.md](../Docs/TESTING_STRATEGY.md) - Testing approach
- [DEPLOYMENT_GUIDE.md](../Docs/DEPLOYMENT_GUIDE.md) - Deployment process
- [DEVELOPER_QUICKSTART.md](../Docs/DEVELOPER_QUICKSTART.md) - Quick setup guide

## Questions?

When in doubt:
1. Check documentation in `Docs/`
2. Look at existing code patterns
3. Review test files for examples
4. Ask the user for clarification

---

**Remember**: We're building a quality product that people will rely on. Take the time to do it right.

---

**Last Updated**: October 20, 2025  
**Status**: Active - Documentation Complete, Ready for POC Development