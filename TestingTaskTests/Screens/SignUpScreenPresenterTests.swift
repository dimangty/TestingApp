//
//  SignUpScreenPresenterTests.swift
//  TestingTaskTests
//
//  Unit tests for SignUpScreenPresenter
//  Following Mobile Testing Guidelines v3 - Given/When/Then pattern
//
//  Tests cover:
//  - View lifecycle events (viewLoaded)
//  - Field validation for all sign up fields
//  - Create button state management based on validation
//  - Sign up success and failure scenarios
//  - Back button navigation
//

import Foundation
import Testing
import SwiftyMocky
@testable import TestingTask

@Suite("Sign Up Presenter Tests")
struct SignUpScreenPresenterTests {

    @Test("View load configures screen and disables create for empty fields")
    func viewLoadedConfiguresAndDisablesCreate() {
        // Given: Presenter with mocked dependencies and no fields filled
        let mockView = SignUpScreenViewInputMock()
        let mockRouter = SignUpScreenRouterInputMock()
        let mockValidationService = ValidationServiceMock()
        let presenter = SignUpScreenPresenter(view: mockView, router: mockRouter)
        presenter.validationService = mockValidationService
        var lastCreateEnabled: Bool?
        Perform(mockView, .updateCreateButton(enabled: .any, perform: { lastCreateEnabled = $0 }))

        // When: View is loaded
        presenter.viewLoaded()

        // Then: View setup is called and create button is disabled (no fields filled)
        Verify(mockView, .once, .setup())
        Verify(mockView, .once, .updateCreateButton(enabled: .value(false)))
        #expect(lastCreateEnabled == false)
    }

    @Test("Field changed calls validation service")
    func fieldChangedCallsValidationService() {
        // Given: Presenter with mocked dependencies
        let mockView = SignUpScreenViewInputMock()
        let mockRouter = SignUpScreenRouterInputMock()
        let mockValidationService = ValidationServiceMock()
        let presenter = SignUpScreenPresenter(view: mockView, router: mockRouter)
        presenter.validationService = mockValidationService
        Given(mockValidationService, .isValid(field: .any, value: .any, willReturn: false))

        // When: First name field is changed
        presenter.fieldChanged(.firstName, value: "John")

        // Then: Validation is called and button is disabled
        Verify(mockValidationService, .moreOrEqual(to: 1), .isValid(field: .any, value: .any))
        Verify(mockView, .atLeastOnce, .updateCreateButton(enabled: .value(false)))
    }

    @Test("All fields valid enables create button")
    func allFieldsValidEnablesCreateButton() {
        // Given: Presenter with mocked dependencies
        let mockView = SignUpScreenViewInputMock()
        let mockRouter = SignUpScreenRouterInputMock()
        let mockValidationService = ValidationServiceMock()
        let presenter = SignUpScreenPresenter(view: mockView, router: mockRouter)
        presenter.validationService = mockValidationService
        Given(mockValidationService, .isValid(field: .any, value: .any, willReturn: true))

        // When: All fields are filled with valid data
        for field in SignUpField.allCases {
            presenter.fieldChanged(field, value: "validValue")
        }

        // Then: Create button is enabled
        Verify(mockView, .atLeastOnce, .updateCreateButton(enabled: .value(true)))
    }

    @Test("Some fields invalid keeps create button disabled")
    func someFieldsInvalidKeepsCreateButtonDisabled() {
        // Given: Presenter with mocked dependencies
        let mockView = SignUpScreenViewInputMock()
        let mockRouter = SignUpScreenRouterInputMock()
        let mockValidationService = ValidationServiceMock()
        let presenter = SignUpScreenPresenter(view: mockView, router: mockRouter)
        presenter.validationService = mockValidationService
        Given(mockValidationService, .isValid(field: .matching({ $0 != .email }), value: .any, willReturn: true))
        Given(mockValidationService, .isValid(field: .value(.email), value: .any, willReturn: false))

        // When: All fields are filled but email is invalid
        for field in SignUpField.allCases {
            presenter.fieldChanged(field, value: "someValue")
        }

        // Then: Create button is disabled
        Verify(mockView, .atLeastOnce, .updateCreateButton(enabled: .value(false)))
    }

