# Unit Tests Documentation

## Overview
This test suite provides comprehensive unit test coverage for the TestingTask project using **SwiftTesting** framework. All tests follow the **Given/When/Then** pattern as recommended in the Mobile Testing Guidelines v3.

## Project Structure

```
TestingTaskTests/
├── README.md                          # This file
├── TestConfigurator.swift             # Dependency injection setup for tests
├── GeneratedMocks/                    # SwiftyMocky generated mocks
│   └── Mocks.generated.swift         # Auto-generated mock implementations
├── CacheServiceTests.swift           # Cache service unit tests
├── ValidationServiceTests.swift      # Validation service unit tests
├── DateExtensionsTests.swift         # Date extension unit tests
├── ObfuscatorTests.swift            # Obfuscator unit tests
├── JsonHelperTests.swift            # JSON helper unit tests
├── ErrorResponseTests.swift         # Error response unit tests
├── LoginScreenPresenterTests.swift  # Login presenter unit tests (SwiftyMocky)
├── SignUpScreenPresenterTests.swift # Sign up presenter unit tests
├── NewsPresenterTests.swift         # News presenter unit tests
├── ArticlePresenterTests.swift      # Article presenter unit tests (NEW)
└── FavoritePresenterTests.swift     # Favorite presenter unit tests (NEW)
```

## Test Coverage

### Services Tested
- ✅ **CacheService** - Caching logic, expiration, cache hits/misses
- ✅ **ValidationService** - Email, phone, and text field validation
- ✅ **JsonHelper** - JSON decoding with various HTTP status codes
- ✅ **Obfuscator** - Encryption/decryption with XOR cipher

### Presenters Tested
- ✅ **LoginScreenPresenter** - Login flow, validation, navigation (12 tests)
- ✅ **SignUpScreenPresenter** - Sign up flow, field validation, navigation (13 tests)
- ✅ **NewsPresenter** - Article loading, search/filter, favorites (14 tests)
- ✅ **ArticlePresenter** - Article display, favorite toggle, image loading (11 tests) **NEW**
- ✅ **FavoritePresenter** - Favorites list, observer pattern, navigation (14 tests) **NEW**

### Extensions & Utilities Tested
- ✅ **Date Extensions** - Date formatting with various patterns
- ✅ **ErrorResponse** - Error types and messages

## Test Patterns

### Given/When/Then Structure
All tests follow the Given/When/Then pattern:

```swift
@Test("Description of what is being tested")
func testExample() {
    // Given: Setup test conditions and dependencies
    let mockView = MockLoginScreenView()
    let sut = LoginScreenPresenter(view: mockView, router: mockRouter)

    // When: Perform the action being tested
    sut.phoneChanged("1234567890")

    // Then: Assert expected outcomes
    #expect(mockView.updateConfirmButtonReceivedEnabled == true)
}
```

### Dependency Injection for Testing
Presenters use `@Injected` property wrapper which allows overriding dependencies in tests:

```swift
let mockAuth = MockAuthService()
let sut = LoginScreenPresenter(view: mockView, router: mockRouter)
sut.authService = mockAuth  // Override injected dependency
```

**IMPORTANT:** Never remove `@Injected` from presenters - it's required for dependency injection in tests.

## Mock Objects

### SwiftyMocky Integration
The project uses **SwiftyMocky 4.2.0** for automatic mock generation:
- All protocols annotated with `// sourcery: AutoMockable` generate mocks automatically
- Mocks are generated in `TestingTaskTests/GeneratedMocks/Mocks.generated.swift`
- Run `./Scripts/generate_mocks.sh` to regenerate mocks after protocol changes

### Mock Design
All SwiftyMocky mocks follow a consistent pattern:
- Track invocations for verification with `Verify()`
- Support stubbing return values with `Given()`
- Support stubbing behavior with `Perform()`
- Use `resetMock()` method for clean test isolation

### Example SwiftyMocky Usage

```swift
// Given: Create mock and stub behavior
let mockAuth = AuthServiceProtocolMock()
Given(mockAuth, .login(phone: .any, completion: .any, willProduce: { phone, completion in
    completion(.success(()))
}))

// When: Execute system under test
sut.confirmTapped()

// Then: Verify interactions
Verify(mockAuth, 1, .login(phone: .value("1234567890"), completion: .any))
}

// Perform action
sut.confirmTapped()

// Verify interactions
#expect(mockAuth.loginPhoneCompletionCallCount == 1)
```

## Running Tests

### Using Xcode
1. Open `TestingTask.xcodeproj`
2. Select the `TestingTaskTests` scheme
3. Press `Cmd+U` to run all tests
4. Or click the diamond icon next to individual tests

