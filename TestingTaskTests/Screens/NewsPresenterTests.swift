//
//  NewsPresenterTests.swift
//  TestingTaskTests
//
//  Unit tests for NewsPresenter
//  Following Mobile Testing Guidelines v3 - Given/When/Then pattern
//
//  Tests cover:
//  - View lifecycle events (viewLoaded, viewWillAppear)
//  - News loading with success and failure
//  - Search/filter functionality
//  - Article selection and navigation
//  - Favorite management
//  - Loading state management
//  - Error handling
//  - Storage observer pattern
//

import Foundation
import Testing
import SwiftyMocky
@testable import XCTestTask

@Suite("News Presenter Tests")
struct NewsPresenterTests {

    // MARK: - Helper: Create test news data

    /// Helper function to create test news source
    func createTestNewsSource(articleCount: Int = 3) -> NewsSource {
        let articles = (1...articleCount).map { index in
            Article(
                author: "Author \(index)",
                title: "Article \(index)",
                description: "Description \(index)",
                url: URL(string: "https://example.com/\(index)"),
                urlToImage: nil,
                publishedAt: Date(timeIntervalSince1970: TimeInterval(index * 1000))
            )
        }

        return NewsSource(status: "ok", totalResults: articleCount, articles: articles)
    }

    @Test("View load successfully loads and displays news")
    func viewLoadedLoadsNewsSuccessfully() async throws {
        // Given: Presenter with mocked dependencies
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockNewsService = NewsServiceMock()
        let mockStorage = IStorageServiceMock()
        let mockErrorService = ErrorServiceMock()

        // Configure news service to return success
        let testNewsSource = createTestNewsSource(articleCount: 3)
        Given(mockNewsService, .performNewsRequest(completion: .any, willInvoke: { completion in
            completion(.success(testNewsSource))
        }))

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        TestConfigurator.registerService(service: mockNewsService)
        TestConfigurator.registerService(service: mockStorage as StorageService)
        TestConfigurator.registerService(service: mockErrorService as ErrorService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)

        // When: View is loaded
        presenter.viewLoaded()

        // Wait for async completion
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds

        // Then: Loading shown, news fetched, loading hidden, data reloaded
        Verify(mockView, 1, .setup())
        Verify(mockView, 1, .showLoading(.value(true)))
        Verify(mockNewsService, 1, .performNewsRequest(completion: .any))
        Verify(mockView, 1, .showLoading(.value(false)))
        Verify(mockView, 1, .reloadData())
    }

    @Test("View load handles news loading failure and shows error")
    func viewLoadedNewsLoadingFailsShowsError() async throws {
        // Given: Presenter with mocked dependencies
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockNewsService = NewsServiceMock()
        let mockStorage = IStorageServiceMock()
        let mockErrorService = ErrorServiceMock()

        // Configure news service to return failure
        let testError = NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        Given(mockNewsService, .performNewsRequest(completion: .any, willInvoke: { completion in
            completion(.failure(testError))
        }))

        Given(mockStorage, .articles(getter: []))

        TestConfigurator.registerService(service: mockNewsService)
        TestConfigurator.registerService(service: mockStorage as StorageService)
        TestConfigurator.registerService(service: mockErrorService as ErrorService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)

        // When: View is loaded
        presenter.viewLoaded()

        // Wait for async completion
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds

        // Then: Loading shown, error displayed, loading hidden
        Verify(mockView, 1, .showLoading(.value(true)))
        Verify(mockView, 1, .showLoading(.value(false)))
        Verify(mockErrorService, 1, .show(errorText: .value("Network error")))
    }

