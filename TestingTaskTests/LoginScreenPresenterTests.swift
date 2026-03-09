import XCTest
import SwiftyMocky
@testable import TestingTask

final class LoginScreenPresenterTests: XCTestCase {
    func test_viewLoaded_setsUpView_andDisablesConfirmButton_whenPhoneIsEmpty() {
        // Given
        let context = makeContext()

        // When
        context.presenter.viewLoaded()

        // Then
        Verify(context.view, .once, .setup())
        Verify(context.view, .once, .updateConfirmButton(enabled: false))
    }

    func test_confirmTapped_doesNotAuthenticate_whenPhoneIsInvalid() {
        // Given
        let context = makeContext()

        // When
        context.presenter.confirmTapped()

        // Then
        Verify(context.view, .once, .updateConfirmButton(enabled: false))
        Verify(context.authService, .never, .login(phone: .any, completion: .any))
        Verify(context.router, .never, .openMainScreen())
        XCTAssertEqual(context.progressService.showCallCount, 0)
        XCTAssertEqual(context.progressService.hideCallCount, 0)
        XCTAssertTrue(context.errorService.messages.isEmpty)
    }

    func test_confirmTapped_authenticatesAndRoutesToMain_onSuccess() {
        // Given
        let context = makeContext()
        Perform(context.authService, .login(phone: .any, completion: .any, perform: { _, completion in
            completion(.success(()))
        }))
        context.presenter.phoneChanged("1234567")

        // When
        context.presenter.confirmTapped()

        // Then
        Verify(context.authService, .once, .login(phone: "1234567", completion: .any))
        Verify(context.router, .once, .openMainScreen())
        XCTAssertEqual(context.progressService.showCallCount, 1)
        XCTAssertEqual(context.progressService.hideCallCount, 1)
        XCTAssertTrue(context.errorService.messages.isEmpty)
    }

    func test_confirmTapped_showsError_onFailure() {
        // Given
        let context = makeContext()
        Perform(context.authService, .login(phone: .any, completion: .any, perform: { _, completion in
            completion(.failure(AuthError.invalidPhone))
        }))
        context.presenter.phoneChanged("1234567")

        // When
        context.presenter.confirmTapped()

        // Then
        Verify(context.authService, .once, .login(phone: "1234567", completion: .any))
        Verify(context.router, .never, .openMainScreen())
        XCTAssertEqual(context.progressService.showCallCount, 1)
        XCTAssertEqual(context.progressService.hideCallCount, 1)
        XCTAssertEqual(context.errorService.messages, ["Invalid phone number"])
    }

    func test_signUpTapped_opensSignUpScreen() {
        // Given
        let context = makeContext()

        // When
        context.presenter.signUpTapped()

        // Then
        Verify(context.router, .once, .openSignUpScreen())
    }
}

private extension LoginScreenPresenterTests {
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
        let authService = AuthServiceProtocolMockableMock()
        let progressService = ProgressServiceSpy()
        let errorService = ErrorServiceSpy()
        let presenter = LoginScreenPresenter(view: view, router: router)

        presenter.authService = authService
        presenter.progressService = progressService
        presenter.errorService = errorService

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
