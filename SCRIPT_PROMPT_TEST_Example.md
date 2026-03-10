# Универсальные промты для тестирования презентеров с SwiftyMocky

## Основной промт для генерации тестов презентера

```
Напиши полные unit-тесты для презентера {PRESENTER_NAME} используя SwiftyMocky и Swift Testing framework.

КРИТИЧЕСКИ ВАЖНО:
- КАЖДЫЙ тест должен содержать РЕАЛЬНЫЕ проверки (Verify, #expect)
- НЕ используй заглушки типа "// TODO: Add test implementation"
- НЕ используй комментарии типа "// Add assertions here"
- НЕ используй плейсхолдеры вместо реальной логики

Требования к тестам:
1. Используй Swift Testing (@Suite, @Test)
2. Используй SwiftyMocky для моков (Given, Perform, Verify)
3. Следуй Given/When/Then паттерну в комментариях
4. Покрой ВСЕ методы презентера тестами (100% покрытие)
5. Создай Spy классы для сервисов (@Injected dependencies)
6. Тестируй edge cases (nil values, boundary conditions, multiple calls)
7. Проверь все пути выполнения (success/failure scenarios)
8. Используй реальную логику без заглушек

Структура тестов должна включать:
- View lifecycle events (viewLoaded, viewWillAppear, viewDidAppear, viewWillDisappear, viewDidDisappear)
- User actions (button taps, text changes, gestures, etc.)
- Validation logic (проверка валидации данных с граничными значениями)
- Navigation routing (проверка всех переходов между экранами)
- Error scenarios (обработка ошибок, сетевых сбоев, таймаутов)
- State management (управление состоянием UI, включая loading states)
- Edge cases (граничные условия, nil значения, пустые строки, максимальные значения)
- Service interactions (вызовы сервисов с моками и проверка параметров)

Каждый тест должен:
- Иметь описательное имя функции в camelCase (например: testViewLoadedConfiguresScreenCorrectly)
- Иметь четкое описание в @Test("...") на английском языке
- Содержать Given/When/Then комментарии для структурирования логики
- Проверять конкретное поведение (один аспект на тест - Single Responsibility)
- Использовать Verify для проверки вызовов моков с правильными matchers
- Использовать #expect для проверки значений и состояний

Создай приватные Spy классы для всех @Injected зависимостей:
- ProgressServiceSpy (если есть progressService)
- ErrorServiceSpy (если есть errorService)
- Другие сервисы по аналогии (например: AnalyticsServiceSpy, StorageServiceSpy)

Spy классы должны:
- Наследоваться от реального класса сервиса
- Иметь счетчики вызовов для каждого метода (например: showCallCount, hideCallCount)
- Сохранять переданные параметры (например: lastErrorText, lastAnalyticsEvent)
- Быть помечены как private final class
- Располагаться в конце файла после всех тестов

Для моков ViewInput и RouterInput используй:
- {ScreenName}ViewInputMock() для view (например: LoginScreenViewInputMock)
- {ScreenName}RouterInputMock() для router (например: LoginScreenRouterInputMock)

Используй Perform для stubbing (перехват вызовов):
```swift
// Захват параметра
var capturedEnabled: Bool?
Perform(mockView, .updateConfirmButton(enabled: .any, perform: { capturedEnabled = $0 }))

// Проверка после вызова
#expect(capturedEnabled == true)
```

Используй Given для настройки моков сервисов:
```swift
// Синхронный метод
Given(mockService, .someMethod(param: .any, willReturn: expectedValue))

// Async с completion handler
Given(mockAuthService, .login(phone: .any, completion: .any, perform: { _, completion in
    completion(.success(()))
}))

// Async с failure
Given(mockAuthService, .login(phone: .any, completion: .any, perform: { _, completion in
    completion(.failure(NetworkError.timeout))
}))
```

Используй Verify для проверки вызовов:
```swift
// Проверка с точным значением
Verify(mockView, .once, .setup())
Verify(mockView, .once, .updateConfirmButton(enabled: .value(true)))

// Проверка что метод НЕ вызывался
Verify(mockView, .never, .showError())

// Проверка навигации
Verify(mockRouter, .once, .openNextScreen())