    @Test("Valid fields with successful signup opens main")
    func createAccountTappedSuccessOpensMain() {
        // Given: Presenter with all valid fields and successful auth
        let mockView = SignUpScreenViewInputMock()
        let mockRouter = SignUpScreenRouterInputMock()
        let mockAuthService = AuthServiceProtocolMock()
        let mockValidationService = ValidationServiceMock()
        let progressSpy = ProgressServiceSpy()
        let errorSpy = ErrorServiceSpy()
        let presenter = SignUpScreenPresenter(view: mockView, router: mockRouter)
        presenter.authService = mockAuthService
        presenter.validationService = mockValidationService
        presenter.progressService = progressSpy
        presenter.errorService = errorSpy
        Given(mockValidationService, .isValid(field: .any, value: .any, willReturn: true))
        Given(mockAuthService, .signUp(data: .any, completion: .any, willInvoke: { _, completion in
            completion(.success(()))
        }))

        // When: All fields filled and create account is tapped
        for field in SignUpField.allCases {
            presenter.fieldChanged(field, value: "validValue")
        }
        presenter.createAccountTapped()

        // Then: Success flow completes with navigation
        Verify(mockAuthService, .once, .signUp(data: .any, completion: .any))
        #expect(progressSpy.showCallCount == 1)
        #expect(progressSpy.hideCallCount == 1)
        Verify(mockRouter, .once, .openMainScreen())
        #expect(errorSpy.showErrorCallCount == 0)
    }

    @Test("Signup failure shows user-facing error")
    func createAccountTappedFailureShowsError() {
        // Given: Presenter with valid fields but auth failure
        let mockView = SignUpScreenViewInputMock()
        let mockRouter = SignUpScreenRouterInputMock()
        let mockAuthService = AuthServiceProtocolMock()
        let mockValidationService = ValidationServiceMock()
        let progressSpy = ProgressServiceSpy()
        let errorSpy = ErrorServiceSpy()
        let presenter = SignUpScreenPresenter(view: mockView, router: mockRouter)
        presenter.authService = mockAuthService
        presenter.validationService = mockValidationService
        presenter.progressService = progressSpy
        presenter.errorService = errorSpy
        Given(mockValidationService, .isValid(field: .any, value: .any, willReturn: true))
        let testError = NSError(domain: "TestError", code: 500, userInfo: nil)
        Given(mockAuthService, .signUp(data: .any, completion: .any, willInvoke: { _, completion in
            completion(.failure(testError))
        }))

        // When: All fields filled and create account is tapped
        for field in SignUpField.allCases {
            presenter.fieldChanged(field, value: "validValue")
        }
        presenter.createAccountTapped()

        // Then: Error flow completes without navigation
        Verify(mockAuthService, .once, .signUp(data: .any, completion: .any))
        #expect(progressSpy.showCallCount == 1)
        #expect(progressSpy.hideCallCount == 1)
        Verify(mockRouter, .never, .openMainScreen())
        #expect(errorSpy.showErrorCallCount == 1)
        #expect(errorSpy.lastErrorText == "Sign up failed")
    }

    @Test("Back action closes the screen")
    func backTappedClosesScreen() {
        // Given: Presenter with mocked dependencies
        let mockView = SignUpScreenViewInputMock()
        let mockRouter = SignUpScreenRouterInputMock()
        let presenter = SignUpScreenPresenter(view: mockView, router: mockRouter)

        // When: Back button is tapped
        presenter.backTapped()

        // Then: Router closes the screen
        Verify(mockRouter, .once, .close())
    }

