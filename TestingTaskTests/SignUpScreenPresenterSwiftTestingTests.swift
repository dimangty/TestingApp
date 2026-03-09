import Foundation
import Testing
import SwiftyMocky
@testable import TestingTask

@Suite
struct SignUpScreenPresenterSwiftTestingTests {
    
    @Test
    func signUp_createsAccountSuccessfully() {
        // Given
        let viewMock = SignUpScreenViewInputMockableMock()
        let routerMock = SignUpScreenRouterInputMockableMock()
        let authServiceMock = AuthServiceProtocolMockableMock()
        let validationServiceSpy = ValidationServiceSpy()
        let progressServiceSpy = ProgressServiceSpy()
        let errorServiceSpy = ErrorServiceSpy()
        
        let presenter = SignUpScreenPresenter()
        presenter.view = viewMock
        presenter.router = routerMock
        presenter.authService = authServiceMock
        presenter.validationService = validationServiceSpy
        presenter.progressService = progressServiceSpy
        presenter.errorService = errorServiceSpy
        
        let testData = SignUpData(email: "test@example.com", password: "password123")
        
        // When
        Perform(authServiceMock, .signUp(data: testData, completion: .any, perform: { _, completion in
            completion(.success(()))
        }))
        
        // Then
        #expect(validationServiceSpy.isValidCalled)
        #expect(progressServiceSpy.showCalled)
        #expect(progressServiceSpy.hideCalled)
        #expect(routerMock.navigateToMainScreenCalled)
    }
    
    @Test
    func signUp_handlesAuthError() {
        // Given
        let viewMock = SignUpScreenViewInputMockableMock()
        let routerMock = SignUpScreenRouterInputMockableMock()
        let authServiceMock = AuthServiceProtocolMockableMock()
        let validationServiceSpy = ValidationServiceSpy()
        let progressServiceSpy = ProgressServiceSpy()
        let errorServiceSpy = ErrorServiceSpy()
        
        let presenter = SignUpScreenPresenter()
        presenter.view = viewMock
        presenter.router = routerMock
        presenter.authService = authServiceMock
        presenter.validationService = validationServiceSpy
        presenter.progressService = progressServiceSpy
        presenter.errorService = errorServiceSpy
        
        let testData = SignUpData(email: "test@example.com", password: "password123")
        
        // When
        Perform(authServiceMock, .signUp(data: testData, completion: .any, perform: { _, completion in
            completion(.failure(AuthError.invalidCredentials))
        }))
        
        // Then
        #expect(validationServiceSpy.isValidCalled)
        #expect(progressServiceSpy.showCalled)
        #expect(progressServiceSpy.hideCalled)
        #expect(errorServiceSpy.showErrorCalled)
    }
    
    @Test
    func signUp_validatesFieldsBeforeAuth() {
        // Given
        let viewMock = SignUpScreenViewInputMockableMock()
        let routerMock = SignUpScreenRouterInputMockableMock()
        let authServiceMock = AuthServiceProtocolMockableMock()
        let validationServiceSpy = ValidationServiceSpy()
        let progressServiceSpy = ProgressServiceSpy()
        let errorServiceSpy = ErrorServiceSpy()
        
        let presenter = SignUpScreenPresenter()
        presenter.view = viewMock
        presenter.router = routerMock
        presenter.authService = authServiceMock
        presenter.validationService = validationServiceSpy
        presenter.progressService = progressServiceSpy
        presenter.errorService = errorServiceSpy
        
        let testData = SignUpData(email: "test@example.com", password: "password123")
        
        // When
        Perform(authServiceMock, .signUp(data: testData, completion: .any, perform: { _, completion in
            completion(.success(()))
        }))
        
        // Then
        #expect(validationServiceSpy.isValidCalled)
        #expect(validationServiceSpy.isValidCalledWith(field: .email, value: testData.email))
        #expect(validationServiceSpy.isValidCalledWith(field: .password, value: testData.password))
    }
    
    @Test
    func signUp_showsProgressAndHidesItAfterAuth() {
        // Given
        let viewMock = SignUpScreenViewInputMockableMock()
        let routerMock = SignUpScreenRouterInputMockableMock()
        let authServiceMock = AuthServiceProtocolMockableMock()
        let validationServiceSpy = ValidationServiceSpy()
        let progressServiceSpy = ProgressServiceSpy()
        let errorServiceSpy = ErrorServiceSpy()
        
        let presenter = SignUpScreenPresenter()
        presenter.view = viewMock
        presenter.router = routerMock
        presenter.authService = authServiceMock
        presenter.validationService = validationServiceSpy
        presenter.progressService = progressServiceSpy
        presenter.errorService = errorServiceSpy
        
        let testData = SignUpData(email: "test@example.com", password: "password123")
        
        // When
        Perform(authServiceMock, .signUp(data: testData, completion: .any, perform: { _, completion in
            completion(.success(()))
        }))
        
        // Then
        #expect(progressServiceSpy.showCalled)
        #expect(progressServiceSpy.hideCalled)
    }
}

private class ValidationServiceSpy: ValidationService {
    var isValidCalled = false
    var isValidCalledWith: (field: SignUpField, value: String)?
    
    override func isValid(field: SignUpField, value: String) -> Bool {
        isValidCalled = true
        isValidCalledWith = (field: field, value: value)
        return true
    }
}

private class ProgressServiceSpy: ProgressService {
    var showCalled = false
    var hideCalled = false
    
    override func show() {
        showCalled = true
    }
    
    override func hide() {
        hideCalled = true
    }
}

private class ErrorServiceSpy: ErrorService {
    var showErrorCalled = false
    
    override func show(errorText: String) {
        showErrorCalled = true
    }
}
