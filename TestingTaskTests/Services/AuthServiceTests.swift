import Testing
import Foundation
@testable import TestingTask

@Suite("AuthService Tests")
struct AuthServiceTests {

    // MARK: - Login

    @Test("login with valid phone succeeds")
    @MainActor
    func login_validPhone_succeeds() async throws {
        // Given
        let sut = AuthService()
        var result: Result<Void, Error>?

        // When
        sut.login(phone: "1234567") { res in
            result = res
        }

        try await Task.sleep(nanoseconds: 500_000_000) // Wait for async completion

        // Then
        guard case .success = result else {
            Issue.record("Expected success but got \(String(describing: result))")
            return
        }
    }

    @Test("login with minimum valid phone length succeeds")
    @MainActor
    func login_minimumValidLength_succeeds() async throws {
        // Given
        let sut = AuthService()
        var result: Result<Void, Error>?

        // When
        sut.login(phone: "1234567") { res in // 7 digits
            result = res
        }

        try await Task.sleep(nanoseconds: 500_000_000)

        // Then
        guard case .success = result else {
            Issue.record("Expected success for 7-digit phone")
            return
        }
    }

    @Test("login with maximum valid phone length succeeds")
    @MainActor
    func login_maximumValidLength_succeeds() async throws {
        // Given
        let sut = AuthService()
        var result: Result<Void, Error>?

        // When
        sut.login(phone: "123456789012345") { res in // 15 digits
            result = res
        }

        try await Task.sleep(nanoseconds: 500_000_000)

        // Then
        guard case .success = result else {
            Issue.record("Expected success for 15-digit phone")
            return
        }
    }

    @Test("login with too short phone fails")
    func login_tooShortPhone_fails() {
        // Given
        let sut = AuthService()
        var result: Result<Void, Error>?

        // When
        sut.login(phone: "123456") { res in // 6 digits - too short
            result = res
        }

        // Then - should fail immediately (synchronous)
        guard case .failure(let error) = result else {
            Issue.record("Expected failure for 6-digit phone")
            return
        }
        #expect(error is AuthError)
    }

    @Test("login with too long phone fails")
    func login_tooLongPhone_fails() {
        // Given
        let sut = AuthService()
        var result: Result<Void, Error>?

        // When
        sut.login(phone: "1234567890123456") { res in // 16 digits - too long
            result = res
        }

        // Then
        guard case .failure(let error) = result else {
            Issue.record("Expected failure for 16-digit phone")
            return
        }
        #expect(error is AuthError)
    }

    @Test("login with empty phone fails")
    func login_emptyPhone_fails() {
        // Given
        let sut = AuthService()
        var result: Result<Void, Error>?

        // When
        sut.login(phone: "") { res in
            result = res
        }

        // Then
        guard case .failure = result else {
            Issue.record("Expected failure for empty phone")
            return
        }
    }

    @Test("login filters non-digit characters from phone")
    @MainActor
    func login_filtersNonDigits_succeeds() async throws {
        // Given
        let sut = AuthService()
        var result: Result<Void, Error>?

        // When - phone with formatting but 7 actual digits
        sut.login(phone: "+1-234-567") { res in
            result = res
        }

        try await Task.sleep(nanoseconds: 500_000_000)

        // Then - should succeed as it has 7 digits
        guard case .success = result else {
            Issue.record("Expected success when filtering to 7 digits")
            return
        }
    }

    // MARK: - Sign Up

    @Test("signUp with non-empty fields succeeds")
    @MainActor
    func signUp_nonEmptyFields_succeeds() async throws {
        // Given
        let sut = AuthService()
        let data = SignUpData(fields: [.firstName: "John", .lastName: "Doe"])
        var result: Result<Void, Error>?

        // When
        sut.signUp(data: data) { res in
            result = res
        }

        try await Task.sleep(nanoseconds: 700_000_000)

        // Then
        guard case .success = result else {
            Issue.record("Expected success for non-empty sign up data")
            return
        }
    }

    @Test("signUp with empty fields fails")
    func signUp_emptyFields_fails() {
        // Given
        let sut = AuthService()
        let data = SignUpData(fields: [:])
        var result: Result<Void, Error>?

        // When
        sut.signUp(data: data) { res in
            result = res
        }

        // Then - should fail immediately
        guard case .failure(let error) = result else {
            Issue.record("Expected failure for empty sign up data")
            return
        }
        #expect(error is AuthError)
    }

    @Test("signUp with single field succeeds")
    @MainActor
    func signUp_singleField_succeeds() async throws {
        // Given
        let sut = AuthService()
        let data = SignUpData(fields: [.email: "test@example.com"])
        var result: Result<Void, Error>?

        // When
        sut.signUp(data: data) { res in
            result = res
        }

        try await Task.sleep(nanoseconds: 700_000_000)

        // Then
        guard case .success = result else {
            Issue.record("Expected success for single field sign up")
            return
        }
    }
}
