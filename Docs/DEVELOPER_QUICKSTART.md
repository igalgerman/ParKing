# ParKing - Developer Quick Start Guide

## 🎯 Goal

Get you up and running with ParKing development in **under 30 minutes**.

---

## ✅ Prerequisites Checklist

Before you start, ensure you have:

- [ ] Flutter SDK 3.24.0+ installed ([Install Guide](https://docs.flutter.dev/get-started/install))
- [ ] Dart 3.0+ (comes with Flutter)
- [ ] Git installed
- [ ] Android Studio (for Android) or Xcode (for iOS)
- [ ] A code editor (VS Code recommended)
- [ ] Firebase account (free tier is fine)

**Verify Installation**:
```bash
flutter doctor
# Should show checkmarks for Flutter, Android/iOS toolchain
```

---

## 🚀 Setup Steps

### 1. Clone & Install Dependencies

```bash
# Clone the repository
git clone https://github.com/igalgerman/ParKing.git
cd ParKing

# Install Flutter packages
flutter pub get

# Generate code (mocks, etc.)
flutter pub run build_runner build
```

### 2. Firebase Setup

#### Option A: Use Existing Dev Project (Recommended)

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase (select parking-dev when prompted)
flutterfire configure --project=parking-dev
```

#### Option B: Create Your Own Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create new project: `parking-dev-[yourname]`
3. Enable these services:
   - Authentication (Email, Google)
   - Firestore Database
   - Storage
4. Run configuration:
   ```bash
   flutterfire configure --project=parking-dev-[yourname]
   ```

### 3. Configure Firebase Services

**Enable Authentication**:
```
Firebase Console > Authentication > Sign-in method
Enable: Email/Password, Google
```

**Create Firestore Database**:
```
Firebase Console > Firestore Database > Create database
Start in: Test mode (for development)
```

**Deploy Security Rules** (optional for local dev):
```bash
firebase deploy --only firestore:rules,storage
```

### 4. Environment Configuration

Create environment config (optional for POC):

```dart
// lib/core/config/environment.dart
// Already configured - just verify it exists
```

### 5. Run the App

```bash
# Start Android emulator or iOS simulator first

# Run in debug mode
flutter run --dart-define=ENV=local

# Or specify device
flutter run -d android --dart-define=ENV=local
flutter run -d ios --dart-define=ENV=local
```

**First Run** might take 2-3 minutes to build. Subsequent runs are faster.

---

## 🧪 Verify Setup

### Run Tests

```bash
# All tests should pass
flutter test

# Check coverage
flutter test --coverage
```

### Check Code Quality

```bash
# Analyze code
flutter analyze

# Format code
flutter format .
```

---

## 📂 Project Tour

### Key Directories

```
lib/
├── core/                   # Shared code
│   ├── config/            # App configuration
│   ├── utils/             # Helper functions
│   └── error/             # Error handling
│
├── features/              # Features (add new features here)
│   ├── auth/             # Login, register
│   ├── provider/         # Publish spots
│   └── seeker/           # Search, purchase spots
│
└── infrastructure/        # External services
    ├── firebase/         # Firebase integration
    ├── location/         # GPS services
    └── maps/             # Map integration
```

### Important Files

```
lib/main.dart              # App entry point
lib/core/config/
  ├── timing_config.dart   # Configurable timers (X, Y, Z minutes)
  └── environment.dart     # Environment settings

pubspec.yaml               # Dependencies
```

---

## 🛠️ Development Workflow

### 1. Create a New Feature

```bash
# Create branch
git checkout -b feature/my-awesome-feature

# Create feature structure
mkdir -p lib/features/my_feature/{data,domain,presentation}
```

### 2. Follow TDD

```dart
// 1. Write test first (RED)
// test/domain/usecases/my_usecase_test.dart
test('should do something', () {
  // Arrange, Act, Assert
});

// 2. Implement (GREEN)
// lib/domain/usecases/my_usecase.dart
class MyUseCase { }

// 3. Refactor (REFACTOR)
// Improve code quality
```

### 3. Run Tests Continuously

```bash
# Watch mode (reruns on file changes)
flutter test --watch
```

### 4. Commit & Push

```bash
# Stage changes
git add .

# Commit (follow conventional commits)
git commit -m "feat: add awesome feature"

# Push
git push origin feature/my-awesome-feature
```

### 5. Create Pull Request

- Open PR on GitHub
- Ensure CI passes
- Request code review
- Address feedback
- Merge when approved

---

## 🐛 Common Issues & Solutions

### Issue: `flutter: command not found`

**Solution**:
```bash
# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Or add permanently to ~/.bashrc or ~/.zshrc
```

### Issue: `Firebase not configured`

**Solution**:
```bash
# Reconfigure Firebase
flutterfire configure --project=parking-dev
```

### Issue: `Build fails on iOS`

**Solution**:
```bash
# Clean and reinstall pods
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

### Issue: `Android build fails`

**Solution**:
```bash
# Clean build cache
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
```

### Issue: Tests failing

**Solution**:
```bash
# Regenerate mocks
flutter pub run build_runner build --delete-conflicting-outputs

# Clear test cache
flutter test --no-test-assets
```

---

## 📖 Essential Reading

Before diving into code, read these (in order):

1. [Project Overview](./PROJECT_OVERVIEW.md) - Understand the vision
2. [Technical Architecture](./TECHNICAL_ARCHITECTURE.md) - System design
3. [Feature Specifications](./FEATURE_SPECIFICATIONS.md) - What to build
4. [Testing Strategy](./TESTING_STRATEGY.md) - How to test

---

## 🎓 Learning Resources

### Flutter Basics
- [Flutter Codelabs](https://docs.flutter.dev/codelabs)
- [Flutter Widget Catalog](https://docs.flutter.dev/development/ui/widgets)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

### Firebase
- [FlutterFire Docs](https://firebase.flutter.dev/)
- [Firestore Queries](https://firebase.google.com/docs/firestore/query-data/queries)
- [Firebase Auth](https://firebase.google.com/docs/auth)

### Architecture
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Flutter TDD](https://resocoder.com/flutter-tdd-clean-architecture-course/)

---

## 💡 Pro Tips

### Speed Up Development

1. **Use Hot Reload**: Press `r` in terminal or Save in IDE
2. **Use Hot Restart**: Press `R` when hot reload isn't enough
3. **Use DevTools**: `flutter pub global activate devtools`
4. **Use Extensions**:
   - VS Code: Flutter, Dart, Error Lens
   - Android Studio: Flutter plugin

### Code Faster

```dart
// Use code snippets
stless  // StatelessWidget
stful   // StatefulWidget
test    // Test template

// Use shortcuts
Cmd/Ctrl + .        // Quick fixes
Cmd/Ctrl + Shift + R // Refactor
```

### Debug Better

```dart
// Use debugPrint instead of print
debugPrint('User ID: $userId');

// Use assert for development checks
assert(userId != null, 'User ID cannot be null');

// Use breakpoints in IDE
// Click line number to add breakpoint
```

---

## 🧰 Useful Commands

```bash
# Development
flutter run --dart-define=ENV=local
flutter run --debug
flutter run --release

# Testing
flutter test
flutter test --coverage
flutter test path/to/specific_test.dart

# Code Quality
flutter analyze
flutter format .
dart fix --apply

# Build
flutter build apk --debug
flutter build ios --debug

# Clean
flutter clean
flutter pub get

# Upgrade
flutter upgrade
flutter pub upgrade

# Devices
flutter devices
flutter emulators
```

---

## 🆘 Getting Help

1. **Documentation**: Check `Docs/` folder first
2. **Code Comments**: Read inline documentation
3. **Tests**: Look at test files for usage examples
4. **Team**: Ask in team chat/Slack
5. **GitHub Issues**: Search existing issues or create new one
6. **Stack Overflow**: Tag with `flutter`, `firebase`

---

## ✨ You're Ready!

You should now have:
- ✅ Development environment set up
- ✅ App running on emulator/simulator
- ✅ Tests passing
- ✅ Understanding of project structure
- ✅ Knowledge of development workflow

**Next Steps**:
1. Pick a task from project board
2. Read relevant documentation
3. Write tests first (TDD)
4. Implement feature
5. Create PR
6. Celebrate! 🎉

---

**Happy Coding! 🚀**

If you get stuck, don't hesitate to ask for help. Everyone started where you are now.

---

**Document Version**: 1.0  
**Last Updated**: October 20, 2025  
**Status**: Ready for Use