// Проверка с любым значением
Verify(mockService, .once, .track(event: .any))
```

Пример структуры теста:
```swift
@Test("Description of what is being tested")
func testMethodName() {
    // Given: Setup with mocked dependencies
    let mockView = {ScreenName}ViewInputMock()
    let mockRouter = {ScreenName}RouterInputMock()
    let mockService = ServiceProtocolMock()
    let progressSpy = ProgressServiceSpy()
    let presenter = {PresenterName}(view: mockView, router: mockRouter)
    presenter.service = mockService
    presenter.progressService = progressSpy

    // Configure behavior
    var capturedValue: Type?
    Perform(mockView, .method(param: .any, perform: { capturedValue = $0 }))

    Given(mockService, .fetchData(completion: .any, perform: { completion in
        completion(.success(testData))
    }))

    // When: Execute action being tested
    presenter.someAction()

    // Then: Verify expected behavior
    Verify(mockView, .once, .method(param: .value(expectedValue)))
    #expect(capturedValue == expectedValue)
    #expect(progressSpy.showCallCount == 1)
    #expect(progressSpy.hideCallCount == 1)
}
```

Обязательно покрой тестами:
1. Все lifecycle методы (viewLoaded, viewWillAppear, viewDidAppear, etc.)
   - Проверь начальное состояние UI
   - Проверь вызовы setup методов
   - Проверь подписки на события

2. Все user action методы (buttonTapped, textChanged, etc.)
   - Проверь валидацию ввода
   - Проверь обновление UI
   - Проверь вызовы сервисов

3. Все validation методы с различными входными данными
   - Граничные значения (минимум, максимум)
   - Невалидные данные (пустые, nil, некорректный формат)
   - Валидные данные (середина диапазона)

4. Все async операции (success и failure paths)
   - Success: проверь навигацию и обновление UI
   - Failure: проверь показ ошибки и состояние UI
   - Проверь loading states (show/hide progress)

5. Все navigation flows
   - Проверь вызовы router с правильными параметрами
   - Проверь условия навигации (guard statements)

6. Все edge cases (empty, nil, boundary values)
   - Пустые строки: ""
   - Nil значения: nil
   - Граничные значения: 0, -1, максимальные числа
   - Специальные символы в тексте

7. Множественные вызовы одного метода
   - Проверь что состояние обновляется корректно
   - Проверь счетчики вызовов (callCount)

8. Переходы между состояниями
   - От невалидного к валидному
   - От валидного к невалидному
   - Множественные изменения подряд

НЕ используй заглушки типа:
- "// TODO: Add test implementation"
- "// Add assertions here"
- "// Implement test logic"
- "// Test implementation goes here"

Каждый тест должен быть полностью реализован с реальными проверками (Verify и #expect).
```

## Промт для анализа презентера перед тестированием

```
Проанализируй презентер {PRESENTER_FILE_PATH} и выведи:

1. Все публичные методы презентера с сигнатурами
2. Все @Injected зависимости
3. Все приватные методы и свойства
4. Типы view и router протоколов
5. Все возможные пути выполнения (success/failure branches)
6. Все edge cases, которые нужно протестировать
7. Список необходимых Spy классов

Формат ответа:
## Публичные методы (ViewOutput)
- method1(param: Type) -> ReturnType
- method2()

## Зависимости (@Injected)
- authService: AuthServiceProtocol?
- progressService: ProgressService?

## Приватные методы
- privateMethod1()

## Протоколы
- View: {ScreenName}ViewInput
- Router: {ScreenName}RouterInput

## Пути выполнения
- method1 -> success -> calls router.navigate()
- method1 -> failure -> shows error

## Edge cases для тестирования
- Empty input
- Nil values
- Boundary conditions
- Multiple rapid calls

## Необходимые Spy классы
- ProgressServiceSpy
- ErrorServiceSpy
```

## Промт для проверки покрытия тестов

```
Проверь, что тесты для презентера {PRESENTER_NAME} покрывают:

1. Все публичные методы презентера
2. Все ветки условий (if/else, switch/case)
3. Все async completion handlers (success/failure)
4. Все вызовы view методов
5. Все вызовы router методов
6. Все вызовы сервисов
7. Все edge cases
8. Все переходы состояний

Выведи:
- ✅ Покрыто: список покрытых сценариев
- ❌ Не покрыто: список непокрытых сценариев
- 📝 Рекомендации: дополнительные тесты для улучшения покрытия
```

