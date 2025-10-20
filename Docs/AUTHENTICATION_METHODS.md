# ParKing - Authentication Methods

## Overview

ParKing supports **multiple authentication methods** powered by Firebase Authentication, providing users with flexibility and convenience.

---

## Supported Authentication Methods

### ✅ 1. Email/Password Authentication

**Status**: ✅ Fully Implemented

**How it works**:
- User registers with email and password
- Password requirements: minimum 8 characters
- Email verification available
- Password reset via email

**User Flow**:
1. User enters email and password
2. System validates credentials
3. Creates Firebase Auth account
4. Creates Firestore user document
5. User logged in

**Code**:
```dart
final result = await authRepository.register(
  email: 'user@example.com',
  password: 'SecurePass123',
  displayName: 'John Doe',
);
```

---

### ✅ 2. Google Sign-In

**Status**: ✅ Fully Implemented

**How it works**:
- One-click sign-in with Google account
- Uses OAuth 2.0
- No password required
- Existing Google account users can sign in instantly

**User Flow**:
1. User taps "Sign in with Google" button
2. Google Sign-In popup opens
3. User selects Google account
4. Firebase authenticates with Google credentials
5. User logged in (creates account if new)

**Code**:
```dart
final result = await authRepository.signInWithGoogle();
```

**Setup Required in Firebase Console**:
1. Navigate to Authentication → Sign-in method
2. Enable "Google" provider
3. Add authorized domains (localhost for testing, your domain for production)

---

### ✅ 3. Apple Sign-In

**Status**: ✅ Fully Implemented

**How it works**:
- One-click sign-in with Apple ID
- Required for iOS apps on App Store
- Privacy-focused (can hide email)
- Native iOS integration

**User Flow**:
1. User taps "Sign in with Apple" button
2. Apple Sign-In prompt appears
3. User authenticates with Face ID/Touch ID or password
4. Firebase authenticates with Apple credentials
5. User logged in (creates account if new)

**Code**:
```dart
final result = await authRepository.signInWithApple();
```

**Setup Required**:
1. **Firebase Console**:
   - Enable "Apple" provider in Authentication → Sign-in method
   - Configure Service ID
2. **Apple Developer Account**:
   - Enable "Sign in with Apple" capability
   - Configure Service ID and Key
3. **iOS App**:
   - Add capability in Xcode

**Platform Support**: iOS, macOS, Web (with limitations)

---

### ✅ 4. Phone Number Authentication

**Status**: ✅ Fully Implemented

**How it works**:
- SMS-based verification
- User receives 6-digit code
- No password required
- Supports international phone numbers

**User Flow**:
1. User enters phone number (E.164 format: +1234567890)
2. Firebase sends SMS with 6-digit code
3. User enters verification code
4. System verifies code
5. User logged in (creates account if new)

**Code**:
```dart
// Step 1: Send verification code
final result = await authRepository.sendPhoneVerificationCode(
  phoneNumber: '+1234567890',
);

result.when(
  success: (verificationId) {
    // Step 2: Verify SMS code
    final verifyResult = await authRepository.verifyPhoneNumber(
      verificationId: verificationId,
      smsCode: '123456',
    );
  },
  failure: (error) => print(error.message),
);
```

**Setup Required in Firebase Console**:
1. Navigate to Authentication → Sign-in method
2. Enable "Phone" provider
3. Add test phone numbers for development (optional)
4. Configure reCAPTCHA for web (automatic for mobile)

**Rate Limits**:
- Free tier: 10,000 verifications/month
- Quota applies per project
- Consider costs for production

---

## Authentication Architecture

### Layer Structure

```
┌─────────────────────────────────────────────────────────┐
│                  Presentation Layer                      │
│  LoginScreen, RegisterScreen, SocialAuthButtons         │
└──────────────────┬──────────────────────────────────────┘
                   │ Calls
┌──────────────────▼──────────────────────────────────────┐
│                   Domain Layer                           │
│  AuthRepository (interface), Use Cases                   │
└──────────────────┬──────────────────────────────────────┘
                   │ Implements
┌──────────────────▼──────────────────────────────────────┐
│                   Data Layer                             │
│  AuthRepositoryImpl, UserMapper, UserDataSource         │
└──────────────────┬──────────────────────────────────────┘
                   │ Calls
┌──────────────────▼──────────────────────────────────────┐
│              Infrastructure Layer                        │
│  FirebaseAuthService (wraps Firebase SDK)               │
│  - google_sign_in package                               │
│  - sign_in_with_apple package                           │
│  - firebase_auth (email, phone)                         │
└─────────────────────────────────────────────────────────┘
```

### Key Files

| Layer | File | Purpose |
|-------|------|---------|
| **Domain** | `lib/domain/repositories/auth_repository.dart` | Interface defining all auth methods |
| **Data** | `lib/data/repositories/auth_repository_impl.dart` | Implementation with Firebase |
| **Infrastructure** | `lib/infrastructure/firebase/firebase_auth_service.dart` | Firebase SDK wrapper |
| **Presentation** | `lib/presentation/screens/auth/login_screen.dart` | Login UI |
| **Presentation** | `lib/presentation/screens/auth/register_screen.dart` | Registration UI |

---

## Firebase Console Setup Checklist

### Before Users Can Sign In

- [ ] **Email/Password**:
  - [ ] Enable in Firebase Console → Authentication → Sign-in method
  
- [ ] **Google Sign-In**:
  - [ ] Enable Google provider
  - [ ] Add authorized domains
  
