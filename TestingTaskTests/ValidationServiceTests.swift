import Foundation
import Testing
@testable import TestingTask

@Suite("Validation and Auth Tests")
struct ValidationServiceTests {
    @Test("Required sign-up fields reject empty values")
    func requiredFieldsRejectEmptyInput() {
        // Given
        let sut = ValidationService()
        let requiredFields: [SignUpField] = [.firstName, .lastName, .gender, .birthDate, .country, .city]

        // When
        let values = requiredFields.map { sut.isValid(field: $0, value: " ") }

        // Then
        #expect(values.allSatisfy { $0 == false })
    }

    @Test("Required sign-up fields accept non-empty values")
    func requiredFieldsAcceptNonEmptyInput() {
        // Given
        let sut = ValidationService()
        let requiredFields: [SignUpField] = [.firstName, .lastName, .gender, .birthDate, .country, .city]

        // When
        let values = requiredFields.map { sut.isValid(field: $0, value: "Value") }

        // Then
        #expect(values.allSatisfy { $0 == true })
    }

    @Test("Email field validates format")
    func validatesEmailField() {
        // Given
        let sut = ValidationService()

        // When
        let valid = sut.isValid(field: .email, value: "user@example.com")
        let invalid = sut.isValid(field: .email, value: "user@example")

        // Then
        #expect(valid == true)
        #expect(invalid == false)
    }

    @Test("Phone field validates digits and length")
    func validatesPhoneField() {
        // Given
        let sut = ValidationService()

        // When
        let valid = sut.isValid(field: .phone, value: "1234567")
        let tooShort = sut.isValid(field: .phone, value: "123")
        let withSymbols = sut.isValid(field: .phone, value: "123-4567")

        // Then
        #expect(valid == true)
        #expect(tooShort == false)
        #expect(withSymbols == false)
    }

    @Test("Auth login returns invalidPhone for bad input")
    func authLoginFailsForInvalidPhone() {
        // Given
        let sut = AuthService(executeAfter: { _, action in action() })
        var result: Result<Void, Error>?

        // When
        sut.login(phone: "123") { completion in
            result = completion
        }

        // Then
        switch result {
        case .success:
            #expect(false)
        case .failure(let error):
            guard let authError = error as? AuthError else {
                #expect(false)
                return
            }
            switch authError {
            case .invalidPhone:
                #expect(true)
            case .invalidData:
                #expect(false)
            }
        case .none:
            #expect(false)
        }
    }

    @Test("Auth login succeeds with valid phone using deterministic executor")
    func authLoginSucceedsForValidPhone() {
        // Given
        let sut = AuthService(executeAfter: { _, action in action() })
        var result: Result<Void, Error>?

        // When
        sut.login(phone: "1234567") { completion in
            result = completion
        }

        // Then
        switch result {
        case .success:
            #expect(true)
        default:
            #expect(false)
        }
    }

    @Test("Auth sign-up rejects empty payload")
    func authSignUpFailsForEmptyFields() {
        // Given
        let sut = AuthService(executeAfter: { _, action in action() })
        let data = SignUpData(fields: [:])
        var result: Result<Void, Error>?

        // When
        sut.signUp(data: data) { completion in
            result = completion
        }

        // Then
        switch result {
        case .success:
            #expect(false)
        case .failure(let error):
            guard let authError = error as? AuthError else {
                #expect(false)
                return
            }
            switch authError {
            case .invalidData:
                #expect(true)
            case .invalidPhone:
                #expect(false)
            }
        case .none:
            #expect(false)
        }
    }

    @Test("Auth sign-up succeeds for non-empty payload")
    func authSignUpSucceedsForFilledFields() {
        // Given
        let sut = AuthService(executeAfter: { _, action in action() })
        let data = SignUpData(fields: [.firstName: "Ivan", .email: "ivan@mail.com"])
        var result: Result<Void, Error>?

        // When
        sut.signUp(data: data) { completion in
            result = completion
        }

        // Then
        switch result {
        case .success:
            #expect(true)
        default:
            #expect(false)
        }
    }
}