## Промт для создания Spy классов

```
Создай Spy классы для всех @Injected сервисов в презентере {PRESENTER_FILE_PATH}.

Требования:
1. Используй private final class
2. Наследуйся от реального класса сервиса
3. Добавь счетчики вызовов для каждого метода ({methodName}CallCount)
4. Сохраняй последние переданные параметры (last{ParamName})
5. Override все публичные методы
6. Increment callCount в каждом методе
7. Сохраняй параметры для проверки в тестах

Пример структуры:
```swift
private final class {ServiceName}Spy: {ServiceProtocol} {
    private(set) var methodCallCount = 0
    private(set) var lastParameter: Type?

    override func method(parameter: Type) {
        methodCallCount += 1
        lastParameter = parameter
    }
}
```

Создай Spy для всех найденных сервисов.
```

## Промт для генерации тестов конкретного метода

```
Напиши comprehensive тесты для метода {METHOD_NAME} презентера {PRESENTER_NAME}.

Покрой все сценарии:
1. Happy path (основной сценарий)
2. Error paths (все пути ошибок)
3. Edge cases (граничные случаи)
4. Invalid input
5. Nil values
6. Multiple calls
7. State transitions

Для каждого теста:
- Given: детальная настройка моков
- When: вызов тестируемого метода
- Then: проверка всех side effects

Используй:
- Perform для stubbing
- Given для настройки возвращаемых значений
- Verify для проверки вызовов
- #expect для проверки значений
- Spy классы для проверки вызовов сервисов
```

## Промт для рефакторинга существующих тестов

```
Рефактор тесты презентера {PRESENTER_NAME} согласно best practices:

1. Используй Swift Testing вместо XCTest (если используется XCTest)
2. Добавь Given/When/Then комментарии
3. Улучши названия тестов (должны читаться как предложения)
4. Замени заглушки на реальные проверки
5. Добавь проверки всех side effects
6. Используй Spy вместо просто моков где нужно
7. Добавь edge cases если отсутствуют
8. Проверь что все verify используют правильные matchers (.once, .value(), .any)
9. Убедись что каждый тест проверяет только один аспект

Сохрани всю функциональность и добавь недостающие проверки.
```

## Шаблон для XCTest (альтернативный)

```
Напиши unit-тесты для презентера {PRESENTER_NAME} используя XCTest и SwiftyMocky.

Требования:
1. Используй XCTestCase
2. Используй SwiftyMocky (Given, Perform, Verify)
3. Следуй Given/When/Then паттерну
4. Создай Spy классы для сервисов
5. Покрой все методы и edge cases

Пример структуры:
```swift
import XCTest
import SwiftyMocky
@testable import {ModuleName}

final class {PresenterName}Tests: XCTestCase {

    func test_methodName_expectedBehavior() {
        // Given
        let mockView = {ScreenName}ViewInputMock()
        let mockRouter = {ScreenName}RouterInputMock()
        let sut = {PresenterName}(view: mockView, router: mockRouter)

        // When
        sut.someMethod()

        // Then
        Verify(mockView, .once, .someViewMethod())
    }
}
```
```

## Советы по работе с SwiftyMocky

### Matchers
- `.any` - любое значение
- `.value(x)` - точное значение x
- `.matching { $0 > 5 }` - custom matcher

### Verify counts
- `.once` - ровно один раз
- `.never` - ни разу
- `.atLeastOnce` - хотя бы один раз
- `.exactly(n)` - ровно n раз

### Perform stubbing
```swift
// Capture parameter
var captured: Type?
Perform(mock, .method(param: .any, perform: { captured = $0 }))

// Return value
Given(mock, .method(param: .any, willReturn: value))

// Execute closure
Given(mock, .asyncMethod(completion: .any, perform: { completion in
    completion(.success(result))
}))
```

### Reset mock
```swift
mockView.resetMock() // Очищает историю вызовов
```

## Примеры проверок

### Проверка вызова метода view
```swift
Verify(mockView, .once, .setup())
Verify(mockView, .once, .display(title: .value("Test"), content: .any))
```

