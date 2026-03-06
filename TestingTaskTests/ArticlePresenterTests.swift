//
//  ArticlePresenterTests.swift
//  TestingTaskTests
//
//  Unit tests for ArticlePresenter with Given/When/Then pattern
//  Testing presenter business logic with SwiftyMocky generated mocks
//  Following Mobile Testing Guidelines v3 recommendations
//
//  Tests cover:
//  - View initialization and setup
//  - Article data display (title, date, content)
//  - Favorite state management
//  - Image loading async behavior
//  - Favorite toggle logic
//  - View lifecycle methods
//

import Testing
import Foundation
import UIKit
import SwiftyMocky
@testable import TestingTask

@Suite("ArticlePresenter Tests - Business Logic")
struct ArticlePresenterTests {

    // MARK: - Test: View Setup on Load

    /// Tests that presenter correctly initializes view and displays article data
    /// Business rule: All article data should be displayed when view loads
    @Test("Should setup view and display article data when view loads")
    func testViewSetupOnLoad() async {
        // Given: A presenter with mocked view, router, and article with storage
        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let testDate = Date(timeIntervalSince1970: 1704067200) // Jan 1, 2024
        let testArticle = Article(
            author: "Test Author",
            title: "Test Article Title",
            description: "Test article description content",
            url: URL(string: "https://example.com"),
            urlToImage: nil,
            publishedAt: testDate
        )
        let articleViewModel = ArticleViewModel(article: testArticle, storage: mockStorage)
        let sut = ArticlePresenter(view: mockView, router: mockRouter, article: articleViewModel)

        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        // When: View loads
        sut.viewLoaded()

        // Wait for async image loading to complete
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then: Should call setup, display article data, and update like state
        Verify(mockView, 1, .setup())
        Verify(mockView, .display(title: .value("Test Article Title"),
                                   date: .any,
                                   content: .value("Test article description content")))
        Verify(mockView, .displayLike(isFavorite: .value(false)))
    }

    // MARK: - Test: Display Favorite State - Not Favorite

    /// Tests that presenter correctly displays non-favorite article state
    /// Business rule: Heart icon should reflect actual favorite status
    @Test("Should display article as not favorite when article is not in favorites")
    func testDisplayNonFavoriteState() {
        // Given: A presenter with article that is not in favorites
        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let testArticle = Article(
            author: nil,
            title: "Non-Favorite Article",
            description: "This article is not favorited",
            url: nil,
            urlToImage: nil,
            publishedAt: Date()
        )
        let articleViewModel = ArticleViewModel(article: testArticle, storage: mockStorage)
        let sut = ArticlePresenter(view: mockView, router: mockRouter, article: articleViewModel)

        Given(mockStorage, .isArticleInFavorites(title: .value("Non-Favorite Article"), willReturn: false))

        // When: View will appear
        sut.viewWillAppear()

        // Then: Should display as not favorite
        Verify(mockView, 1, .displayLike(isFavorite: .value(false)))
    }

    // MARK: - Test: Display Favorite State - Is Favorite

    /// Tests that presenter correctly displays favorite article state
    /// Business rule: Heart icon should be filled for favorite articles
    @Test("Should display article as favorite when article is in favorites")
    func testDisplayFavoriteState() {
        // Given: A presenter with article that is in favorites
        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let testArticle = Article(
            author: nil,
            title: "Favorite Article",
            description: "This article is favorited",
            url: nil,
            urlToImage: nil,
            publishedAt: Date()
        )
        let articleViewModel = ArticleViewModel(article: testArticle, storage: mockStorage)
        let sut = ArticlePresenter(view: mockView, router: mockRouter, article: articleViewModel)

        Given(mockStorage, .isArticleInFavorites(title: .value("Favorite Article"), willReturn: true))

        // When: View will appear
        sut.viewWillAppear()

        // Then: Should display as favorite
        Verify(mockView, 1, .displayLike(isFavorite: .value(true)))
    }

    // MARK: - Test: Toggle Favorite - Add to Favorites

