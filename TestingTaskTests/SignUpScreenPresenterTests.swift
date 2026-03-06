//
//  SignUpScreenPresenterTests.swift
//  TestingTaskTests
//
//  Unit tests for SignUpScreenPresenter with Given/When/Then pattern
//  Testing presenter business logic with mocked dependencies
//

import Testing
import Foundation
@testable import TestingTask

@Suite("SignUpScreenPresenter Tests")
struct SignUpScreenPresenterTests {

    // MARK: - Test: View Setup on Load
    @Test("Should setup view and disable create button when view loads")
    func testViewSetupOnLoad() {
        // Given: A presenter with mocked view and router
        let mockView = MockSignUpScreenView()
        let mockRouter = MockSignUpScreenRouter()
        let sut = SignUpScreenPresenter(view: mockView, router: mockRouter)

        // When: View loads
        sut.viewLoaded()

        // Then: Should call setup and disable create button (no fields filled)
        #expect(mockView.setupCallCount == 1)
        #expect(mockView.updateCreateButtonCallCount == 1)
        #expect(mockView.updateCreateButtonReceivedEnabled == false)
    }

    // MARK: - Test: Single Field Change - Invalid Form
    @Test("Should keep create button disabled when only one field is filled")
    func testSingleFieldChangeKeepsButtonDisabled() {
        // Given: A presenter with mocked dependencies
        let mockView = MockSignUpScreenView()
        let mockRouter = MockSignUpScreenRouter()
        let mockValidation = MockValidationService()

        let sut = SignUpScreenPresenter(view: mockView, router: mockRouter)
        sut.validationService = mockValidation

        mockValidation.isValidFieldValueClosure = { field, value in
            // Only firstName is valid
            return field == .firstName && !value.isEmpty
        }

        sut.viewLoaded()
        mockView.reset()

        // When: User fills only first name
        sut.fieldChanged(.firstName, value: "John")

        // Then: Create button should remain disabled (not all fields valid)
        #expect(mockView.updateCreateButtonCallCount == 1)
        #expect(mockView.updateCreateButtonReceivedEnabled == false)
    }

    // MARK: - Test: All Fields Valid - Enable Button
    @Test("Should enable create button when all fields are valid")
    func testEnableCreateButtonWhenAllFieldsValid() {
        // Given: A presenter with mocked dependencies
        let mockView = MockSignUpScreenView()
        let mockRouter = MockSignUpScreenRouter()
        let mockValidation = MockValidationService()

        let sut = SignUpScreenPresenter(view: mockView, router: mockRouter)
        sut.validationService = mockValidation

        // All fields return valid
        mockValidation.isValidFieldValueReturnValue = true

        sut.viewLoaded()
        mockView.reset()

        // When: User fills all required fields
        for field in SignUpField.allCases {
            sut.fieldChanged(field, value: "Valid Value")
        }

        // Then: Create button should be enabled
        #expect(mockView.updateCreateButtonReceivedEnabled == true)
    }

    // MARK: - Test: All Fields Then One Invalid - Disable Button
    @Test("Should disable create button when one field becomes invalid")
    func testDisableCreateButtonWhenOneFieldBecomesInvalid() {
        // Given: A presenter with all fields initially valid
        let mockView = MockSignUpScreenView()
        let mockRouter = MockSignUpScreenRouter()
        let mockValidation = MockValidationService()

        let sut = SignUpScreenPresenter(view: mockView, router: mockRouter)
        sut.validationService = mockValidation

        mockValidation.isValidFieldValueClosure = { field, value in
            return !value.isEmpty
        }

        // Fill all fields with valid values
        for field in SignUpField.allCases {
            sut.fieldChanged(field, value: "Valid")
        }

        mockView.reset()

        // When: User clears the email field
        sut.fieldChanged(.email, value: "")

        // Then: Create button should be disabled
        #expect(mockView.updateCreateButtonCallCount == 1)
        #expect(mockView.updateCreateButtonReceivedEnabled == false)
    }

