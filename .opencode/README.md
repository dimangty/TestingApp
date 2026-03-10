# OpenCode Skills для тестирования презентеров

Этот проект содержит набор навыков (skills) для автоматической генерации comprehensive unit-тестов презентеров с использованием SwiftyMocky и Swift Testing framework.

## Установка

1. Убедитесь, что у вас установлены:
   - opencode-desktop
   - ollama
   - qwen3-coder:30b

2. Проверьте что Ollama запущена:
```bash
ollama list
```

3. Скилы находятся в директории `.opencode/skills/`

## Доступные скилы

### 1. analyze-presenter
Анализирует презентер и выводит детальную информацию для написания тестов.

**Использование через opencode-cli:**
```bash
opencode-cli --skill analyze-presenter \
  --param presenter_content="$(cat TestingTask/Core/Sources/LoginScreen/Presenter/LoginScreenPresenter.swift)"
```

**Что выводит:**
- Публичные методы (ViewOutput)
- Зависимости (@Injected)
- Приватные методы и свойства
- Протоколы (View, Router)
- Пути выполнения
- Edge cases для тестирования
- Необходимые Spy классы
- Методы View и Router протоколов
- Async операции

### 2. generate-presenter-tests
Генерирует полные unit-тесты для презентера.

**Использование:**
```bash
opencode-cli --skill generate-presenter-tests \
  --param presenter_file="TestingTask/Core/Sources/LoginScreen/Presenter/LoginScreenPresenter.swift" \
  --param presenter_content="$(cat TestingTask/Core/Sources/LoginScreen/Presenter/LoginScreenPresenter.swift)" \
  --param test_output_path="TestingTaskTests/LoginScreenPresenterTests.swift"
```

**Что генерирует:**
- Тесты для всех lifecycle методов (viewLoaded, viewWillAppear)
- Тесты для всех user actions (buttonTapped, textChanged)
- Тесты валидации
- Тесты навигации
- Тесты обработки ошибок
- Edge cases
- Spy классы для сервисов

### 3. create-spy-classes
Создает Spy классы для всех @Injected сервисов в презентере.

**Использование:**
```bash
opencode-cli --skill create-spy-classes \
  --param presenter_content="$(cat TestingTask/Core/Sources/LoginScreen/Presenter/LoginScreenPresenter.swift)"
```

**Что генерирует:**
- Spy классы с счетчиками вызовов
- Хранение последних параметров
- Полная реализация протоколов

### 4. check-test-coverage
Проверяет покрытие тестов и предлагает недостающие тесты.

**Использование:**
```bash
opencode-cli --skill check-test-coverage \
  --param presenter_content="$(cat TestingTask/Core/Sources/LoginScreen/Presenter/LoginScreenPresenter.swift)" \
  --param test_content="$(cat TestingTaskTests/LoginScreenPresenterTests.swift)"
```

**Что проверяет:**
- Покрытие всех публичных методов
- Покрытие всех веток условий
- Покрытие async операций
- Покрытие вызовов view/router/services
- Edge cases
- Переходы состояний

**Что выводит:**
- ✅ Покрыто тестами
- ❌ Не покрыто тестами
- 📝 Рекомендации по улучшению
- 📊 Статистика покрытия

### 5. test-specific-method
Генерирует comprehensive тесты для конкретного метода презентера.

**Использование:**
```bash
opencode-cli --skill test-specific-method \
  --param method_name="confirmTapped" \
  --param presenter_content="$(cat TestingTask/Core/Sources/LoginScreen/Presenter/LoginScreenPresenter.swift)"
```

**Что генерирует:**
- 5-10 тестов для метода
- Happy path
- Error paths
- Edge cases
- Invalid input
- Nil values
- Multiple calls
- State transitions

## Примеры использования

### Пример 1: Полный цикл тестирования нового презентера

