//
//  FavoritePresenterTests.swift
//  TestingTaskTests
//
//  Unit tests for FavoritePresenter with Given/When/Then pattern
//  Testing presenter business logic with SwiftyMocky generated mocks
//  Following Mobile Testing Guidelines v3 recommendations
//
//  Tests cover:
//  - View initialization and setup
//  - Loading favorites from storage
//  - Empty state display logic
//  - Article list management
//  - Navigation to article detail
//  - Favorite toggle functionality
//  - Observer pattern (add/remove notifications)
//  - IndexPath-based operations
//

import Testing
import Foundation
import SwiftyMocky
@testable import TestingTask

@Suite("FavoritePresenter Tests - Business Logic")
struct FavoritePresenterTests {

    // MARK: - Test: View Setup on Load with Empty Favorites

    /// Tests that presenter correctly initializes view with empty favorites list
    /// Business rule: Should show empty state when no favorites exist
    @Test("Should setup view and show empty state when no favorites exist")
    func testViewSetupWithEmptyFavorites() {
        // Given: A presenter with empty favorites list
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .addObserver(.any, willReturn: ()))

        let sut = FavoritePresenter(view: mockView, router: mockRouter)
        sut._storage = mockStorage

        // When: View loads
        sut.viewLoaded()

        // Then: Should setup view, reload data, and show empty state
        Verify(mockView, 1, .setup())
        Verify(mockView, 1, .reloadData())
        Verify(mockView, 1, .showEmptyState(.value(true)))
    }

    // MARK: - Test: View Setup on Load with Favorites

    /// Tests that presenter correctly initializes view with existing favorites
    /// Business rule: Should hide empty state and display favorites list
    @Test("Should setup view and hide empty state when favorites exist")
    func testViewSetupWithFavorites() {
        // Given: A presenter with favorites in storage
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        // Create mock ArticleEntity
        let mockArticle = createMockArticleEntity(
            title: "Favorite Article",
            contents: "Content",
            publishedAt: Date(),
            urlToImage: nil
        )

        Given(mockStorage, .articles(getter: [mockArticle]))
        Given(mockStorage, .addObserver(.any, willReturn: ()))

        let sut = FavoritePresenter(view: mockView, router: mockRouter)
        sut._storage = mockStorage

        // When: View loads
        sut.viewLoaded()

        // Then: Should setup view, reload data, and hide empty state
        Verify(mockView, 1, .setup())
        Verify(mockView, 1, .reloadData())
        Verify(mockView, 1, .showEmptyState(.value(false)))
    }

    // MARK: - Test: Number of Rows with Empty List

    /// Tests that presenter returns zero rows when favorites list is empty
    /// Business rule: numberOfRows should match articles count
    @Test("Should return zero rows when favorites list is empty")
    func testNumberOfRowsWithEmptyList() {
        // Given: A presenter with empty favorites list
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .addObserver(.any, willReturn: ()))

        let sut = FavoritePresenter(view: mockView, router: mockRouter)
        sut._storage = mockStorage
        sut.viewLoaded()

        // When: Asking for number of rows
        let rowCount = sut.numberOfRows()

        // Then: Should return 0
        #expect(rowCount == 0)
    }

    // MARK: - Test: Number of Rows with Multiple Favorites

    /// Tests that presenter returns correct count when favorites exist
    /// Business rule: numberOfRows should equal articles array count
    @Test("Should return correct number of rows when favorites exist")
    func testNumberOfRowsWithMultipleFavorites() {
        // Given: A presenter with 3 favorites in storage
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article1 = createMockArticleEntity(title: "Article 1", contents: "Content 1", publishedAt: Date(), urlToImage: nil)
        let article2 = createMockArticleEntity(title: "Article 2", contents: "Content 2", publishedAt: Date(), urlToImage: nil)
        let article3 = createMockArticleEntity(title: "Article 3", contents: "Content 3", publishedAt: Date(), urlToImage: nil)

        Given(mockStorage, .articles(getter: [article1, article2, article3]))
        Given(mockStorage, .addObserver(.any, willReturn: ()))

        let sut = FavoritePresenter(view: mockView, router: mockRouter)
        sut._storage = mockStorage
        sut.viewLoaded()

        // When: Asking for number of rows
        let rowCount = sut.numberOfRows()

        // Then: Should return 3
        #expect(rowCount == 3)
    }

    // MARK: - Test: Get Article at Index

    /// Tests that presenter returns correct article at specified index
    /// Business rule: article(at:) should return the article at given IndexPath
    @Test("Should return correct article at specified index")
    func testGetArticleAtIndex() {
        // Given: A presenter with multiple favorites
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article1 = createMockArticleEntity(title: "First Article", contents: "Content 1", publishedAt: Date(), urlToImage: nil)
        let article2 = createMockArticleEntity(title: "Second Article", contents: "Content 2", publishedAt: Date(), urlToImage: nil)

        Given(mockStorage, .articles(getter: [article1, article2]))
        Given(mockStorage, .addObserver(.any, willReturn: ()))

        let sut = FavoritePresenter(view: mockView, router: mockRouter)
        sut._storage = mockStorage
        sut.viewLoaded()

        // When: Getting article at index 1
        let indexPath = IndexPath(row: 1, section: 0)
        let article = sut.article(at: indexPath)

        // Then: Should return article with title "Second Article"
        #expect(article.title == "Second Article")
    }

    // MARK: - Test: Navigate to Article on Selection

    /// Tests that presenter navigates to article detail when row is selected
    /// Business rule: didSelectRow should open article screen via router
    @Test("Should navigate to article detail when row is selected")
    func testNavigateToArticleOnSelection() {
        // Given: A presenter with favorite article
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article = createMockArticleEntity(title: "Selected Article", contents: "Content", publishedAt: Date(), urlToImage: nil)

        Given(mockStorage, .articles(getter: [article]))
        Given(mockStorage, .addObserver(.any, willReturn: ()))
        Given(mockRouter, .openArticle(article: .any, willReturn: ()))

        let sut = FavoritePresenter(view: mockView, router: mockRouter)
        sut._storage = mockStorage
        sut.viewLoaded()

        // When: User selects row at index 0
        let indexPath = IndexPath(row: 0, section: 0)
        sut.didSelectRow(at: indexPath)

        // Then: Should open article via router
        Verify(mockRouter, 1, .openArticle(article: .any))
    }

    // MARK: - Test: Toggle Favorite at Index

    /// Tests that presenter toggles favorite state when favorite button is tapped
    /// Business rule: didTapFavorite should add/remove article from favorites
    @Test("Should toggle favorite state when favorite button is tapped")
    func testToggleFavoriteAtIndex() {
        // Given: A presenter with favorite article
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article = createMockArticleEntity(title: "Article to Unfavorite", contents: "Content", publishedAt: Date(), urlToImage: nil)

        Given(mockStorage, .articles(getter: [article]))
        Given(mockStorage, .addObserver(.any, willReturn: ()))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: true))
        Given(mockStorage, .removeFromFavorites(title: .any, willReturn: ()))

        let sut = FavoritePresenter(view: mockView, router: mockRouter)
        sut._storage = mockStorage
        sut.viewLoaded()

        // When: User taps favorite button at index 0
        let indexPath = IndexPath(row: 0, section: 0)
        sut.didTapFavorite(at: indexPath)

        // Then: Should toggle favorite state (article is favorite, so it should be removed)
        Verify(mockStorage, .removeFromFavorites(title: .value("Article to Unfavorite")))
    }

    // MARK: - Test: View Will Appear Reloads Data

    /// Tests that presenter reloads favorites when view appears
    /// Business rule: Favorites list should refresh when returning to screen
    @Test("Should reload favorites when view will appear")
    func testReloadFavoritesOnViewWillAppear() {
        // Given: A presenter with initial favorites
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article = createMockArticleEntity(title: "Article", contents: "Content", publishedAt: Date(), urlToImage: nil)

        Given(mockStorage, .articles(getter: [article]))
        Given(mockStorage, .addObserver(.any, willReturn: ()))

        let sut = FavoritePresenter(view: mockView, router: mockRouter)
        sut._storage = mockStorage
        sut.viewLoaded()

        mockView.resetMock()

        // When: View will appear
        sut.viewWillAppear()

        // Then: Should reload data and update selected cell
        Verify(mockView, 1, .reloadData())
        Verify(mockView, 1, .updateSelectedCell())
    }

    // MARK: - Test: Observer - Article Removed from Favorites

    /// Tests that presenter updates list when article is removed via observer
    /// Business rule: Should reload data and show empty state if list becomes empty
    @Test("Should update view when article is removed via observer notification")
    func testObserverArticleRemovedFromFavorites() {
        // Given: A presenter with one favorite article
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article = createMockArticleEntity(title: "Article to Remove", contents: "Content", publishedAt: Date(), urlToImage: nil)

        Given(mockStorage, .articles(getter: [article]))
        Given(mockStorage, .addObserver(.any, willReturn: ()))

        let sut = FavoritePresenter(view: mockView, router: mockRouter)
        sut._storage = mockStorage
        sut.viewLoaded()

        mockView.resetMock()

        // Update storage to return empty list after removal
        Given(mockStorage, .articles(getter: []))

        // When: Observer receives article removed notification
        sut.didRemoveFromFavorites(title: "Article to Remove")

        // Then: Should reload data and show empty state
        Verify(mockView, 1, .reloadData())
        Verify(mockView, 1, .showEmptyState(.value(true)))
    }

    // MARK: - Test: Observer - Article Removed Not in List

    /// Tests that presenter handles removal of article not in current list
    /// Business rule: Should not crash or update view if article is not in list
    @Test("Should handle removal notification for article not in list")
    func testObserverArticleRemovedNotInList() {
        // Given: A presenter with favorite articles
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article1 = createMockArticleEntity(title: "Article 1", contents: "Content 1", publishedAt: Date(), urlToImage: nil)
        let article2 = createMockArticleEntity(title: "Article 2", contents: "Content 2", publishedAt: Date(), urlToImage: nil)

        Given(mockStorage, .articles(getter: [article1, article2]))
        Given(mockStorage, .addObserver(.any, willReturn: ()))

        let sut = FavoritePresenter(view: mockView, router: mockRouter)
        sut._storage = mockStorage
        sut.viewLoaded()

        mockView.resetMock()

        // When: Observer receives removal notification for non-existent article
        sut.didRemoveFromFavorites(title: "Non-existent Article")

        // Then: Should not reload data (article not in list)
        Verify(mockView, 0, .reloadData())
        #expect(sut.numberOfRows() == 2)
    }

    // MARK: - Test: Observer - Article Added to Favorites

    /// Tests that presenter reloads favorites when new article is added
    /// Business rule: Should refresh list to include newly added favorite
    @Test("Should reload favorites when article is added via observer notification")
    func testObserverArticleAddedToFavorites() {
        // Given: A presenter with empty favorites
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .addObserver(.any, willReturn: ()))

        let sut = FavoritePresenter(view: mockView, router: mockRouter)
        sut._storage = mockStorage
        sut.viewLoaded()

        mockView.resetMock()

        // Update storage to return article after addition
        let newArticle = createMockArticleEntity(title: "New Article", contents: "Content", publishedAt: Date(), urlToImage: nil)
        Given(mockStorage, .articles(getter: [newArticle]))

        // When: Observer receives article added notification
        sut.didAddToFavorites(article: newArticle)

        // Then: Should reload data and hide empty state
        Verify(mockView, 1, .reloadData())
        Verify(mockView, 1, .showEmptyState(.value(false)))
    }

    // MARK: - Test: Multiple Articles Removed Updates Count

    /// Tests that presenter correctly updates count when multiple articles are removed
    /// Business rule: numberOfRows should decrease as articles are removed
    @Test("Should correctly update count when multiple articles are removed")
    func testMultipleArticlesRemovedUpdatesCount() {
        // Given: A presenter with 3 favorite articles
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article1 = createMockArticleEntity(title: "Article 1", contents: "Content 1", publishedAt: Date(), urlToImage: nil)
        let article2 = createMockArticleEntity(title: "Article 2", contents: "Content 2", publishedAt: Date(), urlToImage: nil)
        let article3 = createMockArticleEntity(title: "Article 3", contents: "Content 3", publishedAt: Date(), urlToImage: nil)

        Given(mockStorage, .articles(getter: [article1, article2, article3]))
        Given(mockStorage, .addObserver(.any, willReturn: ()))

        let sut = FavoritePresenter(view: mockView, router: mockRouter)
        sut._storage = mockStorage
        sut.viewLoaded()

        #expect(sut.numberOfRows() == 3)

        // When: Two articles are removed via observer
        Given(mockStorage, .articles(getter: [article2]))
        sut.didRemoveFromFavorites(title: "Article 1")

        Given(mockStorage, .articles(getter: []))
        sut.didRemoveFromFavorites(title: "Article 2")

        // Then: Should have correct count after removals
        #expect(sut.numberOfRows() == 0)
    }

    // MARK: - Test: Empty to Non-Empty State Transition

    /// Tests that presenter correctly transitions from empty to non-empty state
    /// Business rule: Empty state should be hidden when first article is added
    @Test("Should transition from empty to non-empty state when first article is added")
    func testEmptyToNonEmptyStateTransition() {
        // Given: A presenter starting with empty favorites
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        Given(mockStorage, .articles(getter: []))
        Given(mockStorage, .addObserver(.any, willReturn: ()))

        let sut = FavoritePresenter(view: mockView, router: mockRouter)
        sut._storage = mockStorage
        sut.viewLoaded()

        // Verify empty state is shown
        Verify(mockView, .showEmptyState(.value(true)))

        mockView.resetMock()

        // When: First article is added
        let newArticle = createMockArticleEntity(title: "First Article", contents: "Content", publishedAt: Date(), urlToImage: nil)
        Given(mockStorage, .articles(getter: [newArticle]))
        sut.didAddToFavorites(article: newArticle)

        // Then: Should hide empty state and show list
        Verify(mockView, .showEmptyState(.value(false)))
    }

    // MARK: - Test: Non-Empty to Empty State Transition

    /// Tests that presenter correctly transitions from non-empty to empty state
    /// Business rule: Empty state should be shown when last article is removed
    @Test("Should transition from non-empty to empty state when last article is removed")
    func testNonEmptyToEmptyStateTransition() {
        // Given: A presenter with one favorite article
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article = createMockArticleEntity(title: "Last Article", contents: "Content", publishedAt: Date(), urlToImage: nil)

        Given(mockStorage, .articles(getter: [article]))
        Given(mockStorage, .addObserver(.any, willReturn: ()))

        let sut = FavoritePresenter(view: mockView, router: mockRouter)
        sut._storage = mockStorage
        sut.viewLoaded()

        // Verify empty state is not shown
        Verify(mockView, .showEmptyState(.value(false)))

        mockView.resetMock()

        // When: Last article is removed
        Given(mockStorage, .articles(getter: []))
        sut.didRemoveFromFavorites(title: "Last Article")

        // Then: Should show empty state
        Verify(mockView, .showEmptyState(.value(true)))
    }
}

