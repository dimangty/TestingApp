//
//  FavoritePresenterTests.swift
//  TestingTaskTests
//
//  Unit tests for FavoritePresenter
//  Following Mobile Testing Guidelines v3 - Given/When/Then pattern
//
//  Tests cover:
//  - View lifecycle events (viewLoaded, viewWillAppear)
//  - Favorites list display and empty state
//  - Observer pattern for storage changes
//  - Article selection and navigation
//  - Favorite removal handling
//  - List data management
//

import Foundation
import Testing
import SwiftyMocky
@testable import XCTestTask

@Suite("Favorite Presenter Tests")
struct FavoritePresenterTests {

    // MARK: - Helper: Create mock article entity

    /// Helper function to create a mock ArticleEntity
    func createMockArticleEntity(title: String, contents: String = "Test content") -> ArticleEntity {
        let entity = ArticleEntity()
        entity.title = title
        entity.contents = contents
        entity.publishedAt = Date(timeIntervalSince1970: 1000000)
        entity.addedAt = Date()
        return entity
    }

    @Test("View load with no favorites shows empty state")
    func viewLoadedNoFavoritesShowsEmptyState() {
        // Given: Presenter with empty favorites list
        TestConfigurator.setupForTesting()
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        // Configure storage with empty articles
        Given(mockStorage, .articles(getter: []))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        let presenter = FavoritePresenter(view: mockView, router: mockRouter)

        // When: View is loaded
        presenter.viewLoaded()

        // Then: View is set up, data is reloaded, and empty state is shown
        Verify(mockView, 1, .setup())
        Verify(mockView, 1, .reloadData())
        Verify(mockView, 1, .showEmptyState(.value(true)))
    }

    @Test("View load with favorites hides empty state")
    func viewLoadedWithFavoritesHidesEmptyState() {
        // Given: Presenter with favorites in storage
        TestConfigurator.setupForTesting()
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article1 = createMockArticleEntity(title: "Favorite 1")
        let article2 = createMockArticleEntity(title: "Favorite 2")

        // Configure storage with articles
        Given(mockStorage, .articles(getter: [article1, article2]))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        let presenter = FavoritePresenter(view: mockView, router: mockRouter)

        // When: View is loaded
        presenter.viewLoaded()

        // Then: View is set up, data is reloaded, and empty state is hidden
        Verify(mockView, 1, .setup())
        Verify(mockView, 1, .reloadData())
        Verify(mockView, 1, .showEmptyState(.value(false)))
    }

    @Test("Number of rows returns correct count")
    func numberOfRowsReturnsCorrectCount() {
        // Given: Presenter with 3 favorites
        TestConfigurator.setupForTesting()
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let articles = [
            createMockArticleEntity(title: "Article 1"),
            createMockArticleEntity(title: "Article 2"),
            createMockArticleEntity(title: "Article 3")
        ]

        Given(mockStorage, .articles(getter: articles))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        let presenter = FavoritePresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        // When: Number of rows is requested
        let count = presenter.numberOfRows()

        // Then: Count equals number of favorites
        #expect(count == 3)
    }

