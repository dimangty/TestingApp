import Testing
import Foundation
@testable import TestingTask

@Suite("ValidationService Tests")
struct ValidationServiceSwiftTests {

    private let sut = ValidationService()

    // MARK: - First Name Validation

    @Test("firstName with valid value returns true")
    func firstName_validValue_returnsTrue() {
        // Given
        let field = SignUpField.firstName
        let value = "John"

        // When
        let result = sut.isValid(field: field, value: value)

        // Then
        #expect(result == true)
    }

    @Test("firstName with empty value returns false")
    func firstName_emptyValue_returnsFalse() {
        // Given
        let field = SignUpField.firstName
        let value = ""

        // When
        let result = sut.isValid(field: field, value: value)

        // Then
        #expect(result == false)
    }

    @Test("firstName with whitespace only returns false")
    func firstName_whitespaceOnly_returnsFalse() {
        // Given
        let field = SignUpField.firstName
        let value = "   "

        // When
        let result = sut.isValid(field: field, value: value)

        // Then
        #expect(result == false)
    }

    // MARK: - Last Name Validation

    @Test("lastName with valid value returns true")
    func lastName_validValue_returnsTrue() {
        // Given
        let field = SignUpField.lastName
        let value = "Doe"

        // When
        let result = sut.isValid(field: field, value: value)

        // Then
        #expect(result == true)
    }

    @Test("lastName with empty value returns false")
    func lastName_emptyValue_returnsFalse() {
        // Given
        let field = SignUpField.lastName
        let value = ""

        // When
        let result = sut.isValid(field: field, value: value)

        // Then
        #expect(result == false)
    }

    // MARK: - Gender Validation

    @Test("gender with valid value returns true")
    func gender_validValue_returnsTrue() {
        #expect(sut.isValid(field: .gender, value: "Male") == true)
        #expect(sut.isValid(field: .gender, value: "Female") == true)
        #expect(sut.isValid(field: .gender, value: "Other") == true)
    }

    @Test("gender with empty value returns false")
    func gender_emptyValue_returnsFalse() {
        #expect(sut.isValid(field: .gender, value: "") == false)
    }

    // MARK: - Birth Date Validation

    @Test("birthDate with valid value returns true")
    func birthDate_validValue_returnsTrue() {
        #expect(sut.isValid(field: .birthDate, value: "01.01.1990") == true)
        #expect(sut.isValid(field: .birthDate, value: "1990-01-01") == true)
    }

    @Test("birthDate with empty value returns false")
    func birthDate_emptyValue_returnsFalse() {
        #expect(sut.isValid(field: .birthDate, value: "") == false)
    }

    // MARK: - Country Validation

    @Test("country with valid value returns true")
    func country_validValue_returnsTrue() {
        #expect(sut.isValid(field: .country, value: "Russia") == true)
        #expect(sut.isValid(field: .country, value: "USA") == true)
    }

    @Test("country with empty value returns false")
    func country_emptyValue_returnsFalse() {
        #expect(sut.isValid(field: .country, value: "") == false)
    }

    // MARK: - City Validation

    @Test("city with valid value returns true")
    func city_validValue_returnsTrue() {
        #expect(sut.isValid(field: .city, value: "Moscow") == true)
        #expect(sut.isValid(field: .city, value: "New York") == true)
    }

    @Test("city with empty value returns false")
    func city_emptyValue_returnsFalse() {
        #expect(sut.isValid(field: .city, value: "") == false)
    }

    // MARK: - Email Validation

    @Test("email with valid format returns true")
    func email_validFormat_returnsTrue() {
        let validEmails = [
            "test@example.com",
            "user.name@domain.org",
            "user+tag@example.co.uk",
            "a@b.cd"
        ]

        for email in validEmails {
            #expect(sut.isValid(field: .email, value: email) == true, "Expected \(email) to be valid")
        }
    }

    @Test("email with invalid format returns false")
    func email_invalidFormat_returnsFalse() {
        let invalidEmails = [
            "",
            "invalid",
            "invalid@",
            "@domain.com",
            "invalid@domain",
            "invalid@.com",
            "in valid@domain.com"
        ]

        for email in invalidEmails {
            #expect(sut.isValid(field: .email, value: email) == false, "Expected \(email) to be invalid")
        }
    }

    @Test("email with whitespace is trimmed and validated")
    func email_withWhitespace_isTrimmed() {
        // Leading/trailing whitespace should be trimmed
        #expect(sut.isValid(field: .email, value: "  test@example.com  ") == true)
    }

    // MARK: - Phone Validation

    @Test("phone with valid length returns true")
    func phone_validLength_returnsTrue() {
        let validPhones = [
            "1234567",      // 7 digits - minimum
            "12345678",     // 8 digits
            "123456789012345" // 15 digits - maximum
        ]

        for phone in validPhones {
            #expect(sut.isValid(field: .phone, value: phone) == true, "Expected \(phone) to be valid")
        }
    }

    @Test("phone with invalid length returns false")
    func phone_invalidLength_returnsFalse() {
        let invalidPhones = [
            "",            // empty
            "123456",      // 6 digits - too short
            "1234567890123456" // 16 digits - too long
        ]

        for phone in invalidPhones {
            #expect(sut.isValid(field: .phone, value: phone) == false, "Expected \(phone) to be invalid")
        }
    }

    @Test("phone with non-numeric characters returns false")
    func phone_nonNumeric_returnsFalse() {
        let invalidPhones = [
            "+1234567",     // has plus
            "123-4567",     // has dash
            "123 4567",     // has space
            "(123)4567890", // has parentheses
            "12345a67"      // has letter
        ]

        for phone in invalidPhones {
            #expect(sut.isValid(field: .phone, value: phone) == false, "Expected \(phone) to be invalid")
        }
    }

    @Test("phone only allows digits")
    func phone_onlyDigits_returnsTrue() {
        #expect(sut.isValid(field: .phone, value: "0123456789") == true)
    }

    // MARK: - Edge Cases

    @Test("all field types handle nil-like values correctly")
    func allFields_handleEmptyCorrectly() {
        for field in SignUpField.allCases {
            #expect(sut.isValid(field: field, value: "") == false, "Field \(field) should be invalid for empty string")
        }
    }

    @Test("text fields accept special characters")
    func textFields_acceptSpecialCharacters() {
        #expect(sut.isValid(field: .firstName, value: "Jean-Pierre") == true)
        #expect(sut.isValid(field: .lastName, value: "O'Connor") == true)
        #expect(sut.isValid(field: .city, value: "Saint-Petersburg") == true)
    }

    @Test("text fields accept unicode characters")
    func textFields_acceptUnicode() {
        #expect(sut.isValid(field: .firstName, value: "Дмитрий") == true)
        #expect(sut.isValid(field: .lastName, value: "中文") == true)
        #expect(sut.isValid(field: .city, value: "Москва") == true)
    }
}
