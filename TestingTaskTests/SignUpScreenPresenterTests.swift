import Foundation
import Testing
@testable import TestingTask

@Suite("Sign-Up Presenter Tests")
struct SignUpScreenPresenterTests {
    @Test("View load configures screen and disables create for empty fields")
    func viewLoadedConfiguresAndDisablesCreate() {
        // Given
        let view = SignUpScreenViewInputMockableMock()
        let router = SignUpScreenRouterInputMockableMock()
        let validation = ValidationService()
        let sut = SignUpScreenPresenter(view: view, router: router)
        sut.validationService = validation
        var lastCreateEnabled: Bool?
        Perform(view, .updateCreateButton(enabled: .any, perform: { lastCreateEnabled = $0 }))

        // When
        sut.viewLoaded()

        // Then
        Verify(view, .once, .setup())
        Verify(view, .once, .updateCreateButton(enabled: .value(false)))
        #expect(lastCreateEnabled == false)
    }

    @Test("Valid fields enable create button")
    func fieldChangedWithValidValuesEnablesCreate() {
        // Given
        let view = SignUpScreenViewInputMockableMock()
        let router = SignUpScreenRouterInputMockableMock()
        let validation = ValidationService()
        let sut = SignUpScreenPresenter(view: view, router: router)
        sut.validationService = validation
        var createStates: [Bool] = []
        Perform(view, .updateCreateButton(enabled: .any, perform: { createStates.append($0) }))

        // When
        for field in SignUpField.allCases {
            let value = field == .email ? "test@mail.com" : (field == .phone ? "1234567" : "Value")
            sut.fieldChanged(field, value: value)
        }

        // Then
        Verify(view, .updateCreateButton(enabled: .value(true)))
        #expect(createStates.last == true)
    }

    @Test("Successful account creation opens main")
    func createAccountTappedSuccessOpensMain() {
        // Given
        let view = SignUpScreenViewInputMockableMock()
        let router = SignUpScreenRouterInputMockableMock()
        let auth = AuthServiceProtocolMockableMock()
        let validation = ValidationService()
        let progress = ProgressServiceSpy()
        let error = ErrorServiceSpy()
        let sut = SignUpScreenPresenter(view: view, router: router)
        sut.authService = auth
        sut.validationService = validation
        sut.progressService = progress
        sut.errorService = error
        Perform(auth, .signUp(data: .any, completion: .any, perform: { _, completion in
            completion(.success(()))
        }))

        for field in SignUpField.allCases {
            let value = field == .email ? "test@mail.com" : (field == .phone ? "1234567" : "Value")
            sut.fieldChanged(field, value: value)
        }

        // When
        sut.createAccountTapped()

        // Then
        Verify(auth, .once, .signUp(data: .any, completion: .any))
        #expect(progress.showCallCount == 1)
        #expect(progress.hideCallCount == 1)
        Verify(router, .once, .openMainScreen())
        #expect(error.showErrorCallCount == 0)
    }

    @Test("Failed account creation shows error")
    func createAccountTappedFailureShowsError() {
        // Given
        let view = SignUpScreenViewInputMockableMock()
        let router = SignUpScreenRouterInputMockableMock()
        let auth = AuthServiceProtocolMockableMock()
        let validation = ValidationService()
        let progress = ProgressServiceSpy()
        let error = ErrorServiceSpy()
        let sut = SignUpScreenPresenter(view: view, router: router)
        sut.authService = auth
        sut.validationService = validation
        sut.progressService = progress
        sut.errorService = error
        Perform(auth, .signUp(data: .any, completion: .any, perform: { _, completion in
            completion(.failure(AuthError.invalidData))
        }))

        for field in SignUpField.allCases {
            let value = field == .email ? "test@mail.com" : (field == .phone ? "1234567" : "Value")
            sut.fieldChanged(field, value: value)
        }

        // When
        sut.createAccountTapped()

        // Then
        Verify(auth, .once, .signUp(data: .any, completion: .any))
        #expect(progress.showCallCount == 1)
        #expect(progress.hideCallCount == 1)
        Verify(router, .never, .openMainScreen())
        #expect(error.showErrorCallCount == 1)
        #expect(error.lastErrorText == "Sign up failed")
    }

    @Test("Back action closes module")
    func backTappedClosesModule() {
        // Given
        let view = SignUpScreenViewInputMockableMock()
        let router = SignUpScreenRouterInputMockableMock()
        let sut = SignUpScreenPresenter(view: view, router: router)

        // When
        sut.backTapped()

        // Then
        Verify(router, .once, .close())
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