### Проверка вызова router
```swift
Verify(mockRouter, .once, .openNextScreen())
Verify(mockRouter, .never, .dismiss())
```

### Проверка async операций
```swift
let expectation = XCTestExpectation(description: "Async operation")
Perform(mockService, .fetchData(completion: .any, perform: { completion in
    completion(.success(data))
    expectation.fulfill()
}))

sut.loadData()

wait(for: [expectation], timeout: 1.0)
Verify(mockView, .once, .showData(.any))
```

### Проверка состояния через Spy
```swift
let progressSpy = ProgressServiceSpy()
presenter.progressService = progressSpy

presenter.login()

#expect(progressSpy.showCallCount == 1)
#expect(progressSpy.hideCallCount == 1)
```

---

## 📝 РЕАЛЬНЫЙ ПРИМЕР: LoginScreenPresenter

### Исходный код презентера

```swift
//  LoginScreenPresenter.swift

class LoginScreenPresenter {
    private weak var view: LoginScreenViewInput?
    private let router: LoginScreenRouterInput

    @Injected var authService: AuthServiceProtocol?
    @Injected var progressService: ProgressService?
    @Injected var errorService: ErrorService?

    private var phone: String = ""

    init(view: LoginScreenViewInput, router: LoginScreenRouterInput) {
        self.view = view
        self.router = router
    }

    private var isPhoneValid: Bool {
        return phone.count >= 7 && phone.count <= 15
    }

    private func updateConfirmState() {
        view?.updateConfirmButton(enabled: isPhoneValid)
    }
}

extension LoginScreenPresenter: LoginScreenViewOutput {
    func viewLoaded() {
        view?.setup()
        updateConfirmState()
    }

    func phoneChanged(_ phone: String) {
        self.phone = phone
        updateConfirmState()
    }

    func confirmTapped() {
        guard isPhoneValid else {
            updateConfirmState()
            return
        }

        progressService?.show()
        authService?.login(phone: phone, completion: { [weak self] result in
            self?.progressService?.hide()
            switch result {
            case .success:
                self?.router.openMainScreen()
            case .failure:
                self?.errorService?.show(errorText: "Invalid phone number")
            }
        })
    }

    func signUpTapped() {
        router.openSignUpScreen()
    }
}
```

### Промт для генерации тестов

```
Напиши полные unit-тесты для презентера LoginScreenPresenter используя SwiftyMocky и Swift Testing framework.

Требования:
1. Используй Swift Testing (@Suite, @Test)
2. Используй SwiftyMocky для моков (Given, Perform, Verify)
3. Следуй Given/When/Then паттерну в комментариях
4. Покрой ВСЕ методы презентера тестами
5. Создай Spy классы для сервисов (@Injected dependencies)
6. Тестируй edge cases (nil values, boundary conditions, multiple calls)
7. Проверь все пути выполнения (success/failure scenarios)
8. Используй реальную логику без заглушек

Структура тестов должна включать:
- View lifecycle events (viewLoaded)
- User actions (phoneChanged, confirmTapped, signUpTapped)
- Validation logic (phone validation: 7-15 digits)
- Navigation routing (openMainScreen, openSignUpScreen)
- Error scenarios (invalid phone, auth failure)
- State management (confirm button enabled/disabled)
- Edge cases (empty phone, boundary values: 6, 7, 15, 16 digits)
- Service interactions (authService, progressService, errorService)

Каждый тест должен:
- Иметь описательное имя функции в camelCase
- Иметь четкое описание в @Test("...")
- Содержать Given/When/Then комментарии
- Проверять конкретное поведение (один аспект)
- Использовать Verify для проверки вызовов моков
- Использовать #expect для проверки значений

Создай приватные Spy классы для:
- ProgressServiceSpy (с showCallCount, hideCallCount)
- ErrorServiceSpy (с showErrorCallCount, lastErrorText)

Для моков ViewInput и RouterInput используй:
- LoginScreenViewInputMock() для view
- LoginScreenRouterInputMock() для router

Код презентера:
[вставить код LoginScreenPresenter выше]

НЕ используй заглушки типа "// TODO: Add test implementation"
Каждый тест должен быть полностью реализован с реальными проверками.
```

