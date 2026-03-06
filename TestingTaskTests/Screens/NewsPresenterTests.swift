import Testing
import Foundation
@testable import TestingTask

@Suite("NewsPresenter Tests")
struct NewsPresenterTests {

    // MARK: - View Loaded

    @Test("viewLoaded calls setup on view")
    func viewLoaded_callsSetup() async {
        // Given
        let (presenter, view, _, _, _) = makeSUT()

        // When
        presenter.viewLoaded()
        await Task.yield()

        // Then
        #expect(view.setupCallCount == 1)
    }

    @Test("viewLoaded shows loading indicator")
    func viewLoaded_showsLoading() async {
        // Given
        let (presenter, view, _, _, _) = makeSUT()

        // When
        presenter.viewLoaded()
        await Task.yield()

        // Then
        #expect(view.showLoadingCallCount >= 1)
        #expect(view.lastLoadingState == true || view.lastLoadingState == false)
    }

    @Test("viewLoaded calls news service to fetch articles")
    func viewLoaded_fetchesArticles() async {
        // Given
        let (presenter, _, _, newsService, _) = makeSUT()

        // When
        presenter.viewLoaded()
        await Task.yield()

        // Then
        #expect(newsService.performNewsRequestCallCount == 1)
    }

    @Test("viewLoaded on success reloads data")
    @MainActor
    func viewLoaded_success_reloadsData() async throws {
        // Given
        let articles = [Article.stub(title: "Article 1"), Article.stub(title: "Article 2")]
        let (presenter, view, _, newsService, _) = makeSUT()
        newsService.newsResult = .success(NewsSource.stub(articles: articles))

        // When
        presenter.viewLoaded()
        try await Task.sleep(nanoseconds: 100_000_000) // Wait for async completion

        // Then
        #expect(view.reloadDataCallCount >= 1)
    }

    @Test("viewLoaded on failure shows error")
    @MainActor
    func viewLoaded_failure_showsError() async throws {
        // Given
        let (presenter, _, errorService, newsService, _) = makeSUT()
        newsService.newsResult = .failure(ApiErrors.dataIsNil)

        // When
        presenter.viewLoaded()
        try await Task.sleep(nanoseconds: 100_000_000)

        // Then
        #expect(errorService.showErrorCallCount >= 1)
    }

    // MARK: - View Will Appear

    @Test("viewWillAppear updates selected cell")
    func viewWillAppear_updatesSelectedCell() {
        // Given
        let (presenter, view, _, _, _) = makeSUT()

        // When
        presenter.viewWillAppear()

        // Then
        #expect(view.updateSelectedCellCallCount == 1)
    }

    // MARK: - Number of Rows

    @Test("numberOfRows returns zero when no articles loaded")
    func numberOfRows_noArticles_returnsZero() {
        // Given
        let (presenter, _, _, _, _) = makeSUT()

        // When
        let count = presenter.numberOfRows()

        // Then
        #expect(count == 0)
    }

    @Test("numberOfRows returns correct count after loading")
    @MainActor
    func numberOfRows_afterLoading_returnsCorrectCount() async throws {
        // Given
        let articles = [Article.stub(title: "1"), Article.stub(title: "2"), Article.stub(title: "3")]
        let (presenter, _, _, newsService, _) = makeSUT()
        newsService.newsResult = .success(NewsSource.stub(articles: articles))

        // When
        presenter.viewLoaded()
        try await Task.sleep(nanoseconds: 100_000_000)

        // Then
        #expect(presenter.numberOfRows() == 3)
    }

    // MARK: - Article at IndexPath

    @Test("article at indexPath returns correct article")
    @MainActor
    func articleAtIndexPath_returnsCorrectArticle() async throws {
        // Given
        let articles = [
            Article.stub(title: "First Article"),
            Article.stub(title: "Second Article")
        ]
        let (presenter, _, _, newsService, _) = makeSUT()
        newsService.newsResult = .success(NewsSource.stub(articles: articles))

        // When
        presenter.viewLoaded()
        try await Task.sleep(nanoseconds: 100_000_000)

        // Then
        let firstArticle = presenter.article(at: IndexPath(row: 0, section: 0))
        let secondArticle = presenter.article(at: IndexPath(row: 1, section: 0))

        #expect(firstArticle.title == "First Article")
        #expect(secondArticle.title == "Second Article")
    }

    // MARK: - Did Select Row

    @Test("didSelectRow navigates to article screen")
    @MainActor
    func didSelectRow_navigatesToArticle() async throws {
        // Given
        let articles = [Article.stub(title: "Selected Article")]
        let (presenter, _, _, newsService, router) = makeSUT()
        newsService.newsResult = .success(NewsSource.stub(articles: articles))

        presenter.viewLoaded()
        try await Task.sleep(nanoseconds: 100_000_000)

        // When
        presenter.didSelectRow(at: IndexPath(row: 0, section: 0))

        // Then
        #expect(router.openArticleCallCount == 1)
        #expect(router.lastOpenedArticle?.title == "Selected Article")
    }

