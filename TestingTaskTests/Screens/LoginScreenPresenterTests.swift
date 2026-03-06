import Testing
import Foundation
import SwiftyMocky
@testable import TestingTask

@Suite("LoginScreenPresenter Tests")
struct LoginScreenPresenterTests {

    // MARK: - View Loaded

    @Test("viewLoaded calls setup on view")
    func viewLoaded_callsSetup() {
        // Given
        let view = LoginScreenViewInputMock()
        let router = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: view, router: router)

        // When
        presenter.viewLoaded()

        // Then
        view.verify(.setup(), count: .exactly(1))
    }

    @Test("viewLoaded updates confirm button to disabled state initially")
    func viewLoaded_updatesConfirmButton_disabled() {
        // Given
        let view = LoginScreenViewInputMock()
        let router = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: view, router: router)

        // When
        presenter.viewLoaded()

        // Then
        view.verify(.updateConfirmButton(enabled: .value(false)), count: .exactly(1))
    }

    // MARK: - Phone Validation

    @Test("phoneChanged with short phone keeps button disabled")
    func phoneChanged_shortPhone_buttonDisabled() {
        // Given
        let view = LoginScreenViewInputMock()
        let router = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: view, router: router)

        // When
        presenter.phoneChanged("123456") // 6 digits - too short

        // Then
        view.verify(.updateConfirmButton(enabled: .value(false)), count: .exactly(1))
    }

    @Test("phoneChanged with valid phone enables button")
    func phoneChanged_validPhone_buttonEnabled() {
        // Given
        let view = LoginScreenViewInputMock()
        let router = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: view, router: router)

        // When
        presenter.phoneChanged("1234567") // 7 digits - valid minimum

        // Then
        view.verify(.updateConfirmButton(enabled: .value(true)), count: .exactly(1))
    }

    @Test("phoneChanged with max length phone enables button")
    func phoneChanged_maxLengthPhone_buttonEnabled() {
        // Given
        let view = LoginScreenViewInputMock()
        let router = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: view, router: router)

        // When
        presenter.phoneChanged("123456789012345") // 15 digits - valid maximum

        // Then
        view.verify(.updateConfirmButton(enabled: .value(true)), count: .exactly(1))
    }

    @Test("phoneChanged with too long phone disables button")
    func phoneChanged_tooLongPhone_buttonDisabled() {
        // Given
        let view = LoginScreenViewInputMock()
        let router = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: view, router: router)

        // When
        presenter.phoneChanged("1234567890123456") // 16 digits - too long

        // Then
        view.verify(.updateConfirmButton(enabled: .value(false)), count: .exactly(1))
    }

    @Test("phoneChanged updates button state on each change")
    func phoneChanged_multipleChanges_updatesButtonEachTime() {
        // Given
        let view = LoginScreenViewInputMock()
        let router = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: view, router: router)

        // When
        presenter.phoneChanged("123")
        presenter.phoneChanged("1234567")
        presenter.phoneChanged("12")

        // Then
        view.verify(.updateConfirmButton(enabled: .any), count: .exactly(3))
    }

    // MARK: - Confirm Tapped

    @Test("confirmTapped with invalid phone does not call auth service")
    func confirmTapped_invalidPhone_noAuthServiceCall() {
        // Given
        let view = LoginScreenViewInputMock()
        let router = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: view, router: router)
        let authService = AuthServiceProtocolMock()
        presenter.authService = authService

        // When
        presenter.phoneChanged("123") // Invalid phone
        presenter.confirmTapped()

        // Then
        authService.verify(.login(phone: .any, completion: .any), count: .exactly(0))
    }

    @Test("confirmTapped with invalid phone does not navigate")
    func confirmTapped_invalidPhone_noNavigation() {
        // Given
        let view = LoginScreenViewInputMock()
        let router = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: view, router: router)
        let authService = AuthServiceProtocolMock()
        presenter.authService = authService

        // When
        presenter.phoneChanged("123")
        presenter.confirmTapped()

        // Then
        router.verify(.openMainScreen(), count: .exactly(0))
        router.verify(.openSignUpScreen(), count: .exactly(0))
    }

    @Test("confirmTapped with valid phone calls auth service login")
    func confirmTapped_validPhone_callsLogin() {
        // Given
        let view = LoginScreenViewInputMock()
        let router = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: view, router: router)
        let authService = AuthServiceProtocolMock()
        presenter.authService = authService

        // Stub auth service to succeed
        authService.perform(.login(phone: .any, completion: .any, perform: { phone, completion in
            completion(.success(()))
        }))

        // When
        presenter.phoneChanged("1234567")
        presenter.confirmTapped()

        // Then
        authService.verify(.login(phone: .value("1234567"), completion: .any), count: .exactly(1))
    }

    @Test("confirmTapped with valid phone shows progress")
    func confirmTapped_validPhone_showsProgress() {
        // Given
        let view = LoginScreenViewInputMock()
        let router = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: view, router: router)
        let authService = AuthServiceProtocolMock()
        let progressService = IProgressServiceMock()
        presenter.authService = authService
        presenter.progressService = progressService

        // Stub auth service to succeed
        authService.perform(.login(phone: .any, completion: .any, perform: { phone, completion in
            completion(.success(()))
        }))

        // When
        presenter.phoneChanged("1234567")
        presenter.confirmTapped()

        // Then
        progressService.verify(.show(), count: .exactly(1))
        progressService.verify(.hide(), count: .exactly(1))
    }

    @Test("confirmTapped on login success navigates to main screen")
    func confirmTapped_loginSuccess_navigatesToMain() {
        // Given
        let view = LoginScreenViewInputMock()
        let router = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: view, router: router)
        let authService = AuthServiceProtocolMock()
        presenter.authService = authService

        // Stub auth service to succeed
        authService.perform(.login(phone: .any, completion: .any, perform: { phone, completion in
            completion(.success(()))
        }))

        // When
        presenter.phoneChanged("1234567")
        presenter.confirmTapped()

        // Then
        router.verify(.openMainScreen(), count: .exactly(1))
    }

    @Test("confirmTapped on login failure shows error")
    func confirmTapped_loginFailure_showsError() {
        // Given
        let view = LoginScreenViewInputMock()
        let router = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: view, router: router)
        let authService = AuthServiceProtocolMock()
        let errorService = IErrorServiceMock()
        presenter.authService = authService
        presenter.errorService = errorService

        // Stub auth service to fail
        authService.perform(.login(phone: .any, completion: .any, perform: { phone, completion in
            completion(.failure(AuthError.invalidPhone))
        }))

        // When
        presenter.phoneChanged("1234567")
        presenter.confirmTapped()

        // Then
        router.verify(.openMainScreen(), count: .exactly(0))
        errorService.verify(.show(errorText: .value("Invalid phone number")), count: .exactly(1))
    }

    // MARK: - Sign Up Tapped

    @Test("signUpTapped navigates to sign up screen")
    func signUpTapped_navigatesToSignUp() {
        // Given
        let view = LoginScreenViewInputMock()
        let router = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: view, router: router)

        // When
        presenter.signUpTapped()

        // Then
        router.verify(.openSignUpScreen(), count: .exactly(1))
        router.verify(.openMainScreen(), count: .exactly(0))
    }

    @Test("signUpTapped can be called multiple times")
    func signUpTapped_multipleTimes_navigatesEachTime() {
        // Given
        let view = LoginScreenViewInputMock()
        let router = LoginScreenRouterInputMock()
        let presenter = LoginScreenPresenter(view: view, router: router)

        // When
        presenter.signUpTapped()
        presenter.signUpTapped()

        // Then
        router.verify(.openSignUpScreen(), count: .exactly(2))
    }
}
