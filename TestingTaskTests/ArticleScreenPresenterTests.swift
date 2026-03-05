import Foundation
import UIKit
import Testing
@testable import TestingTask

@Suite("Article Presenter Tests")
struct ArticlePresenterTests {
    @Test("Article presenter displays article data on load")
    func viewLoadedDisplaysArticleDataAndLikeState() {
        // Given
        let storage = ArticleStorageSpy()
        let article = Article(author: "A",
                              title: "ArticleTitle",
                              description: "Body",
                              url: nil,
                              urlToImage: nil,
                              publishedAt: Date(timeIntervalSince1970: 0))
        let model = ArticleViewModel(article: article, storage: storage)
        let view = ArticleViewInputMockableMock()
        let router = ArticleRouterInputMockableMock()
        let sut = ArticlePresenter(view: view, router: router, article: model)
        var displayedTitle: String?
        var displayedContent: String?
        var displayedLikeState: Bool?
        Perform(view, .display(title: .any, date: .any, content: .any, perform: { title, _, content in
            displayedTitle = title
            displayedContent = content
        }))
        Perform(view, .displayLike(isFavorite: .any, perform: { displayedLikeState = $0 }))

        // When
        sut.viewLoaded()

        // Then
        Verify(view, .once, .setup())
        Verify(view, .once, .display(title: .value("ArticleTitle"), date: .any, content: .value("Body")))
        Verify(view, .once, .displayLike(isFavorite: .value(false)))
        #expect(displayedTitle == "ArticleTitle")
        #expect(displayedContent == "Body")
        #expect(displayedLikeState == false)
    }

    @Test("Heart tap toggles favorite state")
    func heartTappedTogglesFavoriteState() {
        // Given
        let storage = ArticleStorageSpy()
        let article = Article(author: "A",
                              title: "FavArticle",
                              description: "Body",
                              url: nil,
                              urlToImage: nil,
                              publishedAt: Date(timeIntervalSince1970: 0))
        let model = ArticleViewModel(article: article, storage: storage)
        let view = ArticleViewInputMockableMock()
        let router = ArticleRouterInputMockableMock()
        let sut = ArticlePresenter(view: view, router: router, article: model)
        var likeValues: [Bool] = []
        Perform(view, .displayLike(isFavorite: .any, perform: { likeValues.append($0) }))

        // When
        sut.heartTapped()

        // Then
        #expect(storage.addToFavoritesCallCount == 1)
        #expect(storage.removeFromFavoritesCallCount == 0)
        Verify(view, .once, .displayLike(isFavorite: .value(true)))
        #expect(likeValues.last == true)
    }

    @Test("View will appear refreshes like state")
    func viewWillAppearRefreshesLikeState() {
        // Given
        let storage = ArticleStorageSpy(initialFavorites: ["FavArticle"])
        let article = Article(author: "A",
                              title: "FavArticle",
                              description: "Body",
                              url: nil,
                              urlToImage: nil,
                              publishedAt: Date(timeIntervalSince1970: 0))
        let model = ArticleViewModel(article: article, storage: storage)
        let view = ArticleViewInputMockableMock()
        let router = ArticleRouterInputMockableMock()
        let sut = ArticlePresenter(view: view, router: router, article: model)
        var displayedLikeState: Bool?
        Perform(view, .displayLike(isFavorite: .any, perform: { displayedLikeState = $0 }))

        // When
        sut.viewWillAppear()

        // Then
        Verify(view, .once, .displayLike(isFavorite: .value(true)))
        #expect(displayedLikeState == true)
    }
}

private final class ArticleStorageSpy: IStorageService {
    private(set) var addToFavoritesCallCount = 0
    private(set) var removeFromFavoritesCallCount = 0
    private var favoriteTitles: Set<String>

    init(initialFavorites: Set<String> = []) {
        self.favoriteTitles = initialFavorites
    }

    var articles: [ArticleEntity] { [] }

    func isArticleInFavorites(title: String) -> Bool {
        favoriteTitles.contains(title)
    }

    func isEmailRegistered(_ email: String) -> Bool {
        false
    }

    func addToFavorites(title: String, contents: String, publishedAt: Date, urlToImage: String?) {
        addToFavoritesCallCount += 1
        favoriteTitles.insert(title)
    }

    func removeFromFavorites(title: String) {
        removeFromFavoritesCallCount += 1
        favoriteTitles.remove(title)
    }

    func addObserver(_ observer: any NewsAppStorageObserver) {
    }

    func removeObserver(_ observer: any NewsAppStorageObserver) {
    }

    func addUser(userName: String, email: String, password: String) -> UserEntity {
        fatalError("Not used in these tests")
    }

    func getUserByEmailAndPassword(email: String, password: String) -> UserEntity? {
        nil
    }
}
