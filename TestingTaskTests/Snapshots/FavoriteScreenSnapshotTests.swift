//
//  FavoriteScreenSnapshotTests.swift
//  TestingTaskTests
//
//  Snapshot tests for FavoriteScreen UI states
//  Testing UI appearance and layout with SnapshotTesting
//  Following Mobile Testing Guidelines v3 recommendations
//
//  Tests cover:
//  - Empty state (no favorites)
//  - Loaded state with favorites
//  - Single favorite
//  - Multiple favorites
//  - Different device sizes
//  - Dark/light mode
//
//  Note: No dynamic dates per guidelines - using fixed test dates
//  Empty state is a critical UI state worth snapshot testing
//

import Testing
import SnapshotTesting
import UIKit
@testable import TestingTask

@Suite("FavoriteScreen Snapshot Tests - UI States")
struct FavoriteScreenSnapshotTests {

    // MARK: - Test: Empty State

    /// Tests the empty state appearance when no favorites exist
    /// Business rule: Should show "No favorites yet" message
    @Test("Should match snapshot for empty state")
    func testEmptyState() {
        // Given: A favorites screen with no favorites
        let (viewController, presenter) = createFavoriteViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()

        // When: No favorites are available
        presenter.setArticles([])
        viewController.showEmptyState(true)
        viewController.reloadData()

        // Then: Should match snapshot with empty state message
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Single Favorite

    /// Tests the appearance with single favorite article
    /// Business rule: Should display one article and hide empty state
    @Test("Should match snapshot with single favorite")
    func testSingleFavoriteState() {
        // Given: A favorites screen with one favorite
        let (viewController, presenter) = createFavoriteViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()

        // When: Single favorite article exists
        let articles = createTestArticles(count: 1)
        presenter.setArticles(articles)
        viewController.showEmptyState(false)
        viewController.reloadData()

        // Then: Should match snapshot with one favorite
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Multiple Favorites

    /// Tests the appearance with multiple favorite articles
    /// Business rule: Should display scrollable list of favorites
    @Test("Should match snapshot with multiple favorites")
    func testMultipleFavoritesState() {
        // Given: A favorites screen with multiple favorites
        let (viewController, presenter) = createFavoriteViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()

        // When: Multiple favorite articles exist
        let articles = createTestArticles(count: 5)
        presenter.setArticles(articles)
        viewController.showEmptyState(false)
        viewController.reloadData()

        // Then: Should match snapshot with favorites list
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Many Favorites Scrolling

    /// Tests the appearance with many favorites (scrollable)
    /// Business rule: Should display scrollable list for many favorites
    @Test("Should match snapshot with many favorites")
    func testManyFavoritesState() {
        // Given: A favorites screen with many favorites
        let (viewController, presenter) = createFavoriteViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()

        // When: Many favorite articles exist
        let articles = createTestArticles(count: 10)
        presenter.setArticles(articles)
        viewController.showEmptyState(false)
        viewController.reloadData()

        // Then: Should match snapshot with scrollable favorites
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Empty State on Different Devices

    /// Tests empty state layout on iPhone SE
    /// Business rule: Empty message should be centered on small screens
    @Test("Should match snapshot for empty state on iPhone SE")
    func testEmptyStateOniPhoneSE() {
        // Given: A favorites screen with no favorites on small device
        let (viewController, presenter) = createFavoriteViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()

        // When: No favorites on iPhone SE
        presenter.setArticles([])
        viewController.showEmptyState(true)
        viewController.reloadData()

        // Then: Should match snapshot with centered message
        assertSnapshot(of: viewController, as: .image(on: .iPhoneSe))
    }

    /// Tests favorites list on iPhone 13 Pro Max
    /// Business rule: Should utilize larger screen space
    @Test("Should match snapshot with favorites on iPhone 13 Pro Max")
    func testFavoritesOniPhone13ProMax() {
        // Given: A favorites screen on large device
        let (viewController, presenter) = createFavoriteViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()

        // When: Favorites displayed on large screen
        let articles = createTestArticles(count: 5)
        presenter.setArticles(articles)
        viewController.showEmptyState(false)
        viewController.reloadData()

        // Then: Should match snapshot with proper layout
        assertSnapshot(of: viewController, as: .image(on: .iPhone13ProMax))
    }

    // MARK: - Test: Dark Mode Appearance

    /// Tests empty state in dark mode
    /// Business rule: Empty message should be visible in dark theme
    @Test("Should match snapshot for empty state in dark mode")
    func testEmptyStateDarkMode() {
        // Given: A favorites screen in dark mode with no favorites
        let (viewController, presenter) = createFavoriteViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()
        viewController.overrideUserInterfaceStyle = .dark

        // When: No favorites in dark mode
        presenter.setArticles([])
        viewController.showEmptyState(true)
        viewController.reloadData()

        // Then: Should match snapshot with dark theme
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    /// Tests favorites list in dark mode
    /// Business rule: Articles should be properly styled in dark theme
    @Test("Should match snapshot with favorites in dark mode")
    func testFavoritesListDarkMode() {
        // Given: A favorites screen in dark mode with favorites
        let (viewController, presenter) = createFavoriteViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()
        viewController.overrideUserInterfaceStyle = .dark

        // When: Favorites displayed in dark mode
        let articles = createTestArticles(count: 3)
        presenter.setArticles(articles)
        viewController.showEmptyState(false)
        viewController.reloadData()

        // Then: Should match snapshot with dark theme
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Light Mode Appearance

    /// Tests empty state in light mode (explicit)
    /// Business rule: Empty message should be visible in light theme
    @Test("Should match snapshot for empty state in light mode")
    func testEmptyStateLightMode() {
        // Given: A favorites screen in light mode with no favorites
        let (viewController, presenter) = createFavoriteViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()
        viewController.overrideUserInterfaceStyle = .light

        // When: No favorites in light mode
        presenter.setArticles([])
        viewController.showEmptyState(true)
        viewController.reloadData()

        // Then: Should match snapshot with light theme
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    /// Tests favorites list in light mode
    /// Business rule: Articles should be properly styled in light theme
    @Test("Should match snapshot with favorites in light mode")
    func testFavoritesListLightMode() {
        // Given: A favorites screen in light mode with favorites
        let (viewController, presenter) = createFavoriteViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()
        viewController.overrideUserInterfaceStyle = .light

        // When: Favorites displayed in light mode
        let articles = createTestArticles(count: 3)
        presenter.setArticles(articles)
        viewController.showEmptyState(false)
        viewController.reloadData()

        // Then: Should match snapshot with light theme
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Transition States

    /// Tests the appearance immediately after removing last favorite
    /// Business rule: Should show empty state when transitioning from 1 to 0 favorites
    @Test("Should match snapshot when transitioning to empty")
    func testTransitionToEmptyState() {
        // Given: A favorites screen that just became empty
        let (viewController, presenter) = createFavoriteViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()

        // When: Last favorite was just removed
        presenter.setArticles([])
        viewController.showEmptyState(true)
        viewController.reloadData()

        // Then: Should match snapshot showing empty state
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }
}

// MARK: - Helper Functions

/// Creates a FavoriteViewController with a testable presenter
/// - Returns: Tuple of view controller and presenter
private func createFavoriteViewControllerWithPresenter() -> (FavoriteViewController, MockFavoritePresenter) {
    let viewController = FavoriteViewController()
    let presenter = MockFavoritePresenter()
    viewController.presenter = presenter

    return (viewController, presenter)
}

/// Creates test articles with fixed data (no dynamic dates)
/// - Parameter count: Number of articles to create
/// - Returns: Array of ArticleViewModel
private func createTestArticles(count: Int) -> [ArticleViewModel] {
    var articles: [ArticleViewModel] = []

    // Fixed date for testing (no dynamic dates per guidelines)
    let fixedDate = Date(timeIntervalSince1970: 1704067200) // Jan 1, 2024

    for i in 1...count {
        let article = Article(
            author: "Favorite Author \(i)",
            title: "Favorite Article \(i)",
            description: "This is favorite article description \(i) with content to display.",
            url: URL(string: "https://example.com/favorite\(i)"),
            urlToImage: nil, // No images to avoid network calls
            publishedAt: fixedDate
        )

        let mockStorage = IStorageServiceMock()
        // All articles in favorites are marked as favorite
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: true))

        let viewModel = ArticleViewModel(article: article, storage: mockStorage)
        articles.append(viewModel)
    }

    return articles
}

// MARK: - Mock Presenter

/// Testable mock presenter for snapshot testing
/// Provides article data for table view
private class MockFavoritePresenter: FavoriteViewOutput {
    private var articles: [ArticleViewModel] = []

    func setArticles(_ articles: [ArticleViewModel]) {
        self.articles = articles
    }

    func viewLoaded() {
        // No-op for snapshot testing
    }

    func viewWillAppear() {
        // No-op for snapshot testing
    }

    func numberOfRows() -> Int {
        return articles.count
    }

    func article(at indexPath: IndexPath) -> ArticleViewModel {
        return articles[indexPath.row]
    }

    func didSelectRow(at indexPath: IndexPath) {
        // No-op for snapshot testing
    }

    func didTapFavorite(at indexPath: IndexPath) {
        // No-op for snapshot testing
    }
}
