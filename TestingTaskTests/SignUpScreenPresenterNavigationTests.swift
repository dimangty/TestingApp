import XCTest
@testable import TestingTask

final class SignUpScreenPresenterNavigationTests: XCTestCase {
    func test_backTapped_closes() {
        // Given
        let view = SignUpViewMock()
        let router = SignUpRouterMock()
        let presenter = SignUpScreenPresenter(view: view, router: router)

        // When
        presenter.backTapped()

        // Then
        XCTAssertEqual(router.closeCallCount, 1)
        XCTAssertEqual(router.openMainCallCount, 0)
    }

    func test_createAccountTapped_withValidFields_opensMainOnSuccess() {
        // Given
        let view = SignUpViewMock()
        let router = SignUpRouterMock()
        let presenter = SignUpScreenPresenter(view: view, router: router)
        let result: Result<Void, Error> = .success(())
        presenter.authService = AuthServiceMock(result: result)
        presenter.validationService = ValidationService()

        // When
        for field in SignUpField.allCases {
            presenter.fieldChanged(field, value: "Value")
        }
        presenter.createAccountTapped()

        // Then
        XCTAssertEqual(router.openMainCallCount, 1)
    }
}

private final class SignUpViewMock: SignUpScreenViewInput {
    func setup() {}
    func updateCreateButton(enabled: Bool) {}
}

private final class SignUpRouterMock: SignUpScreenRouterInput {
    private(set) var closeCallCount = 0
    private(set) var openMainCallCount = 0

    func close() {
        closeCallCount += 1
    }

    func openMainScreen() {
        openMainCallCount += 1
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
