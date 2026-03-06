import Testing
import Foundation
import SwiftyMocky
@testable import TestingTask

@Suite("SignUpScreenPresenter Tests")
struct SignUpScreenPresenterTests {

    // MARK: - View Loaded

    @Test("viewLoaded calls setup on view")
    func viewLoaded_callsSetup() {
        // Given
        let view = SignUpScreenViewInputMock()
        let router = SignUpScreenRouterInputMock()
        let presenter = SignUpScreenPresenter(view: view, router: router)

        // When
        presenter.viewLoaded()

        // Then
        view.verify(.setup(), count: .exactly(1))
    }

    @Test("viewLoaded updates create button to disabled state initially")
    func viewLoaded_updatesCreateButton_disabled() {
        // Given
        let view = SignUpScreenViewInputMock()
        let router = SignUpScreenRouterInputMock()
        let presenter = SignUpScreenPresenter(view: view, router: router)
        let validationService = ValidationServiceMock()
        validationService.validationResult = false
        presenter.validationService = validationService

        // When
        presenter.viewLoaded()

        // Then
        view.verify(.updateCreateButton(enabled: .value(false)), count: .exactly(1))
    }

    // MARK: - Field Validation

    @Test("fieldChanged validates field using validation service")
    func fieldChanged_callsValidationService() {
        // Given
        let view = SignUpScreenViewInputMock()
        let router = SignUpScreenRouterInputMock()
        let presenter = SignUpScreenPresenter(view: view, router: router)
        let validationService = ValidationServiceMock()
        presenter.validationService = validationService

        // When
        presenter.fieldChanged(.firstName, value: "John")

        // Then
        #expect(validationService.isValidCallCount >= 1)
    }

    @Test("fieldChanged with all valid fields enables create button")
    func fieldChanged_allFieldsValid_buttonEnabled() {
        // Given
        let view = SignUpScreenViewInputMock()
        let router = SignUpScreenRouterInputMock()
        let presenter = SignUpScreenPresenter(view: view, router: router)
        let validationService = ValidationService()
        presenter.validationService = validationService

        // When - fill all required fields with valid values
        presenter.fieldChanged(.firstName, value: "John")
        presenter.fieldChanged(.lastName, value: "Doe")
        presenter.fieldChanged(.gender, value: "Male")
        presenter.fieldChanged(.birthDate, value: "01.01.1990")
        presenter.fieldChanged(.country, value: "Russia")
        presenter.fieldChanged(.city, value: "Moscow")
        presenter.fieldChanged(.email, value: "john@example.com")
        presenter.fieldChanged(.phone, value: "1234567")

        // Then
        view.verify(.updateCreateButton(enabled: .value(true)))
    }

    @Test("fieldChanged with invalid email disables create button")
    func fieldChanged_invalidEmail_buttonDisabled() {
        // Given
        let view = SignUpScreenViewInputMock()
        let router = SignUpScreenRouterInputMock()
        let presenter = SignUpScreenPresenter(view: view, router: router)
        let validationService = ValidationService()
        presenter.validationService = validationService

        // When - fill all fields but with invalid email
        presenter.fieldChanged(.firstName, value: "John")
        presenter.fieldChanged(.lastName, value: "Doe")
        presenter.fieldChanged(.gender, value: "Male")
        presenter.fieldChanged(.birthDate, value: "01.01.1990")
        presenter.fieldChanged(.country, value: "Russia")
        presenter.fieldChanged(.city, value: "Moscow")
        presenter.fieldChanged(.email, value: "invalid-email")
        presenter.fieldChanged(.phone, value: "1234567")

        // Then
        view.verify(.updateCreateButton(enabled: .value(false)))
    }

    @Test("fieldChanged with invalid phone disables create button")
    func fieldChanged_invalidPhone_buttonDisabled() {
        // Given
        let view = SignUpScreenViewInputMock()
        let router = SignUpScreenRouterInputMock()
        let presenter = SignUpScreenPresenter(view: view, router: router)
        let validationService = ValidationService()
        presenter.validationService = validationService

        // When - fill all fields but with invalid phone
        presenter.fieldChanged(.firstName, value: "John")
        presenter.fieldChanged(.lastName, value: "Doe")
        presenter.fieldChanged(.gender, value: "Male")
        presenter.fieldChanged(.birthDate, value: "01.01.1990")
        presenter.fieldChanged(.country, value: "Russia")
        presenter.fieldChanged(.city, value: "Moscow")
        presenter.fieldChanged(.email, value: "john@example.com")
        presenter.fieldChanged(.phone, value: "123") // Too short

        // Then
        view.verify(.updateCreateButton(enabled: .value(false)))
    }

    @Test("fieldChanged with empty required field disables create button")
    func fieldChanged_emptyField_buttonDisabled() {
        // Given
        let view = SignUpScreenViewInputMock()
        let router = SignUpScreenRouterInputMock()
        let presenter = SignUpScreenPresenter(view: view, router: router)
        let validationService = ValidationService()
        presenter.validationService = validationService

        // When - fill all fields except firstName
        presenter.fieldChanged(.firstName, value: "") // Empty
        presenter.fieldChanged(.lastName, value: "Doe")
        presenter.fieldChanged(.gender, value: "Male")
        presenter.fieldChanged(.birthDate, value: "01.01.1990")
        presenter.fieldChanged(.country, value: "Russia")
        presenter.fieldChanged(.city, value: "Moscow")
        presenter.fieldChanged(.email, value: "john@example.com")
        presenter.fieldChanged(.phone, value: "1234567")

        // Then
        view.verify(.updateCreateButton(enabled: .value(false)))
    }

