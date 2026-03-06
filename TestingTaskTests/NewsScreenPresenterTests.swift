import Foundation
import Testing
@testable import TestingTask

@Suite("News Presenter Tests")
struct NewsScreenPresenterTests {
    @Test("View load pulls cached data and applies search filter")
    func viewLoadedPullsCachedDataAndFilters() {
        // Given
        // Configure deterministic cache payload to avoid real network requests.
        bootstrapUnitDITestSetup()
        let uniquePrefix = "news-\(UUID().uuidString)"
        let source = NewsSource(status: "ok", totalResults: 2, articles: [
            Article(author: "A", title: "\(uniquePrefix)-alpha", description: "D1", url: nil, urlToImage: nil, publishedAt: Date(timeIntervalSince1970: 0)),
            Article(author: "B", title: "\(uniquePrefix)-beta", description: "D2", url: nil, urlToImage: nil, publishedAt: Date(timeIntervalSince1970: 60))
        ])
        CacheService.shared.cacheNews(source)

        let reloadSemaphore = DispatchSemaphore(value: 0)
        let view = NewsViewInputMockableMock()
        let router = NewsRouterInputMockableMock()
        let sut = NewsPresenter(view: view, router: router)
        Perform(view, .reloadData(perform: { reloadSemaphore.signal() }))

        // When
        // Load presenter data and then apply a narrowing search term.
        sut.viewLoaded()
        let waitResult = reloadSemaphore.wait(timeout: .now() + 2)
        sut.didUpdateSearch(text: "alpha")

        // Then
        // Presenter should complete loading cycle and expose filtered content.
        switch waitResult {
        case .success:
            #expect(true)
        case .timedOut:
            #expect(false)
        }
        Verify(view, .once, .setup())
        Verify(view, .showLoading(.value(true)))
        Verify(view, .showLoading(.value(false)))
        Verify(view, .reloadData())
        #expect(sut.numberOfRows() == 1)

        StorageService.shared.removeObserver(sut)
        CacheService.shared.clearCache()
    }

    @Test("Select row routes to article screen")
    func didSelectRowRoutesToArticle() {
        // Given
        // Seed one cached article to keep route target deterministic.
        bootstrapUnitDITestSetup()
        let title = "select-\(UUID().uuidString)"
        CacheService.shared.cacheNews(NewsSource(status: "ok", totalResults: 1, articles: [
            Article(author: "A", title: title, description: "D", url: nil, urlToImage: nil, publishedAt: Date(timeIntervalSince1970: 0))
        ]))

        let reloadSemaphore = DispatchSemaphore(value: 0)
        let view = NewsViewInputMockableMock()
        let router = NewsRouterInputMockableMock()
        let sut = NewsPresenter(view: view, router: router)
        Perform(view, .reloadData(perform: { reloadSemaphore.signal() }))
        sut.viewLoaded()
        _ = reloadSemaphore.wait(timeout: .now() + 2)

        // When
        // Simulate selecting the first list cell.
        sut.didSelectRow(at: IndexPath(row: 0, section: 0))

        // Then
        // Router must receive openArticle interaction once.
        Verify(router, .once, .openArticle(article: .any))

        StorageService.shared.removeObserver(sut)
        CacheService.shared.clearCache()
    }

    @Test("Favorite tap updates favorite UI state")
    func didTapFavoriteUpdatesFavoriteUI() {
        // Given
        // Cache one article so favorite toggle has a valid target row.
        bootstrapUnitDITestSetup()
        let title = "fav-\(UUID().uuidString)"
        CacheService.shared.cacheNews(NewsSource(status: "ok", totalResults: 1, articles: [
            Article(author: "A", title: title, description: "D", url: nil, urlToImage: nil, publishedAt: Date(timeIntervalSince1970: 0))
        ]))

        let reloadSemaphore = DispatchSemaphore(value: 0)
        let view = NewsViewInputMockableMock()
        let router = NewsRouterInputMockableMock()
        let sut = NewsPresenter(view: view, router: router)
        Perform(view, .reloadData(perform: { reloadSemaphore.signal() }))
        sut.viewLoaded()
        _ = reloadSemaphore.wait(timeout: .now() + 2)

        // When
        // Toggle favorite state from list cell action.
        sut.didTapFavorite(at: IndexPath(row: 0, section: 0))

        // Then
        // View should receive favorite cell refresh request.
        Verify(view, .once, .updateFavorite(at: .any))

        StorageService.shared.removeObserver(sut)
        StorageService.shared.removeFromFavorites(title: title)
        CacheService.shared.clearCache()
    }
}

private func bootstrapUnitDITestSetup() {
    #if DEBUG
    Configurator.shared.setupForUnitTests()
    #else
    Configurator.shared.setup()
    #endif
}
