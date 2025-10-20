# ParKing - Technical Architecture

## Architecture Overview

ParKing follows a **layered architecture** pattern with clear separation of concerns, enabling maintainability, testability, and scalability.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
│  (UI Widgets, Screens, State Management)                    │
└─────────────────┬───────────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────────┐
│                     Business Logic Layer                     │
│  (Use Cases, Domain Logic, Validation)                      │
└─────────────────┬───────────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────────┐
│                     Data Layer                               │
│  (Repositories, Data Sources, Models)                       │
└─────────────────┬───────────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────────┐
│                External Services Layer                       │
│  (Firebase, Maps, Geolocation, Storage)                     │
└─────────────────────────────────────────────────────────────┘
```

## Layer Details

### 1. Presentation Layer

**Responsibility**: User interface and user interaction

**Components**:
- **Widgets**: Reusable UI components (buttons, cards, inputs)
- **Screens**: Full-page views (home, search, profile)
- **State Management**: Application state (Provider/Riverpod/Bloc - TBD)
- **View Models**: Screen-specific logic and state

**Key Principles**:
- Widgets should be small (<200 lines)
- No business logic in widgets
- Material Design 3 components
- Responsive design
- Accessibility support

**File Structure**:
```
lib/presentation/
├── widgets/
│   ├── common/
│   │   ├── app_button.dart
│   │   ├── app_card.dart
│   │   └── loading_indicator.dart
│   ├── provider/
│   │   └── spot_publish_button.dart
│   └── seeker/
│       └── spot_list_item.dart
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── provider/
│   │   └── publish_spot_screen.dart
│   └── seeker/
│       └── search_spots_screen.dart
└── viewmodels/
    ├── auth_viewmodel.dart
    ├── provider_viewmodel.dart
    └── seeker_viewmodel.dart
```

### 2. Business Logic Layer

**Responsibility**: Core business rules and use cases

**Components**:
- **Use Cases**: Single-responsibility business operations
- **Domain Models**: Core business entities
- **Validators**: Business rule validation
- **Services**: Domain-specific services

**Key Principles**:
- Platform-agnostic (no Flutter dependencies)
- Pure Dart code
- Fully testable
- Single Responsibility Principle

**Examples**:
- `PublishParkingSpotUseCase`
- `SearchNearbySpots UseCase`
- `VerifySpotPhotoUseCase`
- `CalculateDistanceService`

**File Structure**:
```
lib/domain/
├── entities/
│   ├── parking_spot.dart
│   ├── user.dart
│   └── transaction.dart
├── usecases/
│   ├── provider/
│   │   ├── publish_spot_usecase.dart
│   │   └── mark_spot_unavailable_usecase.dart
│   ├── seeker/
│   │   ├── search_spots_usecase.dart
│   │   ├── purchase_spot_usecase.dart
│   │   └── verify_spot_usecase.dart
│   └── auth/
│       ├── login_usecase.dart
│       └── register_usecase.dart
├── repositories/
│   └── (interfaces only)
└── services/
    ├── distance_calculator.dart
    └── spot_ranking_service.dart
```

### 3. Data Layer

**Responsibility**: Data access and persistence

**Components**:
- **Repositories**: Abstract data access (implements domain interfaces)
- **Data Sources**: Concrete implementations (Firebase, local cache)
- **DTOs**: Data Transfer Objects
- **Mappers**: Convert between DTOs and domain entities

**Key Principles**:
- Repository pattern
- Single source of truth
- Caching strategy
- Error handling

**File Structure**:
```
lib/data/
├── repositories/
│   ├── parking_spot_repository_impl.dart
│   ├── user_repository_impl.dart
│   └── transaction_repository_impl.dart
├── datasources/
│   ├── remote/
│   │   ├── firebase_spot_datasource.dart
│   │   ├── firebase_auth_datasource.dart
│   │   └── firebase_storage_datasource.dart
│   └── local/
│       └── cache_datasource.dart
├── models/
│   ├── parking_spot_dto.dart
│   ├── user_dto.dart
│   └── transaction_dto.dart
└── mappers/
    ├── spot_mapper.dart
    └── user_mapper.dart
```

### 4. External Services Layer

**Responsibility**: Third-party service integration

**Components**:
- **Firebase Services**: Auth, Firestore, Storage
- **Location Services**: GPS, geolocation
- **Map Services**: OpenStreetMap integration
- **Configuration**: Environment-specific settings

**File Structure**:
```
lib/infrastructure/
├── firebase/
│   ├── firebase_config.dart
│   ├── firestore_service.dart
│   ├── auth_service.dart
│   └── storage_service.dart
├── location/
│   ├── geolocation_service.dart
│   └── location_permissions.dart
├── maps/
│   ├── osm_service.dart
│   └── map_tile_provider.dart
└── config/
    ├── app_config.dart
    ├── environment.dart
    └── timing_config.dart
