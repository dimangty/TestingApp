import XCTest
import SwiftyMocky
@testable import TestingTask

final class SignUpScreenPresenterTests: XCTestCase {
    func test_viewLoaded_setsUpView_andDisablesCreateButton_whenFieldsAreEmpty() {
        // Given
        let context = makeContext()

        // When
        context.presenter.viewLoaded()

        // Then
        Verify(context.view, .once, .setup())
        Verify(context.view, .once, .updateCreateButton(enabled: false))
    }

    func test_fieldChanged_enablesCreateButton_whenAllFieldsBecomeValid() {
        // Given
        let context = makeContext()

        // When
        for (field, value) in validFields {
            context.presenter.fieldChanged(field, value: value)
        }

        // Then
        Verify(context.view, .moreOrEqual(to: 1), .updateCreateButton(enabled: true))
    }

    func test_createAccountTapped_routesToMain_onSuccess() {
        // Given
        let context = makeContext()
        var capturedData: SignUpData?
        Perform(context.authService, .signUp(data: .any, completion: .any, perform: { data, completion in
            capturedData = data
            completion(.success(()))
        }))
        for (field, value) in validFields {
            context.presenter.fieldChanged(field, value: value)
        }

        // When
        context.presenter.createAccountTapped()

        // Then
        Verify(context.authService, .once, .signUp(data: .any, completion: .any))
        Verify(context.router, .once, .openMainScreen())
        XCTAssertEqual(capturedData?.fields[.email], validFields[.email])
        XCTAssertEqual(context.progressService.showCallCount, 1)
        XCTAssertEqual(context.progressService.hideCallCount, 1)
        XCTAssertTrue(context.errorService.messages.isEmpty)
    }

    func test_createAccountTapped_showsError_onFailure() {
        // Given
        let context = makeContext()
        Perform(context.authService, .signUp(data: .any, completion: .any, perform: { _, completion in
            completion(.failure(AuthError.invalidData))
        }))
        for (field, value) in validFields {
            context.presenter.fieldChanged(field, value: value)
        }

        // When
        context.presenter.createAccountTapped()

        // Then
        Verify(context.authService, .once, .signUp(data: .any, completion: .any))
        Verify(context.router, .never, .openMainScreen())
        XCTAssertEqual(context.progressService.showCallCount, 1)
        XCTAssertEqual(context.progressService.hideCallCount, 1)
        XCTAssertEqual(context.errorService.messages, ["Sign up failed"])
    }

    func test_backTapped_closesScreen() {
        // Given
        let context = makeContext()

        // When
        context.presenter.backTapped()

        // Then
        Verify(context.router, .once, .close())
    }
}

private extension SignUpScreenPresenterTests {
    typealias Context = (
        presenter: SignUpScreenPresenter,
        view: SignUpScreenViewInputMockableMock,
        router: SignUpScreenRouterInputMockableMock,
        authService: AuthServiceProtocolMockableMock,
        validationService: ValidationServiceSpy,
        progressService: ProgressServiceSpy,
        errorService: ErrorServiceSpy
    )

    var validFields: [SignUpField: String] {
        [
            .firstName: "John",
            .lastName: "Appleseed",
            .gender: "male",
            .birthDate: "01-01-1990",
            .country: "USA",
            .city: "NYC",
            .email: "john@example.com",
            .phone: "1234567890"
        ]
    }

    func makeContext() -> Context {
        let view = SignUpScreenViewInputMockableMock()
        let router = SignUpScreenRouterInputMockableMock()
        let authService = AuthServiceProtocolMockableMock()
        let validationService = ValidationServiceSpy()
        let progressService = ProgressServiceSpy()
        let errorService = ErrorServiceSpy()
        let presenter = SignUpScreenPresenter(view: view, router: router)

        presenter.authService = authService
        presenter.validationService = validationService
        presenter.progressService = progressService
        presenter.errorService = errorService

        return (presenter, view, router, authService, validationService, progressService, errorService)
    }
}

private final class ValidationServiceSpy: ValidationService {
    override func isValid(field: SignUpField, value: String) -> Bool {
        switch field {
        case .email:
            return value.contains("@") && value.contains(".")
        case .phone:
            let digits = value.filter(\.isNumber)
            return digits.count >= 7 && digits.count <= 15 && digits.count == value.count
        default:
            return !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
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
