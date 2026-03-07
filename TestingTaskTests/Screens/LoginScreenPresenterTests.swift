//
//  LoginScreenPresenterTests.swift
//  TestingTaskTests
//
//  Unit tests for LoginScreenPresenter
//  Following Mobile Testing Guidelines v3 - Given/When/Then pattern
//
//  Tests cover:
//  - View lifecycle events (viewLoaded)
//  - Phone number validation (state and branching)
//  - Login success and failure scenarios
//  - Confirm button state management
//  - Navigation routing
//

import Foundation
import Testing
import SwiftyMocky
@testable import TestingTask

@Suite("Login Presenter Tests")
struct LoginScreenPresenterTests {

    @Test("View load configures screen and disables confirm for empty phone")
    func viewLoadedConfiguresAndDisablesConfirm() {
        // Given: Presenter with mocked dependencies and empty phone
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: mockView, router: mockRouter)
        var lastConfirmEnabled: Bool?
        Perform(mockView, .updateConfirmButton(enabled: .any, perform: { lastConfirmEnabled = $0 }))

        // When: View is loaded
        presenter.viewLoaded()

        // Then: View setup is called and confirm button is disabled (empty phone)
        Verify(mockView, .once, .setup())
        Verify(mockView, .once, .updateConfirmButton(enabled: .value(false)))
        #expect(lastConfirmEnabled == false)
    }

    @Test("Phone changes update confirm button state")
    func phoneChangedUpdatesConfirmButtonState() {
        // Given: Presenter with mocked dependencies and state capture
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: mockView, router: mockRouter)
        var states: [Bool] = []
        Perform(mockView, .updateConfirmButton(enabled: .any, perform: { states.append($0) }))

        // When: Send invalid and then valid phone values
        presenter.phoneChanged("123")
        presenter.phoneChanged("1234567")

        // Then: Presenter should transition button from disabled to enabled
        Verify(mockView, .once, .updateConfirmButton(enabled: .value(false)))
        Verify(mockView, .once, .updateConfirmButton(enabled: .value(true)))
        #expect(states == [false, true])
    }

    @Test("Phone too long disables confirm button")
    func phoneTooLongDisablesConfirm() {
        // Given: Presenter with mocked dependencies
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: mockView, router: mockRouter)
        var lastConfirmEnabled: Bool?
        Perform(mockView, .updateConfirmButton(enabled: .any, perform: { lastConfirmEnabled = $0 }))

        // When: Phone with 16 digits is entered
        presenter.phoneChanged("1234567890123456")

        // Then: Confirm button is disabled
        Verify(mockView, .once, .updateConfirmButton(enabled: .value(false)))
        #expect(lastConfirmEnabled == false)
    }

    @Test("Invalid phone does not trigger auth or navigation")
    func confirmTappedWithInvalidPhoneDoesNotNavigate() {
        // Given: Presenter with mocked dependencies and invalid phone
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let mockAuthService = AuthServiceProtocolMock()
        let presenter = LoginScreenPresenter(view: mockView, router: mockRouter)
        presenter.authService = mockAuthService

        // When: Attempt login with invalid phone length
        presenter.phoneChanged("123")
        presenter.confirmTapped()

        // Then: No network call and no navigation should be performed
        Verify(mockAuthService, .never, .login(phone: .any, completion: .any))
        Verify(mockRouter, .never, .openMainScreen())
        Verify(mockRouter, .never, .openSignUpScreen())
    }

    @Test("Valid phone with successful auth opens main")
    func confirmTappedSuccessOpensMain() {
        // Given: Stub auth success path and observe progress/error side effects
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let mockAuthService = AuthServiceProtocolMock()
        let progressSpy = ProgressServiceSpy()
        let errorSpy = ErrorServiceSpy()
        let presenter = LoginScreenPresenter(view: mockView, router: mockRouter)
        presenter.authService = mockAuthService
        presenter.progressService = progressSpy
        presenter.errorService = errorSpy
        Perform(mockAuthService, .login(phone: .any, completion: .any, perform: { _, completion in
            completion(.success(()))
        }))

        // When: Submit valid phone and execute confirmation action
        presenter.phoneChanged("1234567")
        presenter.confirmTapped()

        // Then: Presenter should run happy-path flow: auth -> hide loader -> route to main
        Verify(mockAuthService, .once, .login(phone: .value("1234567"), completion: .any))
        #expect(progressSpy.showCallCount == 1)
        #expect(progressSpy.hideCallCount == 1)
        Verify(mockRouter, .once, .openMainScreen())
        #expect(errorSpy.showErrorCallCount == 0)
    }

    @Test("Auth failure shows user-facing error")
    func confirmTappedFailureShowsError() {
        // Given: Stub auth failure to validate user-facing error handling
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let mockAuthService = AuthServiceProtocolMock()
        let progressSpy = ProgressServiceSpy()
        let errorSpy = ErrorServiceSpy()
        let presenter = LoginScreenPresenter(view: mockView, router: mockRouter)
        presenter.authService = mockAuthService
        presenter.progressService = progressSpy
        presenter.errorService = errorSpy
        let testError = NSError(domain: "TestError", code: 401, userInfo: nil)
        Perform(mockAuthService, .login(phone: .any, completion: .any, perform: { _, completion in
            completion(.failure(testError))
        }))

        // When: Execute confirmation flow for a valid phone
        presenter.phoneChanged("1234567")
        presenter.confirmTapped()

        // Then: Presenter should not navigate and must display mapped error text
        Verify(mockAuthService, .once, .login(phone: .value("1234567"), completion: .any))
        #expect(progressSpy.showCallCount == 1)
        #expect(progressSpy.hideCallCount == 1)
        Verify(mockRouter, .never, .openMainScreen())
        #expect(errorSpy.showErrorCallCount == 1)
        #expect(errorSpy.lastErrorText == "Invalid phone number")
    }

    @Test("Sign up action routes to sign-up screen")
    func signUpTappedOpensSignUpScreen() {
        // Given: Router mock is used to verify navigation-only interaction
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: mockView, router: mockRouter)

        // When: User taps secondary sign-up action
        presenter.signUpTapped()

        // Then: Presenter should open sign-up flow and avoid main route
        Verify(mockRouter, .once, .openSignUpScreen())
        Verify(mockRouter, .never, .openMainScreen())
    }

    @Test("Phone with exactly 7 digits enables confirm button")
    func phoneWithMinimumLengthEnablesConfirm() {
        // Given: Presenter with mocked dependencies
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: mockView, router: mockRouter)
        var lastConfirmEnabled: Bool?
        Perform(mockView, .updateConfirmButton(enabled: .any, perform: { lastConfirmEnabled = $0 }))

        // When: Phone with exactly 7 digits (minimum valid) is entered
        presenter.phoneChanged("1234567")

        // Then: Confirm button is enabled
        Verify(mockView, .once, .updateConfirmButton(enabled: .value(true)))
        #expect(lastConfirmEnabled == true)
    }

    @Test("Phone with exactly 15 digits enables confirm button")
    func phoneWithMaximumLengthEnablesConfirm() {
        // Given: Presenter with mocked dependencies
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: mockView, router: mockRouter)
        var lastConfirmEnabled: Bool?
        Perform(mockView, .updateConfirmButton(enabled: .any, perform: { lastConfirmEnabled = $0 }))

        // When: Phone with exactly 15 digits (maximum valid) is entered
        presenter.phoneChanged("123456789012345")

        // Then: Confirm button is enabled
        Verify(mockView, .once, .updateConfirmButton(enabled: .value(true)))
        #expect(lastConfirmEnabled == true)
    }

    @Test("Phone with 6 digits disables confirm button")
    func phoneJustBelowMinimumDisablesConfirm() {
        // Given: Presenter with mocked dependencies
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: mockView, router: mockRouter)
        var lastConfirmEnabled: Bool?
        Perform(mockView, .updateConfirmButton(enabled: .any, perform: { lastConfirmEnabled = $0 }))

        // When: Phone with 6 digits (just below minimum) is entered
        presenter.phoneChanged("123456")

        // Then: Confirm button is disabled
        Verify(mockView, .once, .updateConfirmButton(enabled: .value(false)))
        #expect(lastConfirmEnabled == false)
    }

    @Test("Rapid phone changes update button state correctly")
    func rapidPhoneChangesUpdateButtonState() {
        // Given: Presenter with mocked dependencies
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: mockView, router: mockRouter)
        var states: [Bool] = []
        Perform(mockView, .updateConfirmButton(enabled: .any, perform: { states.append($0) }))

        // When: Multiple rapid phone changes occur
        presenter.phoneChanged("12")      // Invalid
        presenter.phoneChanged("123456")  // Invalid
        presenter.phoneChanged("1234567") // Valid
        presenter.phoneChanged("123456789012345") // Valid
        presenter.phoneChanged("1234567890123456") // Invalid (too long)

        // Then: Button state changes reflect validity at each step
        #expect(states.count == 5)
        #expect(states[0] == false) // 2 digits
        #expect(states[1] == false) // 6 digits
        #expect(states[2] == true)  // 7 digits (valid)
        #expect(states[3] == true)  // 15 digits (valid)
        #expect(states[4] == false) // 16 digits
    }

    @Test("Multiple confirm taps with invalid phone do not trigger auth")
    func multipleConfirmTapsInvalidPhoneNoAuth() {
        // Given: Presenter with invalid phone
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let mockAuthService = AuthServiceProtocolMock()
        let presenter = LoginScreenPresenter(view: mockView, router: mockRouter)
        presenter.authService = mockAuthService
        presenter.phoneChanged("12345") // Invalid

        // When: Confirm is tapped multiple times
        presenter.confirmTapped()
        presenter.confirmTapped()
        presenter.confirmTapped()

        // Then: Auth service is never called
        Verify(mockAuthService, .never, .login(phone: .any, completion: .any))
    }

    @Test("Empty phone keeps confirm button disabled")
    func emptyPhoneKeepsConfirmDisabled() {
        // Given: Presenter with initially valid phone
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: mockView, router: mockRouter)
        var lastConfirmEnabled: Bool?
        Perform(mockView, .updateConfirmButton(enabled: .any, perform: { lastConfirmEnabled = $0 }))

        presenter.phoneChanged("1234567") // Valid phone
        mockView.resetMock()

        // When: Phone is changed to empty string
        presenter.phoneChanged("")

        // Then: Confirm button is disabled
        Verify(mockView, .once, .updateConfirmButton(enabled: .value(false)))
        #expect(lastConfirmEnabled == false)
    }

    @Test("Valid phone to invalid phone transition disables button")
    func validToInvalidPhoneTransitionDisablesButton() {
        // Given: Presenter with valid phone
        let mockView = LoginScreenViewInputMock()
        let mockRouter = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: mockView, router: mockRouter)
        var states: [Bool] = []
        Perform(mockView, .updateConfirmButton(enabled: .any, perform: { states.append($0) }))

        // When: Phone changes from valid to invalid
        presenter.phoneChanged("1234567890") // Valid
        presenter.phoneChanged("12")         // Invalid

        // Then: Button state transitions from enabled to disabled
        #expect(states == [true, false])
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
