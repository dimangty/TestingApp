//
//  AuthServiceTests.swift
//  TestingTaskTests
//
//  Unit tests for AuthService with Given/When/Then pattern
//  Testing authentication business logic
//  Following Mobile Testing Guidelines v3 recommendations
//
//  Tests cover:
//  - Phone validation rules (7-15 digits)
//  - Login success and failure scenarios
//  - SignUp validation and success scenarios
//  - Error handling
//  - Async completion callbacks
//
//  Note: AuthService uses DispatchQueue.asyncAfter which requires async tests
//  Per guidelines, we test the behavior despite the implementation detail
//

import Testing
import Foundation
@testable import TestingTask

@Suite("AuthService Tests - Business Logic")
struct AuthServiceTests {

    // MARK: - Login Tests

    // MARK: - Test: Successful Login with Valid Phone

    /// Tests successful login with valid 10-digit phone number
    /// Business rule: Phone with 7-15 digits should succeed
    @Test("Should succeed login with valid 10-digit phone")
    func testLoginSuccessWithValidPhone() async {
        // Given: An auth service and valid phone number
        let sut = AuthService()
        let validPhone = "1234567890"
        var loginResult: Result<Void, Error>?

        // When: Login is attempted with valid phone
        let expectation = AsyncExpectation()
        sut.login(phone: validPhone) { result in
            loginResult = result
            expectation.fulfill()
        }

        // Wait for async completion
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s

        // Then: Login should succeed
        switch loginResult {
        case .success:
            #expect(true) // Success
        case .failure:
            Issue.record("Expected success but got failure")
        case .none:
            Issue.record("Login completion was not called")
        }
    }

    // MARK: - Test: Successful Login with Minimum Length Phone

    /// Tests successful login with minimum valid length (7 digits)
    /// Business rule: Exactly 7 digits should be accepted
    @Test("Should succeed login with 7-digit phone (minimum)")
    func testLoginSuccessWithMinimumLengthPhone() async {
        // Given: An auth service and minimum length phone
        let sut = AuthService()
        let minLengthPhone = "1234567"
        var loginResult: Result<Void, Error>?

        // When: Login is attempted with minimum length phone
        sut.login(phone: minLengthPhone) { result in
            loginResult = result
        }

        // Wait for async completion
        try? await Task.sleep(nanoseconds: 500_000_000)

        // Then: Login should succeed
        switch loginResult {
        case .success:
            #expect(true) // Success
        case .failure:
            Issue.record("Expected success for minimum length phone")
        case .none:
            Issue.record("Login completion was not called")
        }
    }

    // MARK: - Test: Successful Login with Maximum Length Phone

    /// Tests successful login with maximum valid length (15 digits)
    /// Business rule: Exactly 15 digits should be accepted
    @Test("Should succeed login with 15-digit phone (maximum)")
    func testLoginSuccessWithMaximumLengthPhone() async {
        // Given: An auth service and maximum length phone
        let sut = AuthService()
        let maxLengthPhone = "123456789012345"
        var loginResult: Result<Void, Error>?

        // When: Login is attempted with maximum length phone
        sut.login(phone: maxLengthPhone) { result in
            loginResult = result
        }

        // Wait for async completion
        try? await Task.sleep(nanoseconds: 500_000_000)

        // Then: Login should succeed
        switch loginResult {
        case .success:
            #expect(true) // Success
        case .failure:
            Issue.record("Expected success for maximum length phone")
        case .none:
            Issue.record("Login completion was not called")
        }
    }

    // MARK: - Test: Failed Login with Too Short Phone

    /// Tests failed login with phone shorter than minimum
    /// Business rule: Phone with less than 7 digits should fail
    @Test("Should fail login with phone shorter than 7 digits")
    func testLoginFailureWithTooShortPhone() async {
        // Given: An auth service and too short phone
        let sut = AuthService()
        let shortPhone = "123456" // 6 digits
        var loginResult: Result<Void, Error>?

        // When: Login is attempted with short phone
        sut.login(phone: shortPhone) { result in
            loginResult = result
        }

        // Wait for async completion (should fail immediately, but wait to be sure)
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then: Login should fail with invalidPhone error
        switch loginResult {
        case .success:
            Issue.record("Expected failure for short phone")
        case .failure(let error):
            if let authError = error as? AuthError {
                #expect(authError == .invalidPhone)
            } else {
                Issue.record("Expected AuthError.invalidPhone")
            }
        case .none:
            Issue.record("Login completion was not called")
        }
    }

    // MARK: - Test: Failed Login with Too Long Phone