    @Test("Article at indexPath returns correct article")
    func articleAtIndexPathReturnsCorrectArticle() {
        // Given: Presenter with multiple favorites
        TestConfigurator.setupForTesting()
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article1 = createMockArticleEntity(title: "First Article")
        let article2 = createMockArticleEntity(title: "Second Article")

        Given(mockStorage, .articles(getter: [article1, article2]))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: true))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        let presenter = FavoritePresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        // When: Article at index 1 is requested
        let articleViewModel = presenter.article(at: IndexPath(row: 1, section: 0))

        // Then: Second article is returned
        #expect(articleViewModel.title == "Second Article")
    }

    @Test("Select row navigates to article detail")
    func didSelectRowNavigatesToArticle() {
        // Given: Presenter with favorites
        TestConfigurator.setupForTesting()
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article = createMockArticleEntity(title: "Selected Article")

        Given(mockStorage, .articles(getter: [article]))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: true))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        let presenter = FavoritePresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        // When: Row is selected
        presenter.didSelectRow(at: IndexPath(row: 0, section: 0))

        // Then: Router navigates to article
        Verify(mockRouter, 1, .openArticle(article: .matching({ $0.title == "Selected Article" })))
    }

    @Test("Tap favorite toggles article state")
    func didTapFavoriteTogglesState() {
        // Given: Presenter with favorite article
        TestConfigurator.setupForTesting()
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article = createMockArticleEntity(title: "Test Favorite")

        Given(mockStorage, .articles(getter: [article]))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: true))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        let presenter = FavoritePresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        // When: Favorite icon is tapped
        presenter.didTapFavorite(at: IndexPath(row: 0, section: 0))

        // Then: Article's favorite method is called (which toggles state)
        Verify(mockStorage, .atLeastOnce, .removeFromFavorites(title: .value("Test Favorite")))
    }

    @Test("Observer removes article from list and reloads data")
    func didRemoveFromFavoritesUpdatesListAndReloadsData() {
        // Given: Presenter with multiple favorites
        TestConfigurator.setupForTesting()
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article1 = createMockArticleEntity(title: "Keep This")
        let article2 = createMockArticleEntity(title: "Remove This")

        Given(mockStorage, .articles(getter: [article1, article2]))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: true))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        let presenter = FavoritePresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        mockView.resetMock() // Clear initial reload

        // When: Article is removed from favorites (observer notification)
        presenter.didRemoveFromFavorites(title: "Remove This")

        // Then: Data is reloaded
        Verify(mockView, 1, .reloadData())
    }

    @Test("Observer removing last article shows empty state")
    func didRemoveFromFavoritesLastArticleShowsEmptyState() {
        // Given: Presenter with single favorite
        TestConfigurator.setupForTesting()
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article = createMockArticleEntity(title: "Last Favorite")

        Given(mockStorage, .articles(getter: [article]))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: true))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        let presenter = FavoritePresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        mockView.resetMock() // Clear initial calls

        // When: Last article is removed
        presenter.didRemoveFromFavorites(title: "Last Favorite")

        // Then: Empty state is shown
        Verify(mockView, 1, .showEmptyState(.value(true)))
    }

    @Test("Observer adding article reloads favorites list")
    func didAddToFavoritesReloadsFavoritesList() {
        // Given: Presenter with existing favorites
        TestConfigurator.setupForTesting()
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article1 = createMockArticleEntity(title: "Existing Favorite")

        Given(mockStorage, .articles(getter: [article1]))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: true))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        let presenter = FavoritePresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        mockView.resetMock() // Clear initial reload

        // When: New article is added to favorites (observer notification)
        let newArticle = createMockArticleEntity(title: "New Favorite")
        presenter.didAddToFavorites(article: newArticle)

        // Then: Data is reloaded
        Verify(mockView, 1, .reloadData())
    }

    @Test("View will appear refreshes favorites and updates UI")
    func viewWillAppearReloadsFavoritesAndUpdatesUI() {
        // Given: Presenter with favorites
        TestConfigurator.setupForTesting()
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article = createMockArticleEntity(title: "Test Favorite")

        Given(mockStorage, .articles(getter: [article]))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: true))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        let presenter = FavoritePresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        mockView.resetMock() // Clear viewLoaded calls

        // When: View will appear
        presenter.viewWillAppear()

        // Then: Data is reloaded and selected cell is updated
        Verify(mockView, 1, .reloadData())
        Verify(mockView, 1, .updateSelectedCell())
    }

    @Test("Initialization registers presenter as storage observer")
    func initRegistersAsStorageObserver() {
        // Given: Mock storage
        TestConfigurator.setupForTesting()
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        Given(mockStorage, .articles(getter: []))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        // When: Presenter is initialized
        _ = FavoritePresenter(view: mockView, router: mockRouter)

        // Then: Presenter is registered as observer
        Verify(mockStorage, 1, .addObserver(.any))
    }

    @Test("Number of rows after removing favorite decreases")
    func numberOfRowsAfterRemovingFavoriteDecreases() {
        // Given: Presenter with multiple favorites
        TestConfigurator.setupForTesting()
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let articles = [
            createMockArticleEntity(title: "Article 1"),
            createMockArticleEntity(title: "Article 2"),
            createMockArticleEntity(title: "Article 3")
        ]

        Given(mockStorage, .articles(getter: articles))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: true))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        let presenter = FavoritePresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        let initialCount = presenter.numberOfRows()

        // When: Article is removed
        presenter.didRemoveFromFavorites(title: "Article 2")

        // Then: Number of rows decreases by 1
        let newCount = presenter.numberOfRows()
        #expect(initialCount == 3)
        #expect(newCount == 2)
    }

    @Test("Observer removing non-existent article does not crash")
    func didRemoveFromFavoritesNonExistentArticleDoesNotCrash() {
        // Given: Presenter with favorites
        TestConfigurator.setupForTesting()
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article = createMockArticleEntity(title: "Existing Article")

        Given(mockStorage, .articles(getter: [article]))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: true))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        let presenter = FavoritePresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        mockView.resetMock()

        // When: Attempting to remove non-existent article
        presenter.didRemoveFromFavorites(title: "Non-Existent Article")

        // Then: No crash and no data reload
        Verify(mockView, .never, .reloadData())
    }

    @Test("Adding first favorite transitions from empty to non-empty")
    func didAddToFavoritesFirstArticleHidesEmptyState() {
        // Given: Presenter starting with no favorites
        TestConfigurator.setupForTesting()
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        Given(mockStorage, .articles(getter: []))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        let presenter = FavoritePresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        // Update storage to have one article
        let newArticle = createMockArticleEntity(title: "First Favorite")
        Given(mockStorage, .articles(getter: [newArticle]))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: true))

        mockView.resetMock()

        // When: First article is added to favorites
        presenter.didAddToFavorites(article: newArticle)

        // Then: Empty state is hidden and data is reloaded
        Verify(mockView, 1, .reloadData())
        Verify(mockView, 1, .showEmptyState(.value(false)))
    }

    @Test("Multiple select row calls navigate each time")
    func multipleDidSelectRowCallsNavigateEachTime() {
        // Given: Presenter with favorites
        TestConfigurator.setupForTesting()
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let articles = [
            createMockArticleEntity(title: "Article 1"),
            createMockArticleEntity(title: "Article 2")
        ]

        Given(mockStorage, .articles(getter: articles))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: true))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        let presenter = FavoritePresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        // When: Multiple rows are selected
        presenter.didSelectRow(at: IndexPath(row: 0, section: 0))
        presenter.didSelectRow(at: IndexPath(row: 1, section: 0))
        presenter.didSelectRow(at: IndexPath(row: 0, section: 0))

        // Then: Router is called three times
        Verify(mockRouter, 3, .openArticle(article: .any))
    }

    @Test("View loaded with nil storage handles gracefully")
    func viewLoadedWithNilStorageHandlesGracefully() {
        // Given: Presenter without registered storage
        TestConfigurator.setupForTesting()
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()

        // No storage registered

        let presenter = FavoritePresenter(view: mockView, router: mockRouter)

        // When: View is loaded
        presenter.viewLoaded()

        // Then: No crash, empty state shown
        Verify(mockView, 1, .setup())
        Verify(mockView, 1, .showEmptyState(.value(true)))
    }

    @Test("Number of rows with empty favorites returns zero")
    func numberOfRowsWithEmptyFavoritesReturnsZero() {
        // Given: Presenter with no favorites
        TestConfigurator.setupForTesting()
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        Given(mockStorage, .articles(getter: []))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        let presenter = FavoritePresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        // When: Number of rows is requested
        let count = presenter.numberOfRows()

        // Then: Count is zero
        #expect(count == 0)
    }

    @Test("Multiple tap favorite on same article toggles repeatedly")
    func multipleTapFavoriteOnSameArticleTogglesRepeatedly() {
        // Given: Presenter with favorite article
        TestConfigurator.setupForTesting()
        let mockView = FavoriteViewInputMock()
        let mockRouter = FavoriteRouterInputMock()
        let mockStorage = IStorageServiceMock()

        let article = createMockArticleEntity(title: "Toggle Article")

        Given(mockStorage, .articles(getter: [article]))
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: true))

        TestConfigurator.registerService(service: mockStorage as StorageService)

        let presenter = FavoritePresenter(view: mockView, router: mockRouter)
        presenter.viewLoaded()

        // When: Favorite is tapped multiple times
        presenter.didTapFavorite(at: IndexPath(row: 0, section: 0))
        presenter.didTapFavorite(at: IndexPath(row: 0, section: 0))
        presenter.didTapFavorite(at: IndexPath(row: 0, section: 0))

        // Then: Remove from favorites is called three times
        Verify(mockStorage, 3, .removeFromFavorites(title: .value("Toggle Article")))
    }
}
