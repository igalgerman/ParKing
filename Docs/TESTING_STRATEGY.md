# ParKing - Testing Strategy

## Testing Philosophy

**ParKing follows Test-Driven Development (TDD)** principles to ensure high code quality, maintainability, and reliability.

### Core Principles

1. **Write Tests First**: Tests define expected behavior before implementation
2. **Small Tests**: Each test verifies one specific behavior
3. **Fast Feedback**: Tests run quickly and frequently
4. **Comprehensive Coverage**: Target 80%+ code coverage
5. **Maintainable Tests**: Tests are as clean as production code

---

## Testing Pyramid

```
         ╱╲
        ╱  ╲         E2E Tests (5%)
       ╱────╲        - Critical user flows
      ╱      ╲       - High-level scenarios
     ╱────────╲      
    ╱          ╲     Integration Tests (15%)
   ╱────────────╲    - API integration
  ╱              ╲   - Database operations
 ╱────────────────╲  
╱                  ╲ Unit Tests (80%)
────────────────────  - Business logic
                      - Utilities
                      - Validators
```

---

## 1. Unit Tests

### What to Test

- **Business Logic Layer**:
  - Use cases
  - Domain services
  - Validators
  - Utilities
  - Mappers

- **Data Layer**:
  - Repository implementations (with mocked data sources)
  - DTOs and models
  - Data transformations

### Testing Framework

```yaml
dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.0
  build_runner: ^2.4.0
  mocktail: ^1.0.0  # Alternative to mockito
```

### Example: Use Case Test

```dart
// test/domain/usecases/publish_spot_usecase_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([ParkingSpotRepository, GeolocationService])
void main() {
  late PublishSpotUseCase useCase;
  late MockParkingSpotRepository mockRepository;
  late MockGeolocationService mockGeolocation;

  setUp(() {
    mockRepository = MockParkingSpotRepository();
    mockGeolocation = MockGeolocationService();
    useCase = PublishSpotUseCase(mockRepository, mockGeolocation);
  });

  group('PublishSpotUseCase', () {
    test('should publish spot successfully when GPS is accurate', () async {
      // Arrange
      final location = Location(lat: 40.7128, lng: -74.0060, accuracy: 5.0);
      final spot = ParkingSpot(location: location);
      
      when(mockGeolocation.getCurrentLocation())
          .thenAnswer((_) async => Success(location));
      
      when(mockRepository.publishSpot(any))
          .thenAnswer((_) async => Success(spot));

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, isA<Success<ParkingSpot>>());
      verify(mockGeolocation.getCurrentLocation()).called(1);
      verify(mockRepository.publishSpot(any)).called(1);
    });

    test('should fail when GPS accuracy is below threshold', () async {
      // Arrange
      final location = Location(lat: 40.7128, lng: -74.0060, accuracy: 50.0);
      
      when(mockGeolocation.getCurrentLocation())
          .thenAnswer((_) async => Success(location));

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, isA<Failure<ParkingSpot>>());
      expect((result as Failure).error, isA<LocationError>());
      verifyNever(mockRepository.publishSpot(any));
    });

    test('should fail when user already has active spot', () async {
      // Arrange
      final location = Location(lat: 40.7128, lng: -74.0060, accuracy: 5.0);
      
      when(mockGeolocation.getCurrentLocation())
          .thenAnswer((_) async => Success(location));
      
      when(mockRepository.publishSpot(any))
          .thenAnswer((_) async => Failure(ValidationError('Active spot exists')));

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, isA<Failure<ParkingSpot>>());
      expect((result as Failure).error.message, contains('Active spot'));
    });

    test('should handle network errors gracefully', () async {
      // Arrange
      final location = Location(lat: 40.7128, lng: -74.0060, accuracy: 5.0);
      
      when(mockGeolocation.getCurrentLocation())
          .thenAnswer((_) async => Success(location));
      
      when(mockRepository.publishSpot(any))
          .thenAnswer((_) async => Failure(NetworkError('No connection')));

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, isA<Failure<ParkingSpot>>());
      expect((result as Failure).error, isA<NetworkError>());
    });
  });

  tearDown(() {
    reset(mockRepository);
    reset(mockGeolocation);
  });
}
```

### Example: Validator Test

