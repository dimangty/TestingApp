# SwiftTesting + SwiftyMocky Patterns (Single Presenter)

## Scope

This skill covers exactly one presenter per run.

Supported presenter files:

1. `TestingTask/Core/Sources/LoginScreen/Presenter/LoginScreenPresenter.swift`
2. `TestingTask/Core/Sources/SignUpScreen/Presenter/SignUpScreenPresenter.swift`
3. `TestingTask/Core/Sources/NewsScreen/Presenter/NewsPresenter.swift`
4. `TestingTask/Core/Sources/FavoriteScreen/Presenter/FavoritePresenter.swift`
5. `TestingTask/Core/Sources/ArticleScreen/Presenter/ArticlePresenter.swift`

## Test File Path

Default destination:

`TestingTaskTests/<PresenterName>SwiftTestingTests.swift`

## Base Template

```swift
import Foundation
import Testing
import SwiftyMocky
@testable import TestingTask

@Suite("LoginScreenPresenter SwiftTesting")
struct LoginScreenPresenterSwiftTestingTests {
    @Test("viewLoaded configures default state")
    func viewLoaded_configuresDefaultState() {
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

## Injection Pattern

For property-wrapper dependencies:

```swift
sut.$authService.wrappedValue = authMock
sut.$progressService.wrappedValue = progressSpy
sut.$errorService.wrappedValue = errorSpy
```

If a protocol mock is missing, run `$ios-swiftymocky-maintainer`.

## Async Callback Pattern

```swift
var completionWasCalled = false
Perform(authMock, .login(phone: .any, completion: .any, perform: { _, completion in
    completionWasCalled = true
    completion(.success(()))
}))
#expect(completionWasCalled)
```

Then assert with `#expect`.

## Minimum Scenario Set

1. Initial lifecycle (`viewLoaded` / `viewWillAppear` where relevant).
2. Valid input/action path.
3. Invalid/guard path.
4. Router side effect.
5. Error or completion side effect.

## Common Mistakes

1. Mixing `XCTestCase` and `@Suite` in same new file.
2. Using methods not present in current presenter API.
3. Forgetting `@testable import TestingTask`.
4. Skipping `Verify` for key interactions.