// MARK: - Helper Functions

/// Creates a mock ArticleEntity for testing purposes
/// - Parameters:
///   - title: Article title
///   - contents: Article content
///   - publishedAt: Publication date
///   - urlToImage: Optional image URL string
/// - Returns: Mock ArticleEntity conforming to the protocol
private func createMockArticleEntity(title: String, contents: String, publishedAt: Date, urlToImage: String?) -> ArticleEntity {
    // Create a test double that conforms to ArticleEntity protocol
    // Since ArticleEntity is a CoreData entity, we create a mock that matches its interface
    let mock = ArticleEntityMock()
    mock.title = title
    mock.contents = contents
    mock.publishedAt = publishedAt
    mock.urlToImage = urlToImage
    return mock
}

/// Mock ArticleEntity for testing
/// Provides a simple implementation without CoreData dependency
private class ArticleEntityMock: ArticleEntity {
    override var title: String? {
        get { _title }
        set { _title = newValue }
    }

    override var contents: String? {
        get { _contents }
        set { _contents = newValue }
    }

    override var publishedAt: Date? {
        get { _publishedAt }
        set { _publishedAt = newValue }
    }

    override var urlToImage: String? {
        get { _urlToImage }
        set { _urlToImage = newValue }
    }

    private var _title: String?
    private var _contents: String?
    private var _publishedAt: Date?
    private var _urlToImage: String?
}