    // MARK: - Test: Validation Service Called for Each Field
    @Test("Should call validation service for all fields on change")
    func testValidationServiceCalledForAllFields() {
        // Given: A presenter with mocked validation
        let mockView = MockSignUpScreenView()
        let mockRouter = MockSignUpScreenRouter()
        let mockValidation = MockValidationService()

        let sut = SignUpScreenPresenter(view: mockView, router: mockRouter)
        sut.validationService = mockValidation

        mockValidation.isValidFieldValueReturnValue = true

        sut.viewLoaded()
        mockValidation.reset()

        // When: User changes one field
        sut.fieldChanged(.firstName, value: "John")

        // Then: Validation should be called for all 8 fields
        #expect(mockValidation.isValidFieldValueCallCount == 8)
    }

    // MARK: - Test: Successful Sign Up Flow
    @Test("Should show progress, call auth service, and navigate on successful sign up")
    func testSuccessfulSignUpFlow() async {
        // Given: A presenter with all mocked dependencies and valid fields
        let mockView = MockSignUpScreenView()
        let mockRouter = MockSignUpScreenRouter()
        let mockAuth = MockAuthService()
        let mockValidation = MockValidationService()
        let mockProgress = MockProgressService()

        let sut = SignUpScreenPresenter(view: mockView, router: mockRouter)
        sut.authService = mockAuth
        sut.validationService = mockValidation
        sut.progressService = mockProgress

        // All fields valid
        mockValidation.isValidFieldValueReturnValue = true

        // Fill all fields
        for field in SignUpField.allCases {
            sut.fieldChanged(field, value: "Valid Value")
        }

        mockAuth.signUpDataCompletionClosure = { data, completion in
            completion(.success(()))
        }

        // When: User taps create account
        sut.createAccountTapped()

        // Wait for async completion
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then: Should show progress, call auth, hide progress, and navigate
        #expect(mockProgress.showCallCount == 1)
        #expect(mockAuth.signUpDataCompletionCallCount == 1)
        #expect(mockProgress.hideCallCount == 1)
        #expect(mockRouter.openMainScreenCallCount == 1)
    }

    // MARK: - Test: Failed Sign Up Flow
    @Test("Should show error on failed sign up")
    func testFailedSignUpFlow() async {
        // Given: A presenter with mocked dependencies and valid fields
        let mockView = MockSignUpScreenView()
        let mockRouter = MockSignUpScreenRouter()
        let mockAuth = MockAuthService()
        let mockValidation = MockValidationService()
        let mockProgress = MockProgressService()
        let mockError = MockErrorService()

        let sut = SignUpScreenPresenter(view: mockView, router: mockRouter)
        sut.authService = mockAuth
        sut.validationService = mockValidation
        sut.progressService = mockProgress
        sut.errorService = mockError

        mockValidation.isValidFieldValueReturnValue = true

        // Fill all fields
        for field in SignUpField.allCases {
            sut.fieldChanged(field, value: "Valid Value")
        }

        mockAuth.signUpDataCompletionClosure = { data, completion in
            completion(.failure(AuthError.invalidData))
        }

        // When: User taps create account with failing auth
        sut.createAccountTapped()

        // Wait for async completion
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then: Should show/hide progress, call auth, show error, not navigate
        #expect(mockProgress.showCallCount == 1)
        #expect(mockAuth.signUpDataCompletionCallCount == 1)
        #expect(mockProgress.hideCallCount == 1)
        #expect(mockError.showErrorTextCallCount == 1)
        #expect(mockError.showErrorTextReceivedText == "Sign up failed")
        #expect(mockRouter.openMainScreenCallCount == 0)
    }

    // MARK: - Test: Back Navigation
    @Test("Should close screen when back is tapped")
    func testBackNavigation() {
        // Given: A presenter with mocked router
        let mockView = MockSignUpScreenView()
        let mockRouter = MockSignUpScreenRouter()
        let sut = SignUpScreenPresenter(view: mockView, router: mockRouter)

        // When: User taps back button
        sut.backTapped()

        // Then: Should close the screen
        #expect(mockRouter.closeCallCount == 1)
        #expect(mockRouter.openMainScreenCallCount == 0)
    }

