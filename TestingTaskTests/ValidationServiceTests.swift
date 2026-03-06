//
//  ValidationServiceTests.swift
//  TestingTaskTests
//
//  Unit tests for ValidationService with Given/When/Then pattern
//

import Testing
import Foundation
@testable import TestingTask

@Suite("ValidationService Tests")
struct ValidationServiceTests {

    // MARK: - Email Validation Tests

    @Test("Should validate correct email format")
    func testValidEmailFormat() {
        // Given: A validation service and a valid email
        let sut = ValidationService()
        let validEmail = "test@example.com"

        // When: Validating the email field
        let result = sut.isValid(field: .email, value: validEmail)

        // Then: Validation should pass
        #expect(result == true)
    }

    @Test("Should reject invalid email without @ symbol")
    func testInvalidEmailWithoutAtSymbol() {
        // Given: A validation service and an invalid email
        let sut = ValidationService()
        let invalidEmail = "testexample.com"

        // When: Validating the email field
        let result = sut.isValid(field: .email, value: invalidEmail)

        // Then: Validation should fail
        #expect(result == false)
    }

    @Test("Should reject invalid email without domain")
    func testInvalidEmailWithoutDomain() {
        // Given: A validation service and an email without domain
        let sut = ValidationService()
        let invalidEmail = "test@"

        // When: Validating the email field
        let result = sut.isValid(field: .email, value: invalidEmail)

        // Then: Validation should fail
        #expect(result == false)
    }

    @Test("Should reject empty email")
    func testEmptyEmail() {
        // Given: A validation service and an empty email
        let sut = ValidationService()
        let emptyEmail = ""

        // When: Validating the email field
        let result = sut.isValid(field: .email, value: emptyEmail)

        // Then: Validation should fail
        #expect(result == false)
    }

    @Test("Should validate email with subdomain")
    func testEmailWithSubdomain() {
        // Given: A validation service and an email with subdomain
        let sut = ValidationService()
        let emailWithSubdomain = "user@mail.example.com"

        // When: Validating the email field
        let result = sut.isValid(field: .email, value: emailWithSubdomain)

        // Then: Validation should pass
        #expect(result == true)
    }

    @Test("Should validate email with plus sign")
    func testEmailWithPlusSign() {
        // Given: A validation service and an email with plus sign
        let sut = ValidationService()
        let emailWithPlus = "user+tag@example.com"

        // When: Validating the email field
        let result = sut.isValid(field: .email, value: emailWithPlus)

        // Then: Validation should pass
        #expect(result == true)
    }

    // MARK: - Phone Validation Tests

    @Test("Should validate phone with 10 digits")
    func testValidPhoneWith10Digits() {
        // Given: A validation service and a valid 10-digit phone
        let sut = ValidationService()
        let validPhone = "1234567890"

        // When: Validating the phone field
        let result = sut.isValid(field: .phone, value: validPhone)

        // Then: Validation should pass
        #expect(result == true)
    }

    @Test("Should validate phone with minimum 7 digits")
    func testValidPhoneWithMinimum7Digits() {
        // Given: A validation service and a phone with 7 digits
        let sut = ValidationService()
        let validPhone = "1234567"

        // When: Validating the phone field
        let result = sut.isValid(field: .phone, value: validPhone)

        // Then: Validation should pass
        #expect(result == true)
    }

    @Test("Should validate phone with maximum 15 digits")
    func testValidPhoneWithMaximum15Digits() {
        // Given: A validation service and a phone with 15 digits
        let sut = ValidationService()
        let validPhone = "123456789012345"

        // When: Validating the phone field
        let result = sut.isValid(field: .phone, value: validPhone)

        // Then: Validation should pass
        #expect(result == true)
    }

    @Test("Should reject phone with less than 7 digits")
    func testInvalidPhoneWithLessThan7Digits() {
        // Given: A validation service and a phone with 6 digits
        let sut = ValidationService()
        let invalidPhone = "123456"

        // When: Validating the phone field
        let result = sut.isValid(field: .phone, value: invalidPhone)

        // Then: Validation should fail
        #expect(result == false)
    }