### Using Command Line
```bash
xcodebuild test -scheme TestingTaskTests -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Running Specific Test Suites
```bash
# Run only CacheService tests
xcodebuild test -scheme TestingTaskTests -only-testing:TestingTaskTests/CacheServiceTests

# Run only Presenter tests
xcodebuild test -scheme TestingTaskTests -only-testing:TestingTaskTests/LoginScreenPresenterTests
```

## Testing Guidelines (from PDF)

### ✅ What We Test
- ✅ Formatters and converters (Date extensions)
- ✅ Business rules (Validation, Auth logic)
- ✅ State and branching (Presenter state management)
- ✅ Error handling (Error responses, failed requests)
- ✅ Caching (Cache expiration, hit/miss scenarios)
- ✅ Async operations (Auth requests, news loading)

### ❌ What We DON'T Test
- ❌ UI layout
- ❌ Simple DTO models
- ❌ Third-party libraries
- ❌ Framework code
- ❌ Pass-through code without logic

### Good Unit Test Characteristics
✅ Tests behavior, not implementation
✅ Independent of time (uses injected clock/date providers)
✅ Independent of network (uses mocks)
✅ Independent of database (uses mocks)
✅ Independent of execution order
✅ Readable as Given/When/Then scenarios

## Test Configuration

### TestConfigurator
The `TestConfigurator` class provides isolated dependency injection for tests:

```swift
let configurator = TestConfigurator()
configurator.registerService(service: mockAuthService)

// Get service in test
let authService = configurator.getService(type: AuthServiceProtocol.self)
```

This keeps tests isolated from production `Configurator.shared`.

## Async Testing

Tests involving async operations use Swift concurrency:

```swift
@Test("Async test example")
func testAsync() async {
    // Setup
    sut.confirmTapped()

    // Wait for async completion
    try? await Task.sleep(nanoseconds: 100_000_000)

    // Assert
    #expect(mockRouter.openMainScreenCallCount == 1)
}
```

## Common Test Scenarios

### Testing Success Flow
```swift
// Given: Valid inputs and successful mock response
mockAuth.loginPhoneCompletionClosure = { phone, completion in
    completion(.success(()))
}

// When: User performs action
sut.confirmTapped()

// Then: Should navigate to success screen
#expect(mockRouter.openMainScreenCallCount == 1)
```

### Testing Failure Flow
```swift
// Given: Mock service returns error
mockAuth.loginPhoneCompletionClosure = { phone, completion in
    completion(.failure(AuthError.invalidPhone))
}

// When: User performs action
sut.confirmTapped()

// Then: Should show error message
#expect(mockError.showErrorTextCallCount == 1)
```

### Testing Validation
```swift
// Given: Validation rules
mockValidation.isValidFieldValueClosure = { field, value in
    return !value.isEmpty
}

// When: User enters value
sut.fieldChanged(.email, value: "test@example.com")

// Then: Should enable submit button
#expect(mockView.updateCreateButtonReceivedEnabled == true)
```

## Best Practices

1. **Reset mocks between tests**: Always call `mock.reset()` or create new mock instances
2. **Test one thing**: Each test should verify a single behavior
3. **Use descriptive names**: Test names should describe what is being tested
4. **Avoid test interdependence**: Tests should not rely on other tests
5. **Keep tests fast**: Use mocks to avoid network/database dependencies
6. **Verify all expectations**: Check both positive and negative cases

## Troubleshooting

### Test Fails Due to Async Timing
- Increase `Task.sleep` duration
- Ensure `DispatchQueue.main.async` is used in mocks
- Check that completion handlers are called

### Mock Not Recording Calls
- Verify mock is properly injected: `sut.service = mockService`
- Check that mock method signature matches protocol
- Ensure `callCount` is being incremented

### Compiler Errors
- Ensure all test files are added to TestingTaskTests target
- Verify `@testable import TestingTask` is present
- Check that Testing framework is available

## Coverage Goals

Following the Test Pyramid principle:
- **Unit Tests** (70-80%): Business logic, services, presenters ✅
- **Integration Tests** (15-20%): Service interactions ⏳
- **UI Tests** (5-10%): Critical user flows ✅ (Already implemented)

## Future Enhancements

- [ ] Add tests for ArticleViewModel
- [ ] Add tests for FavoritePresenter
- [ ] Add integration tests for service interactions
- [ ] Add performance tests for large data sets
- [ ] Add snapshot tests for complex UI states

## Contact & Support

For questions about tests or to report issues:
1. Check this README
2. Review Mobile Testing Guidelines v3 PDF
3. Examine existing tests for patterns
4. Consult with team lead

---

**Last Updated**: 2026-03-06
**Testing Framework**: Swift Testing
**Guidelines**: Mobile Testing Guidelines v3