```bash
# Шаг 1: Анализируем презентер
opencode-cli --skill analyze-presenter \
  --param presenter_content="$(cat TestingTask/Core/Sources/ArticleScreen/Presenter/ArticlePresenter.swift)" \
  > article_analysis.txt

# Шаг 2: Генерируем тесты
opencode-cli --skill generate-presenter-tests \
  --param presenter_file="TestingTask/Core/Sources/ArticleScreen/Presenter/ArticlePresenter.swift" \
  --param presenter_content="$(cat TestingTask/Core/Sources/ArticleScreen/Presenter/ArticlePresenter.swift)" \
  --param test_output_path="TestingTaskTests/ArticlePresenterTests.swift"

# Шаг 3: Проверяем покрытие
opencode-cli --skill check-test-coverage \
  --param presenter_content="$(cat TestingTask/Core/Sources/ArticleScreen/Presenter/ArticlePresenter.swift)" \
  --param test_content="$(cat TestingTaskTests/ArticlePresenterTests.swift)"
```

### Пример 2: Улучшение существующих тестов

```bash
# Проверяем текущее покрытие
opencode-cli --skill check-test-coverage \
  --param presenter_content="$(cat TestingTask/Core/Sources/LoginScreen/Presenter/LoginScreenPresenter.swift)" \
  --param test_content="$(cat TestingTaskTests/LoginScreenPresenterTests.swift)"

# Генерируем тесты для непокрытого метода
opencode-cli --skill test-specific-method \
  --param method_name="phoneChanged" \
  --param presenter_content="$(cat TestingTask/Core/Sources/LoginScreen/Presenter/LoginScreenPresenter.swift)"
```

### Пример 3: Создание Spy классов

```bash
# Генерируем Spy классы
opencode-cli --skill create-spy-classes \
  --param presenter_content="$(cat TestingTask/Core/Sources/NewsScreen/Presenter/NewsPresenter.swift)"

# Сохраняем в файл
opencode-cli --skill create-spy-classes \
  --param presenter_content="$(cat TestingTask/Core/Sources/NewsScreen/Presenter/NewsPresenter.swift)" \
  > TestingTaskTests/Spies/NewsPresenterSpies.swift
```

## Структура генерируемых тестов

Все тесты следуют единому паттерну:

```swift
import Foundation
import Testing
import SwiftyMocky
@testable import TestingTask

@Suite("{PresenterName} Tests")
struct {PresenterName}Tests {

    @Test("Description of test scenario")
    func testMethodName_scenario_expectedBehavior() {
        // Given: Setup with mocked dependencies
        let mockView = {ScreenName}ViewInputMock()
        let mockRouter = {ScreenName}RouterInputMock()
        let presenter = {PresenterName}(view: mockView, router: mockRouter)

        // When: Execute action being tested
        presenter.someMethod()

        // Then: Verify expected behavior
        Verify(mockView, .once, .expectedMethod())
        #expect(actualValue == expectedValue)
    }
}

// MARK: - Spy Classes

private final class ServiceSpy: IService {
    private(set) var methodCallCount = 0

    func method() {
        methodCallCount += 1
    }
}
```

## Best Practices

1. **Всегда анализируйте презентер сначала** - используйте `analyze-presenter` перед генерацией тестов
2. **Проверяйте покрытие** - используйте `check-test-coverage` после написания тестов
3. **Тестируйте edge cases** - генерируйте дополнительные тесты для граничных случаев
4. **Используйте Spy для сервисов** - создавайте Spy классы вместо моков для @Injected зависимостей
5. **Один тест - один аспект** - каждый тест должен проверять только одно поведение
6. **Given/When/Then** - всегда используйте этот паттерн в комментариях

## Конфигурация модели

Все скилы используют:
- **Model**: qwen3-coder:30b
- **Temperature**: 0.2-0.3 (для детерминированных результатов)

## Troubleshooting

### Ollama не отвечает
```bash
# Проверьте что Ollama запущена
ollama serve

# Проверьте наличие модели
ollama list | grep qwen3-coder
```

### Скил не найден
```bash
# Проверьте что файлы скилов существуют
ls -la .opencode/skills/

# Проверьте права доступа
chmod +x .opencode/skills/*.skill
```

### Некорректный вывод
- Убедитесь что используется правильная версия модели (qwen3-coder:30b)
- Проверьте что файл презентера корректен
- Увеличьте timeout для больших презентеров

## Документация

Подробная документация по промтам находится в файле:
```
SCRIPT_PROMPT_TEST_Example.md
```

## Контакты

Для вопросов и предложений создавайте issue в репозитории проекта.