    @Test("Should reject phone with more than 15 digits")
    func testInvalidPhoneWithMoreThan15Digits() {
        // Given: A validation service and a phone with 16 digits
        let sut = ValidationService()
        let invalidPhone = "1234567890123456"

        // When: Validating the phone field
        let result = sut.isValid(field: .phone, value: invalidPhone)

        // Then: Validation should fail
        #expect(result == false)
    }

    @Test("Should reject phone containing non-digit characters")
    func testInvalidPhoneWithNonDigitCharacters() {
        // Given: A validation service and a phone with letters
        let sut = ValidationService()
        let invalidPhone = "12345abc89"

        // When: Validating the phone field
        let result = sut.isValid(field: .phone, value: invalidPhone)

        // Then: Validation should fail
        #expect(result == false)
    }

    @Test("Should reject phone with special characters")
    func testInvalidPhoneWithSpecialCharacters() {
        // Given: A validation service and a phone with special characters
        let sut = ValidationService()
        let invalidPhone = "+1-234-567-890"

        // When: Validating the phone field
        let result = sut.isValid(field: .phone, value: invalidPhone)

        // Then: Validation should fail
        #expect(result == false)
    }

    // MARK: - Text Field Validation Tests

    @Test("Should validate non-empty first name")
    func testValidFirstName() {
        // Given: A validation service and a valid first name
        let sut = ValidationService()
        let validName = "John"

        // When: Validating the first name field
        let result = sut.isValid(field: .firstName, value: validName)

        // Then: Validation should pass
        #expect(result == true)
    }

    @Test("Should reject empty first name")
    func testEmptyFirstName() {
        // Given: A validation service and an empty first name
        let sut = ValidationService()
        let emptyName = ""

        // When: Validating the first name field
        let result = sut.isValid(field: .firstName, value: emptyName)

        // Then: Validation should fail
        #expect(result == false)
    }

    @Test("Should reject first name with only whitespace")
    func testFirstNameWithOnlyWhitespace() {
        // Given: A validation service and a name with only whitespace
        let sut = ValidationService()
        let whitespaceName = "   "

        // When: Validating the first name field
        let result = sut.isValid(field: .firstName, value: whitespaceName)

        // Then: Validation should fail
        #expect(result == false)
    }

    @Test("Should validate first name after trimming whitespace")
    func testFirstNameWithLeadingTrailingWhitespace() {
        // Given: A validation service and a name with leading/trailing whitespace
        let sut = ValidationService()
        let nameWithWhitespace = "  John  "

        // When: Validating the first name field
        let result = sut.isValid(field: .firstName, value: nameWithWhitespace)

        // Then: Validation should pass (whitespace is trimmed)
        #expect(result == true)
    }

    @Test("Should validate non-empty country")
    func testValidCountry() {
        // Given: A validation service and a valid country
        let sut = ValidationService()
        let validCountry = "United States"

        // When: Validating the country field
        let result = sut.isValid(field: .country, value: validCountry)

        // Then: Validation should pass
        #expect(result == true)
    }

    @Test("Should reject empty country")
    func testEmptyCountry() {
        // Given: A validation service and an empty country
        let sut = ValidationService()
        let emptyCountry = ""

        // When: Validating the country field
        let result = sut.isValid(field: .country, value: emptyCountry)

        // Then: Validation should fail
        #expect(result == false)
    }

    @Test("Should validate all required text fields")
    func testAllTextFieldsValidation() {
        // Given: A validation service and valid values for all text fields
        let sut = ValidationService()
        let textFields: [SignUpField] = [.firstName, .lastName, .gender, .birthDate, .country, .city]

        // When: Validating each text field with non-empty value
        let results = textFields.map { field in
            sut.isValid(field: field, value: "Valid Value")
        }

        // Then: All validations should pass
        for result in results {
            #expect(result == true)
        }
    }

    @Test("Should reject all text fields when empty")
    func testAllTextFieldsRejectedWhenEmpty() {
        // Given: A validation service and empty values for all text fields
        let sut = ValidationService()
        let textFields: [SignUpField] = [.firstName, .lastName, .gender, .birthDate, .country, .city]

        // When: Validating each text field with empty value
        let results = textFields.map { field in
            sut.isValid(field: field, value: "")
        }

        // Then: All validations should fail
        for result in results {
            #expect(result == false)
        }
    }
}