```dart
// test/domain/validators/spot_validator_test.dart

import 'package:flutter_test/flutter_test.dart';

void main() {
  late SpotValidator validator;

  setUp(() {
    validator = SpotValidator();
  });

  group('SpotValidator', () {
    group('validateLocation', () {
      test('should return valid for accurate GPS', () {
        final location = Location(lat: 40.7128, lng: -74.0060, accuracy: 5.0);
        
        final result = validator.validateLocation(location);
        
        expect(result.isValid, true);
      });

      test('should return invalid for low accuracy GPS', () {
        final location = Location(lat: 40.7128, lng: -74.0060, accuracy: 50.0);
        
        final result = validator.validateLocation(location);
        
        expect(result.isValid, false);
        expect(result.error, contains('accuracy'));
      });

      test('should return invalid for null coordinates', () {
        final location = Location(lat: null, lng: -74.0060, accuracy: 5.0);
        
        final result = validator.validateLocation(location);
        
        expect(result.isValid, false);
      });

      test('should return invalid for coordinates out of range', () {
        final location = Location(lat: 100.0, lng: -74.0060, accuracy: 5.0);
        
        final result = validator.validateLocation(location);
        
        expect(result.isValid, false);
        expect(result.error, contains('latitude'));
      });
    });

    group('validateSpotExpiry', () {
      test('should calculate correct expiry time', () {
        final publishedAt = DateTime(2025, 10, 20, 14, 0);
        
        final expiresAt = validator.calculateExpiry(publishedAt);
        
        expect(expiresAt, DateTime(2025, 10, 20, 14, 30));
      });
    });
  });
}
```

### Coverage Target

- **Business Logic**: 90%+
- **Validators**: 100%
- **Utilities**: 90%+
- **Mappers**: 80%+

---

## 2. Widget Tests

### What to Test

- Individual widgets
- Widget interactions
- State changes
- UI rendering

### Example: Widget Test

```dart
// test/presentation/widgets/spot_list_item_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SpotListItem', () {
    testWidgets('should display spot distance and time', (tester) async {
      // Arrange
      final spot = ParkingSpot(
        id: '123',
        distance: 0.5,
        publishedAt: DateTime.now().subtract(Duration(minutes: 10)),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SpotListItem(spot: spot),
          ),
        ),
      );

      // Assert
      expect(find.text('500m away'), findsOneWidget);
      expect(find.text('10 min ago'), findsOneWidget);
    });

    testWidgets('should trigger callback on tap', (tester) async {
      // Arrange
      final spot = ParkingSpot(id: '123');
      bool tapped = false;
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SpotListItem(
              spot: spot,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SpotListItem));
      await tester.pump();

      // Assert
      expect(tapped, true);
    });

    testWidgets('should show loading state', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SpotListItem.loading(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

### Example: Screen Test

```dart
// test/presentation/screens/publish_spot_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('PublishSpotScreen', () {
    late MockProviderViewModel mockViewModel;

    setUp(() {
      mockViewModel = MockProviderViewModel();
    });

    testWidgets('should display publish button', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: PublishSpotScreen(viewModel: mockViewModel),
        ),
      );

      // Assert
      expect(find.text('Publish Spot'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should show loading indicator when publishing', (tester) async {
      // Arrange
      when(mockViewModel.isLoading).thenReturn(true);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: PublishSpotScreen(viewModel: mockViewModel),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error message on failure', (tester) async {
      // Arrange
      when(mockViewModel.error).thenReturn('GPS unavailable');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: PublishSpotScreen(viewModel: mockViewModel),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('GPS unavailable'), findsOneWidget);
    });

    testWidgets('should call publishSpot on button tap', (tester) async {
      // Arrange
      when(mockViewModel.isLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: PublishSpotScreen(viewModel: mockViewModel),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      verify(mockViewModel.publishSpot()).called(1);
    });
  });
}
```

---

## 3. Integration Tests

### What to Test

- Firebase integration
- Geolocation services
- Photo upload
- Real-time listeners
- End-to-end data flow

### Setup

```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
  firebase_auth_mocks: ^0.11.0
  fake_cloud_firestore: ^2.4.0
