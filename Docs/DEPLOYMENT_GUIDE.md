# ParKing - Deployment & DevOps Guide

## Deployment Strategy

ParKing uses **Firebase** for backend infrastructure, providing automatic scaling and simplified deployment.

---

## 1. Environment Setup

### Development Environments

| Environment | Purpose | Firebase Project | Branch |
|-------------|---------|------------------|--------|
| **Local** | Development & testing | parking-dev | feature/* |
| **Staging** | Pre-production testing | parking-staging | develop |
| **Production** | Live app | parking-prod | main |

### Environment Configuration

```dart
// lib/core/config/environment.dart

enum Environment {
  local,
  staging,
  production,
}

class EnvironmentConfig {
  static Environment get current {
    const env = String.fromEnvironment('ENV', defaultValue: 'local');
    return Environment.values.firstWhere((e) => e.name == env);
  }
  
  static FirebaseOptions get firebaseOptions {
    switch (current) {
      case Environment.local:
      case Environment.staging:
        return _stagingFirebaseOptions;
      case Environment.production:
        return _productionFirebaseOptions;
    }
  }
}
```

---

## 2. Firebase Setup

### Firebase Projects

#### Create Projects

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Create projects (via Firebase Console or CLI)
firebase projects:create parking-dev
firebase projects:create parking-staging
firebase projects:create parking-prod
```

#### Initialize Firebase in Flutter

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for each environment
flutterfire configure --project=parking-dev
flutterfire configure --project=parking-staging
flutterfire configure --project=parking-prod
```

### Firebase Services Configuration

#### 1. Authentication

**Enable Sign-In Methods**:
- Email/Password
- Google
- Apple (iOS)
- Phone

**Configuration** (Firebase Console):
```
Authentication > Sign-in method > Enable providers
```

**OAuth Setup**:
- Google: Add OAuth 2.0 Client ID
- Apple: Configure Sign in with Apple

#### 2. Firestore Database

**Create Database**:
```
Firestore > Create database > Start in production mode
```

**Set Security Rules**:
```javascript
// firestore.rules

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow write: if isOwner(userId);
    }
    
    // Parking spots collection
    match /parking_spots/{spotId} {
      allow read: if isAuthenticated() && 
                     resource.data.status == 'active';
      allow read: if isAuthenticated() && 
                     resource.data.providerId == request.auth.uid;
      allow create: if isAuthenticated() && 
                       request.resource.data.providerId == request.auth.uid &&
                       request.resource.data.status == 'active';
      allow update: if isAuthenticated() && 
                       resource.data.providerId == request.auth.uid;
    }
    
    // Transactions collection
    match /transactions/{txnId} {
      allow read: if isAuthenticated() && 
                     (resource.data.seekerId == request.auth.uid ||
                      resource.data.providerId == request.auth.uid);
      allow create: if isAuthenticated() && 
                       request.resource.data.seekerId == request.auth.uid;
      allow update: if isAuthenticated() && 
                       (resource.data.seekerId == request.auth.uid ||
                        resource.data.providerId == request.auth.uid);
    }
    
    // Configurations (read-only)
    match /configurations/{configId} {
      allow read: if isAuthenticated();
      allow write: if false;  // Only via Cloud Functions
    }
  }
}
```

**Deploy Rules**:
```bash
firebase deploy --only firestore:rules --project parking-dev
```

**Create Indexes**:
```javascript
// firestore.indexes.json

{
  "indexes": [
    {
      "collectionGroup": "parking_spots",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "geohash", "order": "ASCENDING" },
        { "fieldPath": "publishedAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "parking_spots",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "providerId", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "publishedAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "transactions",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "seekerId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    }
  ]
}
```

**Deploy Indexes**:
```bash
firebase deploy --only firestore:indexes --project parking-dev
```

#### 3. Storage

**Create Buckets**:
```
Storage > Get started > Set up security rules
```

**Security Rules**:
```javascript
// storage.rules

rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // User profile photos
    match /users/{userId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                      request.auth.uid == userId &&
                      request.resource.size < 5 * 1024 * 1024 &&
                      request.resource.contentType.matches('image/.*');
    }
    
    // Verification photos - only involved parties can read/write
    match /verifications/{transactionId}/{fileName} {
      allow read: if request.auth != null && 
                   (request.auth.uid == get(/databases/$(database)/documents/transactions/$(transactionId)).data.seekerId ||
                    request.auth.uid == get(/databases/$(database)/documents/transactions/$(transactionId)).data.providerId);
      allow write: if request.auth != null &&
                      request.resource.size < 2 * 1024 * 1024 &&
                      request.resource.contentType.matches('image/(jpeg|jpg|png)');
    }
  }
}
```

**Deploy Rules**:
```bash
firebase deploy --only storage --project parking-dev
```

#### 4. Cloud Functions (for cleanup)

**Install Dependencies**:
```bash
cd functions
npm install
```

**Cleanup Function**:
```typescript
// functions/src/index.ts

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

// Run every hour to cleanup expired spots
export const cleanupExpiredSpots = functions.pubsub
  .schedule('every 1 hours')
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    
    const expiredSpots = await admin.firestore()
      .collection('parking_spots')
      .where('status', '==', 'active')
      .where('expiresAt', '<', now)
      .get();
    
    const batch = admin.firestore().batch();
    
    expiredSpots.docs.forEach(doc => {
      batch.update(doc.ref, { status: 'expired' });
    });
    
    await batch.commit();
    
    console.log(`Cleaned up ${expiredSpots.size} expired spots`);
  });

// Cleanup old verification photos (weekly)
export const cleanupOldPhotos = functions.pubsub
  .schedule('every sunday 02:00')
  .onRun(async (context) => {
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
    
    const oldTransactions = await admin.firestore()
      .collection('transactions')
      .where('verifiedAt', '<', admin.firestore.Timestamp.fromDate(thirtyDaysAgo))
      .get();
    
    const bucket = admin.storage().bucket();
    
    for (const doc of oldTransactions.docs) {
      const photoUrl = doc.data().verificationPhotoUrl;
      if (photoUrl) {
        const filePath = new URL(photoUrl).pathname.split('/').pop();
        await bucket.file(`verifications/${filePath}`).delete();
      }
    }
    
    console.log(`Cleaned up ${oldTransactions.size} old photos`);
  });
```

**Deploy Functions**:
```bash
firebase deploy --only functions --project parking-dev
```

---

## 3. Flutter App Build & Deployment

### Version Management

**pubspec.yaml**:
```yaml
version: 1.0.0+1  # version+buildNumber
```

**Auto-increment script**:
```bash
# scripts/bump_version.sh

#!/bin/bash
VERSION=$(grep "version:" pubspec.yaml | sed 's/version: //')
BUILD=$(echo $VERSION | cut -d'+' -f2)
NEW_BUILD=$((BUILD + 1))
NEW_VERSION=$(echo $VERSION | cut -d'+' -f1)+$NEW_BUILD

sed -i "s/version: $VERSION/version: $NEW_VERSION/" pubspec.yaml
echo "Version bumped to $NEW_VERSION"
```

### Android Build

#### Debug Build
```bash
flutter build apk --debug --dart-define=ENV=local
```

#### Release Build
```bash
# Staging
flutter build apk --release --dart-define=ENV=staging

# Production
flutter build apk --release --dart-define=ENV=production
```

#### App Bundle (Play Store)
```bash
flutter build appbundle --release --dart-define=ENV=production
```

#### Signing Configuration

**android/key.properties**:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=parking-release
storeFile=../parking-keystore.jks
```

**android/app/build.gradle**:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### iOS Build

#### Debug Build
```bash
flutter build ios --debug --dart-define=ENV=local
```

#### Release Build
```bash
# Staging
flutter build ios --release --dart-define=ENV=staging

# Production
flutter build ipa --release --dart-define=ENV=production
```

#### Code Signing (Xcode)

1. Open `ios/Runner.xcworkspace`
2. Select Runner target
3. Signing & Capabilities
4. Select Team
5. Choose Provisioning Profile

---

## 4. App Distribution

### Android (Google Play)

#### Play Console Setup

1. Create app in Play Console
2. Fill app details
3. Set content rating
4. Upload privacy policy
5. Create release

#### Internal Testing
```bash
# Upload to Internal Testing track
bundletool build-apks --bundle=build/app/outputs/bundle/release/app-release.aab \
  --output=build/app/outputs/bundle/release/app-release.apks \
  --mode=universal

# Upload via Play Console or fastlane
```

#### Production Release

Use **staged rollout**:
- Start with 5% of users
- Monitor crashes/ANRs
- Gradually increase to 100%

### iOS (App Store)

#### App Store Connect Setup

1. Create app in App Store Connect
2. Fill metadata
3. Upload screenshots
4. Set pricing
5. Submit for review

#### TestFlight (Beta)

```bash
# Build and upload
flutter build ipa --release --dart-define=ENV=staging
open build/ios/archive/Runner.xcarchive

# Use Xcode to distribute to TestFlight
```

#### Production Release

```bash
flutter build ipa --release --dart-define=ENV=production
# Upload via Xcode or Transporter app
```

---

## 5. CI/CD Pipeline

### GitHub Actions Workflow

```yaml
# .github/workflows/deploy.yml

name: Deploy

on:
  push:
    branches:
      - main      # Production
      - develop   # Staging

jobs:
  build-and-deploy:
    runs-on: macos-latest  # macOS for iOS builds
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
      
      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '17'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test
      
      - name: Build Android APK (Staging)
        if: github.ref == 'refs/heads/develop'
        run: |
          flutter build apk --release --dart-define=ENV=staging
      
      - name: Build Android App Bundle (Production)
        if: github.ref == 'refs/heads/main'
        run: |
          echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > android/app/parking-keystore.jks
          flutter build appbundle --release --dart-define=ENV=production
        env:
          KEYSTORE_PASSWORD: ${{ secrets.KEYSTORE_PASSWORD }}
          KEY_ALIAS: ${{ secrets.KEY_ALIAS }}
          KEY_PASSWORD: ${{ secrets.KEY_PASSWORD }}
      
      - name: Build iOS (Production)
        if: github.ref == 'refs/heads/main'
        run: |
          flutter build ios --release --dart-define=ENV=production --no-codesign
      
      - name: Upload to Play Store (Internal Testing)
        if: github.ref == 'refs/heads/develop'
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.PLAY_SERVICE_ACCOUNT_JSON }}
          packageName: com.parking.app
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: internal
      
      - name: Deploy Firebase Functions
        run: |
          cd functions
          npm ci
          firebase deploy --only functions --project parking-${{ github.ref == 'refs/heads/main' && 'prod' || 'staging' }}
        env:
          FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
      
      - name: Notify Slack
        uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          text: 'Deployment to ${{ github.ref == "refs/heads/main" && "Production" || "Staging" }} ${{ job.status }}'
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
```

---

## 6. Monitoring & Analytics

### Firebase Crashlytics

**Setup**:
```dart
// lib/main.dart

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Pass all uncaught errors to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  
  runApp(MyApp());
}
```

**Log Custom Errors**:
```dart
try {
  // risky operation
} catch (e, stack) {
  await FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Failed to publish spot');
}
```

### Firebase Analytics

**Track Events**:
```dart
await FirebaseAnalytics.instance.logEvent(
  name: 'spot_published',
  parameters: {
    'user_id': userId,
    'accuracy': gpsAccuracy,
  },
);
```

### Performance Monitoring

**Setup**:
```dart
import 'package:firebase_performance/firebase_performance.dart';

final trace = FirebasePerformance.instance.newTrace('search_spots');
await trace.start();

// ... search operation ...

await trace.stop();
```

---

## 7. Rollback Strategy

### Firebase Rollback

**Firestore Rules**:
```bash
# View rule history
firebase firestore:rules:list --project parking-prod

# Rollback to previous version
firebase firestore:rules:release <version-id> --project parking-prod
```

**Cloud Functions**:
```bash
# Previous version stays deployed
# Manually switch traffic if needed
```

### App Rollback

**Android**: Use Play Console to halt rollout or rollback

**iOS**: Remove app update or submit expedited review for fix

---

## 8. Secrets Management

### GitHub Secrets

Store in repository settings:
- `FIREBASE_TOKEN`
- `KEYSTORE_BASE64`
- `KEYSTORE_PASSWORD`
- `KEY_ALIAS`
- `KEY_PASSWORD`
- `PLAY_SERVICE_ACCOUNT_JSON`
- `SLACK_WEBHOOK`

### Environment Variables

```bash
# .env.staging
FIREBASE_PROJECT_ID=parking-staging
MAP_TILE_URL=https://tile.openstreetmap.org

# .env.production
FIREBASE_PROJECT_ID=parking-prod
MAP_TILE_URL=https://tile.openstreetmap.org
```

---

## 9. Database Backup & Restore

### Firestore Backup

```bash
# Automated daily backups (via Cloud Console)
# Cloud Firestore > Backups > Schedule backup

# Manual export
gcloud firestore export gs://parking-prod-backups/$(date +%Y-%m-%d) \
  --project=parking-prod
```

### Restore

```bash
gcloud firestore import gs://parking-prod-backups/2025-10-20 \
  --project=parking-prod
```

---

## 10. Scaling Considerations

### Firebase Scaling

- **Firestore**: Auto-scales, monitor costs
- **Storage**: Set lifecycle policies for old files
- **Functions**: Increase memory/timeout if needed

### Cost Optimization

1. **Firestore**: Use caching, pagination
2. **Storage**: Compress images, delete old photos
3. **Functions**: Optimize cold starts
4. **Analytics**: Sample events if high volume

---

## 11. Deployment Checklist

### Pre-Deployment

- [ ] All tests passing
- [ ] Code review completed
- [ ] Version bumped
- [ ] Changelog updated
- [ ] Firebase rules tested
- [ ] Security audit passed
- [ ] Performance testing done
- [ ] Staging tested thoroughly

### Deployment

- [ ] Deploy Firebase rules
- [ ] Deploy Cloud Functions
- [ ] Build app for production
- [ ] Upload to stores
- [ ] Monitor crash reports
- [ ] Check analytics
- [ ] Test on production

### Post-Deployment

- [ ] Monitor for 24 hours
- [ ] Check user feedback
- [ ] Review crash reports
- [ ] Verify analytics
- [ ] Document issues
- [ ] Plan hotfix if needed

---

**Document Version**: 1.0  
**Last Updated**: October 20, 2025  
**Status**: Draft - Under Review