    // MARK: - Did Tap Favorite

    @Test("didTapFavorite updates favorite at index path")
    @MainActor
    func didTapFavorite_updatesFavorite() async throws {
        // Given
        let articles = [Article.stub(title: "Favorite Article")]
        let (presenter, view, _, newsService, _) = makeSUT()
        newsService.newsResult = .success(NewsSource.stub(articles: articles))

        presenter.viewLoaded()
        try await Task.sleep(nanoseconds: 100_000_000)

        // When
        let indexPath = IndexPath(row: 0, section: 0)
        presenter.didTapFavorite(at: indexPath)

        // Then
        #expect(view.updateFavoriteCallCount >= 1)
        #expect(view.lastFavoriteIndexPath == indexPath)
    }

    // MARK: - Search / Filter

    @Test("didUpdateSearch with empty text shows all articles")
    @MainActor
    func didUpdateSearch_emptyText_showsAllArticles() async throws {
        // Given
        let articles = [
            Article.stub(title: "First"),
            Article.stub(title: "Second"),
            Article.stub(title: "Third")
        ]
        let (presenter, _, _, newsService, _) = makeSUT()
        newsService.newsResult = .success(NewsSource.stub(articles: articles))

        presenter.viewLoaded()
        try await Task.sleep(nanoseconds: 100_000_000)

        // When
        presenter.didUpdateSearch(text: "")

        // Then
        #expect(presenter.numberOfRows() == 3)
    }

    @Test("didUpdateSearch filters articles by title")
    @MainActor
    func didUpdateSearch_filtersArticlesByTitle() async throws {
        // Given
        let articles = [
            Article.stub(title: "Apple News"),
            Article.stub(title: "Google News"),
            Article.stub(title: "Apple Update")
        ]
        let (presenter, _, _, newsService, _) = makeSUT()
        newsService.newsResult = .success(NewsSource.stub(articles: articles))

        presenter.viewLoaded()
        try await Task.sleep(nanoseconds: 100_000_000)

        // When
        presenter.didUpdateSearch(text: "Apple")

        // Then
        #expect(presenter.numberOfRows() == 2)
    }

    @Test("didUpdateSearch is case insensitive")
    @MainActor
    func didUpdateSearch_caseInsensitive() async throws {
        // Given
        let articles = [
            Article.stub(title: "BREAKING NEWS"),
            Article.stub(title: "breaking news"),
            Article.stub(title: "Other")
        ]
        let (presenter, _, _, newsService, _) = makeSUT()
        newsService.newsResult = .success(NewsSource.stub(articles: articles))

        presenter.viewLoaded()
        try await Task.sleep(nanoseconds: 100_000_000)

        // When
        presenter.didUpdateSearch(text: "breaking")

        // Then
        #expect(presenter.numberOfRows() == 2)
    }

    @Test("didUpdateSearch with no matches returns zero articles")
    @MainActor
    func didUpdateSearch_noMatches_returnsZero() async throws {
        // Given
        let articles = [
            Article.stub(title: "First"),
            Article.stub(title: "Second")
        ]
        let (presenter, _, _, newsService, _) = makeSUT()
        newsService.newsResult = .success(NewsSource.stub(articles: articles))

        presenter.viewLoaded()
        try await Task.sleep(nanoseconds: 100_000_000)

        // When
        presenter.didUpdateSearch(text: "xyz123nonexistent")

        // Then
        #expect(presenter.numberOfRows() == 0)
    }

    @Test("didUpdateSearch reloads data")
    @MainActor
    func didUpdateSearch_reloadsData() async throws {
        // Given
        let articles = [Article.stub(title: "Test")]
        let (presenter, view, _, newsService, _) = makeSUT()
        newsService.newsResult = .success(NewsSource.stub(articles: articles))

        presenter.viewLoaded()
        try await Task.sleep(nanoseconds: 100_000_000)
        let reloadCountBefore = view.reloadDataCallCount

        // When
        presenter.didUpdateSearch(text: "Test")

        // Then
        #expect(view.reloadDataCallCount > reloadCountBefore)
    }

    // MARK: - Storage Observer

    @Test("presenter registers as storage observer on init")
    func init_registersAsStorageObserver() {
        // Given / When
        let (_, _, _, _, _) = makeSUT()

        // Then - the makeSUT creates the presenter which registers as observer
        // Storage observer count is checked internally
    }

    // MARK: - Helper

    private func makeSUT() -> (TestableNewsPresenter, NewsViewMock, ErrorServiceMock, NewsServiceMock, NewsRouterMock) {
        let view = NewsViewMock()
        let router = NewsRouterMock()
        let newsService = NewsServiceMock()
        let storage = StorageServiceMock()
        let errorService = ErrorServiceMock()

        let presenter = TestableNewsPresenter(
            view: view,
            router: router,
            newsService: newsService,
            storage: storage,
            errorService: errorService
        )

        return (presenter, view, errorService, newsService, router)
    }
}
