import Foundation
import Testing
@testable import TestingTask

@Suite("Favorite Presenter Tests")
struct FavoriteScreenPresenterTests {
    @Test("View load shows non-empty state when storage contains favorites")
    func viewLoadedShowsNonEmptyState() {
        // Given
        bootstrapUnitDITestSetup()
        let title = "favorite-\(UUID().uuidString)"
        StorageService.shared.addToFavorites(title: title,
                                             contents: "Body",
                                             publishedAt: Date(timeIntervalSince1970: 0),
                                             urlToImage: nil)
        defer {
            StorageService.shared.removeFromFavorites(title: title)
        }

        let view = FavoriteViewInputMockableMock()
        let router = FavoriteRouterInputMockableMock()
        let sut = FavoritePresenter(view: view, router: router)
        var lastEmptyState: Bool?
        Perform(view, .showEmptyState(.any, perform: { lastEmptyState = $0 }))

        // When
        sut.viewLoaded()

        // Then
        Verify(view, .once, .setup())
        Verify(view, .reloadData())
        Verify(view, .showEmptyState(.value(false)))
        #expect(lastEmptyState == false)
        #expect(sut.numberOfRows() >= 1)

        StorageService.shared.removeObserver(sut)
    }

    @Test("Select row routes to article screen")
    func didSelectRowRoutesToArticle() {
        // Given
        bootstrapUnitDITestSetup()
        let title = "favorite-route-\(UUID().uuidString)"
        StorageService.shared.addToFavorites(title: title,
                                             contents: "Body",
                                             publishedAt: Date(timeIntervalSince1970: 0),
                                             urlToImage: nil)
        defer {
            StorageService.shared.removeFromFavorites(title: title)
        }

        let view = FavoriteViewInputMockableMock()
        let router = FavoriteRouterInputMockableMock()
        let sut = FavoritePresenter(view: view, router: router)
        sut.viewLoaded()

        // When
        if sut.numberOfRows() > 0 {
            sut.didSelectRow(at: IndexPath(row: 0, section: 0))
        }

        // Then
        Verify(router, .once, .openArticle(article: .any))

        StorageService.shared.removeObserver(sut)
    }

    @Test("View will appear refreshes selection visuals")
    func viewWillAppearRefreshesSelectionVisuals() {
        // Given
        bootstrapUnitDITestSetup()
        let view = FavoriteViewInputMockableMock()
        let router = FavoriteRouterInputMockableMock()
        let sut = FavoritePresenter(view: view, router: router)

        // When
        sut.viewWillAppear()

        // Then
        Verify(view, .once, .updateSelectedCell())
        Verify(view, .reloadData())

        StorageService.shared.removeObserver(sut)
    }
}

private func bootstrapUnitDITestSetup() {
    #if DEBUG
    Configurator.shared.setupForUnitTests()
    #else
    Configurator.shared.setup()
    #endif
}
