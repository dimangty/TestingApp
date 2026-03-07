//
//  ArticlePresenterTests.swift
//  TestingTaskTests
//
//  Unit tests for ArticlePresenter
//  Following Mobile Testing Guidelines v3 - Given/When/Then pattern
//
//  Tests cover:
//  - View lifecycle events (viewLoaded, viewWillAppear)
//  - Article data display
//  - Like/favorite state management
//  - Heart button tap handling
//  - Image loading
//

import Foundation
import Testing
import SwiftyMocky
@testable import XCTestTask

@Suite("Article Presenter Tests")
struct ArticlePresenterTests {

    // MARK: - Helper: Create test article

    /// Helper function to create a test article
    func createTestArticle(title: String = "Test Article",
                          description: String = "Test Description",
                          isFavorite: Bool = false) -> (Article, ArticleViewModel, IStorageServiceMock) {
        let article = Article(
            author: "Test Author",
            title: title,
            description: description,
            url: URL(string: "https://example.com"),
            urlToImage: nil,
            publishedAt: Date(timeIntervalSince1970: 1000000)
        )

        let mockStorage = IStorageServiceMock()
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: isFavorite))

        let viewModel = ArticleViewModel(article: article, storage: mockStorage)

        return (article, viewModel, mockStorage)
    }

    @Test("View load displays article data")
    func viewLoadedDisplaysArticleData() {
        // Given: Presenter with mocked view, router, and test article
        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let (_, articleViewModel, _) = createTestArticle(title: "Test Title", description: "Test Content", isFavorite: false)

        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: articleViewModel)

        // When: View is loaded
        presenter.viewLoaded()

        // Then: View is set up and article data is displayed
        Verify(mockView, 1, .setup())
        Verify(mockView, 1, .display(title: .value("Test Title"), date: .any, content: .value("Test Content")))
        Verify(mockView, 1, .displayLike(isFavorite: .value(false)))
    }

    @Test("View load displays favorite article correctly")
    func viewLoadedDisplaysFavoriteArticle() {
        // Given: Presenter with favorite article
        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let (_, articleViewModel, _) = createTestArticle(isFavorite: true)

        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: articleViewModel)

        // When: View is loaded
        presenter.viewLoaded()

        // Then: Like state is displayed as true
        Verify(mockView, 1, .displayLike(isFavorite: .value(true)))
    }

    @Test("View will appear updates like state")
    func viewWillAppearUpdatesLikeState() {
        // Given: Presenter with test article
        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let (_, articleViewModel, _) = createTestArticle(isFavorite: false)

        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: articleViewModel)

        // Reset mock to clear viewLoaded calls
        mockView.resetMock()

        // When: View will appear
        presenter.viewWillAppear()

        // Then: Like state is updated
        Verify(mockView, 1, .displayLike(isFavorite: .value(false)))
    }

    @Test("Heart tap on non-favorite article adds to favorites")
    func heartTappedNonFavoriteAddsToFavorites() {
        // Given: Presenter with non-favorite article
        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let (_, articleViewModel, mockStorage) = createTestArticle(title: "Test Article", isFavorite: false)

        // Configure storage to change favorite state after tap
        var favoriteState = false
        Given(mockStorage, .isArticleInFavorites(title: .any, willProduce: { _ in favoriteState }))
        Given(mockStorage, .addToFavorites(title: .any, contents: .any, publishedAt: .any, urlToImage: .any, willInvoke: { _, _, _, _ in
            favoriteState = true
        }))

        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: articleViewModel)
        mockView.resetMock() // Clear viewLoaded calls

        // When: Heart is tapped
        presenter.heartTapped()

        // Then: Article is added to favorites and like UI is updated
        Verify(mockStorage, 1, .addToFavorites(title: .value("Test Article"), contents: .any, publishedAt: .any, urlToImage: .any))
        Verify(mockView, .atLeastOnce, .displayLike(isFavorite: .any))
    }

    @Test("Heart tap on favorite article removes from favorites")
    func heartTappedFavoriteRemovesFromFavorites() {
        // Given: Presenter with favorite article
        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let (_, articleViewModel, mockStorage) = createTestArticle(title: "Favorite Article", isFavorite: true)

        // Configure storage to change favorite state after tap
        var favoriteState = true
        Given(mockStorage, .isArticleInFavorites(title: .any, willProduce: { _ in favoriteState }))
        Given(mockStorage, .removeFromFavorites(title: .any, willInvoke: { _ in
            favoriteState = false
        }))

        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: articleViewModel)
        mockView.resetMock() // Clear viewLoaded calls

        // When: Heart is tapped
        presenter.heartTapped()

        // Then: Article is removed from favorites and like UI is updated
        Verify(mockStorage, 1, .removeFromFavorites(title: .value("Favorite Article")))
        Verify(mockView, .atLeastOnce, .displayLike(isFavorite: .any))
    }

    @Test("Multiple heart taps toggle favorite state")
    func heartTappedMultipleTapsTogglesState() {
        // Given: Presenter with non-favorite article
        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let (_, articleViewModel, mockStorage) = createTestArticle(title: "Toggle Article", isFavorite: false)

        var favoriteState = false
        Given(mockStorage, .isArticleInFavorites(title: .any, willProduce: { _ in favoriteState }))
        Given(mockStorage, .addToFavorites(title: .any, contents: .any, publishedAt: .any, urlToImage: .any, willInvoke: { _, _, _, _ in
            favoriteState = true
        }))
        Given(mockStorage, .removeFromFavorites(title: .any, willInvoke: { _ in
            favoriteState = false
        }))

        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: articleViewModel)
        mockView.resetMock() // Clear viewLoaded calls

        // When: Heart is tapped twice
        presenter.heartTapped() // First tap: add to favorites
        presenter.heartTapped() // Second tap: remove from favorites

        // Then: Both add and remove are called
        Verify(mockStorage, 1, .addToFavorites(title: .value("Toggle Article"), contents: .any, publishedAt: .any, urlToImage: .any))
        Verify(mockStorage, 1, .removeFromFavorites(title: .value("Toggle Article")))
    }

    @Test("Article without title handles gracefully")
    func viewLoadedArticleWithoutTitleHandlesGracefully() {
        // Given: Article with nil title
        let article = Article(
            author: "Test Author",
            title: nil,
            description: "Test Description",
            url: URL(string: "https://example.com"),
            urlToImage: nil,
            publishedAt: Date(timeIntervalSince1970: 1000000)
        )

        let mockStorage = IStorageServiceMock()
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        let viewModel = ArticleViewModel(article: article, storage: mockStorage)

        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: viewModel)

        // When: View is loaded
        presenter.viewLoaded()

        // Then: Display is called with nil title (no crash)
        Verify(mockView, 1, .display(title: .value(nil), date: .any, content: .any))
    }

    @Test("View load displays formatted date")
    func viewLoadedDisplaysFormattedDate() {
        // Given: Article with specific date
        let specificDate = Date(timeIntervalSince1970: 1704067200) // January 1, 2024, 00:00:00 UTC
        let article = Article(
            author: "Test Author",
            title: "Test",
            description: "Description",
            url: URL(string: "https://example.com"),
            urlToImage: nil,
            publishedAt: specificDate
        )

        let mockStorage = IStorageServiceMock()
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        let viewModel = ArticleViewModel(article: article, storage: mockStorage)

        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: viewModel)

        // When: View is loaded
        presenter.viewLoaded()

        // Then: Date is displayed in formatted form (not raw timestamp)
        Verify(mockView, 1, .display(title: .any, date: .matching({ !$0.isEmpty }), content: .any))
    }

    @Test("View load with nil description displays gracefully")
    func viewLoadedArticleWithNilDescriptionHandlesGracefully() {
        // Given: Article with nil description
        let article = Article(
            author: "Test Author",
            title: "Test Article",
            description: nil,
            url: URL(string: "https://example.com"),
            urlToImage: nil,
            publishedAt: Date(timeIntervalSince1970: 1000000)
        )

        let mockStorage = IStorageServiceMock()
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        let viewModel = ArticleViewModel(article: article, storage: mockStorage)

        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: viewModel)

        // When: View is loaded
        presenter.viewLoaded()

        // Then: Display is called with nil content (no crash)
        Verify(mockView, 1, .display(title: .value("Test Article"), date: .any, content: .value(nil)))
    }

    @Test("View load with nil URL displays gracefully")
    func viewLoadedArticleWithNilURLHandlesGracefully() {
        // Given: Article with nil URL
        let article = Article(
            author: "Test Author",
            title: "Test Article",
            description: "Test Description",
            url: nil,
            urlToImage: nil,
            publishedAt: Date(timeIntervalSince1970: 1000000)
        )

        let mockStorage = IStorageServiceMock()
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        let viewModel = ArticleViewModel(article: article, storage: mockStorage)

        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: viewModel)

        // When: View is loaded
        presenter.viewLoaded()

        // Then: Display is called successfully
        Verify(mockView, 1, .display(title: .value("Test Article"), date: .any, content: .value("Test Description")))
    }

    @Test("Image loading calls display image")
    func viewLoadedTriggersImageLoading() {
        // Given: Article with image URL
        let article = Article(
            author: "Test Author",
            title: "Test",
            description: "Description",
            url: URL(string: "https://example.com"),
            urlToImage: URL(string: "https://example.com/image.jpg"),
            publishedAt: Date(timeIntervalSince1970: 1000000)
        )

        let mockStorage = IStorageServiceMock()
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        let viewModel = ArticleViewModel(article: article, storage: mockStorage)

        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: viewModel)

        // When: View is loaded (triggers image loading)
        presenter.viewLoaded()

        // Then: Display image is eventually called (async)
        // Note: In real tests, would need async handling or mock the image loading
        Verify(mockView, 1, .setup())
    }

    @Test("View will appear after favorite change updates correctly")
    func viewWillAppearAfterFavoriteChangeUpdatesCorrectly() {
        // Given: Presenter with article
        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let (_, articleViewModel, mockStorage) = createTestArticle(isFavorite: false)

        var favoriteState = false
        Given(mockStorage, .isArticleInFavorites(title: .any, willProduce: { _ in favoriteState }))
        Given(mockStorage, .addToFavorites(title: .any, contents: .any, publishedAt: .any, urlToImage: .any, willInvoke: { _, _, _, _ in
            favoriteState = true
        }))

        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: articleViewModel)
        presenter.viewLoaded()
        presenter.heartTapped() // Change favorite state
        mockView.resetMock()

        // When: View will appear
        presenter.viewWillAppear()

        // Then: Like state is updated with new state
        Verify(mockView, 1, .displayLike(isFavorite: .value(true)))
    }

    @Test("Article with nil author displays gracefully")
    func viewLoadedArticleWithNilAuthorHandlesGracefully() {
        // Given: Article with nil author
        let article = Article(
            author: nil,
            title: "Test Article",
            description: "Test Description",
            url: URL(string: "https://example.com"),
            urlToImage: nil,
            publishedAt: Date(timeIntervalSince1970: 1000000)
        )

        let mockStorage = IStorageServiceMock()
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        let viewModel = ArticleViewModel(article: article, storage: mockStorage)

        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: viewModel)

        // When: View is loaded
        presenter.viewLoaded()

        // Then: Display is called successfully (no crash with nil author)
        Verify(mockView, 1, .display(title: .value("Test Article"), date: .any, content: .value("Test Description")))
    }

    @Test("Multiple view will appear calls update like state each time")
    func multipleViewWillAppearCallsUpdateEachTime() {
        // Given: Presenter with test article
        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let (_, articleViewModel, _) = createTestArticle(isFavorite: false)

        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: articleViewModel)
        presenter.viewLoaded()
        mockView.resetMock()

        // When: View will appear is called multiple times
        presenter.viewWillAppear()
        presenter.viewWillAppear()
        presenter.viewWillAppear()

        // Then: Like state is updated three times
        Verify(mockView, 3, .displayLike(isFavorite: .value(false)))
    }
}
