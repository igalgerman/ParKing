# ParKing - TODO List

## Code Quality - CRITICAL (Blocking)

### Fix const Constructor Warnings (35 errors)
**Priority**: 🔴 **CRITICAL** - Must fix before any commit  
**Status**: 🔧 In Progress  
**Reason**: analysis_options.yaml treats warnings as errors - zero tolerance policy

#### Files to Fix:
1. ✅ `lib/core/design/app_button.dart` - Fixed (compilation errors resolved)
2. ❌ `lib/core/design/app_theme.dart` - 2 errors
   - Line 36:20 - prefer_const_constructors
   - Line 154:20 - prefer_const_constructors

3. ❌ `lib/core/design/design_constants.dart` - 5 errors
   - Line 37:7 - prefer_const_constructors
   - Line 53:7 - prefer_const_constructors
   - Line 63:7 - prefer_const_constructors
   - Line 73:7 - prefer_const_constructors
   - Line 79:7 - prefer_const_constructors

4. ❌ `lib/main.dart` - 2 errors
   - Line 228:34 - prefer_const_constructors
   - Line 230:36 - prefer_const_constructors

5. ❌ `lib/presentation/screens/auth/login_screen.dart` - 1 error
   - Line 132:30 - prefer_const_constructors

6. ❌ `lib/presentation/screens/auth/register_screen.dart` - 1 error
   - Line 176:30 - prefer_const_constructors

7. ❌ `lib/presentation/screens/home_screen.dart` - 3 errors
   - Line 24:25 - prefer_const_constructors
   - Line 25:25 - prefer_const_constructors
   - Line 379:30 - prefer_const_constructors

8. ❌ `lib/presentation/screens/provider_screen.dart` - 12 errors
   - Lines: 160, 162, 213, 215, 222, 224, 255, 257, 310, 312, 384, 405, 463

9. ❌ `lib/presentation/screens/seeker_screen.dart` - 9 errors
   - Lines: 254, 256, 357, 414, 422, 436, 460, 462

**Action Items**:
- [ ] Run auto-fix: `dart fix --apply` (try this first)
- [ ] Manual fix remaining issues
- [ ] Verify with `flutter analyze`
- [ ] Ensure zero errors before commit

---

## Firebase Setup - USER ACTION REQUIRED

### Connect to Real Firebase
**Priority**: 🔴 **HIGH** - Required for app functionality  
**Status**: ⏸️ Waiting for User  
**Guide**: See `Docs/FIREBASE_SETUP_GUIDE.md`

**Steps**:
1. [ ] Install Firebase CLI: `npm install -g firebase-tools`
2. [ ] Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
3. [ ] Login to Firebase: `firebase login`
4. [ ] Configure project: `flutterfire configure`
5. [ ] Enable Authentication in Firebase Console
6. [ ] Enable Firestore Database
7. [ ] Enable Firebase Storage
8. [ ] Uncomment Firebase initialization in `lib/main.dart`
9. [ ] Test authentication flow

---

## Testing - HIGH PRIORITY

### Unit Tests for Auth Use Cases
**Priority**: 🟡 **HIGH**  
**Status**: 📝 Not Started  
**Files to Create**:
- [ ] `test/domain/usecases/auth/login_usecase_test.dart`
- [ ] `test/domain/usecases/auth/register_usecase_test.dart`
- [ ] `test/domain/usecases/auth/logout_usecase_test.dart`

**Requirements**:
- Mock AuthRepository using mockito
- Test success cases
- Test validation errors
- Test repository failures
- Coverage target: 90%+

### Integration Tests for Auth Repository
**Priority**: 🟡 **HIGH**  
**Status**: 📝 Not Started  
**Files to Create**:
- [ ] `integration_test/repositories/auth_repository_test.dart`

**Requirements**:
- Use fake_cloud_firestore
- Test Firebase integration
- Test error mapping
- Coverage target: 80%+

---

## Feature Implementation - NEXT PHASE

### Parking Spot Features
**Priority**: 🟢 **MEDIUM**  
**Status**: 📝 Not Started  
**Depends On**: Firebase setup complete

**Use Cases to Implement**:
- [ ] `lib/domain/usecases/parking/publish_spot_usecase.dart`
- [ ] `lib/domain/usecases/parking/search_spots_usecase.dart`
- [ ] `lib/domain/usecases/parking/cancel_spot_usecase.dart`

**Data Layer**:
- [ ] `lib/data/models/parking_spot_dto.dart`
- [ ] `lib/data/mappers/parking_spot_mapper.dart`
- [ ] `lib/data/datasources/remote/firebase_parking_spot_datasource.dart`
- [ ] `lib/data/repositories/parking_spot_repository_impl.dart`

**Presentation Layer**:
- [ ] Update `ProviderScreen` with real functionality
- [ ] Update `SeekerScreen` with real search
- [ ] Create Riverpod providers for parking spots

### Transaction Features
**Priority**: 🟢 **MEDIUM**  
**Status**: 📝 Not Started  

**Use Cases to Implement**:
- [ ] `lib/domain/usecases/transaction/purchase_spot_usecase.dart`
- [ ] `lib/domain/usecases/transaction/verify_spot_usecase.dart`
- [ ] `lib/domain/usecases/transaction/dispute_transaction_usecase.dart`

---

## Documentation

### Update Documentation
**Priority**: 🟢 **LOW**  
**Status**: ✅ Up to date

**Files**:
- [x] PROJECT_OVERVIEW.md
- [x] TECHNICAL_ARCHITECTURE.md
- [x] FEATURE_SPECIFICATIONS.md
- [x] DATA_MODELS.md
- [x] TESTING_STRATEGY.md
- [x] DEPLOYMENT_GUIDE.md
- [x] DEVELOPER_QUICKSTART.md
- [x] FIREBASE_SETUP_GUIDE.md
- [x] TODO.md (this file)

---

## Code Quality Standards

### Non-Negotiable Rules
1. ✅ **Zero warnings** - All warnings are errors
2. ✅ **Zero compilation errors** - Must compile cleanly
3. ⏳ **Test coverage >80%** - Not yet measured
4. ✅ **Clean architecture** - Strict layer separation
5. ✅ **TDD approach** - Tests before implementation
6. ⏳ **Const where possible** - Performance optimization (35 to fix)
7. ✅ **No unused imports** - Enforced by analyzer
8. ✅ **No unused variables** - Enforced by analyzer

---

## Legend

**Priority**:
- 🔴 **CRITICAL** - Blocking, must fix immediately
- 🟡 **HIGH** - Important, do soon
- 🟢 **MEDIUM** - Normal priority
- 🔵 **LOW** - Nice to have

**Status**:
- ✅ Complete
- 🔧 In Progress
- 📝 Not Started
- ⏸️ Waiting/Blocked

---

**Last Updated**: October 20, 2025  
**Next Review**: After const fixes completed
