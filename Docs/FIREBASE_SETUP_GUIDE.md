# Firebase Setup Guide for ParKing

This guide walks you through connecting the ParKing app to a real Firebase project.

## Prerequisites

- ✅ Flutter SDK installed
- ✅ Node.js and npm installed (you have npm 11.6.0)
- ✅ Internet connection
- ⬜ Google/Gmail account

---

## Step 1: Install Required Tools

### 1.1 Install Firebase CLI

Open PowerShell and run:

```powershell
npm install -g firebase-tools
```

Verify installation:
```powershell
firebase --version
```

### 1.2 Install FlutterFire CLI

```powershell
dart pub global activate flutterfire_cli
```

**Important**: Add Dart global bin to your PATH if not already added:
```
C:\Users\<YourUsername>\AppData\Local\Pub\Cache\bin
```

To add to PATH permanently:
1. Search "Environment Variables" in Windows
2. Click "Environment Variables"
3. Under "User variables", select "Path" → "Edit"
4. Add: `C:\Users\<YourUsername>\AppData\Local\Pub\Cache\bin`
5. Click OK

Verify installation:
```powershell
flutterfire --version
```

---

## Step 2: Create Firebase Project

### 2.1 Go to Firebase Console

Visit: https://console.firebase.google.com

### 2.2 Create New Project

1. Click **"Add project"** or **"Create a project"**
2. **Project name**: `parking-dev` (or your preferred name)
3. **Google Analytics**: Enable (recommended) or disable (optional)
4. **Analytics location**: Choose your country
5. Click **"Create project"**
6. Wait for project creation (takes ~30 seconds)
7. Click **"Continue"**

---

## Step 3: Enable Firebase Services

### 3.1 Enable Authentication

1. In Firebase Console, click **"Authentication"** from left menu
2. Click **"Get started"**
3. Go to **"Sign-in method"** tab
4. Enable these providers:
   - **Email/Password**: Click → Toggle "Enable" → Save
   - **Google** (optional): Click → Enable → Configure → Save

### 3.2 Create Firestore Database

1. Click **"Firestore Database"** from left menu
2. Click **"Create database"**
3. **Start mode**: Select **"Start in test mode"** (for development)
   - ⚠️ Test mode allows all reads/writes - perfect for development
   - You'll secure it later with rules
4. **Location**: Choose closest region (e.g., `us-central1`, `europe-west1`)
5. Click **"Enable"**

### 3.3 Enable Firebase Storage

1. Click **"Storage"** from left menu
2. Click **"Get started"**
3. **Security rules**: Select **"Start in test mode"**
4. **Location**: Use same location as Firestore
5. Click **"Done"**

---

## Step 4: Connect Firebase to Flutter App

### 4.1 Login to Firebase

Open PowerShell and run:

```powershell
firebase login
```

- Browser will open
- Sign in with your Google account
- Allow Firebase CLI permissions
- You should see: "✔ Success! Logged in as your-email@gmail.com"

### 4.2 Navigate to App Directory

```powershell
cd C:\work\ParKing\ParKing\app
```

### 4.3 Run FlutterFire Configure

```powershell
flutterfire configure
```

**Interactive Prompts**:

1. **Select platforms**:
   - [x] android
   - [x] ios
   - [x] web
   - Use arrow keys and spacebar to select
   - Press Enter when done

2. **Select Firebase project**:
   - Choose `parking-dev` (or your project name)
   - Press Enter

3. **Firebase app IDs**:
   - The tool will create app IDs automatically
   - Wait for completion

**Result**: This creates `lib/firebase_options.dart` file with your Firebase configuration.

---

## Step 5: Enable Firebase in Your App

### 5.1 Uncomment Firebase Initialization

Edit `lib/main.dart` and uncomment these lines:

```dart
import 'firebase_options.dart'; // ← Uncomment this

// In main() function:
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
); // ← Uncomment this
```

### 5.2 Verify the Changes