    // MARK: - Test: SignUpData Contains All Fields
    @Test("Should pass all filled fields to auth service")
    func testSignUpDataContainsAllFields() async {
        // Given: A presenter with mocked auth
        let mockView = MockSignUpScreenView()
        let mockRouter = MockSignUpScreenRouter()
        let mockAuth = MockAuthService()
        let mockValidation = MockValidationService()

        let sut = SignUpScreenPresenter(view: mockView, router: mockRouter)
        sut.authService = mockAuth
        sut.validationService = mockValidation

        mockValidation.isValidFieldValueReturnValue = true

        var receivedData: SignUpData?
        mockAuth.signUpDataCompletionClosure = { data, completion in
            receivedData = data
            completion(.success(()))
        }

        // When: User fills specific values for each field
        let testValues: [SignUpField: String] = [
            .firstName: "John",
            .lastName: "Doe",
            .email: "john@example.com",
            .phone: "1234567890",
            .gender: "Male",
            .birthDate: "1990-01-01",
            .country: "USA",
            .city: "New York"
        ]

        for (field, value) in testValues {
            sut.fieldChanged(field, value: value)
        }

        sut.createAccountTapped()

        // Wait for async completion
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then: SignUpData should contain all field values
        #expect(receivedData != nil)
        #expect(receivedData?.fields.count == 8)
        #expect(receivedData?.fields[.firstName] == "John")
        #expect(receivedData?.fields[.lastName] == "Doe")
        #expect(receivedData?.fields[.email] == "john@example.com")
    }

    // MARK: - Test: Progressive Field Validation
    @Test("Should validate progressively as fields are filled")
    func testProgressiveFieldValidation() {
        // Given: A presenter with mocked validation
        let mockView = MockSignUpScreenView()
        let mockRouter = MockSignUpScreenRouter()
        let mockValidation = MockValidationService()

        let sut = SignUpScreenPresenter(view: mockView, router: mockRouter)
        sut.validationService = mockValidation

        var filledFields = Set<SignUpField>()

        mockValidation.isValidFieldValueClosure = { field, value in
            return filledFields.contains(field)
        }

        sut.viewLoaded()
        mockView.reset()

        // When: User fills fields one by one
        let states = SignUpField.allCases.map { field -> Bool in
            filledFields.insert(field)
            sut.fieldChanged(field, value: "Valid")
            return mockView.updateCreateButtonReceivedEnabled ?? false
        }

        // Then: Button should only be enabled after last field
        #expect(states.dropLast().allSatisfy { $0 == false })
        #expect(states.last == true)
    }

    // MARK: - Test: Empty Field After Valid Entry
    @Test("Should disable button when field is emptied after valid entry")
    func testEmptyFieldAfterValidEntry() {
        // Given: A presenter with all fields initially valid
        let mockView = MockSignUpScreenView()
        let mockRouter = MockSignUpScreenRouter()
        let mockValidation = MockValidationService()

        let sut = SignUpScreenPresenter(view: mockView, router: mockRouter)
        sut.validationService = mockValidation

        var fieldValues: [SignUpField: String] = [:]

        mockValidation.isValidFieldValueClosure = { field, value in
            let storedValue = fieldValues[field] ?? ""
            return !storedValue.isEmpty
        }

        // Fill all fields
        for field in SignUpField.allCases {
            fieldValues[field] = "Valid"
            sut.fieldChanged(field, value: "Valid")
        }

        mockView.reset()

        // When: User empties the phone field
        fieldValues[.phone] = ""
        sut.fieldChanged(.phone, value: "")

        // Then: Button should be disabled
        #expect(mockView.updateCreateButtonReceivedEnabled == false)
    }

    // MARK: - Test: Update Button State Multiple Times
    @Test("Should update button state correctly on multiple field changes")
    func testMultipleFieldChangesButtonState() {
        // Given: A presenter with mocked validation
        let mockView = MockSignUpScreenView()
        let mockRouter = MockSignUpScreenRouter()
        let mockValidation = MockValidationService()

        let sut = SignUpScreenPresenter(view: mockView, router: mockRouter)
        sut.validationService = mockValidation

        sut.viewLoaded()
        mockView.reset()

        // When: User makes multiple changes
        mockValidation.isValidFieldValueReturnValue = false
        sut.fieldChanged(.firstName, value: "")

        mockValidation.isValidFieldValueReturnValue = false
        sut.fieldChanged(.lastName, value: "")

        mockValidation.isValidFieldValueReturnValue = true
        sut.fieldChanged(.email, value: "valid@email.com")

        // Then: Should have updated button state for each change
        #expect(mockView.updateCreateButtonCallCount >= 3)
    }
}
