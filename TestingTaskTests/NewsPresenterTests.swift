//
//  NewsPresenterTests.swift
//  TestingTaskTests
//
//  Unit tests for NewsPresenter with Given/When/Then pattern
//  Testing presenter business logic with mocked dependencies
//

import Testing
import Foundation
@testable import TestingTask

@Suite("NewsPresenter Tests")
struct NewsPresenterTests {

    // MARK: - Test: View Setup and Load Articles
    @Test("Should setup view, register storage observer and load articles on view load")
    func testViewSetupAndLoadArticles() async {
        // Given: A presenter with mocked dependencies
        let mockView = MockNewsView()
        let mockRouter = MockNewsRouter()
        let mockNews = MockNewsService()
        let mockStorage = MockStorageService()

        let sut = NewsPresenter(view: mockView, router: mockRouter)
        sut.newsService = mockNews
        sut.storage = mockStorage

        let sampleArticle = Article(
            author: "Test Author",
            title: "Test Title",
            description: "Test Description",
            url: URL(string: "https://example.com"),
            urlToImage: nil,
            publishedAt: Date()
        )
        let sampleNews = NewsSource(status: "ok", totalResults: 1, articles: [sampleArticle])

        mockNews.performNewsRequestClosure = { completion in
            DispatchQueue.main.async {
                completion(.success(sampleNews))
            }
        }

        // When: View loads
        sut.viewLoaded()

        // Wait for async loading
        try? await Task.sleep(nanoseconds: 200_000_000)

        // Then: Should setup view, add storage observer, show loading, and reload data
        #expect(mockView.setupCallCount == 1)
        #expect(mockStorage.addObserverCallCount == 1)
        #expect(mockView.showLoadingReceivedInvocations.contains(true))
        #expect(mockView.showLoadingReceivedInvocations.contains(false))
        #expect(mockView.reloadDataCallCount == 1)
        #expect(mockNews.performNewsRequestCallCount == 1)
    }

    // MARK: - Test: Load Articles Success
    @Test("Should load and display articles on successful news request")
    func testLoadArticlesSuccess() async {
        // Given: A presenter with mocked dependencies
        let mockView = MockNewsView()
        let mockRouter = MockNewsRouter()
        let mockNews = MockNewsService()
        let mockStorage = MockStorageService()

        let sut = NewsPresenter(view: mockView, router: mockRouter)
        sut.newsService = mockNews
        sut.storage = mockStorage

        let articles = [
            Article(author: "Author 1", title: "Title 1", description: "Desc 1", url: nil, urlToImage: nil, publishedAt: Date()),
            Article(author: "Author 2", title: "Title 2", description: "Desc 2", url: nil, urlToImage: nil, publishedAt: Date())
        ]
        let newsSource = NewsSource(status: "ok", totalResults: 2, articles: articles)

        mockNews.performNewsRequestClosure = { completion in
            DispatchQueue.main.async {
                completion(.success(newsSource))
            }
        }

        // When: View loads
        sut.viewLoaded()

        // Wait for async loading
        try? await Task.sleep(nanoseconds: 200_000_000)

        // Then: Should have 2 articles
        #expect(sut.numberOfRows() == 2)
    }

    // MARK: - Test: Load Articles Failure
    @Test("Should show error on failed news request")
    func testLoadArticlesFailure() async {
        // Given: A presenter with mocked dependencies
        let mockView = MockNewsView()
        let mockRouter = MockNewsRouter()
        let mockNews = MockNewsService()
        let mockStorage = MockStorageService()
        let mockError = MockErrorService()

        let sut = NewsPresenter(view: mockView, router: mockRouter)
        sut.newsService = mockNews
        sut.storage = mockStorage
        sut.errorService = mockError

        mockNews.performNewsRequestClosure = { completion in
            DispatchQueue.main.async {
                completion(.failure(ErrorResponse(message: "Network error")))
            }
        }

        // When: View loads
        sut.viewLoaded()

        // Wait for async loading
        try? await Task.sleep(nanoseconds: 200_000_000)

        // Then: Should hide loading and show error
        #expect(mockView.showLoadingReceivedInvocations.contains(false))
        #expect(mockError.showErrorTextCallCount == 1)
        #expect(sut.numberOfRows() == 0)
    }

    // MARK: - Test: Number of Rows
    @Test("Should return correct number of rows")
    func testNumberOfRows() async {
        // Given: A presenter with loaded articles
        let mockView = MockNewsView()
        let mockRouter = MockNewsRouter()
        let mockNews = MockNewsService()
        let mockStorage = MockStorageService()

        let sut = NewsPresenter(view: mockView, router: mockRouter)
        sut.newsService = mockNews
        sut.storage = mockStorage

        let articles = (1...5).map { i in
            Article(author: "Author \(i)", title: "Title \(i)", description: "Desc \(i)", url: nil, urlToImage: nil, publishedAt: Date())
        }
        let newsSource = NewsSource(status: "ok", totalResults: 5, articles: articles)

        mockNews.performNewsRequestClosure = { completion in
            DispatchQueue.main.async {
                completion(.success(newsSource))
            }
        }

        sut.viewLoaded()

        // Wait for async loading
        try? await Task.sleep(nanoseconds: 200_000_000)

        // When: Getting number of rows
        let count = sut.numberOfRows()

        // Then: Should return 5
        #expect(count == 5)
    }

