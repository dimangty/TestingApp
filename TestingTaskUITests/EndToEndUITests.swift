import XCTest

final class EndToEndUITests: UITestBase {
    func test_loginNavigatesToMainTabs() {
        // Given
        let app = launchApp()
        let phoneField = app.textFields["login.phone"]
        let confirmButton = app.buttons["login.confirm"]
        XCTAssertTrue(phoneField.waitForExistence(timeout: 2))

        // When
        phoneField.tap()
        phoneField.typeText("1234567")
        confirmButton.tap()

        // Then
        let newsTab = app.tabBars.buttons["News"]
        XCTAssertTrue(newsTab.waitForExistence(timeout: 5))
    }
}