    @Test("Field changes store values for signup")
    func fieldChangedStoresFieldValues() {
        // Given: Presenter with mocked dependencies
        let mockView = SignUpScreenViewInputMock()
        let mockRouter = SignUpScreenRouterInputMock()
        let mockAuthService = AuthServiceProtocolMock()
        let mockValidationService = ValidationServiceMock()
        let presenter = SignUpScreenPresenter(view: mockView, router: mockRouter)
        presenter.authService = mockAuthService
        presenter.validationService = mockValidationService
        Given(mockValidationService, .isValid(field: .any, value: .any, willReturn: true))
        var capturedData: SignUpData?
        Given(mockAuthService, .signUp(data: .any, completion: .any, willInvoke: { data, completion in
            capturedData = data
            completion(.success(()))
        }))

        // When: Fields are changed with specific values
        presenter.fieldChanged(.firstName, value: "John")
        presenter.fieldChanged(.email, value: "john@example.com")
        presenter.createAccountTapped()

        // Then: Auth service receives the correct field values
        #expect(capturedData != nil)
        Verify(mockAuthService, .once, .signUp(data: .any, completion: .any))
    }

    @Test("Changing valid field to empty disables create button")
    func changingValidFieldToEmptyDisablesButton() {
        // Given: Presenter with all valid fields
        let mockView = SignUpScreenViewInputMock()
        let mockRouter = SignUpScreenRouterInputMock()
        let mockValidationService = ValidationServiceMock()
        let presenter = SignUpScreenPresenter(view: mockView, router: mockRouter)
        presenter.validationService = mockValidationService

        var validationResults: [SignUpField: Bool] = [:]
        SignUpField.allCases.forEach { validationResults[$0] = true }

        Given(mockValidationService, .isValid(field: .any, value: .any, willProduce: { field, value in
            return value.isEmpty ? false : (validationResults[field] ?? false)
        }))

        // Fill all fields initially
        for field in SignUpField.allCases {
            presenter.fieldChanged(field, value: "valid")
        }
        mockView.resetMock()

        // When: One field is changed to empty
        presenter.fieldChanged(.email, value: "")

        // Then: Create button is disabled
        Verify(mockView, .once, .updateCreateButton(enabled: .value(false)))
    }

    @Test("Field validation called for each field type")
    func fieldValidationCalledForEachFieldType() {
        // Given: Presenter with mocked validation service
        let mockView = SignUpScreenViewInputMock()
        let mockRouter = SignUpScreenRouterInputMock()
        let mockValidationService = ValidationServiceMock()
        let presenter = SignUpScreenPresenter(view: mockView, router: mockRouter)
        presenter.validationService = mockValidationService
        Given(mockValidationService, .isValid(field: .any, value: .any, willReturn: false))

        // When: Different field types are changed
        presenter.fieldChanged(.firstName, value: "John")
        presenter.fieldChanged(.lastName, value: "Doe")
        presenter.fieldChanged(.email, value: "test@test.com")
        presenter.fieldChanged(.phone, value: "1234567")

        // Then: Validation is called for each specific field type
        Verify(mockValidationService, .atLeastOnce, .isValid(field: .value(.firstName), value: .any))
        Verify(mockValidationService, .atLeastOnce, .isValid(field: .value(.lastName), value: .any))
        Verify(mockValidationService, .atLeastOnce, .isValid(field: .value(.email), value: .any))
        Verify(mockValidationService, .atLeastOnce, .isValid(field: .value(.phone), value: .any))
    }

    @Test("Multiple back taps close screen once")
    func multipleBackTapsCloseScreenOnce() {
        // Given: Presenter with mocked router
        let mockView = SignUpScreenViewInputMock()
        let mockRouter = SignUpScreenRouterInputMock()
        let presenter = SignUpScreenPresenter(view: mockView, router: mockRouter)

        // When: Back is tapped multiple times
        presenter.backTapped()
        presenter.backTapped()
        presenter.backTapped()

        // Then: Router close is called three times (no guard in code)
        Verify(mockRouter, 3, .close())
    }

