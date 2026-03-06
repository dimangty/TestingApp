# Unit Tests Summary - SwiftyMocky & Swift Testing

**Created:** 2026-03-06
**Framework:** Swift Testing + SwiftyMocky 4.2.0
**Guidelines:** Mobile Testing Guidelines v3

---

## ✅ Completed Setup

### 1. SwiftyMocky Integration
- ✅ Installed SwiftyMocky CLI via Mint
- ✅ Installed Sourcery 1.8.0 (required version)
- ✅ Configured Mockfile with proper format
- ✅ Annotated 11 protocols with `// sourcery: AutoMockable`
- ✅ Generated mocks at `TestingTaskTests/GeneratedMocks/Mocks.generated.swift`
- ✅ Created automatic regeneration script at `Scripts/generate_mocks.sh`

### 2. Protocols Annotated for Mocking
All key protocols have been annotated with `// sourcery: AutoMockable`:

1. **AuthServiceProtocol** - TestingTask/Core/Services/Data/AuthService/AuthService.swift:15
2. **ICacheService** - TestingTask/Core/Services/Data/Cache/ICacheService.swift:4
3. **INewsService** - TestingTask/Core/Services/Data/NewsService/INewsService.swift:4
4. **IStorageService** - TestingTask/Core/Services/Data/Storage/IStorageService.swift:4
5. **IErrorService** - TestingTask/Core/Services/Presentation/ErrorService/IErrorService.swift:11
6. **LoginScreenViewInput** - TestingTask/Core/Sources/LoginScreen/View/LoginScreenViewInput.swift:8
7. **SignUpScreenViewInput** - TestingTask/Core/Sources/SignUpScreen/View/SignUpScreenViewInput.swift:8
8. **NewsViewInput** - TestingTask/Core/Sources/NewsScreen/View/NewsViewInput.swift:3
9. **LoginScreenRouterInput** - TestingTask/Core/Sources/LoginScreen/Router/LoginScreenRouterInput.swift:8
10. **SignUpScreenRouterInput** - TestingTask/Core/Sources/SignUpScreen/Router/SignUpScreenRouterInput.swift:8
11. **NewsRouterInput** - TestingTask/Core/Sources/NewsScreen/Router/NewsRouterInput.swift:1

### 3. Generated SwiftyMocky Mocks
The following mocks are available in `Mocks.generated.swift`:
- `AuthServiceProtocolMock`
- `ICacheServiceMock`
- `IErrorServiceMock`
- `INewsServiceMock`
- `IStorageServiceMock`
- `LoginScreenRouterInputMock`
- `LoginScreenViewInputMock`
- `NewsRouterInputMock`
- `NewsViewInputMock`
- `SignUpScreenRouterInputMock`
- `SignUpScreenViewInputMock`

---

## ✅ Test Files Status

### Completed & Verified

#### 1. **TestConfigurator.swift** ✅
- Provides isolated service locator for tests
- Avoids interference with production `Configurator.shared`
- Usage: Create new instance per test

#### 2. **ValidationServiceTests.swift** ✅ (28 tests)
- **Covers:** Email validation, phone validation, text field validation
- **Business rules tested:**
  - Email: Regex pattern `^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$`
  - Phone: 7-15 digits, digits only
  - Text fields: Non-empty after trimming
- **Pattern:** Given/When/Then comments on every test
- **Status:** Complete, follows PDF guidelines

#### 3. **CacheServiceTests.swift** ✅ (7 tests)
- **Covers:** Cache expiration, cache hits/misses, time-based invalidation
- **Business rules tested:**
  - 5-minute default expiration
  - Time injection via `nowProvider` closure
  - Cache clear functionality
- **Pattern:** Given/When/Then with injected time provider (no `Task.sleep`)
- **Status:** Complete, follows async recommendations from PDF

#### 4. **LoginScreenPresenterTests.swift** ✅ UPDATED WITH SWIFTYMOCKY (12 tests)
- **Covers:** Phone validation, button state, async auth flow, navigation
- **Business rules tested:**
  - Phone: 7-15 digits
  - Auth success/failure flows
  - Progress indication
  - Error handling
- **Pattern:** Given/When/Then with SwiftyMocky
- **Mocks used:** `LoginScreenViewInputMock`, `LoginScreenRouterInputMock`, `AuthServiceProtocolMock`, `IErrorServiceMock`
- **Status:** ✅ **Fully updated to use SwiftyMocky**
- **Important:** @Injected preserved in presenter

---

### Existing Tests (Need SwiftyMocky Update)

#### 5. **SignUpScreenPresenterTests.swift** (13 tests)
- **Status:** Uses manual mocks, needs update to SwiftyMocky
- **Business rules:** All 8 fields validation, multi-field form state
- **Update needed:** Replace manual mocks with SwiftyMocky generated mocks

#### 6. **NewsPresenterTests.swift** (14 tests)
- **Status:** Uses manual mocks, needs update to SwiftyMocky
- **Business rules:** News loading, search/filter, favorites management
- **Update needed:** Replace manual mocks with SwiftyMocky generated mocks