- [ ] **Apple Sign-In** (if supporting iOS):
  - [ ] Enable Apple provider
  - [ ] Configure Service ID in Apple Developer Account
  - [ ] Add Apple Sign-In capability in Xcode
  
- [ ] **Phone Authentication**:
  - [ ] Enable Phone provider
  - [ ] Configure reCAPTCHA (web)
  - [ ] Add test phone numbers for development

---

## Security Considerations

### Email/Password
- ✅ Password strength validation (min 8 chars)
- ✅ Email verification available
- ✅ Password reset functionality
- ⚠️ Users responsible for password security

### Social Sign-In (Google, Apple)
- ✅ OAuth 2.0 security
- ✅ No password storage
- ✅ Managed by trusted providers
- ✅ Apple: Privacy-focused (can hide email)

### Phone Authentication
- ✅ SMS-based verification
- ⚠️ SMS interception risk (use 2FA for sensitive operations)
- ⚠️ SIM swapping attacks possible
- 💡 Consider as secondary auth or combine with other methods

---

## Best Practices

### User Experience
1. **Offer Multiple Options**: Let users choose their preferred method
2. **Social Sign-In First**: Google/Apple for fastest onboarding
3. **Phone for Verification**: Use phone auth as 2FA
4. **Email as Fallback**: Always support email/password

### Security
1. **Email Verification**: Enable for email/password accounts
2. **Multi-Factor Authentication**: Add phone verification for sensitive operations
3. **Session Management**: Implement proper logout and token refresh
4. **Rate Limiting**: Firebase handles this automatically

### UI/UX
1. **Clear CTAs**: "Sign in with Google" more clear than "Google"
2. **Brand Icons**: Use official brand buttons/icons
3. **Loading States**: Show progress during authentication
4. **Error Handling**: Clear, user-friendly error messages

---

## Testing

### Test Accounts (Development)

Firebase allows adding test phone numbers without consuming SMS quota:

1. **Firebase Console** → Authentication → Sign-in method → Phone
2. Add test phone numbers with codes:
   - +1 650-555-1234 → Code: 123456
   - +1 650-555-5678 → Code: 654321

### Testing Checklist

- [ ] Email/Password registration
- [ ] Email/Password login
- [ ] Password reset flow
- [ ] Google Sign-In (cancel, success)
- [ ] Apple Sign-In (iOS only)
- [ ] Phone auth (send code, verify code)
- [ ] Error handling for all methods
- [ ] Logout functionality
- [ ] Session persistence

---

## Future Enhancements (Phase 2+)

### Additional Providers
- [ ] Facebook Login
- [ ] Twitter/X Login
- [ ] Microsoft/GitHub Login

### Enhanced Security
- [ ] Multi-Factor Authentication (MFA)
- [ ] Biometric authentication (fingerprint, Face ID)
- [ ] Email verification enforcement
- [ ] Phone number verification for email accounts

### User Management
- [ ] Account linking (merge accounts)
- [ ] Change password
- [ ] Change email
- [ ] Change phone number
- [ ] Delete account

---

## Dependencies

```yaml
dependencies:
  firebase_core: ^3.8.1           # Firebase core SDK
  firebase_auth: ^5.3.3           # Email, phone authentication
  cloud_firestore: ^5.5.2         # User data storage
  google_sign_in: ^6.2.2          # Google Sign-In
  sign_in_with_apple: ^6.1.3      # Apple Sign-In
```

---

## API Reference

### AuthRepository Interface

```dart
abstract class AuthRepository {
  // Email/Password
  Future<Result<User>> login({required String email, required String password});
  Future<Result<User>> register({required String email, required String password, required String displayName});
  Future<Result<void>> resetPassword({required String email});
  
  // Social Sign-In
  Future<Result<User>> signInWithGoogle();
  Future<Result<User>> signInWithApple();
  
  // Phone Authentication
  Future<Result<String>> sendPhoneVerificationCode({required String phoneNumber});
  Future<Result<User>> verifyPhoneNumber({required String verificationId, required String smsCode});
  
  // User Management
  Future<Result<void>> logout();
  Future<Result<User?>> getCurrentUser();
  Future<Result<User>> updateProfile({String? displayName, String? phoneNumber, String? photoUrl});
  Future<Result<void>> deleteAccount();
  
  // Auth State
  Stream<User?> get authStateChanges;
}
```

---

## Troubleshooting

### Google Sign-In Issues

**Problem**: "Sign-in aborted by user"
- **Solution**: User cancelled - this is normal, handle gracefully in UI

**Problem**: "Network error"
- **Solution**: Check internet connection, Firebase project configuration

**Problem**: "Unauthorized domain"
- **Solution**: Add domain to authorized list in Firebase Console

### Apple Sign-In Issues

**Problem**: Not available on Android/Web
- **Solution**: Apple Sign-In is iOS/macOS only. Show button conditionally.

**Problem**: "Invalid configuration"
- **Solution**: Verify Service ID and Key in Apple Developer Account

### Phone Authentication Issues

**Problem**: "Invalid phone number"
- **Solution**: Use E.164 format (+1234567890), include country code

**Problem**: SMS not received
- **Solution**: Check phone number, SMS quota, test with test phone numbers

**Problem**: "Too many requests"
- **Solution**: Firebase rate limiting - wait or use test numbers

---

**Document Version**: 1.0  
**Last Updated**: October 20, 2025  
**Status**: Complete - All methods implemented
