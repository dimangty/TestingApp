#!/bin/bash

# Test script for generate-presenter-tests skill using Ollama directly

PRESENTER_CONTENT=$(cat TestingTask/Core/Sources/ArticleScreen/Presenter/ArticlePresenter.swift)

PROMPT="Напиши полные unit-тесты для презентера ArticlePresenter используя SwiftyMocky и Swift Testing framework.

КРИТИЧЕСКИ ВАЖНО - каждый тест должен содержать РЕАЛЬНЫЕ проверки:
- Используй Verify для проверки вызовов моков
- Используй #expect для проверки значений
- НЕ используй заглушки типа \"// Add assertions here\"
- НЕ используй комментарии типа \"// TODO\"
- Каждая проверка должна быть полностью реализована

Требования:
1. Используй Swift Testing (@Suite, @Test)
2. Используй SwiftyMocky для моков (Given, Perform, Verify)
3. Следуй Given/When/Then паттерну в комментариях
4. Покрой ВСЕ методы презентера тестами
5. Создай Spy классы для сервисов (@Injected dependencies)
6. Тестируй edge cases (nil values, boundary conditions, multiple calls)
7. Проверь все пути выполнения (success/failure scenarios)

Структура тестов должна включать:
- View lifecycle events (viewLoaded, viewWillAppear)
- User actions (heartTapped)
- Edge cases (nil values, weak reference)
- State transitions (favorite toggling)

Пример реального теста:
\`\`\`swift
@Test(\"View load displays article data\")
func viewLoadedDisplaysArticleData() {
    // Given: Presenter with mocked dependencies
    let mockView = ArticleViewInputMock()
    let mockRouter = ArticleRouterInputMock()
    let mockArticle = ArticleViewModelMock()
    let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: mockArticle)

    Given(mockArticle, .title(getter: \"Test Title\"))
    Given(mockArticle, .publishedAt(getter: \"2024-01-01\"))
    Given(mockArticle, .contents(getter: \"Test Content\"))
    Given(mockArticle, .isFavorite(getter: false))

    // When: View is loaded
    presenter.viewLoaded()

    // Then: View displays article data
    Verify(mockView, .once, .setup())
    Verify(mockView, .once, .display(title: .value(\"Test Title\"), date: .any, content: .value(\"Test Content\")))
    Verify(mockView, .once, .displayLike(isFavorite: .value(false)))
}
\`\`\`

Код презентера:
$PRESENTER_CONTENT

Сгенерируй ПОЛНЫЙ файл с тестами, включая:
1. Imports
2. @Suite с тестами
3. Spy классы в конце файла (если нужны)

ВАЖНО: Каждый тест ДОЛЖЕН содержать реальные Verify и #expect проверки, а не заглушки!"

echo "Testing generate-presenter-tests skill with ArticlePresenter..."
echo "=================================================================="
echo ""

ollama run qwen3-coder:30b "$PROMPT" > .opencode/generated-article-presenter-tests.swift

echo "Tests generated and saved to .opencode/generated-article-presenter-tests.swift"
echo ""
echo "First 100 lines of generated tests:"
head -100 .opencode/generated-article-presenter-tests.swift