```

### Example: Repository Integration Test

```dart
// integration_test/repositories/parking_spot_repository_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late ParkingSpotRepositoryImpl repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    final dataSource = FirebaseSpotDataSource(fakeFirestore);
    repository = ParkingSpotRepositoryImpl(dataSource);
  });

  group('ParkingSpotRepository Integration', () {
    test('should publish spot to Firestore', () async {
      // Arrange
      final spot = ParkingSpot(
        id: 'test_123',
        providerId: 'user_456',
        location: GeoPoint(40.7128, -74.0060),
        publishedAt: DateTime.now(),
      );

      // Act
      final result = await repository.publishSpot(spot);

      // Assert
      expect(result, isA<Success>());
      
      final doc = await fakeFirestore
          .collection('parking_spots')
          .doc('test_123')
          .get();
      
      expect(doc.exists, true);
      expect(doc.data()!['providerId'], 'user_456');
    });

    test('should retrieve nearby spots', () async {
      // Arrange
      await _seedTestSpots(fakeFirestore);
      final center = GeoPoint(40.7128, -74.0060);
      
      // Act
      final result = await repository.getNearbySpots(center, 1.0);

      // Assert
      expect(result, isA<Success>());
      final spots = (result as Success).data;
      expect(spots.length, greaterThan(0));
      expect(spots.every((s) => s.status == SpotStatus.active), true);
    });

    test('should listen to real-time spot updates', () async {
      // Arrange
      final center = GeoPoint(40.7128, -74.0060);
      final updates = <List<ParkingSpot>>[];
      
      // Act
      final stream = repository.watchNearbySpots(center, 1.0);
      final subscription = stream.listen(updates.add);
      
      await Future.delayed(Duration(milliseconds: 100));
      
      // Add new spot
      await _addTestSpot(fakeFirestore, 'spot_new');
      await Future.delayed(Duration(milliseconds: 100));

      // Assert
      expect(updates.length, greaterThan(1));
      expect(updates.last.any((s) => s.id == 'spot_new'), true);
      
      await subscription.cancel();
    });
  });
}

Future<void> _seedTestSpots(FakeFirebaseFirestore firestore) async {
  // Helper to add test data
}
```

---

## 4. End-to-End (E2E) Tests

### What to Test

Critical user flows:
1. **Provider Flow**: Register → Publish spot → Receive notification
2. **Seeker Flow**: Register → Search → Purchase → Verify
3. **Dispute Flow**: Purchase → Spot unavailable → Refund

### Example: E2E Test

```dart
// integration_test/flows/seeker_flow_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Seeker Flow E2E', () {
    testWidgets('complete seeker journey', (tester) async {
      // 1. Launch app
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // 2. Login
      await tester.enterText(find.byKey(Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(Key('password_field')), 'Password123');
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle();

      // 3. Search for spots
      expect(find.byKey(Key('search_screen')), findsOneWidget);
      await tester.tap(find.byKey(Key('search_button')));
      await tester.pumpAndSettle();

      // 4. Wait for results
      expect(find.byKey(Key('spot_list')), findsOneWidget);
      await tester.pump(Duration(seconds: 2));

      // 5. Select first spot
      await tester.tap(find.byKey(Key('spot_item_0')));
      await tester.pumpAndSettle();

      // 6. Purchase spot
      await tester.tap(find.text('Get This Spot'));
      await tester.pumpAndSettle();

      // 7. Verify location shown
      expect(find.byKey(Key('spot_map')), findsOneWidget);
      expect(find.text('Navigate'), findsOneWidget);

      // 8. Upload verification photo
      await tester.tap(find.byKey(Key('upload_photo_button')));
      await tester.pumpAndSettle();
      // Note: Camera simulation requires platform-specific mocking

      // 9. Verify success message
      expect(find.text('Spot verified successfully'), findsOneWidget);
    });
  });
}
```

---

## 5. Test Data & Fixtures

### Test Data Factory

```dart
// test/fixtures/test_data_factory.dart

class TestDataFactory {
  static ParkingSpot createSpot({
    String? id,
    String? providerId,
    GeoPoint? location,
    SpotStatus? status,
  }) {
    return ParkingSpot(
      id: id ?? 'test_spot_${DateTime.now().millisecondsSinceEpoch}',
      providerId: providerId ?? 'test_provider',
      location: location ?? GeoPoint(40.7128, -74.0060),
      publishedAt: DateTime.now(),
      expiresAt: DateTime.now().add(Duration(minutes: 30)),
      status: status ?? SpotStatus.active,
    );
  }

  static User createUser({
    String? id,
    String? email,
    UserRole? role,
  }) {
    return User(
      id: id ?? 'test_user_${DateTime.now().millisecondsSinceEpoch}',
      email: email ?? 'test@example.com',
      role: role ?? UserRole.both,
      createdAt: DateTime.now(),
    );
  }

  static Transaction createTransaction({
    String? id,
    String? spotId,
    String? providerId,
    String? seekerId,
    TransactionStatus? status,
  }) {
    return Transaction(
      id: id ?? 'test_txn_${DateTime.now().millisecondsSinceEpoch}',
      spotId: spotId ?? 'test_spot',
      providerId: providerId ?? 'test_provider',
      seekerId: seekerId ?? 'test_seeker',
      createdAt: DateTime.now(),
      status: status ?? TransactionStatus.pending,
    );
  }
}
```

---

## 6. Mocking Strategy

### Mock Classes

```dart
// test/mocks/mock_repositories.dart

@GenerateMocks([
  ParkingSpotRepository,
  UserRepository,
  TransactionRepository,
])
void generateMocks() {}

