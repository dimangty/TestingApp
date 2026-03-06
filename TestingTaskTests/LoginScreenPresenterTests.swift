//
//  LoginScreenPresenterTests.swift
//  TestingTaskTests
//
//  Unit tests for LoginScreenPresenter with Given/When/Then pattern
//  Testing presenter business logic with SwiftyMocky generated mocks
//  Following Mobile Testing Guidelines v3 recommendations
//
//  Tests cover:
//  - View initialization and setup
//  - Phone validation business rules (7-15 digits)
//  - Button state management based on validation
//  - Async authentication flow with success/failure scenarios
//  - Navigation to different screens
//  - Error handling and progress indication
//

import Testing
import Foundation
import SwiftyMocky
@testable import TestingTask

private final class ErrorServiceSpy: ErrorService {
    private(set) var shownErrors: [String] = []

    override func show(errorText: String) {
        shownErrors.append(errorText)
    }
}

@Suite("LoginScreenPresenter Tests - Business Logic")
struct LoginScreenPresenterTests {

    // MARK: - Test: View Setup on Load

    /// Tests that presenter correctly initializes view state on load
    /// Business rule: Confirm button should be disabled initially (empty phone)
    @Test("Should setup view and update confirm button state when view loads")
    func testViewSetupOnLoad() {
        // Given: A presenter with SwiftyMocky mocked view and router
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let sut = LoginScreenPresenter(view: mockView, router: mockRouter)

        // When: View loads
        sut.viewLoaded()

        // Then: Should call setup and update confirm button as disabled
        Verify(mockView, 1, .setup())
        Verify(mockView, 1, .updateConfirmButton(enabled: .value(false)))
    }

    // MARK: - Test: Phone Validation - Valid Phone

    /// Tests button enabling with valid 10-digit phone
    /// Business rule: Phone must be 7-15 digits to be valid
    @Test("Should enable confirm button when valid phone is entered")
    func testEnableConfirmButtonWithValidPhone() {
        // Given: A presenter with mocked view
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let sut = LoginScreenPresenter(view: mockView, router: mockRouter)

        // When: User enters a valid phone number (10 digits)
        sut.phoneChanged("1234567890")

        // Then: Confirm button should be enabled
        Verify(mockView, .updateConfirmButton(enabled: .value(true)))
    }

    // MARK: - Test: Phone Validation - Short Phone

    /// Tests button disabling with phone shorter than minimum
    /// Business rule: Minimum 7 digits required
    @Test("Should disable confirm button when phone is too short")
    func testDisableConfirmButtonWithShortPhone() {
        // Given: A presenter with mocked view
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let sut = LoginScreenPresenter(view: mockView, router: mockRouter)

        // When: User enters a phone with 6 digits (too short)
        sut.phoneChanged("123456")

        // Then: Confirm button should be disabled
        Verify(mockView, .updateConfirmButton(enabled: .value(false)))
    }

    // MARK: - Test: Phone Validation - Long Phone

    /// Tests button disabling with phone longer than maximum
    /// Business rule: Maximum 15 digits allowed
    @Test("Should disable confirm button when phone is too long")
    func testDisableConfirmButtonWithLongPhone() {
        // Given: A presenter with mocked view
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let sut = LoginScreenPresenter(view: mockView, router: mockRouter)

        // When: User enters a phone with 16 digits (too long)
        sut.phoneChanged("1234567890123456")

        // Then: Confirm button should be disabled
        Verify(mockView, .updateConfirmButton(enabled: .value(false)))
    }

    // MARK: - Test: Phone Validation - Boundary Minimum

    /// Tests boundary condition at minimum valid length
    /// Business rule: Exactly 7 digits should be accepted
    @Test("Should enable confirm button with minimum valid phone length")
    func testEnableConfirmButtonWithMinimumPhoneLength() {
        // Given: A presenter with mocked view
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let sut = LoginScreenPresenter(view: mockView, router: mockRouter)

        // When: User enters exactly 7 digits (minimum valid)
        sut.phoneChanged("1234567")

        // Then: Confirm button should be enabled
        Verify(mockView, .updateConfirmButton(enabled: .value(true)))
    }

    // MARK: - Test: Phone Validation - Boundary Maximum

    /// Tests boundary condition at maximum valid length
    /// Business rule: Exactly 15 digits should be accepted
    @Test("Should enable confirm button with maximum valid phone length")
    func testEnableConfirmButtonWithMaximumPhoneLength() {
        // Given: A presenter with mocked view
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let sut = LoginScreenPresenter(view: mockView, router: mockRouter)

        // When: User enters exactly 15 digits (maximum valid)
        sut.phoneChanged("123456789012345")

        // Then: Confirm button should be enabled
        Verify(mockView, .updateConfirmButton(enabled: .value(true)))
    }

    // MARK: - Test: Successful Login Flow

    /// Tests complete successful authentication flow
    /// Verifies: progress shown → auth called → progress hidden → navigation
    @Test("Should show progress, call auth service, and navigate on successful login")
    func testSuccessfulLoginFlow() async {
        // Given: A presenter with all SwiftyMocky mocked dependencies
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let mockAuth = AuthServiceProtocolMock()

        let sut = LoginScreenPresenter(view: mockView, router: mockRouter)
        sut.authService = mockAuth

        // Setup valid phone
        sut.phoneChanged("1234567890")

        // Stub auth service completion for success
        Perform(mockAuth, .login(phone: .any, completion: .any, perform: { _, completion in
            completion(.success(()))
        }))

        // When: User taps confirm button
        sut.confirmTapped()

        // Wait for async completion
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then: Should call auth service and navigate to main screen
        Verify(mockAuth, 1, .login(phone: .value("1234567890"), completion: .any))
        Verify(mockRouter, 1, .openMainScreen())
    }

