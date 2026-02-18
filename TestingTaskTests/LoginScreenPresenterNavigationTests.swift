import XCTest
@testable import TestingTask

final class LoginScreenPresenterNavigationTests: XCTestCase {
    func test_signUpTapped_opensSignUp() {
        // Given
        let view = LoginViewMock()
        let router = LoginRouterMock()
        let presenter = LoginScreenPresenter(view: view, router: router)

        // When
        presenter.signUpTapped()

        // Then
        XCTAssertEqual(router.openSignUpCallCount, 1)
        XCTAssertEqual(router.openMainCallCount, 0)
    }

    func test_confirmTapped_withValidPhone_opensMainOnSuccess() {
        // Given
        let view = LoginViewMock()
        let router = LoginRouterMock()
        let presenter = LoginScreenPresenter(view: view, router: router)
        presenter.authService = AuthServiceMock(result: .success(()))

        // When
        presenter.phoneChanged("1234567")
        presenter.confirmTapped()

        // Then
        XCTAssertEqual(router.openMainCallCount, 1)
    }

    func test_confirmTapped_withInvalidPhone_doesNotNavigate() {
        // Given
        let view = LoginViewMock()
        let router = LoginRouterMock()
        let presenter = LoginScreenPresenter(view: view, router: router)
        presenter.authService = AuthServiceMock(result: .success(()))

        // When
        presenter.phoneChanged("123")
        presenter.confirmTapped()

        // Then
        XCTAssertEqual(router.openMainCallCount, 0)
        XCTAssertEqual(router.openSignUpCallCount, 0)
    }
}

private final class LoginViewMock: LoginScreenViewInput {
    func setup() {}
    func updateConfirmButton(enabled: Bool) {}
}

private final class LoginRouterMock: LoginScreenRouterInput {
    private(set) var openMainCallCount = 0
    private(set) var openSignUpCallCount = 0

    func openMainScreen() {
        openMainCallCount += 1
    }

    func openSignUpScreen() {
        openSignUpCallCount += 1
    }
}

private final class AuthServiceMock: AuthServiceProtocol {
    private let result: Result<Void, Error>

    init(result: Result<Void, Error>) {
        self.result = result
    }

    func login(phone: String, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(result)
    }

    func signUp(data: SignUpData, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(result)
    }
}
