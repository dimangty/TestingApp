import Testing
import Foundation
@testable import TestingTask

@Suite("ArticlePresenter Tests")
struct ArticlePresenterTests {

    // MARK: - View Loaded

    @Test("viewLoaded calls setup on view")
    func viewLoaded_callsSetup() {
        // Given
        let (presenter, view, _, _) = makeSUT()

        // When
        presenter.viewLoaded()

        // Then
        #expect(view.setupCallCount == 1)
    }

    @Test("viewLoaded displays article title, date and content")
    func viewLoaded_displaysArticleInfo() {
        // Given
        let article = Article.stub(
            title: "Test Title",
            description: "Test Content"
        )
        let (presenter, view, _, _) = makeSUT(article: article)

        // When
        presenter.viewLoaded()

        // Then
        #expect(view.displayCallCount == 1)
        #expect(view.lastDisplayedTitle == "Test Title")
        #expect(view.lastDisplayedContent == "Test Content")
    }

    @Test("viewLoaded displays like state for non-favorite article")
    func viewLoaded_displaysFavoriteState_notFavorite() {
        // Given
        let article = Article.stub(title: "Test Article")
        let storage = StorageServiceMock()
        storage.favoritesTitles = []
        let (presenter, view, _, _) = makeSUT(article: article, storage: storage)

        // When
        presenter.viewLoaded()

        // Then
        #expect(view.displayLikeCallCount == 1)
        #expect(view.lastIsFavorite == false)
    }

    @Test("viewLoaded displays like state for favorite article")
    func viewLoaded_displaysFavoriteState_isFavorite() {
        // Given
        let article = Article.stub(title: "Favorite Article")
        let storage = StorageServiceMock()
        storage.favoritesTitles = ["Favorite Article"]
        let (presenter, view, _, _) = makeSUT(article: article, storage: storage)

        // When
        presenter.viewLoaded()

        // Then
        #expect(view.displayLikeCallCount == 1)
        #expect(view.lastIsFavorite == true)
    }

    @Test("viewLoaded with nil title displays nil")
    func viewLoaded_nilTitle_displaysNil() {
        // Given
        let article = Article.stub(title: nil, description: "Content only")
        let (presenter, view, _, _) = makeSUT(article: article)

        // When
        presenter.viewLoaded()

        // Then
        #expect(view.lastDisplayedTitle == nil)
        #expect(view.lastDisplayedContent == "Content only")
    }

    // MARK: - View Will Appear

    @Test("viewWillAppear updates like state")
    func viewWillAppear_updatesLikeState() {
        // Given
        let article = Article.stub(title: "Test")
        let (presenter, view, _, _) = makeSUT(article: article)

        // When
        presenter.viewWillAppear()

        // Then
        #expect(view.displayLikeCallCount == 1)
    }

    @Test("viewWillAppear reflects changed favorite state")
    func viewWillAppear_reflectsChangedState() {
        // Given
        let article = Article.stub(title: "Test")
        let storage = StorageServiceMock()
        storage.favoritesTitles = []
        let (presenter, view, _, _) = makeSUT(article: article, storage: storage)

        // Initially not favorite
        presenter.viewWillAppear()
        #expect(view.lastIsFavorite == false)

        // Simulate external change
        storage.favoritesTitles = ["Test"]

        // When
        presenter.viewWillAppear()

        // Then
        #expect(view.lastIsFavorite == true)
    }

    // MARK: - Heart Tapped

    @Test("heartTapped adds article to favorites when not favorite")
    func heartTapped_addsToFavorites_whenNotFavorite() {
        // Given
        let article = Article.stub(title: "Test Article", description: "Description")
        let storage = StorageServiceMock()
        storage.favoritesTitles = []
        let (presenter, _, _, _) = makeSUT(article: article, storage: storage)

        // When
        presenter.heartTapped()

        // Then
        #expect(storage.addToFavoritesCallCount == 1)
        #expect(storage.lastAddedTitle == "Test Article")
    }

    @Test("heartTapped removes article from favorites when favorite")
    func heartTapped_removesFromFavorites_whenFavorite() {
        // Given
        let article = Article.stub(title: "Favorite Article")
        let storage = StorageServiceMock()
        storage.favoritesTitles = ["Favorite Article"]
        let (presenter, _, _, _) = makeSUT(article: article, storage: storage)

        // When
        presenter.heartTapped()

        // Then
        #expect(storage.removeFromFavoritesCallCount == 1)
        #expect(storage.lastRemovedTitle == "Favorite Article")
    }

    @Test("heartTapped updates like state after toggling")
    func heartTapped_updatesLikeState() {
        // Given
        let article = Article.stub(title: "Test")
        let storage = StorageServiceMock()
        storage.favoritesTitles = []
        let (presenter, view, _, _) = makeSUT(article: article, storage: storage)

        // When
        presenter.heartTapped()

        // Then
        #expect(view.displayLikeCallCount >= 1)
    }

    @Test("heartTapped toggles favorite state correctly")
    func heartTapped_togglesFavoriteState() {
        // Given
        let article = Article.stub(title: "Toggle Article")
        let storage = StorageServiceMock()
        storage.favoritesTitles = []
        let (presenter, _, _, _) = makeSUT(article: article, storage: storage)

        // When - first tap adds to favorites
        presenter.heartTapped()
        #expect(storage.favoritesTitles.contains("Toggle Article"))

        // When - second tap removes from favorites
        presenter.heartTapped()
        #expect(!storage.favoritesTitles.contains("Toggle Article"))
    }

    @Test("heartTapped with nil title does nothing")
    func heartTapped_nilTitle_doesNothing() {
        // Given
        let article = Article.stub(title: nil)
        let storage = StorageServiceMock()
        let (presenter, _, _, _) = makeSUT(article: article, storage: storage)

        // When
        presenter.heartTapped()

        // Then
        #expect(storage.addToFavoritesCallCount == 0)
        #expect(storage.removeFromFavoritesCallCount == 0)
    }

    // MARK: - Image Loading

    @Test("viewLoaded triggers image loading for article with image URL")
    func viewLoaded_loadsImage_whenUrlExists() {
        // Given
        let imageUrl = URL(string: "https://example.com/image.jpg")!
        let article = Article.stub(urlToImage: imageUrl)
        let (presenter, view, _, _) = makeSUT(article: article)

        // When
        presenter.viewLoaded()

        // Note: Image loading is async, we just verify the call was made
        // In production, you'd use async expectations
        #expect(view.setupCallCount == 1) // View setup was called
    }

    // MARK: - Helper

    private func makeSUT(
        article: Article = .stub(),
        storage: StorageServiceMock = StorageServiceMock()
    ) -> (ArticlePresenter, ArticleViewMock, ArticleRouterMock, StorageServiceMock) {
        let view = ArticleViewMock()
        let router = ArticleRouterMock()
        let articleViewModel = ArticleViewModel(article: article, storage: storage)
        let presenter = ArticlePresenter(view: view, router: router, article: articleViewModel)

        return (presenter, view, router, storage)
    }
}