    // MARK: - Test: Get Article at IndexPath
    @Test("Should return correct article at indexPath")
    func testArticleAtIndexPath() async {
        // Given: A presenter with loaded articles
        let mockView = MockNewsView()
        let mockRouter = MockNewsRouter()
        let mockNews = MockNewsService()
        let mockStorage = MockStorageService()

        let sut = NewsPresenter(view: mockView, router: mockRouter)
        sut.newsService = mockNews
        sut.storage = mockStorage

        let articles = [
            Article(author: "Author 1", title: "Title 1", description: "Desc 1", url: nil, urlToImage: nil, publishedAt: Date()),
            Article(author: "Author 2", title: "Title 2", description: "Desc 2", url: nil, urlToImage: nil, publishedAt: Date())
        ]
        let newsSource = NewsSource(status: "ok", totalResults: 2, articles: articles)

        mockNews.performNewsRequestClosure = { completion in
            DispatchQueue.main.async {
                completion(.success(newsSource))
            }
        }

        sut.viewLoaded()

        // Wait for async loading
        try? await Task.sleep(nanoseconds: 200_000_000)

        // When: Getting article at index 1
        let article = sut.article(at: IndexPath(row: 1, section: 0))

        // Then: Should return the second article
        #expect(article.title == "Title 2")
    }

    // MARK: - Test: Select Article Navigation
    @Test("Should navigate to article detail when row is selected")
    func testSelectArticleNavigation() async {
        // Given: A presenter with loaded articles
        let mockView = MockNewsView()
        let mockRouter = MockNewsRouter()
        let mockNews = MockNewsService()
        let mockStorage = MockStorageService()

        let sut = NewsPresenter(view: mockView, router: mockRouter)
        sut.newsService = mockNews
        sut.storage = mockStorage

        let articles = [
            Article(author: "Author 1", title: "Title 1", description: "Desc 1", url: nil, urlToImage: nil, publishedAt: Date())
        ]
        let newsSource = NewsSource(status: "ok", totalResults: 1, articles: articles)

        mockNews.performNewsRequestClosure = { completion in
            DispatchQueue.main.async {
                completion(.success(newsSource))
            }
        }

        sut.viewLoaded()

        // Wait for async loading
        try? await Task.sleep(nanoseconds: 200_000_000)

        // When: User selects row
        sut.didSelectRow(at: IndexPath(row: 0, section: 0))

        // Then: Should navigate to article detail
        #expect(mockRouter.openArticleCallCount == 1)
        #expect(mockRouter.openArticleReceivedArticle?.title == "Title 1")
    }

    // MARK: - Test: Search Filter - Empty Query
    @Test("Should show all articles when search text is empty")
    func testSearchFilterEmptyQuery() async {
        // Given: A presenter with loaded articles
        let mockView = MockNewsView()
        let mockRouter = MockNewsRouter()
        let mockNews = MockNewsService()
        let mockStorage = MockStorageService()

        let sut = NewsPresenter(view: mockView, router: mockRouter)
        sut.newsService = mockNews
        sut.storage = mockStorage

        let articles = [
            Article(author: "Author 1", title: "Swift Programming", description: "Desc 1", url: nil, urlToImage: nil, publishedAt: Date()),
            Article(author: "Author 2", title: "Kotlin Guide", description: "Desc 2", url: nil, urlToImage: nil, publishedAt: Date())
        ]
        let newsSource = NewsSource(status: "ok", totalResults: 2, articles: articles)

        mockNews.performNewsRequestClosure = { completion in
            DispatchQueue.main.async {
                completion(.success(newsSource))
            }
        }

        sut.viewLoaded()

        // Wait for async loading
        try? await Task.sleep(nanoseconds: 200_000_000)

        mockView.reset()

        // When: User enters empty search text
        sut.didUpdateSearch(text: "")

        // Then: Should show all articles
        #expect(sut.numberOfRows() == 2)
        #expect(mockView.reloadDataCallCount == 1)
    }

    // MARK: - Test: Search Filter - Matching Query
    @Test("Should filter articles by search text")
    func testSearchFilterMatchingQuery() async {
        // Given: A presenter with loaded articles
        let mockView = MockNewsView()
        let mockRouter = MockNewsRouter()
        let mockNews = MockNewsService()
        let mockStorage = MockStorageService()

        let sut = NewsPresenter(view: mockView, router: mockRouter)
        sut.newsService = mockNews
        sut.storage = mockStorage

        let articles = [
            Article(author: "Author 1", title: "Swift Programming", description: "Desc 1", url: nil, urlToImage: nil, publishedAt: Date()),
            Article(author: "Author 2", title: "Kotlin Guide", description: "Desc 2", url: nil, urlToImage: nil, publishedAt: Date()),
            Article(author: "Author 3", title: "Swift Advanced", description: "Desc 3", url: nil, urlToImage: nil, publishedAt: Date())
        ]
        let newsSource = NewsSource(status: "ok", totalResults: 3, articles: articles)

        mockNews.performNewsRequestClosure = { completion in
            DispatchQueue.main.async {
                completion(.success(newsSource))
            }
        }

        sut.viewLoaded()

        // Wait for async loading
        try? await Task.sleep(nanoseconds: 200_000_000)

        // When: User searches for "Swift"
        sut.didUpdateSearch(text: "Swift")

        // Then: Should show only 2 Swift articles
        #expect(sut.numberOfRows() == 2)
        #expect(sut.article(at: IndexPath(row: 0, section: 0)).title?.contains("Swift") == true)
    }

