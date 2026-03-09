# Presenter Unit Test Patterns (TestingTask)

## Test Stack

1. Framework: `XCTest` for unit tests.
2. Mocking: `SwiftyMocky` generated mocks from `TestingTaskTests/Support/Generated/Mock.generated.swift`.
3. Module import: `@testable import TestingTask`.

## Presenter Targets

1. `LoginScreenPresenter`
2. `SignUpScreenPresenter`
3. `NewsPresenter`
4. `FavoritePresenter`
5. `ArticlePresenter`

Expected test paths:

1. `TestingTaskTests/LoginScreenPresenterTests.swift`
2. `TestingTaskTests/SignUpScreenPresenterTests.swift`
3. `TestingTaskTests/NewsPresenterTests.swift`
4. `TestingTaskTests/FavoritePresenterTests.swift`
5. `TestingTaskTests/ArticlePresenterTests.swift`

## Base XCTest Skeleton

```swift
import XCTest
import SwiftyMocky
@testable import TestingTask

final class LoginScreenPresenterTests: XCTestCase {
    func test_viewLoaded_setsUpViewAndDisablesConfirmWhenPhoneInvalid() {
        // Given
        let view = LoginScreenViewInputMockableMock()
        let router = LoginScreenRouterInputMockableMock()
        let sut = LoginScreenPresenter(view: view, router: router)

        // When
        sut.viewLoaded()

        // Then
        Verify(view, .once, .setup())
        Verify(view, .atLeast(1), .updateConfirmButton(enabled: false))
    }
}
```

## Dependency Injection Pattern

Presenters use `@Injected` wrappers. Override in tests through projected value:

```swift
sut.$authService.wrappedValue = authMock
sut.$progressService.wrappedValue = progressSpy
sut.$errorService.wrappedValue = errorSpy
```

If mock types are missing for protocols, run `$ios-swiftymocky-maintainer`.

## Concrete-Service Strategy

Some dependencies are concrete classes (`ProgressService`, `ErrorService`, `ValidationService`, `NewsService`, `StorageService`).
When SwiftyMocky cannot mock them:

1. Create lightweight `final class ...Spy` in test file.
2. Override only methods needed by the test.
3. Avoid touching real network/core-data behavior in unit tests.

## Async Pattern

For completion-based methods:

1. Create `XCTestExpectation`.
2. Trigger callback through stub or controlled fake.
3. Wait with bounded timeout.

Example:

```swift
let exp = expectation(description: "login completion")
Perform(authMock, .login(phone: .any, completion: .any, perform: { _, completion in
    completion(.success(()))
    exp.fulfill()
}))
wait(for: [exp], timeout: 1.0)
```

## Minimum Coverage per Presenter

1. `viewLoaded` setup.
2. valid input branch.
3. invalid input branch.
4. routing side effects.
5. error side effects.