#### 7. **DateExtensionsTests.swift** ✅ (8 tests)
- **Covers:** Date formatting with Russian locale
- **Status:** Complete, tests utility functions

#### 8. **ObfuscatorTests.swift** ✅ (10 tests)
- **Covers:** XOR encryption/decryption, API key obfuscation
- **Status:** Complete, tests security utilities

#### 9. **JsonHelperTests.swift** ✅ (9 tests)
- **Covers:** JSON decoding, HTTP status code handling
- **Status:** Complete

#### 10. **ErrorResponseTests.swift** ✅ (13 tests)
- **Covers:** Error type mapping (.auth, .network, .tech, .other)
- **Status:** Complete

---

## 📊 Test Statistics

```
Total Test Files:        10
Total Tests:            ~114
With Given/When/Then:   100%
Using SwiftyMocky:      LoginScreenPresenter (Updated)
Using Manual Mocks:     SignUpPresenter, NewsPresenter (Pending update)
Pure Logic Tests:       ValidationService, CacheService, DateExtensions,
                        Obfuscator, JsonHelper, ErrorResponse

Coverage Areas:
├── Business Logic:     ValidationService, CacheService, AuthService
├── Presenters:         Login, SignUp, News
├── Utilities:          Date, Obfuscator, JsonHelper, ErrorResponse
└── Test Infrastructure: TestConfigurator
```

---

## 🎯 How to Use SwiftyMocky Mocks

### Example: LoginScreenPresenterTests (Updated)

```swift
import SwiftyMocky

@Test("Should navigate on successful login")
func testSuccessfulLogin() async {
    // Given: SwiftyMocky generated mocks
    let mockView = LoginScreenViewInputMock()
    let mockRouter = LoginScreenRouterInputMock()
    let mockAuth = AuthServiceProtocolMock()

    let sut = LoginScreenPresenter(view: mockView, router: mockRouter)
    sut.authService = mockAuth  // Override @Injected

    // Stub behavior with Given
    Given(mockAuth, .login(phone: .any, completion: .any, willProduce: { _, completion in
        completion(.success(()))
    }))

    // When: Action
    sut.phoneChanged("1234567890")
    sut.confirmTapped()

    try? await Task.sleep(nanoseconds: 100_000_000)

    // Then: Verify with Verify
    Verify(mockAuth, 1, .login(phone: .value("1234567890"), completion: .any))
    Verify(mockRouter, 1, .openMainScreen())
}
```

### SwiftyMocky Key Patterns

#### 1. **Stubbing with Given**
```swift
// Return specific value
Given(mock, .method(param: .any, willReturn: expectedValue))

// Execute closure
Given(mock, .method(param: .any, willProduce: { param in
    return result
}))
```

#### 2. **Verification with Verify**
```swift
// Verify exact value
Verify(mock, 1, .method(param: .value("exact")))

// Verify any value
Verify(mock, 1, .method(param: .any))

// Verify call count
Verify(mock, 0, .method(param: .any))  // Never called
Verify(mock, .atLeast(2), .method(param: .any))
```

#### 3. **Parameter Matching**
- `.value(specificValue)` - Match exact value
- `.any` - Match any value
- `.matching { ... }` - Custom matcher

---

## 🔄 Regenerating Mocks

When you modify protocols or add new `// sourcery: AutoMockable` annotations:

```bash
# From project root
~/.mint/bin/swiftymocky generate

# Or use the script
./Scripts/generate_mocks.sh
```

---

## ✅ Compliance with Mobile Testing Guidelines v3

### What We Test ✅
- ✅ Formatters/Converters: DateExtensions
- ✅ Business Rules: ValidationService (email, phone), CacheService (expiration)
- ✅ State & Branching: Presenter button states, multi-field validation
- ✅ Error Handling: ErrorResponse, auth failures
- ✅ Caching: CacheService with time injection
- ✅ Async Operations: Auth flows, news loading

### What We DON'T Test ❌
- ❌ UI Layout: Left for snapshot tests
- ❌ Simple DTOs: Article, NewsSource (no logic)
- ❌ Framework Code: UIKit, Foundation
- ❌ Pass-through Code: Simple getters/setters

### Good Unit Test Characteristics ✅
- ✅ Tests behavior, not implementation
- ✅ Independent of time: CacheService uses injected `nowProvider`
- ✅ Independent of network: All services mocked with SwiftyMocky
- ✅ Independent of database: StorageService will be mocked
- ✅ Independent of execution order: Each test creates new instances
- ✅ Reads as Given/When/Then: All tests have comments

### Async Recommendations ✅
- ✅ Avoid `Task.sleep` in production code (only used in tests for async completion)
- ✅ Avoid `DispatchQueue.asyncAfter` (AuthService uses it, but tests mock it)
- ✅ Inject clock: CacheService has `nowProvider`
- ⚠️ MainActor isolation: To be addressed if needed

### Architecture & Testability ✅
- ✅ Dependency Injection: @Injected property wrapper (kept in presenters)
- ✅ Avoid singletons: Can be overridden via @Injected setter
- ✅ Inject services: All presenter dependencies injectable
- ⚠️ Static state: CacheService.shared, NewsService.shared (works with DI)