### Ожидаемые тесты для покрытия

```swift
import Foundation
import Testing
import SwiftyMocky
@testable import TestingTask

@Suite("Login Presenter Tests")
struct LoginScreenPresenterTests {

    // MARK: - View Lifecycle

    @Test("View load configures screen and disables confirm for empty phone")
    func viewLoadedConfiguresAndDisablesConfirm() {
        // Тест проверяет инициализацию экрана с пустым номером
    }

    // MARK: - Phone Validation

    @Test("Phone with 6 digits disables confirm button")
    func phoneJustBelowMinimumDisablesConfirm() {
        // Граничное условие: 6 цифр (меньше минимума 7)
    }

    @Test("Phone with exactly 7 digits enables confirm button")
    func phoneWithMinimumLengthEnablesConfirm() {
        // Граничное условие: минимальная валидная длина
    }

    @Test("Phone with exactly 15 digits enables confirm button")
    func phoneWithMaximumLengthEnablesConfirm() {
        // Граничное условие: максимальная валидная длина
    }

    @Test("Phone with 16 digits disables confirm button")
    func phoneTooLongDisablesConfirm() {
        // Граничное условие: 16 цифр (больше максимума 15)
    }

    @Test("Phone changes update confirm button state")
    func phoneChangedUpdatesConfirmButtonState() {
        // Проверка динамического обновления состояния кнопки
    }

    @Test("Empty phone keeps confirm button disabled")
    func emptyPhoneKeepsConfirmDisabled() {
        // Edge case: переход от валидного к пустому номеру
    }

    @Test("Rapid phone changes update button state correctly")
    func rapidPhoneChangesUpdateButtonState() {
        // Edge case: множественные быстрые изменения
    }

    // MARK: - Confirm Action

    @Test("Invalid phone does not trigger auth or navigation")
    func confirmTappedWithInvalidPhoneDoesNotNavigate() {
        // Проверка guard условия
    }

    @Test("Valid phone with successful auth opens main")
    func confirmTappedSuccessOpensMain() {
        // Happy path: валидация -> прогресс -> auth success -> навигация
    }

    @Test("Auth failure shows user-facing error")
    func confirmTappedFailureShowsError() {
        // Error path: валидация -> прогресс -> auth failure -> ошибка
    }

    @Test("Multiple confirm taps with invalid phone do not trigger auth")
    func multipleConfirmTapsInvalidPhoneNoAuth() {
        // Edge case: защита от множественных вызовов с невалидными данными
    }

    // MARK: - Navigation

    @Test("Sign up action routes to sign-up screen")
    func signUpTappedOpensSignUpScreen() {
        // Проверка навигации к регистрации
    }

    // MARK: - Service Interactions

    @Test("Progress service shows and hides correctly")
    func progressServiceShowsAndHides() {
        // Проверка вызовов progress service через Spy
    }

    @Test("Error service receives correct error message")
    func errorServiceReceivesCorrectMessage() {
        // Проверка текста ошибки через Spy
    }
}

// MARK: - Spy Classes

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
```

### Что покрывают эти тесты

#### 1. View Lifecycle (1 тест)
- ✅ viewLoaded - инициализация и начальное состояние

#### 2. Phone Validation (7 тестов)
- ✅ Граничное значение: 6 цифр (невалидно)
- ✅ Граничное значение: 7 цифр (минимум валидно)
- ✅ Граничное значение: 15 цифр (максимум валидно)
- ✅ Граничное значение: 16 цифр (невалидно)
- ✅ Динамическое обновление состояния
- ✅ Переход от валидного к невалидному
- ✅ Множественные быстрые изменения

#### 3. Confirm Action (4 теста)
- ✅ Guard условие с невалидным номером
- ✅ Happy path: успешная авторизация
- ✅ Error path: неудачная авторизация
- ✅ Защита от множественных вызовов

#### 4. Navigation (1 тест)
- ✅ Переход на экран регистрации

#### 5. Service Interactions (2 теста)
- ✅ Вызовы ProgressService (show/hide)
- ✅ Передача текста ошибки в ErrorService

**Итого: 15 тестов** покрывающих все методы, edge cases и пути выполнения

### Пример одного полного теста

