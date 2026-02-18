import XCTest
@testable import TestingTask

final class ValidationServiceTests: XCTestCase {
    private var service: ValidationService!

    override func setUp() {
        super.setUp()
        service = ValidationService()
    }

    func test_requiredFields_whenEmpty_returnsFalse() {
        // Given
        let requiredFields: [SignUpField] = [.firstName, .lastName, .gender, .birthDate, .country, .city]

        // When / Then
        for field in requiredFields {
            XCTAssertFalse(service.isValid(field: field, value: " "), "Expected \(field) to be invalid for empty value")
        }
    }

    func test_requiredFields_whenFilled_returnsTrue() {
        // Given
        let requiredFields: [SignUpField] = [.firstName, .lastName, .gender, .birthDate, .country, .city]

        // When / Then
        for field in requiredFields {
            XCTAssertTrue(service.isValid(field: field, value: "Value"), "Expected \(field) to be valid for non-empty value")
        }
    }

    func test_emailValidation() {
        // Given
        let valid = "user@example.com"
        let invalid = "user@example"

        // When / Then
        XCTAssertTrue(service.isValid(field: .email, value: valid))
        XCTAssertFalse(service.isValid(field: .email, value: invalid))
    }

    func test_phoneValidation() {
        // Given
        let valid = "1234567"
        let tooShort = "123"
        let withSymbols = "123-4567"

        // When / Then
        XCTAssertTrue(service.isValid(field: .phone, value: valid))
        XCTAssertFalse(service.isValid(field: .phone, value: tooShort))
        XCTAssertFalse(service.isValid(field: .phone, value: withSymbols))
    }
}
