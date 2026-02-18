import XCTest

final class LoginFlowUITests: UITestBase {
    func test_confirmButtonEnablesWithValidPhone() {
        // Given
        let app = launchApp()
        let phoneField = app.textFields["login.phone"]
        let confirmButton = app.buttons["login.confirm"]

        // When
        XCTAssertTrue(phoneField.waitForExistence(timeout: 2))
        XCTAssertFalse(confirmButton.isEnabled)

        phoneField.tap()
        phoneField.typeText("1234567")

        // Then
        XCTAssertTrue(confirmButton.isEnabled)
    }
}
