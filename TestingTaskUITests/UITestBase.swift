import XCTest

class UITestBase: XCTestCase {
    func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["UITESTS"]
        app.launch()
        return app
    }
}
