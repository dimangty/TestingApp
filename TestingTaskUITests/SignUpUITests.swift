import XCTest

final class SignUpUITests: UITestBase {
    func test_createAccountButtonEnabledAfterAllFieldsValid() {
        // Given
        let app = launchApp()
        let signUpButton = app.buttons["login.signup"]
        XCTAssertTrue(signUpButton.waitForExistence(timeout: 2))
        signUpButton.tap()

        let createButton = app.buttons["signup.createAccount"]
        XCTAssertTrue(createButton.waitForExistence(timeout: 2))
        XCTAssertFalse(createButton.isEnabled)

        // When
        app.textFields["signup.firstName"].tap()
        app.textFields["signup.firstName"].typeText("John")

        app.textFields["signup.lastName"].tap()
        app.textFields["signup.lastName"].typeText("Doe")

        app.textFields["signup.gender"].tap()
        app.sheets.buttons["Male"].tap()

        app.textFields["signup.birthDate"].tap()
        app.sheets.buttons["Done"].tap()

        app.textFields["signup.country"].tap()
        app.sheets.buttons["USA"].tap()

        app.textFields["signup.city"].tap()
        app.sheets.buttons["New York"].tap()

        app.textFields["signup.email"].tap()
        app.textFields["signup.email"].typeText("john@example.com")

        app.textFields["signup.phone"].tap()
        app.textFields["signup.phone"].typeText("1234567")

        // Then
        XCTAssertTrue(createButton.isEnabled)
    }
}
