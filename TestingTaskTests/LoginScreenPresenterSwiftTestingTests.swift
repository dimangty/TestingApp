import Foundation
import Testing
import SwiftyMocky
@testable import TestingTask

@Suite("LoginScreenPresenter SwiftTesting")
struct LoginScreenPresenterSwiftTestingTests {
    @Test("viewLoaded sets up view and keeps confirm disabled by default")
    func viewLoaded_setsUpView_andDisablesConfirm() {
        // Given
        let context = makeContext()

        // When
        context.presenter.viewLoaded()

        // Then
        Verify(context.view, .once, .setup())
        Verify(context.view, .once, .updateConfirmButton(enabled: .value(false)))
    }

    @Test("phoneChanged enables confirm button for valid phone")
    func phoneChanged_enablesConfirm_forValidPhone() {
        // Given
        let context = makeContext()

        // When
        context.presenter.phoneChanged("1234567")

        // Then
        Verify(context.view, .once, .updateConfirmButton(enabled: .value(true)))
    }

    @Test("phoneChanged disables confirm button for invalid phone")
    func phoneChanged_disablesConfirm_forInvalidPhone() {
        // Given
        let context = makeContext()

        // When
        context.presenter.phoneChanged("123")

        // Then
        Verify(context.view, .once, .updateConfirmButton(enabled: .value(false)))
    }

    @Test("confirmTapped with invalid phone does not call auth and keeps state")
    func confirmTapped_withInvalidPhone_doesNotLogin() {
        // Given
        let context = makeContext()

        // When
        context.presenter.confirmTapped()

        // Then
        Verify(context.authService, .never, .login(phone: .any, completion: .any))
        Verify(context.router, .never, .openMainScreen())
        Verify(context.view, .once, .updateConfirmButton(enabled: .value(false)))
        #expect(context.progressService.showCallCount == 0)
        #expect(context.progressService.hideCallCount == 0)
        #expect(context.errorService.messages.isEmpty)
    }

    @Test("confirmTapped with valid phone opens main screen on success")
    func confirmTapped_withValidPhone_opensMainScreenOnSuccess() {
        // Given
        let context = makeContext()
        let phone = "1234567"
        context.presenter.phoneChanged(phone)
        Perform(context.authService, .login(phone: .any, completion: .any, perform: { _, completion in
            completion(.success(()))
        }))

        // When
        context.presenter.confirmTapped()

        // Then
        Verify(context.authService, .once, .login(phone: .value(phone), completion: .any))
        Verify(context.router, .once, .openMainScreen())
        #expect(context.progressService.showCallCount == 1)
        #expect(context.progressService.hideCallCount == 1)
        #expect(context.errorService.messages.isEmpty)
    }

    @Test("confirmTapped with valid phone shows error on auth failure")
    func confirmTapped_withValidPhone_showsErrorOnFailure() {
        // Given
        let context = makeContext()
        let phone = "1234567"
        context.presenter.phoneChanged(phone)
        Perform(context.authService, .login(phone: .any, completion: .any, perform: { _, completion in
            completion(.failure(AuthError.invalidPhone))
        }))

        // When
        context.presenter.confirmTapped()

        // Then
        Verify(context.authService, .once, .login(phone: .value(phone), completion: .any))
        Verify(context.router, .never, .openMainScreen())
        #expect(context.progressService.showCallCount == 1)
        #expect(context.progressService.hideCallCount == 1)
        #expect(context.errorService.messages == ["Invalid phone number"])
    }

    @Test("signUpTapped opens sign up screen")
    func signUpTapped_opensSignUpScreen() {
        // Given
        let context = makeContext()

        // When
        context.presenter.signUpTapped()

        // Then
        Verify(context.router, .once, .openSignUpScreen())
    }
}

private extension LoginScreenPresenterSwiftTestingTests {
    typealias Context = (
        presenter: LoginScreenPresenter,
        view: LoginScreenViewInputMockableMock,
        router: LoginScreenRouterInputMockableMock,
        authService: AuthServiceProtocolMockableMock,
        progressService: ProgressServiceSpy,
        errorService: ErrorServiceSpy
    )

    func makeContext() -> Context {
        let view = LoginScreenViewInputMockableMock()
        let router = LoginScreenRouterInputMockableMock()
        let presenter = LoginScreenPresenter(view: view, router: router)
        let authService = AuthServiceProtocolMockableMock()
        let progressService = ProgressServiceSpy()
        let errorService = ErrorServiceSpy()

        presenter.$authService.wrappedValue = authService
        presenter.$progressService.wrappedValue = progressService
        presenter.$errorService.wrappedValue = errorService

        return (presenter, view, router, authService, progressService, errorService)
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
    private(set) var messages: [String] = []

    override func show(errorText: String) {
        messages.append(errorText)
    }
}