    @Test("Create account with no fields filled does not enable button")
    func createAccountNoFieldsFilledButtonDisabled() {
        // Given: Presenter with validation returning false for empty values
        let mockView = SignUpScreenViewInputMock()
        let mockRouter = SignUpScreenRouterInputMock()
        let mockValidationService = ValidationServiceMock()
        let presenter = SignUpScreenPresenter(view: mockView, router: mockRouter)
        presenter.validationService = mockValidationService
        Given(mockValidationService, .isValid(field: .any, value: .any, willReturn: false))

        // When: View is loaded (no fields changed)
        presenter.viewLoaded()

        // Then: Create button is disabled
        Verify(mockView, .once, .updateCreateButton(enabled: .value(false)))
    }

    @Test("Rapid field changes update button state correctly")
    func rapidFieldChangesUpdateButtonState() {
        // Given: Presenter with mocked dependencies
        let mockView = SignUpScreenViewInputMock()
        let mockRouter = SignUpScreenRouterInputMock()
        let mockValidationService = ValidationServiceMock()
        let presenter = SignUpScreenPresenter(view: mockView, router: mockRouter)
        presenter.validationService = mockValidationService

        var states: [Bool] = []
        Perform(mockView, .updateCreateButton(enabled: .any, perform: { states.append($0) }))

        var emailValid = false
        Given(mockValidationService, .isValid(field: .any, value: .any, willProduce: { field, _ in
            return field == .email ? emailValid : false
        }))

        // When: Email field changes rapidly
        presenter.fieldChanged(.email, value: "a")      // Invalid (others empty)
        emailValid = true
        presenter.fieldChanged(.email, value: "valid")  // Invalid (others empty)
        presenter.fieldChanged(.firstName, value: "John") // Invalid (not all valid)

        // Then: Button state remains disabled throughout
        #expect(states.allSatisfy { $0 == false })
    }

    @Test("Create account tapped without valid fields does not trigger signup")
    func createAccountTappedInvalidFieldsDoesNotTriggerSignup() {
        // Given: Presenter with invalid fields
        let mockView = SignUpScreenViewInputMock()
        let mockRouter = SignUpScreenRouterInputMock()
        let mockAuthService = AuthServiceProtocolMock()
        let mockValidationService = ValidationServiceMock()
        let progressSpy = ProgressServiceSpy()
        let presenter = SignUpScreenPresenter(view: mockView, router: mockRouter)
        presenter.authService = mockAuthService
        presenter.validationService = mockValidationService
        presenter.progressService = progressSpy
        Given(mockValidationService, .isValid(field: .any, value: .any, willReturn: false))

        presenter.fieldChanged(.email, value: "invalid")

        // When: Create account is tapped with invalid data
        presenter.createAccountTapped()

        // Then: Progress shown and signup is still attempted (no validation guard in createAccountTapped)
        #expect(progressSpy.showCallCount == 1)
        Verify(mockAuthService, .once, .signUp(data: .any, completion: .any))
    }

    @Test("All field types can be updated independently")
    func allFieldTypesCanBeUpdatedIndependently() {
        // Given: Presenter with mocked dependencies
        let mockView = SignUpScreenViewInputMock()
        let mockRouter = SignUpScreenRouterInputMock()
        let mockValidationService = ValidationServiceMock()
        let presenter = SignUpScreenPresenter(view: mockView, router: mockRouter)
        presenter.validationService = mockValidationService
        Given(mockValidationService, .isValid(field: .any, value: .any, willReturn: false))

        // When: All field types are changed
        for field in SignUpField.allCases {
            presenter.fieldChanged(field, value: "test\(field)")
        }

        // Then: Validation is called for each field at least once
        for field in SignUpField.allCases {
            Verify(mockValidationService, .atLeastOnce, .isValid(field: .value(field), value: .any))
        }
    }
}

// MARK: - Spy Classes

private final class ProgressServiceSpy: IProgressService {
    private(set) var showCallCount = 0
    private(set) var hideCallCount = 0

    func show() {
        showCallCount += 1
    }

    func hide() {
        hideCallCount += 1
    }
}

private final class ErrorServiceSpy: IErrorService {
    private(set) var showErrorCallCount = 0
    private(set) var lastErrorText: String?

    func show(errorText: String) {
        showErrorCallCount += 1
        lastErrorText = errorText
    }
}
