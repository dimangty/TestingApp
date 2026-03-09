# UI Flow Test Patterns (TestingTask)

## Current UI Test Baseline

1. Base class: `TestingTaskUITests/UITestBase.swift`
2. Launch helper: `launchApp()` with `app.launchArguments = ["UITESTS"]`
3. Existing tests:
   - `TestingTaskUITests/LoginFlowUITests.swift`
   - `TestingTaskUITests/SignUpUITests.swift`
   - `TestingTaskUITests/EndToEndUITests.swift`

## Accessibility IDs in Project

1. `login.phone`
2. `login.confirm`
3. `login.signup`
4. `signup.firstName`
5. `signup.lastName`
6. `signup.gender`
7. `signup.birthDate`
8. `signup.country`
9. `signup.city`
10. `signup.email`
11. `signup.phone`
12. `signup.createAccount`

## XCTest Template

```swift
import XCTest

final class LoginFlowUITests: UITestBase {
    func test_confirmButtonEnablesWithValidPhone() {
        // Given
        let app = launchApp()
        let phoneField = app.textFields["login.phone"]
        let confirmButton = app.buttons["login.confirm"]

        // When
        XCTAssertTrue(phoneField.waitForExistence(timeout: 2))
        phoneField.tap()
        phoneField.typeText("1234567")

        // Then
        XCTAssertTrue(confirmButton.isEnabled)
    }
}
```

## Stability Rules

1. Never use `sleep(...)`.
2. Wait for first interactive element of each screen.
3. Use accessibility IDs over visible labels where available.
4. Keep one user behavior per test function.
5. Keep typed text deterministic.

## Suggested Additional Flows

1. Login invalid phone stays on login screen.
2. Sign up back navigation returns to login.
3. News tab opens and article detail is visible after tap.
4. Favorite toggle reflected in favorite tab flow.
