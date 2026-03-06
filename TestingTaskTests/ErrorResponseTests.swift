import XCTest
@testable import TestingTask

final class ErrorResponseTests: XCTestCase {
    func test_getType_returnsExpectedMessage() {
        // Given
        let auth = ErrorResponse(type: .auth)
        let network = ErrorResponse(type: .network)
        let tech = ErrorResponse(type: .tech)
        let other = ErrorResponse(type: .other)

        // When / Then
        XCTAssertEqual(auth.getType(), "Type error")
        XCTAssertEqual(network.getType(), "Network error")
        XCTAssertEqual(tech.getType(), "Tech error")
        XCTAssertEqual(other.getType(), "Other error")
    }
}
