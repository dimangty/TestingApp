# Quick Start Guide - Генерация тестов презентеров

## Быстрая генерация тестов для любого презентера

### За 3 шага к полному набору тестов!

---

## Шаг 1: Анализ презентера (опционально)

```bash
cd .opencode

# Замените путь на ваш презентер
PRESENTER_PATH="../TestingTask/Core/Sources/YourScreen/Presenter/YourPresenter.swift"
PRESENTER_CONTENT=$(cat $PRESENTER_PATH)

# Анализ структуры
ollama run qwen3-coder:30b "Проанализируй презентер и выведи:
- Публичные методы
- Зависимости (@Injected)
- Edge cases для тестирования

Код:
$PRESENTER_CONTENT"
```

---

## Шаг 2: Генерация тестов

```bash
# Замените путь на ваш презентер
PRESENTER_PATH="../TestingTask/Core/Sources/YourScreen/Presenter/YourPresenter.swift"
PRESENTER_NAME="YourPresenter"
PRESENTER_CONTENT=$(cat $PRESENTER_PATH)

# Генерация тестов
ollama run qwen3-coder:30b "Напиши полные unit-тесты для презентера $PRESENTER_NAME используя SwiftyMocky и Swift Testing.

ВАЖНО:
1. Используй Swift Testing (@Suite, @Test)
2. Создай Spy классы для @Injected сервисов
3. Используй Given/When/Then паттерн
4. Покрой ВСЕ методы и edge cases
5. НЕ используй заглушки - только реальные проверки

Код презентера:
$PRESENTER_CONTENT" > ${PRESENTER_NAME}Tests.swift
```

---

## Шаг 3: Интеграция в проект

```bash
# Скопировать сгенерированные тесты
cp ${PRESENTER_NAME}Tests.swift ../TestingTaskTests/

# Исправить module name (если нужно)
sed -i '' 's/@testable import YourApp/@testable import TestingTask/g' \
   ../TestingTaskTests/${PRESENTER_NAME}Tests.swift
```

---

## Готовые скрипты

### Анализ ArticlePresenter
```bash
cd .opencode && ./test-analyze-presenter.sh
```

### Генерация тестов для ArticlePresenter
```bash
cd .opencode && ./test-generate-tests.sh
```

### Комплексный тест всех скилов
```bash
cd .opencode && ./test-all.sh
```

---

## Примеры использования

### Пример 1: NewsPresenter

```bash
cd .opencode

PRESENTER=$(cat ../TestingTask/Core/Sources/NewsScreen/Presenter/NewsPresenter.swift)

ollama run qwen3-coder:30b "Напиши полные unit-тесты для NewsPresenter используя SwiftyMocky и Swift Testing.

Требования:
- Swift Testing (@Suite, @Test)
- Spy классы для сервисов
- Given/When/Then
- Покрыть все методы
- Реальные проверки

Код:
$PRESENTER" > NewsPresenterTests.swift

# Копируем в проект
cp NewsPresenterTests.swift ../TestingTaskTests/
```

### Пример 2: LoginScreenPresenter

```bash
cd .opencode

PRESENTER=$(cat ../TestingTask/Core/Sources/LoginScreen/Presenter/LoginScreenPresenter.swift)

ollama run qwen3-coder:30b "Напиши полные unit-тесты для LoginScreenPresenter используя SwiftyMocky и Swift Testing.

Требования:
- Swift Testing (@Suite, @Test)
- Spy классы для ProgressService, ErrorService, AuthService
- Given/When/Then
- Покрыть все методы и edge cases
- Реальные проверки

Код:
$PRESENTER" > LoginScreenPresenterTests.swift

cp LoginScreenPresenterTests.swift ../TestingTaskTests/
```

---

## Структура сгенерированных тестов

```swift
import Testing
import SwiftyMocky
@testable import TestingTask

// MARK: - Spy Classes

final class YourViewInputSpy: YourViewInput {
    var setupCalled = false
    // ... другие свойства

    func setup() {
        setupCalled = true
    }
    // ... другие методы
}

// MARK: - Tests

@Suite("YourPresenter Tests")
struct YourPresenterTests {

    @Test("Description of test")
    func testMethodName() {
        // Given: Setup
        let mockView = YourViewInputSpy()
        let presenter = YourPresenter(view: mockView)

        // When: Action
        presenter.someMethod()

        // Then: Assertions
        #expect(mockView.setupCalled == true)
    }
}
```

---

## Что генерируется?

✅ **Imports** - Testing, SwiftyMocky, testable import
✅ **Spy классы** - для всех @Injected зависимостей
✅ **Suite** - группировка тестов
✅ **Tests** - для всех методов презентера
✅ **Edge cases** - nil values, boundary conditions
✅ **Given/When/Then** - четкая структура
✅ **Assertions** - #expect с реальными проверками

---

## Проверка работы

```bash
# Проверить что Ollama работает
ollama list | grep qwen3-coder

# Должно вывести:
# qwen3-coder:30b   ...   18 GB   ...

# Запустить тестовую генерацию
cd .opencode && ./test-all.sh
```

---

## Troubleshooting

### Ollama не отвечает
```bash
ollama serve &
ollama list
```

### Тесты не компилируются
1. Проверьте `@testable import TestingTask`
2. Убедитесь что SwiftyMocky настроен
3. Проверьте что протоколы помечены `@Mockable`

### Долгая генерация
- Попробуйте qwen2.5-coder:14b для быстрой генерации
- Генерируйте тесты для одного метода за раз

---

## Полная документация

📖 **Подробные промты**: SCRIPT_PROMPT_TEST_Example.md
📖 **Руководство по настройке**: TESTING_SETUP_GUIDE.md
📖 **Документация скилов**: .opencode/README.md

---

## Результат

🎉 **Полный набор тестов за 1-2 минуты!**

- ✅ Покрытие всех методов
- ✅ Edge cases
- ✅ Spy классы
- ✅ Given/When/Then
- ✅ Реальные проверки
- ✅ Без заглушек

---

**Готово к использованию! 🚀**