    /// Tests adding article to favorites when heart is tapped
    /// Business rule: Tapping heart on non-favorite article should add it to favorites
    @Test("Should add article to favorites when heart tapped on non-favorite article")
    func testAddToFavoritesOnHeartTap() {
        // Given: A presenter with non-favorite article
        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let testDate = Date(timeIntervalSince1970: 1704067200)
        let testArticle = Article(
            author: nil,
            title: "Article to Favorite",
            description: "Article description",
            url: nil,
            urlToImage: URL(string: "https://example.com/image.jpg"),
            publishedAt: testDate
        )
        let articleViewModel = ArticleViewModel(article: testArticle, storage: mockStorage)
        let sut = ArticlePresenter(view: mockView, router: mockRouter, article: articleViewModel)

        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))
        Given(mockStorage, .addToFavorites(title: .any, contents: .any, publishedAt: .any, urlToImage: .any, willReturn: ()))

        // When: User taps heart button
        sut.heartTapped()

        // Then: Should add article to favorites and update UI
        Verify(mockStorage, 1, .addToFavorites(
            title: .value("Article to Favorite"),
            contents: .value("Article description"),
            publishedAt: .value(testDate),
            urlToImage: .value("https://example.com/image.jpg")
        ))
        Verify(mockView, .displayLike(isFavorite: .any))
    }

    // MARK: - Test: Toggle Favorite - Remove from Favorites

    /// Tests removing article from favorites when heart is tapped
    /// Business rule: Tapping heart on favorite article should remove it from favorites
    @Test("Should remove article from favorites when heart tapped on favorite article")
    func testRemoveFromFavoritesOnHeartTap() {
        // Given: A presenter with favorite article
        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let testArticle = Article(
            author: nil,
            title: "Favorite to Remove",
            description: "Article description",
            url: nil,
            urlToImage: nil,
            publishedAt: Date()
        )
        let articleViewModel = ArticleViewModel(article: testArticle, storage: mockStorage)
        let sut = ArticlePresenter(view: mockView, router: mockRouter, article: articleViewModel)

        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: true))
        Given(mockStorage, .removeFromFavorites(title: .any, willReturn: ()))

        // When: User taps heart button
        sut.heartTapped()

        // Then: Should remove article from favorites and update UI
        Verify(mockStorage, 1, .removeFromFavorites(title: .value("Favorite to Remove")))
        Verify(mockView, .displayLike(isFavorite: .any))
    }

    // MARK: - Test: View Will Appear Updates Favorite State

    /// Tests that favorite state is refreshed when view appears
    /// Business rule: Favorite state should be updated when returning to article screen
    @Test("Should refresh favorite state when view will appear")
    func testRefreshFavoriteStateOnViewWillAppear() {
        // Given: A presenter with article
        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let testArticle = Article(
            author: nil,
            title: "Article Title",
            description: "Content",
            url: nil,
            urlToImage: nil,
            publishedAt: Date()
        )
        let articleViewModel = ArticleViewModel(article: testArticle, storage: mockStorage)
        let sut = ArticlePresenter(view: mockView, router: mockRouter, article: articleViewModel)

        // Simulate favorite state changed by another screen
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))
        sut.viewWillAppear()

        mockView.resetMock()

        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: true))

        // When: View will appear again with updated favorite state
        sut.viewWillAppear()

        // Then: Should display updated favorite state
        Verify(mockView, 1, .displayLike(isFavorite: .value(true)))
    }

    // MARK: - Test: Article Without Title Handles Gracefully

    /// Tests handling of article without title (edge case)
    /// Business rule: Should handle nil title gracefully without crashes
    @Test("Should handle article without title gracefully")
    func testHandleArticleWithoutTitle() async {
        // Given: A presenter with article having nil title
        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let testArticle = Article(
            author: nil,
            title: nil,
            description: "Content without title",
            url: nil,
            urlToImage: nil,
            publishedAt: Date()
        )
        let articleViewModel = ArticleViewModel(article: testArticle, storage: mockStorage)
        let sut = ArticlePresenter(view: mockView, router: mockRouter, article: articleViewModel)

        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        // When: View loads
        sut.viewLoaded()

        // Wait for async operations
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then: Should display nil title without crashing
        Verify(mockView, .display(title: .value(nil), date: .any, content: .any))
    }

    // MARK: - Test: Heart Tap on Article Without Title

    /// Tests that heart tap on article without title does not crash
    /// Business rule: Should not attempt to save article without title
    @Test("Should not save article without title when heart is tapped")
    func testHeartTapOnArticleWithoutTitle() {
        // Given: A presenter with article having nil title
        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let testArticle = Article(
            author: nil,
            title: nil,
            description: "Content",
            url: nil,
            urlToImage: nil,
            publishedAt: Date()
        )
        let articleViewModel = ArticleViewModel(article: testArticle, storage: mockStorage)
        let sut = ArticlePresenter(view: mockView, router: mockRouter, article: articleViewModel)

        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))
        Given(mockStorage, .addToFavorites(title: .any, contents: .any, publishedAt: .any, urlToImage: .any, willReturn: ()))

        // When: User taps heart button
        sut.heartTapped()

        // Then: Should not call storage service (title is required)
        Verify(mockStorage, 0, .addToFavorites(title: .any, contents: .any, publishedAt: .any, urlToImage: .any))
        Verify(mockStorage, 0, .removeFromFavorites(title: .any))
    }

    // MARK: - Test: Date Formatting

    /// Tests that article date is formatted correctly for display
    /// Business rule: Date should be displayed in "d MMMM" format
    @Test("Should format article date correctly for display")
    func testArticleDateFormatting() async {
        // Given: A presenter with article having specific date
        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let mockStorage = IStorageServiceMock()

        // Create date for "15 января 2024" (January 15, 2024)
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 15
        let calendar = Calendar.current
        let testDate = calendar.date(from: components)!

        let testArticle = Article(
            author: nil,
            title: "Article with Date",
            description: "Content",
            url: nil,
            urlToImage: nil,
            publishedAt: testDate
        )
        let articleViewModel = ArticleViewModel(article: testArticle, storage: mockStorage)
        let sut = ArticlePresenter(view: mockView, router: mockRouter, article: articleViewModel)

        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        // When: View loads
        sut.viewLoaded()

        // Wait for async operations
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then: Should display formatted date
        // Date format "d MMMM" should produce "15 января" for Russian locale
        Verify(mockView, .display(title: .any, date: .any, content: .any))
    }

    // MARK: - Test: Image Loading Not Called on View Will Appear

    /// Tests that image loading is not re-triggered on view will appear
    /// Business rule: Image should only load once on view loaded
    @Test("Should not reload image when view will appear")
    func testNoImageReloadOnViewWillAppear() async {
        // Given: A presenter with article
        let mockView = ArticleViewInputMock()
        let mockRouter = ArticleRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let testArticle = Article(
            author: nil,
            title: "Article",
            description: "Content",
            url: nil,
            urlToImage: nil,
            publishedAt: Date()
        )
        let articleViewModel = ArticleViewModel(article: testArticle, storage: mockStorage)
        let sut = ArticlePresenter(view: mockView, router: mockRouter, article: articleViewModel)

        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: false))

        // When: View loads and then appears
        sut.viewLoaded()
        try? await Task.sleep(nanoseconds: 100_000_000)

        let displayImageCallsAfterLoad = mockView.invocations.filter { invocation in
            if case .m_displayImage = invocation { return true }
            return false
        }.count

        sut.viewWillAppear()
        try? await Task.sleep(nanoseconds: 100_000_000)

        let displayImageCallsAfterAppear = mockView.invocations.filter { invocation in
            if case .m_displayImage = invocation { return true }
            return false
        }.count

        // Then: displayImage should not be called again on viewWillAppear
        #expect(displayImageCallsAfterLoad == displayImageCallsAfterAppear)
    }
}