```

## State Management

**Decision**: Riverpod (Recommended for simplicity, testability, and modern approach)

**Options Considered**:
1. **Provider** (Good for simplicity, but Riverpod offers more compile-time safety)
2. **Bloc** (Powerful but often adds unnecessary complexity for this project's scale)

**Selection Criteria**:
- Aligns with "simple is better"
- Strong testing support
- Clear separation of concerns
- Compile-time safety to prevent runtime errors
- Good documentation and community support

## Data Flow

### Example: Publishing a Parking Spot

```
1. User taps "Publish Spot" button
   ↓
2. PublishSpotScreen validates input
   ↓
3. ProviderViewModel calls PublishSpotUseCase
   ↓
4. UseCase validates business rules
   ↓
5. UseCase calls ParkingSpotRepository
   ↓
6. Repository maps entity to DTO
   ↓
7. FirebaseSpotDataSource saves to Firestore
   ↓
8. GeolocationService captures GPS coordinates
   ↓
9. Success/Error flows back up the chain
   ↓
10. UI updates with result
```

## Communication Between Layers

### Rules:
1. **Dependency Direction**: Outer layers depend on inner layers (never reverse)
2. **Interfaces**: Use interfaces/abstract classes for layer boundaries
3. **Dependency Injection**: Pass dependencies via constructor
4. **No Direct Access**: Presentation → Business → Data → Services

### Example Interface:

```dart
// domain/repositories/parking_spot_repository.dart
abstract class ParkingSpotRepository {
  Future<Result<ParkingSpot>> publishSpot(ParkingSpot spot);
  Future<Result<List<ParkingSpot>>> getNearbySpots(Location location, double radiusKm);
  Future<Result<void>> markAsUnavailable(String spotId);
}

// data/repositories/parking_spot_repository_impl.dart
class ParkingSpotRepositoryImpl implements ParkingSpotRepository {
  final FirebaseSpotDataSource _remoteDataSource;
  final CacheDataSource _localDataSource;
  
  ParkingSpotRepositoryImpl(this._remoteDataSource, this._localDataSource);
  
  @override
  Future<Result<ParkingSpot>> publishSpot(ParkingSpot spot) async {
    // Implementation
  }
}
```

## Module Structure

Each feature follows a **feature-first** organization:

```
lib/
├── core/                    # Shared utilities
│   ├── error/
│   ├── utils/
│   └── constants/
├── features/
│   ├── auth/
│   │   ├── presentation/
│   │   ├── domain/
│   │   └── data/
│   ├── provider/
│   │   ├── presentation/
│   │   ├── domain/
│   │   └── data/
│   └── seeker/
│       ├── presentation/
│       ├── domain/
│       └── data/
└── infrastructure/          # External services
```

## Error Handling

### Result Pattern

Use a `Result<T>` type for operations that can fail:

```dart
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppError error;
  const Failure(this.error);
}
```

### Error Types

```dart
abstract class AppError {
  final String message;
  final String? code;
  const AppError(this.message, [this.code]);
}

class NetworkError extends AppError { }
class ValidationError extends AppError { }
class AuthenticationError extends AppError { }
class LocationError extends AppError { }
```

## Testing Strategy

### Unit Tests
- All business logic (use cases, services)
- Validators and utilities
- Mappers
- Target: 80%+ coverage

### Widget Tests
- Individual widgets
- Screen layouts
- User interactions

### Integration Tests
- Repository implementations
- Firebase integration
- Location services

### E2E Tests
- Critical user flows
- Publish → Search → Purchase → Verify

## Performance Considerations

### Optimization Strategies
1. **Lazy Loading**: Load data on demand
2. **Caching**: Cache frequently accessed data
3. **Pagination**: Limit query results
4. **Image Optimization**: Compress photos before upload
5. **Query Optimization**: Firestore compound indexes
6. **State Management**: Minimize rebuilds

### Monitoring
- Firebase Performance Monitoring
- Crashlytics
- Analytics events
- Custom metrics

## Security Considerations

### Data Security
- Firestore security rules
- Authentication tokens
- Secure storage for sensitive data
- HTTPS only

### Privacy
- Location data encryption
- Photo access permissions
- User data anonymization
- GDPR compliance

### Validation
- Client-side validation
- Server-side validation (Firebase Functions)
- Input sanitization

## Scalability Plan

### Horizontal Scaling
- Firebase auto-scales
- CDN for map tiles (MapTiler)
- Multiple Firebase regions

### Database Optimization
- Proper indexing
- Data sharding by geographic region
- Archive old transactions

### Caching Strategy
- In-memory cache (Provider state)
- Local storage cache (Hive/SharedPreferences)
- CDN cache for static assets

---

**Document Version**: 1.0  
**Last Updated**: October 20, 2025  
**Status**: Draft - Under Review