    // MARK: - Test: Search Filter - Case Insensitive
    @Test("Should filter articles case-insensitively")
    func testSearchFilterCaseInsensitive() async {
        // Given: A presenter with loaded articles
        let mockView = MockNewsView()
        let mockRouter = MockNewsRouter()
        let mockNews = MockNewsService()
        let mockStorage = MockStorageService()

        let sut = NewsPresenter(view: mockView, router: mockRouter)
        sut.newsService = mockNews
        sut.storage = mockStorage

        let articles = [
            Article(author: "Author 1", title: "SWIFT Programming", description: "Desc 1", url: nil, urlToImage: nil, publishedAt: Date()),
            Article(author: "Author 2", title: "Kotlin Guide", description: "Desc 2", url: nil, urlToImage: nil, publishedAt: Date())
        ]
        let newsSource = NewsSource(status: "ok", totalResults: 2, articles: articles)

        mockNews.performNewsRequestClosure = { completion in
            DispatchQueue.main.async {
                completion(.success(newsSource))
            }
        }

        sut.viewLoaded()

        // Wait for async loading
        try? await Task.sleep(nanoseconds: 200_000_000)

        // When: User searches for lowercase "swift"
        sut.didUpdateSearch(text: "swift")

        // Then: Should find the article with uppercase "SWIFT"
        #expect(sut.numberOfRows() == 1)
    }

    // MARK: - Test: Search Filter - No Matches
    @Test("Should show no articles when search has no matches")
    func testSearchFilterNoMatches() async {
        // Given: A presenter with loaded articles
        let mockView = MockNewsView()
        let mockRouter = MockNewsRouter()
        let mockNews = MockNewsService()
        let mockStorage = MockStorageService()

        let sut = NewsPresenter(view: mockView, router: mockRouter)
        sut.newsService = mockNews
        sut.storage = mockStorage

        let articles = [
            Article(author: "Author 1", title: "Swift Programming", description: "Desc 1", url: nil, urlToImage: nil, publishedAt: Date()),
            Article(author: "Author 2", title: "Kotlin Guide", description: "Desc 2", url: nil, urlToImage: nil, publishedAt: Date())
        ]
        let newsSource = NewsSource(status: "ok", totalResults: 2, articles: articles)

        mockNews.performNewsRequestClosure = { completion in
            DispatchQueue.main.async {
                completion(.success(newsSource))
            }
        }

        sut.viewLoaded()

        // Wait for async loading
        try? await Task.sleep(nanoseconds: 200_000_000)

        // When: User searches for non-existent term
        sut.didUpdateSearch(text: "Python")

        // Then: Should show no articles
        #expect(sut.numberOfRows() == 0)
    }

    // MARK: - Test: View Will Appear
    @Test("Should update selected cell when view will appear")
    func testViewWillAppear() {
        // Given: A presenter with mocked view
        let mockView = MockNewsView()
        let mockRouter = MockNewsRouter()
        let sut = NewsPresenter(view: mockView, router: mockRouter)

        // When: View will appear
        sut.viewWillAppear()

        // Then: Should update selected cell
        #expect(mockView.updateSelectedCellCallCount == 1)
    }

    // MARK: - Test: Tap Favorite
    @Test("Should update favorite state when favorite button is tapped")
    func testTapFavorite() async {
        // Given: A presenter with loaded articles
        let mockView = MockNewsView()
        let mockRouter = MockNewsRouter()
        let mockNews = MockNewsService()
        let mockStorage = MockStorageService()

        let sut = NewsPresenter(view: mockView, router: mockRouter)
        sut.newsService = mockNews
        sut.storage = mockStorage

        let articles = [
            Article(author: "Author 1", title: "Title 1", description: "Desc 1", url: nil, urlToImage: nil, publishedAt: Date())
        ]
        let newsSource = NewsSource(status: "ok", totalResults: 1, articles: articles)

        mockNews.performNewsRequestClosure = { completion in
            DispatchQueue.main.async {
                completion(.success(newsSource))
            }
        }

        sut.viewLoaded()

        // Wait for async loading
        try? await Task.sleep(nanoseconds: 200_000_000)

        mockView.reset()

        // When: User taps favorite
        let indexPath = IndexPath(row: 0, section: 0)
        sut.didTapFavorite(at: indexPath)

        // Then: Should update favorite in view
        #expect(mockView.updateFavoriteCallCount == 1)
        #expect(mockView.updateFavoriteReceivedIndexPath == indexPath)
    }
}
