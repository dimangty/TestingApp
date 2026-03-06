//
//  NewsScreenSnapshotTests.swift
//  TestingTaskTests
//
//  Snapshot tests for NewsScreen UI states
//  Testing UI appearance and layout with SnapshotTesting
//  Following Mobile Testing Guidelines v3 recommendations
//
//  Tests cover:
//  - Loading state (activity indicator)
//  - Loaded state with articles
//  - Empty state (no articles)
//  - Different device sizes
//  - Dark/light mode
//
//  Note: No dynamic dates per guidelines - using fixed test dates
//  No animations tested - snapshots capture static states
//

import Testing
import SnapshotTesting
import UIKit
@testable import TestingTask

@Suite("NewsScreen Snapshot Tests - UI States")
struct NewsScreenSnapshotTests {

    // MARK: - Test: Initial State with Loading

    /// Tests the appearance while loading articles
    /// Business rule: Should show activity indicator during loading
    @Test("Should match snapshot for loading state")
    func testLoadingState() {
        // Given: A news screen in loading state
        let viewController = createNewsViewController()
        viewController.loadViewIfNeeded()

        // When: Loading begins
        viewController.setup()
        viewController.showLoading(true)

        // Then: Should match snapshot with loading indicator
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Loaded State with Articles

    /// Tests the appearance with loaded articles
    /// Business rule: Should display list of articles in table view
    @Test("Should match snapshot with loaded articles")
    func testLoadedStateWithArticles() {
        // Given: A news screen with loaded articles
        let (viewController, presenter) = createNewsViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()

        // When: Articles are loaded
        let articles = createTestArticles(count: 5)
        presenter.setArticles(articles)
        viewController.showLoading(false)
        viewController.reloadData()

        // Then: Should match snapshot with article list
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Empty State

    /// Tests the appearance with no articles
    /// Business rule: Should show empty table when no articles available
    @Test("Should match snapshot for empty state")
    func testEmptyState() {
        // Given: A news screen with no articles
        let (viewController, presenter) = createNewsViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()

        // When: No articles are available
        presenter.setArticles([])
        viewController.showLoading(false)
        viewController.reloadData()

        // Then: Should match snapshot with empty table
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Single Article

    /// Tests the appearance with single article
    /// Business rule: Should properly display single article in list
    @Test("Should match snapshot with single article")
    func testSingleArticleState() {
        // Given: A news screen with one article
        let (viewController, presenter) = createNewsViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()

        // When: Single article is loaded
        let articles = createTestArticles(count: 1)
        presenter.setArticles(articles)
        viewController.showLoading(false)
        viewController.reloadData()

        // Then: Should match snapshot with one article
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Many Articles Scrolling

    /// Tests the appearance with many articles (scrollable list)
    /// Business rule: Should display scrollable list for many articles
    @Test("Should match snapshot with many articles")
    func testManyArticlesState() {
        // Given: A news screen with many articles
        let (viewController, presenter) = createNewsViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()

        // When: Many articles are loaded
        let articles = createTestArticles(count: 10)
        presenter.setArticles(articles)
        viewController.showLoading(false)
        viewController.reloadData()

        // Then: Should match snapshot with scrollable list
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Different Device Sizes

    /// Tests layout on iPhone SE (small screen)
    /// Business rule: Table view should adapt to smaller screens
    @Test("Should match snapshot on iPhone SE with articles")
    func testLayoutOniPhoneSE() {
        // Given: A news screen for small device
        let (viewController, presenter) = createNewsViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()

        // When: Articles are displayed on iPhone SE
        let articles = createTestArticles(count: 3)
        presenter.setArticles(articles)
        viewController.showLoading(false)
        viewController.reloadData()

        // Then: Should match snapshot with proper layout
        assertSnapshot(of: viewController, as: .image(on: .iPhoneSe))
    }

    /// Tests layout on iPhone 13 Pro Max (large screen)
    /// Business rule: Table view should utilize larger screen space
    @Test("Should match snapshot on iPhone 13 Pro Max with articles")
    func testLayoutOniPhone13ProMax() {
        // Given: A news screen for large device
        let (viewController, presenter) = createNewsViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()

        // When: Articles are displayed on large device
        let articles = createTestArticles(count: 5)
        presenter.setArticles(articles)
        viewController.showLoading(false)
        viewController.reloadData()

        // Then: Should match snapshot with proper layout
        assertSnapshot(of: viewController, as: .image(on: .iPhone13ProMax))
    }

    // MARK: - Test: Dark Mode Appearance

    /// Tests appearance in dark mode with articles
    /// Business rule: Table view should properly support dark mode
    @Test("Should match snapshot in dark mode with articles")
    func testDarkModeAppearance() {
        // Given: A news screen in dark mode
        let (viewController, presenter) = createNewsViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()
        viewController.overrideUserInterfaceStyle = .dark

        // When: Articles are displayed in dark mode
        let articles = createTestArticles(count: 3)
        presenter.setArticles(articles)
        viewController.showLoading(false)
        viewController.reloadData()

        // Then: Should match snapshot with dark theme
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Light Mode Appearance

    /// Tests appearance in light mode with articles (explicit)
    /// Business rule: Table view should properly support light mode
    @Test("Should match snapshot in light mode with articles")
    func testLightModeAppearance() {
        // Given: A news screen in light mode
        let (viewController, presenter) = createNewsViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.setup()
        viewController.overrideUserInterfaceStyle = .light

        // When: Articles are displayed in light mode
        let articles = createTestArticles(count: 3)
        presenter.setArticles(articles)
        viewController.showLoading(false)
        viewController.reloadData()

        // Then: Should match snapshot with light theme
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }
}

// MARK: - Helper Functions

/// Creates a NewsViewController instance for testing
/// - Returns: Configured NewsViewController
private func createNewsViewController() -> NewsViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    guard let viewController = storyboard.instantiateViewController(
        withIdentifier: "NewsViewController"
    ) as? NewsViewController else {
        fatalError("Failed to instantiate NewsViewController")
    }

    let mockPresenter = MockNewsPresenter()
    viewController.presenter = mockPresenter

    return viewController
}

/// Creates a NewsViewController with a testable presenter
/// - Returns: Tuple of view controller and presenter
private func createNewsViewControllerWithPresenter() -> (NewsViewController, MockNewsPresenter) {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    guard let viewController = storyboard.instantiateViewController(
        withIdentifier: "NewsViewController"
    ) as? NewsViewController else {
        fatalError("Failed to instantiate NewsViewController")
    }

    let presenter = MockNewsPresenter()
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
            author: "Test Author \(i)",
            title: "Test Article Title \(i)",
            description: "This is test article description \(i) with some content to display in the cell.",
            url: URL(string: "https://example.com/article\(i)"),
            urlToImage: nil, // No images to avoid network calls in snapshots
            publishedAt: fixedDate
        )

        let mockStorage = IStorageServiceMock()
        Given(mockStorage, .isArticleInFavorites(title: .any, willReturn: i % 2 == 0)) // Alternate favorite state

        let viewModel = ArticleViewModel(article: article, storage: mockStorage)
        articles.append(viewModel)
    }

    return articles
}

// MARK: - Mock Presenter

/// Testable mock presenter for snapshot testing
/// Provides article data for table view
private class MockNewsPresenter: NewsViewOutput {
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

    func searchTextChanged(_ text: String) {
        // No-op for snapshot testing
    }
}