```swift
@Test("Valid phone with successful auth opens main")
func confirmTappedSuccessOpensMain() {
    // Given: Stub auth success path and observe progress/error side effects
    let mockView = LoginScreenViewInputMock()
    let mockRouter = LoginScreenRouterInputMock()
    let mockAuthService = AuthServiceProtocolMock()
    let progressSpy = ProgressServiceSpy()
    let errorSpy = ErrorServiceSpy()
    let presenter = LoginScreenPresenter(view: mockView, router: mockRouter)
    presenter.authService = mockAuthService
    presenter.progressService = progressSpy
    presenter.errorService = errorSpy

    // Configure auth to succeed
    Perform(mockAuthService, .login(phone: .any, completion: .any, perform: { _, completion in
        completion(.success(()))
    }))

    // When: Submit valid phone and execute confirmation action
    presenter.phoneChanged("1234567")
    presenter.confirmTapped()

    // Then: Presenter should run happy-path flow: auth -> hide loader -> route to main
    Verify(mockAuthService, .once, .login(phone: .value("1234567"), completion: .any))
    #expect(progressSpy.showCallCount == 1)
    #expect(progressSpy.hideCallCount == 1)
    Verify(mockRouter, .once, .openMainScreen())
    #expect(errorSpy.showErrorCallCount == 0)
}
```

### Использование через Ollama

```bash
cd .opencode

PRESENTER_CODE='
class LoginScreenPresenter {
    private weak var view: LoginScreenViewInput?
    private let router: LoginScreenRouterInput

    @Injected var authService: AuthServiceProtocol?
    @Injected var progressService: ProgressService?
    @Injected var errorService: ErrorService?

    private var phone: String = ""

    init(view: LoginScreenViewInput, router: LoginScreenRouterInput) {
        self.view = view
        self.router = router
    }

    private var isPhoneValid: Bool {
        return phone.count >= 7 && phone.count <= 15
    }

    private func updateConfirmState() {
        view?.updateConfirmButton(enabled: isPhoneValid)
    }
}

extension LoginScreenPresenter: LoginScreenViewOutput {
    func viewLoaded() {
        view?.setup()
        updateConfirmState()
    }

    func phoneChanged(_ phone: String) {
        self.phone = phone
        updateConfirmState()
    }

    func confirmTapped() {
        guard isPhoneValid else {
            updateConfirmState()
            return
        }

        progressService?.show()
        authService?.login(phone: phone, completion: { [weak self] result in
            self?.progressService?.hide()
            switch result {
            case .success:
                self?.router.openMainScreen()
            case .failure:
                self?.errorService?.show(errorText: "Invalid phone number")
            }
        })
    }

    func signUpTapped() {
        router.openSignUpScreen()
    }
}
'

# Генерация тестов
ollama run qwen3-coder:30b "Напиши полные unit-тесты для LoginScreenPresenter используя SwiftyMocky и Swift Testing.

КРИТИЧЕСКИ ВАЖНО - каждый тест должен содержать РЕАЛЬНЫЕ проверки:
- Используй Verify для проверки вызовов моков
- Используй #expect для проверки значений
- НЕ используй заглушки типа \"// Add assertions here\"
- НЕ используй комментарии типа \"// TODO\"

Покрой все сценарии:
1. viewLoaded - инициализация
2. phoneChanged - валидация (6, 7, 15, 16 цифр)
3. confirmTapped - успех и ошибка авторизации
4. signUpTapped - навигация

Создай Spy классы:
- ProgressServiceSpy (showCallCount, hideCallCount)
- ErrorServiceSpy (showErrorCallCount, lastErrorText)

Код презентера:
$PRESENTER_CODE" > LoginScreenPresenterTests.swift
```

### Полученный результат

После выполнения команды получится файл `LoginScreenPresenterTests.swift` с ~250-350 строк кода, включающий:

- ✅ 15+ реальных тестов
- ✅ 2 Spy класса (ProgressServiceSpy, ErrorServiceSpy)
- ✅ Given/When/Then комментарии
- ✅ Проверки через Verify и #expect
- ✅ Покрытие всех методов и edge cases
- ✅ БЕЗ заглушек и TODO

Этот пример демонстрирует полный цикл: от кода презентера до готовых comprehensive тестов за 1-2 минуты!
