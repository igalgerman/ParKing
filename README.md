# ParKing 🅿️

**A peer-to-peer parking marketplace connecting parking spot providers with seekers.**

[![Flutter](https://img.shields.io/badge/Flutter-3.24.0-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Powered-FFCA28?logo=firebase)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📱 About

ParKing is a mobile application (Android & iOS) that creates a real-time marketplace for parking spaces. Providers can publish their empty parking spots with one click, while seekers can find and claim available spots nearby.

### Key Features

- **One-Click Publishing**: Providers publish spots instantly with automatic GPS capture
- **Privacy-First Search**: Seekers see aggregated availability (count + distance) before purchase
- **Photo Verification**: Mandatory spot verification to prevent fraud
- **Real-Time Updates**: Spots appear/disappear instantly using Firebase real-time database
- **Configurable Timers**: All timing parameters adjustable via config
- **Material Design 3**: Modern, accessible UI that works beautifully on both platforms

---

## 🎯 Project Status

**Current Phase**: Documentation & Architecture Planning  
**Next Phase**: POC Development (Proof of Concept without payment)

---

## 📚 Documentation

Comprehensive documentation available in the [`Docs/`](./Docs) folder:

| Document | Description |
|----------|-------------|
| [Project Overview](./Docs/PROJECT_OVERVIEW.md) | Vision, goals, phases, and success metrics |
| [Technical Architecture](./Docs/TECHNICAL_ARCHITECTURE.md) | System design, layers, and communication patterns |
| [Feature Specifications](./Docs/FEATURE_SPECIFICATIONS.md) | Detailed feature requirements and user flows |
| [Data Models](./Docs/DATA_MODELS.md) | Database schema, collections, and relationships |
| [Testing Strategy](./Docs/TESTING_STRATEGY.md) | TDD approach, test types, and coverage goals |
| [Deployment Guide](./Docs/DEPLOYMENT_GUIDE.md) | CI/CD, Firebase setup, and app distribution |

---

## 🏗️ Tech Stack

### Frontend
- **Framework**: Flutter 3.24+ (Dart)
- **UI**: Material Design 3
- **State Management**: TBD (Provider/Riverpod/Bloc)
- **Maps**: flutter_map + OpenStreetMap
- **Geolocation**: geolocator package

### Backend
- **BaaS**: Firebase
  - **Authentication**: Firebase Auth (email, social, phone)
  - **Database**: Cloud Firestore (NoSQL, real-time)
  - **Storage**: Firebase Storage (photos)
  - **Functions**: Cloud Functions (cleanup, automation)
- **Hosting**: Firebase Hosting (web landing page - Phase 2)

### DevOps
- **CI/CD**: GitHub Actions
- **Monitoring**: Firebase Crashlytics + Analytics
- **Version Control**: Git + GitHub

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.24.0 or higher
- Dart 3.0+
- Firebase account
- Android Studio / Xcode
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/igalgerman/ParKing.git
   cd ParKing
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase (choose parking-dev project)
   flutterfire configure
   ```

4. **Run the app**
   ```bash
   # Debug mode (local environment)
   flutter run --dart-define=ENV=local
   
   # Or for specific platform
   flutter run -d android --dart-define=ENV=local
   flutter run -d ios --dart-define=ENV=local
   ```

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Run integration tests
flutter test integration_test/
```

**Coverage Target**: 80%+ overall, 90%+ for business logic

---

## 📁 Project Structure

```
lib/
├── core/                   # Shared utilities, constants, errors
├── features/               # Feature-first organization
│   ├── auth/              # Authentication feature
│   │   ├── data/          # Repositories, data sources
│   │   ├── domain/        # Entities, use cases
│   │   └── presentation/  # Widgets, screens, view models
│   ├── provider/          # Provider features (publish spots)
│   └── seeker/            # Seeker features (search, purchase)
└── infrastructure/         # External services (Firebase, maps)

test/                       # Unit & widget tests
integration_test/          # Integration & E2E tests
Docs/                      # Comprehensive documentation
```

---

## 🎨 Design Principles

### Code Quality
- **Simple is Better**: Avoid over-engineering
- **TDD**: Test-driven development approach
- **Small Modules**: Single-responsibility components
- **OOD/OOP**: Object-oriented design principles
- **Clean Code**: Readable, maintainable, documented

### File Standards
- Max ~200-300 lines per file
- One class per file (generally)
- Meaningful names
- Extensive documentation

---

## 🗺️ Roadmap

### Phase 1: POC (Current)
- [x] Requirements gathering
- [x] Technical documentation
- [ ] UI/UX wireframes
- [ ] Core features implementation
  - [ ] Authentication
  - [ ] Publish spot (provider)
  - [ ] Search spots (seeker)
  - [ ] Photo verification
  - [ ] Real-time updates
- [ ] Testing (80%+ coverage)
- [ ] POC launch

### Phase 2: Production MVP
- [ ] Payment integration (Stripe/PayPal)
- [ ] Revenue split mechanism
- [ ] Push notifications (FCM)
- [ ] Rating/reputation system
- [ ] AI-powered dispute resolution
- [ ] Enhanced fraud prevention

### Phase 3: Scale & Optimize
- [ ] Advanced analytics
- [ ] Dynamic pricing
- [ ] Multi-language support
- [ ] Turn-by-turn navigation
- [ ] Provider/Admin dashboards

---

## 🤝 Contributing

We follow a **quality-driven** development approach:

1. **Fork** the repository
2. **Create** a feature branch (`feature/amazing-feature`)
3. **Write tests first** (TDD)
4. **Implement** the feature
5. **Ensure** all tests pass
6. **Document** your changes
7. **Submit** a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Team

- **Project Owner**: [igalgerman](https://github.com/igalgerman)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for simplified backend infrastructure
- OpenStreetMap community
- All contributors and testers

---

## 📞 Contact

- **GitHub Issues**: [Report bugs or request features](https://github.com/igalgerman/ParKing/issues)
- **Email**: [Add your email here]

---

## 🔗 Links

- [Project Documentation](./Docs)
- [Firebase Console](https://console.firebase.google.com)
- [Flutter Documentation](https://docs.flutter.dev)
- [OpenStreetMap](https://www.openstreetmap.org)

---

**Built with ❤️ using Flutter and Firebase**