import XCTest
@testable import YourProjectName // Убедитесь, что имя вашего проекта указано правильно
import SwiftyMocky

class LoginScreenPresenterTests: XCTestCase {
    
    var loginScreenViewMock: LoginScreenViewMock!
    var authServiceMock: AuthServiceProtocolMock!
    var routerMock: RouterProtocolMock!
    
    var sut: LoginScreenPresenter!

    override func setUp() {
        super.setUp()
        
        // Инициализируем объекты-заглушки для представления, сервиса аутентификации и роутера
        loginScreenViewMock = LoginScreenViewMock()
        authServiceMock = AuthServiceProtocolMock()
        routerMock = RouterProtocolMock()
        
        // Создаем экземпляр презентера с использованием заглушек
        sut = LoginScreenPresenter(
            authService: authServiceMock,
            router: routerMock
        )
        sut.view = loginScreenViewMock
    }
    
    override func tearDown() {
        super.tearDown()

        // Обнуляем ссылки на объекты после выполнения тестов
        sut = nil
        loginScreenViewMock = nil
        authServiceMock = nil
        routerMock = nil
        
        // Данный вызов сбрасывает все сохраненные ожидания из Mock'ов в конце каждой тестовой функции.
        // Это важно для предотвращения утечек между тестами и изоляции их друг от друга.
        MockCleanup.assertNoUnfulfilledExpectations(in: [
            loginScreenViewMock, authServiceMock, routerMock
        ])
    }
    
    // MARK: - Test Happy Path
    
    func test_Login_With_Valid_Credentials_Succeeds() {
        // Given (Условие)
        let validEmail = "user@example.com"
        let validPassword = "validPa$$w0rd"
        
        // Ожидаем, что сервис аутентификации будет вызван только один раз
        // с переданными электронной почтой и паролем.
        authServiceMock.shouldReturn(true, for: .login(email: .value(validEmail), password: .value(validPassword)))

        // When (Действие)
        sut.login(email: validEmail, password: validPassword)

        // Then (Результат)
        verify(loginScreenViewMock).showLoading()
        verify(loginScreenViewMock).hideLoading()

        // Ожидаем, что после успешной аутентификации будет проведено роутинг на главный экран.
        verify(routerMock).navigateToMainScreen()
    }
    
    // MARK: - Test Invalid Input
    
    func test_Login_With_Empty_Email_Fails() {
        // Given (Условие)
        let emptyEmail = ""
        let validPassword = "validPa$$w0rd"
        
        // When (Действие)
        sut.login(email: emptyEmail, password: validPassword)

        // Then (Результат)
        verify(loginScreenViewMock).showError("Электронная почта не должна быть пустой.")
        never(loginScreenViewMock).showLoading()
        never(loginScreenViewMock).hideLoading()
        never(authServiceMock).login(email: .value(emptyEmail), password: .any)
        never(routerMock).navigateToMainScreen()
    }
    
    func test_Login_With_Empty_Password_Fails() {
        // Given (Условие)
        let validEmail = "user@example.com"
        let emptyPassword = ""
        
        // When (Действие)
        sut.login(email: validEmail, password: emptyPassword)

        // Then (Результат)
        verify(loginScreenViewMock).showError("Пароль не должен быть пустым.")
        never(loginScreenViewMock).showLoading()
        never(loginScreenViewMock).hideLoading()
        never(authServiceMock).login(email: .value(validEmail), password: .any)
        never(routerMock).navigateToMainScreen()
    }

    func test_Login_With_Invalid_Email_Fails() {
        // Given (Условие)
        let invalidEmail = "notvalidemail"
        let validPassword = "validPa$$w0rd"
        
        // When (Действие)
        sut.login(email: invalidEmail, password: validPassword)

        // Then (Результат)
        verify(loginScreenViewMock).showError("Введите корректную электронную почту.")
        never(loginScreenViewMock).showLoading()
        never(loginScreenViewMock).hideLoading()
        never(authServiceMock).login(email: .value(invalidEmail), password: .any)
        never(routerMock).navigateToMainScreen()
    }

    // MARK: - Test Authentication Errors
    
    func test_Login_With_Wrong_Credentials_Fails() {
        // Given (Условие)
        let invalidEmail = "wrong@example.com"
        let wrongPassword = "wrongPa$$w0rd"
        
        authServiceMock.shouldReturn(false, for: .login(email: .value(invalidEmail), password: .value(wrongPassword)))
        
        // When (Действие)
        sut.login(email: invalidEmail, password: wrongPassword)

        // Then (Результат)
        verify(loginScreenViewMock).showLoading()
        verify(loginScreenViewMock).hideLoading()
        verify(loginScreenViewMock).showError("Неправильный адрес электронной почты или пароль.")
    }

    func test_Login_With_API_Call_Error_Fails() {
        // Given (Условие)
        let validEmail = "user@example.com"
        let validPassword = "validPa$$w0rd"
        
        let expectedError: Error = NSError(domain: "MockedErrorDomain", code: 1, userInfo:nil)
        authServiceMock.shouldThrow(expectedError, for: .login(email: .value(validEmail), password: .value(validPassword)))

        // When (Действие)
        sut.login(email: validEmail, password: validPassword)

        // Then (Результат)
        verify(loginScreenViewMock).showLoading()
        verify(loginScreenViewMock).hideLoading()
        verify(loginScreenViewMock).showError("Ошибка входа. Попробуйте снова.")
    }

    // MARK: - Test Routing
    
    func test_RegisterButton_Tapped_Routes_To_Registration_Screen() {
        // Given (Условие)
        
        // When (Действие)
        sut.registerTapped()
        
        // Then (Результат)
        verify(routerMock).navigateToRegistrationScreen()
    }

    func test_ForgotPasswordButton_Tapped_Routes_To_Reset_Password_Screen() {
        // Given (Условие)
        
        // When (Действие)
        sut.forgotPasswordTapped()
        
        // Then (Результат)
        verify(routerMock).navigateToResetPasswordScreen()
    }
}