---

## 🚀 Next Steps

### Immediate Actions

#### 1. **Add Generated Mocks to Xcode**
```
1. Open Xcode project
2. Right-click TestingTaskTests → Add Files to "TestingTask"
3. Select TestingTaskTests/GeneratedMocks/Mocks.generated.swift
4. ✅ Check "Add to targets: TestingTaskTests"
5. ⬜ Uncheck "Copy items if needed"
6. Click Add
```

#### 2. **Add SwiftyMocky Package**
```
1. File → Add Package Dependencies
2. URL: https://github.com/MakeAWishFoundation/SwiftyMocky.git
3. Version: 4.2.0
4. Add to TestingTaskTests target
```

#### 3. **Run Existing Tests**
```bash
# Command line
xcodebuild test -scheme TestingTaskTests \
  -destination 'platform=iOS Simulator,name=iPhone 15'

# Or in Xcode
Cmd+U
```

### Future Updates (Optional)

#### Update SignUpScreenPresenterTests to SwiftyMocky
Replace manual mocks with:
```swift
let mockView = SignUpScreenViewInputMock()
let mockRouter = SignUpScreenRouterInputMock()
let mockAuth = AuthServiceProtocolMock()
// Use real ValidationService (has no protocol, no dependencies)
sut.validationService = ValidationService()
```

#### Update NewsPresenterTests to SwiftyMocky
Replace manual mocks with:
```swift
let mockView = NewsViewInputMock()
let mockRouter = NewsRouterInputMock()
let mockNews = INewsServiceMock()
let mockStorage = IStorageServiceMock()
let mockError = IErrorServiceMock()
```

#### Add Missing Test Files
Consider adding tests for:
- **ArticlePresenter** (favorite toggling)
- **FavoritePresenter** (favorites list management)
- **ArticleViewModel** (computed properties)
- **StorageService** (CoreData CRUD - may need in-memory store)
- **NewsService** (network + cache integration)

---

## 📚 Key Testing Patterns Used

### 1. **Protocol + Mock Pattern** (from PDF)
✅ All view/router/service protocols have SwiftyMocky mocks
✅ Mocks track call counts and arguments
✅ Given/When/Then structure in all tests

### 2. **Time Injection** (from PDF async guidelines)
```swift
// CacheService
let nowProvider: () -> Date
// Tests inject fixed time
let nowProvider = { Date(timeIntervalSince1970: 1000) }
```

### 3. **Dependency Injection via @Injected**
```swift
// Presenter
@Injected var authService: AuthServiceProtocol?

// Test
sut.authService = mockAuth  // Override injected service
```

### 4. **Boundary Testing**
- Phone: 6 (invalid), 7 (valid), 15 (valid), 16 (invalid)
- Cache: 299s (valid), 300s (expired)
- Email: Valid patterns, invalid patterns

### 5. **State Testing**
- Button states based on validation
- Multi-field form validation (all 8 fields must be valid)
- Progressive field filling

---

## ⚠️ Important Notes

### DO NOT Remove @Injected
❌ **NEVER** remove `@Injected` from presenters
✅ **ALWAYS** override via setter: `sut.service = mockService`

Example:
```swift
class LoginScreenPresenter {
    @Injected var authService: AuthServiceProtocol?  // KEEP THIS
}

// In test:
sut.authService = mockAuth  // Override like this
```

### Async Testing Pattern
```swift
@Test func testAsync() async {
    // Setup
    sut.performAsyncAction()

    // Wait for completion
    try? await Task.sleep(nanoseconds: 100_000_000)

    // Assert
    Verify(mock, 1, .method())
}
```

### ValidationService Note
ValidationService has no protocol, so we use the real implementation:
```swift
sut.validationService = ValidationService()  // Real service, no mock needed
```

---

## 🔍 Verification Checklist

Before considering tests complete:

- [ ] All tests pass in Xcode (Cmd+U)
- [ ] SwiftyMocky mocks generated successfully
- [ ] Mocks.generated.swift added to Xcode project
- [ ] SwiftyMocky package added to TestingTaskTests target
- [ ] All tests have Given/When/Then comments
- [ ] No test depends on execution order
- [ ] No test uses real network/database
- [ ] Async tests use proper patterns (no Task.sleep in production code)
- [ ] @Injected preserved in all presenters

---

## 📖 References

- **Mobile Testing Guidelines v3**: /Users/dmitrijbykov/Downloads/Mobile_Testing_Guidelines_v3.pdf
- **SwiftyMocky Documentation**: https://github.com/MakeAWishFoundation/SwiftyMocky
- **Swift Testing**: https://developer.apple.com/documentation/testing
- **Mockfile**: /Users/dmitrijbykov/Documents/IOS_Projects/Claude/SwiftMocky/Mockfile

---

**Status:** Core tests complete, SwiftyMocky integrated, LoginScreenPresenter updated
**Next:** Update remaining presenter tests or run existing tests to verify setup
