import XCTest
@testable import TestingTask

final class ErrorResponseTests: XCTestCase {
    // MARK: - getType()

    func test_getType_returnsExpectedMessage() {
        // Given
        let auth = ErrorResponse(type: .auth)
        let network = ErrorResponse(type: .network)
        let tech = ErrorResponse(type: .tech)
        let other = ErrorResponse(type: .other)

        // When / Then
        // Each internal enum case should map to a stable user-facing label.
        XCTAssertEqual(auth.getType(), "Type error")
        XCTAssertEqual(network.getType(), "Network error")
        XCTAssertEqual(tech.getType(), "Tech error")
        XCTAssertEqual(other.getType(), "Other error")
    }
}