    @Test("fieldChanged updates button on each change")
    func fieldChanged_multipleChanges_updatesEachTime() {
        // Given
        let view = SignUpScreenViewInputMock()
        let router = SignUpScreenRouterInputMock()
        let presenter = SignUpScreenPresenter(view: view, router: router)
        let validationService = ValidationServiceMock()
        presenter.validationService = validationService

        // When
        presenter.fieldChanged(.firstName, value: "John")
        presenter.fieldChanged(.lastName, value: "Doe")
        presenter.fieldChanged(.email, value: "test@test.com")

        // Then
        view.verify(.updateCreateButton(enabled: .any), count: .exactly(3))
    }

    // MARK: - Create Account

    @Test("createAccountTapped calls auth service signUp")
    func createAccountTapped_callsSignUp() {
        // Given
        let view = SignUpScreenViewInputMock()
        let router = SignUpScreenRouterInputMock()
        let presenter = SignUpScreenPresenter(view: view, router: router)
        let authService = AuthServiceProtocolMock()
        let validationService = ValidationService()
        presenter.authService = authService
        presenter.validationService = validationService

        // When
        fillAllFieldsWithValidData(presenter: presenter)
        presenter.createAccountTapped()

        // Then
        authService.verify(.signUp(data: .any, completion: .any), count: .exactly(1))
    }

    @Test("createAccountTapped shows progress")
    func createAccountTapped_showsProgress() {
        // Given
        let view = SignUpScreenViewInputMock()
        let router = SignUpScreenRouterInputMock()
        let presenter = SignUpScreenPresenter(view: view, router: router)
        let authService = AuthServiceProtocolMock()
        let progressService = IProgressServiceMock()
        presenter.authService = authService
        presenter.progressService = progressService

        // When
        presenter.createAccountTapped()

        // Then
        progressService.verify(.show(), count: .exactly(1))
        progressService.verify(.hide(), count: .exactly(1))
    }

    @Test("createAccountTapped on success navigates to main screen")
    func createAccountTapped_success_navigatesToMain() {
        // Given
        let view = SignUpScreenViewInputMock()
        let router = SignUpScreenRouterInputMock()
        let presenter = SignUpScreenPresenter(view: view, router: router)
        let authService = AuthServiceProtocolMock()
        presenter.authService = authService

        // Stub auth service to succeed
        authService.perform(.signUp(data: .any, completion: .any, perform: { data, completion in
            completion(.success(()))
        }))

        // When
        presenter.createAccountTapped()

        // Then
        router.verify(.openMainScreen(), count: .exactly(1))
    }

    @Test("createAccountTapped on failure shows error")
    func createAccountTapped_failure_showsError() {
        // Given
        let view = SignUpScreenViewInputMock()
        let router = SignUpScreenRouterInputMock()
        let presenter = SignUpScreenPresenter(view: view, router: router)
        let authService = AuthServiceProtocolMock()
        let errorService = IErrorServiceMock()
        presenter.authService = authService
        presenter.errorService = errorService

        // Stub auth service to fail
        authService.perform(.signUp(data: .any, completion: .any, perform: { data, completion in
            completion(.failure(AuthError.invalidData))
        }))

        // When
        presenter.createAccountTapped()

        // Then
        router.verify(.openMainScreen(), count: .exactly(0))
        errorService.verify(.show(errorText: .value("Sign up failed")), count: .exactly(1))
    }

    @Test("createAccountTapped sends correct data to auth service")
    func createAccountTapped_sendsCorrectData() {
        // Given
        let view = SignUpScreenViewInputMock()
        let router = SignUpScreenRouterInputMock()
        let presenter = SignUpScreenPresenter(view: view, router: router)
        let authService = AuthServiceProtocolMock()
        presenter.authService = authService

        // Capture the data sent to auth service
        var capturedData: SignUpData?
        authService.perform(.signUp(data: .any, completion: .any, perform: { data, completion in
            capturedData = data
            completion(.success(()))
        }))

        // When
        presenter.fieldChanged(.firstName, value: "John")
        presenter.fieldChanged(.email, value: "john@test.com")
        presenter.createAccountTapped()

        // Then
        #expect(capturedData?.fields[.firstName] == "John")
        #expect(capturedData?.fields[.email] == "john@test.com")
    }

    // MARK: - Back Tapped

    @Test("backTapped closes screen")
    func backTapped_closesScreen() {
        // Given
        let view = SignUpScreenViewInputMock()
        let router = SignUpScreenRouterInputMock()
        let presenter = SignUpScreenPresenter(view: view, router: router)

        // When
        presenter.backTapped()

        // Then
        router.verify(.close(), count: .exactly(1))
        router.verify(.openMainScreen(), count: .exactly(0))
    }

    @Test("backTapped can be called multiple times")
    func backTapped_multipleTimes() {
        // Given
        let view = SignUpScreenViewInputMock()
        let router = SignUpScreenRouterInputMock()
        let presenter = SignUpScreenPresenter(view: view, router: router)

        // When
        presenter.backTapped()
        presenter.backTapped()

        // Then
        router.verify(.close(), count: .exactly(2))
    }

    // MARK: - Helpers

    private func fillAllFieldsWithValidData(presenter: SignUpScreenPresenter) {
        presenter.fieldChanged(.firstName, value: "John")
        presenter.fieldChanged(.lastName, value: "Doe")
        presenter.fieldChanged(.gender, value: "Male")
        presenter.fieldChanged(.birthDate, value: "01.01.1990")
        presenter.fieldChanged(.country, value: "Russia")
        presenter.fieldChanged(.city, value: "Moscow")
        presenter.fieldChanged(.email, value: "john@example.com")
        presenter.fieldChanged(.phone, value: "1234567")
    }
}
