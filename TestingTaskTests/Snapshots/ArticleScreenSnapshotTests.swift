//
//  ArticleScreenSnapshotTests.swift
//  TestingTaskTests
//
//  Snapshot tests for ArticleScreen UI states
//  Testing UI appearance and layout with SnapshotTesting
//  Following Mobile Testing Guidelines v3 recommendations
//
//  Tests cover:
//  - Article with all data (title, date, content, image)
//  - Article without image
//  - Favorite state (filled heart)
//  - Non-favorite state (empty heart)
//  - Long content scrolling
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

@Suite("ArticleScreen Snapshot Tests - UI States")
struct ArticleScreenSnapshotTests {

    // MARK: - Test: Article with Full Data

    /// Tests the appearance with complete article data
    /// Business rule: Should display title, date, content, and placeholder image
    @Test("Should match snapshot with full article data")
    func testFullArticleDataState() {
        // Given: An article screen with complete data
        let (viewController, presenter) = createArticleViewControllerWithPresenter()
        viewController.loadViewIfNeeded()

        // When: Full article data is displayed
        presenter.setArticleData(
            title: "Breaking News: Important Article Title",
            date: "1 января",
            content: "This is the article content with detailed information about the news story. It contains multiple sentences to show how the content is displayed in the view.",
            image: nil,
            isFavorite: false
        )
        viewController.display(
            title: "Breaking News: Important Article Title",
            date: "1 января",
            content: "This is the article content with detailed information about the news story. It contains multiple sentences to show how the content is displayed in the view."
        )
        viewController.displayLike(isFavorite: false)

        // Then: Should match snapshot with all data displayed
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Article as Favorite

    /// Tests the appearance when article is marked as favorite
    /// Business rule: Should display filled heart icon
    @Test("Should match snapshot with favorite article")
    func testFavoriteArticleState() {
        // Given: An article screen with favorited article
        let (viewController, presenter) = createArticleViewControllerWithPresenter()
        viewController.loadViewIfNeeded()

        // When: Article is marked as favorite
        presenter.setArticleData(
            title: "Favorite Article Title",
            date: "15 января",
            content: "This is a favorite article with interesting content.",
            image: nil,
            isFavorite: true
        )
        viewController.display(
            title: "Favorite Article Title",
            date: "15 января",
            content: "This is a favorite article with interesting content."
        )
        viewController.displayLike(isFavorite: true)

        // Then: Should match snapshot with filled heart
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Article as Non-Favorite

    /// Tests the appearance when article is not favorite
    /// Business rule: Should display empty heart icon
    @Test("Should match snapshot with non-favorite article")
    func testNonFavoriteArticleState() {
        // Given: An article screen with non-favorite article
        let (viewController, presenter) = createArticleViewControllerWithPresenter()
        viewController.loadViewIfNeeded()

        // When: Article is not marked as favorite
        presenter.setArticleData(
            title: "Regular Article Title",
            date: "20 января",
            content: "This is a regular article that is not favorited.",
            image: nil,
            isFavorite: false
        )
        viewController.display(
            title: "Regular Article Title",
            date: "20 января",
            content: "This is a regular article that is not favorited."
        )
        viewController.displayLike(isFavorite: false)

        // Then: Should match snapshot with empty heart
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Article with Long Content

    /// Tests the appearance with long article content
    /// Business rule: Should display scrollable content for long articles
    @Test("Should match snapshot with long article content")
    func testLongContentState() {
        // Given: An article screen with long content
        let (viewController, presenter) = createArticleViewControllerWithPresenter()
        viewController.loadViewIfNeeded()

        let longContent = """
        This is a very long article content that spans multiple paragraphs.

        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

        Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

        Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.
        """

        // When: Long content is displayed
        presenter.setArticleData(
            title: "Article with Long Content",
            date: "25 января",
            content: longContent,
            image: nil,
            isFavorite: false
        )
        viewController.display(
            title: "Article with Long Content",
            date: "25 января",
            content: longContent
        )
        viewController.displayLike(isFavorite: false)

        // Then: Should match snapshot with scrollable content
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Article with Short Content

    /// Tests the appearance with minimal article content
    /// Business rule: Should display short content properly centered/aligned
    @Test("Should match snapshot with short article content")
    func testShortContentState() {
        // Given: An article screen with short content
        let (viewController, presenter) = createArticleViewControllerWithPresenter()
        viewController.loadViewIfNeeded()

        // When: Short content is displayed
        presenter.setArticleData(
            title: "Brief Article",
            date: "30 января",
            content: "Short article content.",
            image: nil,
            isFavorite: false
        )
        viewController.display(
            title: "Brief Article",
            date: "30 января",
            content: "Short article content."
        )
        viewController.displayLike(isFavorite: false)

        // Then: Should match snapshot with short content
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Article without Title

    /// Tests the appearance when article has no title (edge case)
    /// Business rule: Should handle missing title gracefully
    @Test("Should match snapshot with no title")
    func testNoTitleState() {
        // Given: An article screen without title
        let (viewController, presenter) = createArticleViewControllerWithPresenter()
        viewController.loadViewIfNeeded()

        // When: Article has no title
        presenter.setArticleData(
            title: nil,
            date: "5 февраля",
            content: "Article content without a title.",
            image: nil,
            isFavorite: false
        )
        viewController.display(
            title: nil,
            date: "5 февраля",
            content: "Article content without a title."
        )
        viewController.displayLike(isFavorite: false)

        // Then: Should match snapshot handling nil title
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Different Device Sizes

    /// Tests layout on iPhone SE (small screen)
    /// Business rule: Content should be readable on small screens
    @Test("Should match snapshot on iPhone SE")
    func testLayoutOniPhoneSE() {
        // Given: An article screen for small device
        let (viewController, presenter) = createArticleViewControllerWithPresenter()
        viewController.loadViewIfNeeded()

        // When: Article displayed on iPhone SE
        presenter.setArticleData(
            title: "Article on Small Screen",
            date: "10 февраля",
            content: "Content should be readable on small screens.",
            image: nil,
            isFavorite: false
        )
        viewController.display(
            title: "Article on Small Screen",
            date: "10 февраля",
            content: "Content should be readable on small screens."
        )
        viewController.displayLike(isFavorite: false)

        // Then: Should match snapshot with proper layout
        assertSnapshot(of: viewController, as: .image(on: .iPhoneSe))
    }

    /// Tests layout on iPhone 13 Pro Max (large screen)
    /// Business rule: Should utilize larger screen space
    @Test("Should match snapshot on iPhone 13 Pro Max")
    func testLayoutOniPhone13ProMax() {
        // Given: An article screen for large device
        let (viewController, presenter) = createArticleViewControllerWithPresenter()
        viewController.loadViewIfNeeded()

        // When: Article displayed on large screen
        presenter.setArticleData(
            title: "Article on Large Screen",
            date: "15 февраля",
            content: "Content should utilize larger screen space properly.",
            image: nil,
            isFavorite: false
        )
        viewController.display(
            title: "Article on Large Screen",
            date: "15 февраля",
            content: "Content should utilize larger screen space properly."
        )
        viewController.displayLike(isFavorite: false)

        // Then: Should match snapshot with proper layout
        assertSnapshot(of: viewController, as: .image(on: .iPhone13ProMax))
    }

    // MARK: - Test: Dark Mode Appearance

    /// Tests appearance in dark mode
    /// Business rule: Article should be readable in dark theme
    @Test("Should match snapshot in dark mode")
    func testDarkModeAppearance() {
        // Given: An article screen in dark mode
        let (viewController, presenter) = createArticleViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.overrideUserInterfaceStyle = .dark

        // When: Article displayed in dark mode
        presenter.setArticleData(
            title: "Dark Mode Article",
            date: "20 февраля",
            content: "This article is displayed in dark mode for better readability at night.",
            image: nil,
            isFavorite: true
        )
        viewController.display(
            title: "Dark Mode Article",
            date: "20 февраля",
            content: "This article is displayed in dark mode for better readability at night."
        )
        viewController.displayLike(isFavorite: true)

        // Then: Should match snapshot with dark theme
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }

    // MARK: - Test: Light Mode Appearance

    /// Tests appearance in light mode (explicit)
    /// Business rule: Article should be readable in light theme
    @Test("Should match snapshot in light mode")
    func testLightModeAppearance() {
        // Given: An article screen in light mode
        let (viewController, presenter) = createArticleViewControllerWithPresenter()
        viewController.loadViewIfNeeded()
        viewController.overrideUserInterfaceStyle = .light

        // When: Article displayed in light mode
        presenter.setArticleData(
            title: "Light Mode Article",
            date: "25 февраля",
            content: "This article is displayed in light mode for better readability during the day.",
            image: nil,
            isFavorite: false
        )
        viewController.display(
            title: "Light Mode Article",
            date: "25 февраля",
            content: "This article is displayed in light mode for better readability during the day."
        )
        viewController.displayLike(isFavorite: false)

        // Then: Should match snapshot with light theme
        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }
}

// MARK: - Helper Functions

/// Creates an ArticleViewController with a testable presenter
/// - Returns: Tuple of view controller and presenter
private func createArticleViewControllerWithPresenter() -> (ArticleViewController, MockArticlePresenter) {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    guard let viewController = storyboard.instantiateViewController(
        withIdentifier: "ArticleViewController"
    ) as? ArticleViewController else {
        fatalError("Failed to instantiate ArticleViewController")
    }

    let presenter = MockArticlePresenter()
    viewController.presenter = presenter

    return (viewController, presenter)
}

// MARK: - Mock Presenter

/// Testable mock presenter for snapshot testing
/// Provides article data for display
private class MockArticlePresenter: ArticleViewOutput {
    private var articleTitle: String?
    private var articleDate: String = ""
    private var articleContent: String?
    private var articleImage: UIImage?
    private var isFavorite: Bool = false

    func setArticleData(title: String?, date: String, content: String?, image: UIImage?, isFavorite: Bool) {
        self.articleTitle = title
        self.articleDate = date
        self.articleContent = content
        self.articleImage = image
        self.isFavorite = isFavorite
    }

    func viewLoaded() {
        // No-op for snapshot testing
    }

    func viewWillAppear() {
        // No-op for snapshot testing
    }

    func heartTapped() {
        // No-op for snapshot testing
    }
}