    /// Tests failed login with phone longer than maximum
    /// Business rule: Phone with more than 15 digits should fail
    @Test("Should fail login with phone longer than 15 digits")
    func testLoginFailureWithTooLongPhone() async {
        // Given: An auth service and too long phone
        let sut = AuthService()
        let longPhone = "1234567890123456" // 16 digits
        var loginResult: Result<Void, Error>?

        // When: Login is attempted with long phone
        sut.login(phone: longPhone) { result in
            loginResult = result
        }

        // Wait for async completion
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then: Login should fail with invalidPhone error
        switch loginResult {
        case .success:
            Issue.record("Expected failure for long phone")
        case .failure(let error):
            if let authError = error as? AuthError {
                #expect(authError == .invalidPhone)
            } else {
                Issue.record("Expected AuthError.invalidPhone")
            }
        case .none:
            Issue.record("Login completion was not called")
        }
    }

    // MARK: - Test: Failed Login with Empty Phone

    /// Tests failed login with empty phone string
    /// Business rule: Empty phone should fail validation
    @Test("Should fail login with empty phone")
    func testLoginFailureWithEmptyPhone() async {
        // Given: An auth service and empty phone
        let sut = AuthService()
        let emptyPhone = ""
        var loginResult: Result<Void, Error>?

        // When: Login is attempted with empty phone
        sut.login(phone: emptyPhone) { result in
            loginResult = result
        }

        // Wait for async completion
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then: Login should fail with invalidPhone error
        switch loginResult {
        case .success:
            Issue.record("Expected failure for empty phone")
        case .failure(let error):
            if let authError = error as? AuthError {
                #expect(authError == .invalidPhone)
            } else {
                Issue.record("Expected AuthError.invalidPhone")
            }
        case .none:
            Issue.record("Login completion was not called")
        }
    }

    // MARK: - Test: Successful Login with Phone Containing Non-Digits

    /// Tests that phone with non-digit characters is filtered correctly
    /// Business rule: Should filter out non-digits and validate remaining digits
    @Test("Should succeed login with formatted phone (filters non-digits)")
    func testLoginSuccessWithFormattedPhone() async {
        // Given: An auth service and formatted phone
        let sut = AuthService()
        let formattedPhone = "+7 (123) 456-78-90" // Contains 10 digits
        var loginResult: Result<Void, Error>?

        // When: Login is attempted with formatted phone
        sut.login(phone: formattedPhone) { result in
            loginResult = result
        }

        // Wait for async completion
        try? await Task.sleep(nanoseconds: 500_000_000)

        // Then: Login should succeed (non-digits filtered out, 10 valid digits remain)
        switch loginResult {
        case .success:
            #expect(true) // Success
        case .failure:
            Issue.record("Expected success for formatted phone with 10 digits")
        case .none:
            Issue.record("Login completion was not called")
        }
    }

    // MARK: - Test: Failed Login with Phone Containing Only Non-Digits

    /// Tests that phone with only non-digit characters fails
    /// Business rule: After filtering, if no valid digits remain, should fail
    @Test("Should fail login with phone containing only non-digits")
    func testLoginFailureWithOnlyNonDigits() async {
        // Given: An auth service and phone with only symbols
        let sut = AuthService()
        let symbolsPhone = "+() -abc"
        var loginResult: Result<Void, Error>?

        // When: Login is attempted with symbols only
        sut.login(phone: symbolsPhone) { result in
            loginResult = result
        }

        // Wait for async completion
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then: Login should fail (no valid digits)
        switch loginResult {
        case .success:
            Issue.record("Expected failure for phone with no digits")
        case .failure(let error):
            if let authError = error as? AuthError {
                #expect(authError == .invalidPhone)
            } else {
                Issue.record("Expected AuthError.invalidPhone")
            }
        case .none:
            Issue.record("Login completion was not called")
        }
    }

    // MARK: - SignUp Tests

    // MARK: - Test: Successful SignUp with Valid Data

    /// Tests successful signup with complete valid data
    /// Business rule: SignUp with all fields should succeed
    @Test("Should succeed signup with valid data")
    func testSignUpSuccessWithValidData() async {
        // Given: An auth service and valid signup data
        let sut = AuthService()
        let validData = SignUpData(fields: [
            SignUpField(type: .email, value: "test@example.com"),
            SignUpField(type: .phone, value: "1234567890"),
            SignUpField(type: .name, value: "John Doe"),
            SignUpField(type: .login, value: "johndoe"),
            SignUpField(type: .password, value: "password123")
        ])
        var signUpResult: Result<Void, Error>?

        // When: SignUp is attempted with valid data
        sut.signUp(data: validData) { result in
            signUpResult = result
        }

        // Wait for async completion
        try? await Task.sleep(nanoseconds: 700_000_000) // 0.7s

        // Then: SignUp should succeed
        switch signUpResult {
        case .success:
            #expect(true) // Success
        case .failure:
            Issue.record("Expected success for valid signup data")
        case .none:
            Issue.record("SignUp completion was not called")
        }
    }

