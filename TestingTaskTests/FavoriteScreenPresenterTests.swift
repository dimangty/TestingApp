import Foundation
import Testing
@testable import TestingTask

@Suite("Favorite Presenter Tests")
struct FavoriteScreenPresenterTests {
    @Test("View load shows non-empty state when storage contains favorites")
    func viewLoadedShowsNonEmptyState() {
        // Given
        // Populate storage with one favorite to force non-empty rendering path.
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
        // Load presenter lifecycle to pull favorites from storage.
        sut.viewLoaded()

        // Then
        // View should render list content and hide empty-state label.
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
        // Add one favorite item so row selection is valid.
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
        // Simulate selecting first favorite cell.
        if sut.numberOfRows() > 0 {
            sut.didSelectRow(at: IndexPath(row: 0, section: 0))
        }

        // Then
        // Presenter should route to article details exactly once.
        Verify(router, .once, .openArticle(article: .any))

        StorageService.shared.removeObserver(sut)
    }

    @Test("View will appear refreshes selection visuals")
    func viewWillAppearRefreshesSelectionVisuals() {
        // Given
        // Module setup with mocked view to verify refresh callbacks.
        bootstrapUnitDITestSetup()
        let view = FavoriteViewInputMockableMock()
        let router = FavoriteRouterInputMockableMock()
        let sut = FavoritePresenter(view: view, router: router)

        // When
        // Trigger appearance callback used after returning from details screen.
        sut.viewWillAppear()

        // Then
        // Presenter should refresh data and selected-row visual state.
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