Your `main.dart` should look like this:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    const ProviderScope(
      child: ParKingApp(),
    ),
  );
}
```

---

## Step 6: Set Up Firestore Security Rules (Optional but Recommended)

### 6.1 Create Firestore Rules

In Firebase Console → Firestore Database → Rules tab:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Helper function to check if user owns the document
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
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && 
                       request.resource.data.providerId == request.auth.uid;
      allow update, delete: if isAuthenticated() && 
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
  }
}
```

Click **"Publish"** to save the rules.

### 6.2 Create Storage Rules

In Firebase Console → Storage → Rules tab:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // User profile photos
    match /users/{userId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                      request.auth.uid == userId &&
                      request.resource.size < 5 * 1024 * 1024 && // 5MB limit
                      request.resource.contentType.matches('image/.*');
    }
    
    // Verification photos
    match /verifications/{transactionId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null &&
                      request.resource.size < 2 * 1024 * 1024 && // 2MB limit
                      request.resource.contentType.matches('image/(jpeg|jpg|png)');
    }
  }
}
```

Click **"Publish"**.

---

## Step 7: Test Firebase Connection

### 7.1 Run the App

```powershell
cd C:\work\ParKing\ParKing\app
flutter run -d chrome
```

### 7.2 Check Console

You should see in the terminal:
```
✓ Firebase initialized successfully
```

If you see errors, check:
- `firebase_options.dart` file exists
- Firebase initialization is uncommented in `main.dart`
- Internet connection is working

---

## Step 8: Verify Firebase Services (Optional)

### 8.1 Test Authentication

Create a test user in Firebase Console:
1. Go to Authentication → Users tab
2. Click "Add user"
3. Email: `test@parking.com`
4. Password: `Test1234`
5. Click "Add user"

### 8.2 Test Firestore

Create a test document:
1. Go to Firestore Database → Data tab
2. Click "Start collection"
3. Collection ID: `test`
4. Document ID: Auto-ID
5. Field: `message` (string) = `Hello from Firebase!`
6. Click "Save"

If you can see the document, Firestore is working!

### 8.3 Test Storage

Upload a test file:
1. Go to Storage → Files tab
2. Click "Upload file"
3. Select any image
4. If upload succeeds, Storage is working!

---

## Step 9: Environment Setup (For Multiple Environments)

### 9.1 Create Multiple Projects (Optional)

For production setup, create 3 projects:
- `parking-dev` (development)
- `parking-staging` (testing)
- `parking-prod` (production)

### 9.2 Configure Each Environment

```powershell
# Development
flutterfire configure --project=parking-dev --out=lib/firebase_options_dev.dart

# Staging
flutterfire configure --project=parking-staging --out=lib/firebase_options_staging.dart

# Production
flutterfire configure --project=parking-prod --out=lib/firebase_options_prod.dart
```

---

## Troubleshooting

### Issue: `flutterfire: command not found`

**Solution**: Add Dart global bin to PATH (see Step 1.2)

### Issue: `Firebase initialization failed`

**Solutions**:
1. Check `firebase_options.dart` exists
2. Verify internet connection
3. Run `flutter clean && flutter pub get`
4. Check Firebase Console → Project Settings → Apps are registered

### Issue: `Permission denied` in Firestore

**Solution**: Check Firestore Rules allow your operation (see Step 6.1)

### Issue: `Platform not supported`

**Solution**: Run `flutterfire configure` again and select all platforms

---

## Next Steps

After successful Firebase setup:

1. ✅ **Create Auth Screens**: Login/Register UI
2. ✅ **Test Authentication**: Try registering and logging in
3. ✅ **Test Firestore**: Save/retrieve user data
4. ✅ **Implement Features**: Parking spot publishing, search, etc.

---

## Quick Reference Commands

```powershell
# Install tools
npm install -g firebase-tools
dart pub global activate flutterfire_cli

# Login & configure
firebase login
flutterfire configure

# Run app
flutter run -d chrome

# Clean build
flutter clean
flutter pub get

# Check Firebase projects
firebase projects:list
```

---

## Need Help?

- **Firebase Docs**: https://firebase.google.com/docs
- **FlutterFire Docs**: https://firebase.flutter.dev
- **Firebase Console**: https://console.firebase.google.com

---

**Status**: Ready to connect! Follow steps 1-5 to get started. 🚀