    @Test("Number of rows returns correct article count")
    func numberOfRowsReturnsCorrectCount() async throws {
        // Given: Presenter with loaded news
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockNewsService = NewsServiceMock()
        let mockStorage = IStorageServiceMock()
        let mockErrorService = ErrorServiceMock()

        let testNewsSource = createTestNewsSource(articleCount: 5)
        Given(mockNewsService, .performNewsRequest(completion: .any, willInvoke: { completion in
            completion(.success(testNewsSource))
        }))

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        TestConfigurator.registerService(service: mockNewsService)
        TestConfigurator.registerService(service: mockStorage as StorageService)
        TestConfigurator.registerService(service: mockErrorService as ErrorService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        // Wait for async completion
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds

        // When: Number of rows is requested
        let count = presenter.numberOfRows()

        // Then: Count equals number of articles
        #expect(count == 5)
    }

    @Test("Article at indexPath returns correct article")
    func articleAtIndexPathReturnsCorrectArticle() async throws {
        // Given: Presenter with loaded news
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockNewsService = NewsServiceMock()
        let mockStorage = IStorageServiceMock()
        let mockErrorService = ErrorServiceMock()

        let testNewsSource = createTestNewsSource(articleCount: 3)
        Given(mockNewsService, .performNewsRequest(completion: .any, willInvoke: { completion in
            completion(.success(testNewsSource))
        }))

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        TestConfigurator.registerService(service: mockNewsService)
        TestConfigurator.registerService(service: mockStorage as StorageService)
        TestConfigurator.registerService(service: mockErrorService as ErrorService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds

        // When: Article at index 1 is requested
        let articleViewModel = presenter.article(at: IndexPath(row: 1, section: 0))

        // Then: Second article is returned
        #expect(articleViewModel.title == "Article 2")
    }

    @Test("Select row navigates to article detail")
    func didSelectRowNavigatesToArticle() async throws {
        // Given: Presenter with loaded news
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockNewsService = NewsServiceMock()
        let mockStorage = IStorageServiceMock()
        let mockErrorService = ErrorServiceMock()

        let testNewsSource = createTestNewsSource(articleCount: 2)
        Given(mockNewsService, .performNewsRequest(completion: .any, willInvoke: { completion in
            completion(.success(testNewsSource))
        }))

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        TestConfigurator.registerService(service: mockNewsService)
        TestConfigurator.registerService(service: mockStorage as StorageService)
        TestConfigurator.registerService(service: mockErrorService as ErrorService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds

        // When: Row is selected
        presenter.didSelectRow(at: IndexPath(row: 0, section: 0))

        // Then: Router navigates to article
        Verify(mockRouter, 1, .openArticle(article: .matching({ $0.title == "Article 1" })))
    }

    @Test("Tap favorite toggles state and updates view")
    func didTapFavoriteTogglesStateAndUpdatesView() async throws {
        // Given: Presenter with loaded news
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockNewsService = NewsServiceMock()
        let mockStorage = IStorageServiceMock()
        let mockErrorService = ErrorServiceMock()

        let testNewsSource = createTestNewsSource(articleCount: 2)
        Given(mockNewsService, .performNewsRequest(completion: .any, willInvoke: { completion in
            completion(.success(testNewsSource))
        }))

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        TestConfigurator.registerService(service: mockNewsService)
        TestConfigurator.registerService(service: mockStorage as StorageService)
        TestConfigurator.registerService(service: mockErrorService as ErrorService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds

        mockView.resetMock() // Clear previous calls

        // When: Favorite icon is tapped
        presenter.didTapFavorite(at: IndexPath(row: 0, section: 0))

        // Then: Storage is called and view is updated
        Verify(mockStorage, 1, .addToFavorites(title: .value("Article 1"), contents: .any, publishedAt: .any, urlToImage: .any))
        Verify(mockView, 1, .updateFavorite(at: .value(IndexPath(row: 0, section: 0))))
    }

    @Test("Search with matching text filters articles")
    func didUpdateSearchMatchingTextFiltersArticles() async throws {
        // Given: Presenter with loaded news
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockNewsService = NewsServiceMock()
        let mockStorage = IStorageServiceMock()
        let mockErrorService = ErrorServiceMock()

        // Create articles with different titles for filtering
        let articles = [
            Article(author: "A", title: "Apple News", description: "D1", url: nil, urlToImage: nil, publishedAt: Date()),
            Article(author: "B", title: "Banana Update", description: "D2", url: nil, urlToImage: nil, publishedAt: Date()),
            Article(author: "C", title: "Apple Product", description: "D3", url: nil, urlToImage: nil, publishedAt: Date())
        ]
        let testNewsSource = NewsSource(status: "ok", totalResults: 3, articles: articles)

        Given(mockNewsService, .performNewsRequest(completion: .any, willInvoke: { completion in
            completion(.success(testNewsSource))
        }))

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        TestConfigurator.registerService(service: mockNewsService)
        TestConfigurator.registerService(service: mockStorage as StorageService)
        TestConfigurator.registerService(service: mockErrorService as ErrorService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds

        // When: Search is updated with "apple"
        presenter.didUpdateSearch(text: "apple")

        // Then: Only 2 articles with "apple" in title are shown
        let count = presenter.numberOfRows()
        #expect(count == 2)
    }

    @Test("Search with empty text shows all articles")
    func didUpdateSearchEmptyTextShowsAllArticles() async throws {
        // Given: Presenter with loaded news
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockNewsService = NewsServiceMock()
        let mockStorage = IStorageServiceMock()
        let mockErrorService = ErrorServiceMock()

        let testNewsSource = createTestNewsSource(articleCount: 5)
        Given(mockNewsService, .performNewsRequest(completion: .any, willInvoke: { completion in
            completion(.success(testNewsSource))
        }))

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        TestConfigurator.registerService(service: mockNewsService)
        TestConfigurator.registerService(service: mockStorage as StorageService)
        TestConfigurator.registerService(service: mockErrorService as ErrorService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds

        // When: Search is updated with empty text
        presenter.didUpdateSearch(text: "")

        // Then: All articles are shown
        let count = presenter.numberOfRows()
        #expect(count == 5)
    }

    @Test("Search is case-insensitive")
    func didUpdateSearchCaseInsensitive() async throws {
        // Given: Presenter with loaded news
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockNewsService = NewsServiceMock()
        let mockStorage = IStorageServiceMock()
        let mockErrorService = ErrorServiceMock()

        let articles = [
            Article(author: "A", title: "IMPORTANT News", description: "D", url: nil, urlToImage: nil, publishedAt: Date())
        ]
        let testNewsSource = NewsSource(status: "ok", totalResults: 1, articles: articles)

        Given(mockNewsService, .performNewsRequest(completion: .any, willInvoke: { completion in
            completion(.success(testNewsSource))
        }))

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        TestConfigurator.registerService(service: mockNewsService)
        TestConfigurator.registerService(service: mockStorage as StorageService)
        TestConfigurator.registerService(service: mockErrorService as ErrorService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds

        // When: Search is updated with lowercase "important"
        presenter.didUpdateSearch(text: "important")

        // Then: Article with uppercase "IMPORTANT" is found
        let count = presenter.numberOfRows()
        #expect(count == 1)
    }

    @Test("View will appear updates selected cell")
    func viewWillAppearUpdatesSelectedCell() {
        // Given: Presenter
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockNewsService = NewsServiceMock()
        let mockStorage = IStorageServiceMock()
        let mockErrorService = ErrorServiceMock()

        Given(mockStorage, .articles(getter: []))

        TestConfigurator.registerService(service: mockNewsService)
        TestConfigurator.registerService(service: mockStorage as StorageService)
        TestConfigurator.registerService(service: mockErrorService as ErrorService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)

        // When: View will appear
        presenter.viewWillAppear()

        // Then: Selected cell is updated
        Verify(mockView, 1, .updateSelectedCell())
    }

    @Test("Observer removing from favorites updates view")
    func didRemoveFromFavoritesUpdatesView() async throws {
        // Given: Presenter with loaded news
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockNewsService = NewsServiceMock()
        let mockStorage = IStorageServiceMock()
        let mockErrorService = ErrorServiceMock()

        let testNewsSource = createTestNewsSource(articleCount: 3)
        Given(mockNewsService, .performNewsRequest(completion: .any, willInvoke: { completion in
            completion(.success(testNewsSource))
        }))

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        TestConfigurator.registerService(service: mockNewsService)
        TestConfigurator.registerService(service: mockStorage as StorageService)
        TestConfigurator.registerService(service: mockErrorService as ErrorService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds

        mockView.resetMock() // Clear previous calls

        // When: Article is removed from favorites (observer notification)
        presenter.didRemoveFromFavorites(title: "Article 2")

        // Then: View updates favorite icon for that article
        Verify(mockView, 1, .updateFavorite(at: .value(IndexPath(row: 1, section: 0))))
    }

    @Test("Initialization registers presenter as storage observer")
    func initRegistersAsStorageObserver() {
        // Given: Mock storage
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockStorage = IStorageServiceMock()

        Given(mockStorage, .articles(getter: []))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        // When: Presenter is initialized
        _ = NewsPresenter(view: mockView, router: mockRouter)

        // Then: Presenter is registered as observer
        Verify(mockStorage, 1, .addObserver(.any))
    }

    @Test("Search with whitespace-only text shows all articles")
    func didUpdateSearchWithWhitespaceOnlyShowsAllArticles() async throws {
        // Given: Presenter with loaded news
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockNewsService = NewsServiceMock()
        let mockStorage = IStorageServiceMock()
        let mockErrorService = ErrorServiceMock()

        let testNewsSource = createTestNewsSource(articleCount: 5)
        Given(mockNewsService, .performNewsRequest(completion: .any, willInvoke: { completion in
            completion(.success(testNewsSource))
        }))

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        TestConfigurator.registerService(service: mockNewsService)
        TestConfigurator.registerService(service: mockStorage as StorageService)
        TestConfigurator.registerService(service: mockErrorService as ErrorService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        try await Task.sleep(nanoseconds: 200_000_000)

        // When: Search is updated with whitespace only
        presenter.didUpdateSearch(text: "   ")

        // Then: All articles are shown (whitespace is trimmed)
        let count = presenter.numberOfRows()
        #expect(count == 5)
    }

    @Test("Search filters persist across multiple updates")
    func multipleSearchUpdatesFilterCorrectly() async throws {
        // Given: Presenter with articles containing different keywords
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockNewsService = NewsServiceMock()
        let mockStorage = IStorageServiceMock()
        let mockErrorService = ErrorServiceMock()

        let articles = [
            Article(author: "A", title: "Apple News", description: "D1", url: nil, urlToImage: nil, publishedAt: Date()),
            Article(author: "B", title: "Banana Update", description: "D2", url: nil, urlToImage: nil, publishedAt: Date()),
            Article(author: "C", title: "Cherry Report", description: "D3", url: nil, urlToImage: nil, publishedAt: Date())
        ]
        let testNewsSource = NewsSource(status: "ok", totalResults: 3, articles: articles)

        Given(mockNewsService, .performNewsRequest(completion: .any, willInvoke: { completion in
            completion(.success(testNewsSource))
        }))

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        TestConfigurator.registerService(service: mockNewsService)
        TestConfigurator.registerService(service: mockStorage as StorageService)
        TestConfigurator.registerService(service: mockErrorService as ErrorService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        try await Task.sleep(nanoseconds: 200_000_000)

        // When: Multiple searches are performed
        presenter.didUpdateSearch(text: "apple")
        let appleCount = presenter.numberOfRows()

        presenter.didUpdateSearch(text: "banana")
        let bananaCount = presenter.numberOfRows()

        presenter.didUpdateSearch(text: "xyz")
        let noMatchCount = presenter.numberOfRows()

        // Then: Each search filters correctly
        #expect(appleCount == 1)
        #expect(bananaCount == 1)
        #expect(noMatchCount == 0)
    }

    @Test("Observer didAddToFavorites does not update view")
    func didAddToFavoritesDoesNotUpdateView() async throws {
        // Given: Presenter with loaded news
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockNewsService = NewsServiceMock()
        let mockStorage = IStorageServiceMock()
        let mockErrorService = ErrorServiceMock()

        let testNewsSource = createTestNewsSource(articleCount: 2)
        Given(mockNewsService, .performNewsRequest(completion: .any, willInvoke: { completion in
            completion(.success(testNewsSource))
        }))

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        TestConfigurator.registerService(service: mockNewsService)
        TestConfigurator.registerService(service: mockStorage as StorageService)
        TestConfigurator.registerService(service: mockErrorService as ErrorService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        try await Task.sleep(nanoseconds: 200_000_000)

        mockView.resetMock()

        // When: Article is added to favorites (observer notification)
        let article = ArticleEntity()
        article.title = "New Favorite"
        presenter.didAddToFavorites(article: article)

        // Then: View is not updated (implementation is empty)
        Verify(mockView, .never, .updateFavorite(at: .any))
        Verify(mockView, .never, .reloadData())
    }

    @Test("Multiple tap favorite on same article updates view each time")
    func multipleTapFavoriteUpdatesViewEachTime() async throws {
        // Given: Presenter with loaded news
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockNewsService = NewsServiceMock()
        let mockStorage = IStorageServiceMock()
        let mockErrorService = ErrorServiceMock()

        let testNewsSource = createTestNewsSource(articleCount: 2)
        Given(mockNewsService, .performNewsRequest(completion: .any, willInvoke: { completion in
            completion(.success(testNewsSource))
        }))

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        TestConfigurator.registerService(service: mockNewsService)
        TestConfigurator.registerService(service: mockStorage as StorageService)
        TestConfigurator.registerService(service: mockErrorService as ErrorService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        try await Task.sleep(nanoseconds: 200_000_000)

        mockView.resetMock()

        // When: Favorite is tapped multiple times
        let indexPath = IndexPath(row: 0, section: 0)
        presenter.didTapFavorite(at: indexPath)
        presenter.didTapFavorite(at: indexPath)
        presenter.didTapFavorite(at: indexPath)

        // Then: View is updated three times
        Verify(mockView, 3, .updateFavorite(at: .value(indexPath)))
    }

    @Test("Number of rows returns zero when no articles loaded")
    func numberOfRowsReturnsZeroWhenNoArticlesLoaded() {
        // Given: Presenter without loading articles
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockStorage = IStorageServiceMock()

        Given(mockStorage, .articles(getter: []))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)

        // When: Number of rows is requested without loading
        let count = presenter.numberOfRows()

        // Then: Count is zero
        #expect(count == 0)
    }

    @Test("Search with special characters filters correctly")
    func didUpdateSearchWithSpecialCharactersFiltersCorrectly() async throws {
        // Given: Presenter with articles containing special characters
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockNewsService = NewsServiceMock()
        let mockStorage = IStorageServiceMock()
        let mockErrorService = ErrorServiceMock()

        let articles = [
            Article(author: "A", title: "C++ Programming", description: "D1", url: nil, urlToImage: nil, publishedAt: Date()),
            Article(author: "B", title: "Swift & Objective-C", description: "D2", url: nil, urlToImage: nil, publishedAt: Date())
        ]
        let testNewsSource = NewsSource(status: "ok", totalResults: 2, articles: articles)

        Given(mockNewsService, .performNewsRequest(completion: .any, willInvoke: { completion in
            completion(.success(testNewsSource))
        }))

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        TestConfigurator.registerService(service: mockNewsService)
        TestConfigurator.registerService(service: mockStorage as StorageService)
        TestConfigurator.registerService(service: mockErrorService as ErrorService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        try await Task.sleep(nanoseconds: 200_000_000)

        // When: Search is updated with special characters
        presenter.didUpdateSearch(text: "C++")

        // Then: Article with C++ is found
        let count = presenter.numberOfRows()
        #expect(count == 1)
    }

    @Test("Selecting filtered article navigates correctly")
    func selectingFilteredArticleNavigatesCorrectly() async throws {
        // Given: Presenter with filtered articles
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockNewsService = NewsServiceMock()
        let mockStorage = IStorageServiceMock()
        let mockErrorService = ErrorServiceMock()

        let articles = [
            Article(author: "A", title: "Apple News", description: "D1", url: nil, urlToImage: nil, publishedAt: Date()),
            Article(author: "B", title: "Banana Update", description: "D2", url: nil, urlToImage: nil, publishedAt: Date()),
            Article(author: "C", title: "Apple Product", description: "D3", url: nil, urlToImage: nil, publishedAt: Date())
        ]
        let testNewsSource = NewsSource(status: "ok", totalResults: 3, articles: articles)

        Given(mockNewsService, .performNewsRequest(completion: .any, willInvoke: { completion in
            completion(.success(testNewsSource))
        }))

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        TestConfigurator.registerService(service: mockNewsService)
        TestConfigurator.registerService(service: mockStorage as StorageService)
        TestConfigurator.registerService(service: mockErrorService as ErrorService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        try await Task.sleep(nanoseconds: 200_000_000)

        // Apply filter
        presenter.didUpdateSearch(text: "apple")

        // When: Filtered row is selected
        presenter.didSelectRow(at: IndexPath(row: 0, section: 0))

        // Then: Router navigates to the correct filtered article
        Verify(mockRouter, 1, .openArticle(article: .matching({ $0.title == "Apple News" })))
    }

    @Test("View will appear called multiple times updates cell each time")
    func multipleViewWillAppearUpdatesCell() {
        // Given: Presenter
        TestConfigurator.setupForTesting()
        let mockView = NewsViewInputMock()
        let mockRouter = NewsRouterInputMock()
        let mockStorage = IStorageServiceMock()

        Given(mockStorage, .articles(getter: []))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        let presenter = NewsPresenter(view: mockView, router: mockRouter)

        // When: View will appear is called multiple times
        presenter.viewWillAppear()
        presenter.viewWillAppear()
        presenter.viewWillAppear()

        // Then: Selected cell is updated three times
        Verify(mockView, 3, .updateSelectedCell())
    }
}