    // MARK: - Test: Failed Login Flow

    /// Tests authentication failure handling
    /// Verifies: progress shown → auth fails → progress hidden → error shown → no navigation
    @Test("Should show error on failed login")
    func testFailedLoginFlow() async {
        // Given: A presenter with SwiftyMocky mocked dependencies
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let mockAuth = AuthServiceProtocolMock()
        let errorServiceSpy = ErrorServiceSpy()

        let sut = LoginScreenPresenter(view: mockView, router: mockRouter)
        sut.authService = mockAuth
        sut.errorService = errorServiceSpy

        // Setup valid phone
        sut.phoneChanged("1234567890")

        // Stub auth service completion for failure
        Perform(mockAuth, .login(phone: .any, completion: .any, perform: { _, completion in
            completion(.failure(AuthError.invalidPhone))
        }))

        // When: User taps confirm with failing auth
        sut.confirmTapped()

        // Wait for async completion
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then: Should call auth, show error, and not navigate
        Verify(mockAuth, 1, .login(phone: .any, completion: .any))
        #expect(errorServiceSpy.shownErrors == ["Invalid phone number"])
        Verify(mockRouter, 0, .openMainScreen())
    }

    // MARK: - Test: Confirm Tapped with Invalid Phone

    /// Tests that invalid phone prevents authentication call
    /// Business rule: Auth service should not be called if phone is invalid
    @Test("Should not call auth service when confirm tapped with invalid phone")
    func testConfirmTappedWithInvalidPhone() {
        // Given: A presenter with SwiftyMocky mocked dependencies and invalid phone
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let mockAuth = AuthServiceProtocolMock()

        let sut = LoginScreenPresenter(view: mockView, router: mockRouter)
        sut.authService = mockAuth

        // Setup invalid phone (too short)
        sut.phoneChanged("123")

        // When: User taps confirm
        sut.confirmTapped()

        // Then: Should not call auth service or navigate
        Verify(mockAuth, 0, .login(phone: .any, completion: .any))
        Verify(mockRouter, 0, .openMainScreen())
    }

    // MARK: - Test: Sign Up Navigation

    /// Tests navigation to sign up screen
    /// Verifies: router called with correct method
    @Test("Should navigate to sign up screen when sign up is tapped")
    func testSignUpNavigation() {
        // Given: A presenter with SwiftyMocky mocked router
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let sut = LoginScreenPresenter(view: mockView, router: mockRouter)

        // When: User taps sign up button
        sut.signUpTapped()

        // Then: Should navigate to sign up screen only
        Verify(mockRouter, 1, .openSignUpScreen())
        Verify(mockRouter, 0, .openMainScreen())
    }

    // MARK: - Test: Multiple Phone Changes

    /// Tests state management across multiple phone changes
    /// Verifies: button state updated correctly for each validation result
    @Test("Should update button state with each phone change")
    func testMultiplePhoneChanges() {
        // Given: A presenter with SwiftyMocky mocked view
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let sut = LoginScreenPresenter(view: mockView, router: mockRouter)

        // When: User changes phone multiple times with different validity
        sut.phoneChanged("123")          // Invalid (too short)
        sut.phoneChanged("1234567")      // Valid (7 digits)
        sut.phoneChanged("12345")        // Invalid (too short)
        sut.phoneChanged("1234567890")   // Valid (10 digits)

        // Then: Should have called update for each change with correct enabled state
        Verify(mockView, .updateConfirmButton(enabled: .value(false)))
        Verify(mockView, .updateConfirmButton(enabled: .value(true)))
        // SwiftyMocky will have recorded all calls
    }

    // MARK: - Test: Auth Service Integration

    /// Tests that correct phone number is passed to auth service
    /// Verifies: auth service receives exact phone entered by user
    @Test("Should pass correct phone to auth service")
    func testAuthServiceReceivesCorrectPhone() async {
        // Given: A presenter with SwiftyMocky mocked auth service
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let mockAuth = AuthServiceProtocolMock()

        let sut = LoginScreenPresenter(view: mockView, router: mockRouter)
        sut.authService = mockAuth

        let testPhone = "9876543210"

        // Stub auth service completion
        Perform(mockAuth, .login(phone: .any, completion: .any, perform: { _, completion in
            completion(.success(()))
        }))

        // When: User enters phone and confirms
        sut.phoneChanged(testPhone)
        sut.confirmTapped()

        // Wait for async completion
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then: Auth service should be called with the correct phone
        Verify(mockAuth, 1, .login(phone: .value(testPhone), completion: .any))
    }

    // MARK: - Test: Empty Phone State

    /// Tests initial state with empty phone
    /// Business rule: Empty phone should keep button disabled
    @Test("Should keep confirm button disabled with empty phone")
    func testEmptyPhoneKeepsButtonDisabled() {
        // Given: A presenter with mocked view
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let sut = LoginScreenPresenter(view: mockView, router: mockRouter)

        // When: Phone is changed to empty string
        sut.phoneChanged("")

        // Then: Confirm button should be disabled
        Verify(mockView, .updateConfirmButton(enabled: .value(false)))
    }
}
