import XCTest
@testable import TestingTask

final class DateExtensionsTests: XCTestCase {
    func test_toString_formatsDateWithRussianLocale() {
        // Given
        var components = DateComponents()
        components.year = 2024
        components.month = 2
        components.day = 3
        components.hour = 12
        components.minute = 34
        components.timeZone = TimeZone(secondsFromGMT: 0)
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: components) ?? Date(timeIntervalSince1970: 0)

        // When
        let result = date.toString(format: "dd.MM.yyyy")

        // Then
        XCTAssertEqual(result, "03.02.2024")
    }
}