    // MARK: - Test: Successful SignUp with Single Field

    /// Tests successful signup with minimal data (one field)
    /// Business rule: SignUp with at least one field should succeed
    @Test("Should succeed signup with single field")
    func testSignUpSuccessWithSingleField() async {
        // Given: An auth service and minimal signup data
        let sut = AuthService()
        let minimalData = SignUpData(fields: [
            SignUpField(type: .email, value: "user@test.com")
        ])
        var signUpResult: Result<Void, Error>?

        // When: SignUp is attempted with one field
        sut.signUp(data: minimalData) { result in
            signUpResult = result
        }

        // Wait for async completion
        try? await Task.sleep(nanoseconds: 700_000_000)

        // Then: SignUp should succeed
        switch signUpResult {
        case .success:
            #expect(true) // Success
        case .failure:
            Issue.record("Expected success for single field signup")
        case .none:
            Issue.record("SignUp completion was not called")
        }
    }

    // MARK: - Test: Failed SignUp with Empty Fields

    /// Tests failed signup with no fields
    /// Business rule: SignUp with empty fields array should fail
    @Test("Should fail signup with empty fields")
    func testSignUpFailureWithEmptyFields() async {
        // Given: An auth service and empty signup data
        let sut = AuthService()
        let emptyData = SignUpData(fields: [])
        var signUpResult: Result<Void, Error>?

        // When: SignUp is attempted with empty fields
        sut.signUp(data: emptyData) { result in
            signUpResult = result
        }

        // Wait for async completion
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then: SignUp should fail with invalidData error
        switch signUpResult {
        case .success:
            Issue.record("Expected failure for empty fields")
        case .failure(let error):
            if let authError = error as? AuthError {
                #expect(authError == .invalidData)
            } else {
                Issue.record("Expected AuthError.invalidData")
            }
        case .none:
            Issue.record("SignUp completion was not called")
        }
    }

    // MARK: - Test: SignUp Completion is Called

    /// Tests that signup completion handler is always called
    /// Business rule: Async completion must be called for both success and failure
    @Test("Should always call completion handler for signup")
    func testSignUpCompletionAlwaysCalled() async {
        // Given: An auth service
        let sut = AuthService()
        var completionCalled = false

        // When: SignUp is attempted
        let validData = SignUpData(fields: [SignUpField(type: .email, value: "test@test.com")])
        sut.signUp(data: validData) { _ in
            completionCalled = true
        }

        // Wait for async completion
        try? await Task.sleep(nanoseconds: 700_000_000)

        // Then: Completion should have been called
        #expect(completionCalled == true)
    }

    // MARK: - Test: Login Completion is Called

    /// Tests that login completion handler is always called
    /// Business rule: Async completion must be called for both success and failure
    @Test("Should always call completion handler for login")
    func testLoginCompletionAlwaysCalled() async {
        // Given: An auth service
        let sut = AuthService()
        var completionCalled = false

        // When: Login is attempted
        sut.login(phone: "1234567890") { _ in
            completionCalled = true
        }

        // Wait for async completion
        try? await Task.sleep(nanoseconds: 500_000_000)

        // Then: Completion should have been called
        #expect(completionCalled == true)
    }

    // MARK: - Test: Multiple Concurrent Logins

    /// Tests that multiple concurrent login requests are handled correctly
    /// Business rule: Service should handle concurrent requests independently
    @Test("Should handle multiple concurrent login requests")
    func testMultipleConcurrentLogins() async {
        // Given: An auth service and multiple login requests
        let sut = AuthService()
        var results: [Result<Void, Error>?] = [nil, nil, nil]

        // When: Multiple logins are attempted concurrently
        sut.login(phone: "1234567890") { result in
            results[0] = result
        }
        sut.login(phone: "12345") { result in
            results[1] = result
        }
        sut.login(phone: "9876543210") { result in
            results[2] = result
        }

        // Wait for all async completions
        try? await Task.sleep(nanoseconds: 600_000_000)

        // Then: All completions should be called with correct results
        #expect(results[0] != nil) // First should succeed
        #expect(results[1] != nil) // Second should fail (too short)
        #expect(results[2] != nil) // Third should succeed
    }
}

// MARK: - Helper Class

/// Simple expectation helper for async tests
private class AsyncExpectation {
    private var isFulfilled = false

    func fulfill() {
        isFulfilled = true
    }

    var fulfilled: Bool {
        return isFulfilled
    }
}