// test/mocks/mock_services.dart

@GenerateMocks([
  GeolocationService,
  FirebaseAuthService,
  FirebaseStorageService,
  MapService,
])
void generateMocks() {}
```

### Generating Mocks

```bash
flutter pub run build_runner build
```

---

## 7. Test Organization

### Directory Structure

```
test/
├── domain/
│   ├── entities/
│   ├── usecases/
│   ├── validators/
│   └── services/
├── data/
│   ├── repositories/
│   ├── datasources/
│   └── mappers/
├── presentation/
│   ├── widgets/
│   ├── screens/
│   └── viewmodels/
├── fixtures/
│   ├── test_data_factory.dart
│   └── mock_data.dart
└── mocks/
    ├── mock_repositories.dart
    └── mock_services.dart

integration_test/
├── repositories/
├── services/
└── flows/
    ├── provider_flow_test.dart
    ├── seeker_flow_test.dart
    └── dispute_flow_test.dart
```

---

## 8. Continuous Testing

### Run Tests Locally

```bash
# Unit & widget tests
flutter test

# With coverage
flutter test --coverage

# Integration tests
flutter test integration_test/

# E2E on device
flutter drive --target=integration_test/app_test.dart
```

### CI/CD Pipeline (GitHub Actions)

```yaml
# .github/workflows/test.yml

name: Test Suite

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Generate mocks
        run: flutter pub run build_runner build
      
      - name: Run tests
        run: flutter test --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info
      
      - name: Check coverage threshold
        run: |
          lcov --summary coverage/lcov.info | grep "lines......: 80"
```

---

## 9. Test Metrics & Reporting

### Coverage Reports

Use **codecov** or **coveralls** for coverage visualization:

```yaml
# codecov.yml

coverage:
  status:
    project:
      default:
        target: 80%
    patch:
      default:
        target: 70%
```

### Performance Tests

```dart
// test/performance/search_performance_test.dart

void main() {
  test('search should complete within 2 seconds', () async {
    final stopwatch = Stopwatch()..start();
    
    await searchUseCase.execute(location: testLocation);
    
    stopwatch.stop();
    expect(stopwatch.elapsedMilliseconds, lessThan(2000));
  });
}
```

---

## 10. Best Practices

### ✅ Do's

1. **Write descriptive test names**: `should_return_error_when_gps_unavailable`
2. **Follow AAA pattern**: Arrange, Act, Assert
3. **One assertion per test** (when possible)
4. **Mock external dependencies**
5. **Use test fixtures** for consistency
6. **Clean up resources** in `tearDown`
7. **Test edge cases** and error paths
8. **Keep tests fast** (<100ms for unit tests)
9. **Use meaningful test data**
10. **Document complex test logic**

### ❌ Don'ts

1. **Don't test framework code** (Flutter widgets internals)
2. **Don't make tests dependent** on each other
3. **Don't use real Firebase** in unit tests
4. **Don't ignore flaky tests**
5. **Don't test implementation details**
6. **Don't skip negative tests**
7. **Don't use sleeps** (use `pump` instead)
8. **Don't hardcode delays**

---

## 11. TDD Workflow

### Red-Green-Refactor Cycle

```
1. 🔴 RED: Write failing test
   ↓
2. 🟢 GREEN: Write minimal code to pass
   ↓
3. 🔵 REFACTOR: Improve code quality
   ↓
   Repeat
```

### Example TDD Session

```dart
// 1. RED: Write test first
test('should calculate distance between two points', () {
  final point1 = GeoPoint(40.7128, -74.0060);
  final point2 = GeoPoint(40.7589, -73.9851);
  
  final distance = DistanceCalculator.calculate(point1, point2);
  
  expect(distance, closeTo(6.4, 0.1)); // ~6.4 km
});

// Test fails - DistanceCalculator doesn't exist yet

// 2. GREEN: Implement minimal code
class DistanceCalculator {
  static double calculate(GeoPoint p1, GeoPoint p2) {
    // Haversine formula implementation
    return calculatedDistance;
  }
}

// Test passes

// 3. REFACTOR: Improve code
class DistanceCalculator {
  static const earthRadiusKm = 6371.0;
  
  static double calculate(GeoPoint p1, GeoPoint p2) {
    // Extract to methods, add comments, optimize
    final dLat = _toRadians(p2.latitude - p1.latitude);
    final dLon = _toRadians(p2.longitude - p1.longitude);
    // ... cleaner implementation
  }
  
  static double _toRadians(double degrees) => degrees * pi / 180;
}

// Test still passes
```

---

**Document Version**: 1.0  
**Last Updated**: October 20, 2025  
**Status**: Draft - Under Review
