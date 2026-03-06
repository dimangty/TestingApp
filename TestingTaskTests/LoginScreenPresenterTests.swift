import Foundation
import Testing
@testable import TestingTask

@Suite("Login Presenter Tests")
struct LoginScreenPresenterTests {
    @Test("View load configures screen and disables confirm for empty phone")
    func viewLoadedConfiguresAndDisablesConfirm() {
        // Given
        // Prepare presenter with isolated mock view/router collaborators.
        let view = LoginScreenViewInputMockableMock()
        let router = LoginScreenRouterInputMockableMock()
        let sut = LoginScreenPresenter(view: view, router: router)
        var lastConfirmEnabled: Bool?
        Perform(view, .updateConfirmButton(enabled: .any, perform: { lastConfirmEnabled = $0 }))

        // When
        // Trigger lifecycle callback that initializes screen state.
        sut.viewLoaded()

        // Then
        // The screen starts in disabled confirmation mode for empty phone input.
        Verify(view, .once, .setup())
        Verify(view, .once, .updateConfirmButton(enabled: .value(false)))
        #expect(lastConfirmEnabled == false)
    }

    @Test("Phone changes update confirm button state")
    func phoneChangedUpdatesConfirmButtonState() {
        // Given
        // Capture all button state updates emitted by presenter.
        let view = LoginScreenViewInputMockableMock()
        let router = LoginScreenRouterInputMockableMock()
        let sut = LoginScreenPresenter(view: view, router: router)
        var states: [Bool] = []
        Perform(view, .updateConfirmButton(enabled: .any, perform: { states.append($0) }))

        // When
        // Send invalid and then valid phone values.
        sut.phoneChanged("123")
        sut.phoneChanged("1234567")

        // Then
        // Presenter should transition button from disabled to enabled.
        Verify(view, .once, .updateConfirmButton(enabled: .value(false)))
        Verify(view, .once, .updateConfirmButton(enabled: .value(true)))
        #expect(states == [false, true])
    }

    @Test("Invalid phone does not trigger auth or navigation")
    func confirmTappedWithInvalidPhoneDoesNotNavigate() {
        // Given
        // Keep auth mocked to verify no side effects happen on invalid input.
        let view = LoginScreenViewInputMockableMock()
        let router = LoginScreenRouterInputMockableMock()
        let auth = AuthServiceProtocolMockableMock()
        let sut = LoginScreenPresenter(view: view, router: router)
        sut.authService = auth

        // When
        // Attempt login with invalid phone length.
        sut.phoneChanged("123")
        sut.confirmTapped()

        // Then
        // No network call and no navigation should be performed.
        Verify(auth, .never, .login(phone: .any, completion: .any))
        Verify(router, .never, .openMainScreen())
        Verify(router, .never, .openSignUpScreen())
    }

    @Test("Valid phone with successful auth opens main")
    func confirmTappedSuccessOpensMain() {
        // Given
        // Stub auth success path and observe progress/error side effects.
        let view = LoginScreenViewInputMockableMock()
        let router = LoginScreenRouterInputMockableMock()
        let auth = AuthServiceProtocolMockableMock()
        let progress = ProgressServiceSpy()
        let error = ErrorServiceSpy()
        let sut = LoginScreenPresenter(view: view, router: router)
        sut.authService = auth
        sut.progressService = progress
        sut.errorService = error
        Perform(auth, .login(phone: .any, completion: .any, perform: { _, completion in
            completion(.success(()))
        }))

        // When
        // Submit valid phone and execute confirmation action.
        sut.phoneChanged("1234567")
        sut.confirmTapped()

        // Then
        // Presenter should run happy-path flow: auth -> hide loader -> route to main.
        Verify(auth, .once, .login(phone: .value("1234567"), completion: .any))
        #expect(progress.showCallCount == 1)
        #expect(progress.hideCallCount == 1)
        Verify(router, .once, .openMainScreen())
        #expect(error.showErrorCallCount == 0)
    }

    @Test("Auth failure shows user-facing error")
    func confirmTappedFailureShowsError() {
        // Given
        // Stub auth failure to validate user-facing error handling.
        let view = LoginScreenViewInputMockableMock()
        let router = LoginScreenRouterInputMockableMock()
        let auth = AuthServiceProtocolMockableMock()
        let progress = ProgressServiceSpy()
        let error = ErrorServiceSpy()
        let sut = LoginScreenPresenter(view: view, router: router)
        sut.authService = auth
        sut.progressService = progress
        sut.errorService = error
        Perform(auth, .login(phone: .any, completion: .any, perform: { _, completion in
            completion(.failure(AuthError.invalidPhone))
        }))

        // When
        // Execute confirmation flow for a valid phone.
        sut.phoneChanged("1234567")
        sut.confirmTapped()

        // Then
        // Presenter should not navigate and must display mapped error text.
        Verify(auth, .once, .login(phone: .value("1234567"), completion: .any))
        #expect(progress.showCallCount == 1)
        #expect(progress.hideCallCount == 1)
        Verify(router, .never, .openMainScreen())
        #expect(error.showErrorCallCount == 1)
        #expect(error.lastErrorText == "Invalid phone number")
    }

    @Test("Sign up action routes to sign-up screen")
    func signUpTappedOpensSignUpScreen() {
        // Given
        // Router mock is used to verify navigation-only interaction.
        let view = LoginScreenViewInputMockableMock()
        let router = LoginScreenRouterInputMockableMock()
        let sut = LoginScreenPresenter(view: view, router: router)

        // When
        // User taps secondary sign-up action.
        sut.signUpTapped()

        // Then
        // Presenter should open sign-up flow and avoid main route.
        Verify(router, .once, .openSignUpScreen())
        Verify(router, .never, .openMainScreen())
    }
}

private final class ProgressServiceSpy: ProgressService {
    private(set) var showCallCount = 0
    private(set) var hideCallCount = 0

    override func show() {
        showCallCount += 1
    }

    override func hide() {
        hideCallCount += 1
    }
}

private final class ErrorServiceSpy: ErrorService {
    private(set) var showErrorCallCount = 0
    private(set) var lastErrorText: String?

    override func show(errorText: String) {
        showErrorCallCount += 1
        lastErrorText = errorText
    }
}
