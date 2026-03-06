import Foundation
import UIKit
@testable import TestingTask

// MARK: - Login Screen Mocks

final class LoginScreenViewMock: LoginScreenViewInput {
    private(set) var setupCallCount = 0
    private(set) var updateConfirmButtonCallCount = 0
    private(set) var lastConfirmButtonEnabled: Bool?

    func setup() {
        setupCallCount += 1
    }

    func updateConfirmButton(enabled: Bool) {
        updateConfirmButtonCallCount += 1
        lastConfirmButtonEnabled = enabled
    }
}

final class LoginScreenRouterMock: LoginScreenRouterInput {
    private(set) var openMainScreenCallCount = 0
    private(set) var openSignUpScreenCallCount = 0

    func openMainScreen() {
        openMainScreenCallCount += 1
    }

    func openSignUpScreen() {
        openSignUpScreenCallCount += 1
    }
}

// MARK: - SignUp Screen Mocks

final class SignUpScreenViewMock: SignUpScreenViewInput {
    private(set) var setupCallCount = 0
    private(set) var updateCreateButtonCallCount = 0
    private(set) var lastCreateButtonEnabled: Bool?

    func setup() {
        setupCallCount += 1
    }

    func updateCreateButton(enabled: Bool) {
        updateCreateButtonCallCount += 1
        lastCreateButtonEnabled = enabled
    }
}

final class SignUpScreenRouterMock: SignUpScreenRouterInput {
    private(set) var closeCallCount = 0
    private(set) var openMainScreenCallCount = 0

    func close() {
        closeCallCount += 1
    }

    func openMainScreen() {
        openMainScreenCallCount += 1
    }
}

// MARK: - News Screen Mocks

final class NewsViewMock: NewsViewInput {
    private(set) var setupCallCount = 0
    private(set) var showLoadingCallCount = 0
    private(set) var reloadDataCallCount = 0
    private(set) var updateFavoriteCallCount = 0
    private(set) var updateSelectedCellCallCount = 0

    private(set) var lastLoadingState: Bool?
    private(set) var lastFavoriteIndexPath: IndexPath?

    func setup() {
        setupCallCount += 1
    }

    func showLoading(_ isLoading: Bool) {
        showLoadingCallCount += 1
        lastLoadingState = isLoading
    }

    func reloadData() {
        reloadDataCallCount += 1
    }

    func updateFavorite(at indexPath: IndexPath) {
        updateFavoriteCallCount += 1
        lastFavoriteIndexPath = indexPath
    }

    func updateSelectedCell() {
        updateSelectedCellCallCount += 1
    }
}

final class NewsRouterMock: NewsRouterInput {
    private(set) var openArticleCallCount = 0
    private(set) var lastOpenedArticle: ArticleViewModel?

    func openArticle(article: ArticleViewModel) {
        openArticleCallCount += 1
        lastOpenedArticle = article
    }
}

// MARK: - Article Screen Mocks

final class ArticleViewMock: ArticleViewInput {
    private(set) var setupCallCount = 0
    private(set) var displayCallCount = 0
    private(set) var displayImageCallCount = 0
    private(set) var displayLikeCallCount = 0

    private(set) var lastDisplayedTitle: String?
    private(set) var lastDisplayedDate: String?
    private(set) var lastDisplayedContent: String?
    private(set) var lastDisplayedImage: UIImage?
    private(set) var lastIsFavorite: Bool?

    func setup() {
        setupCallCount += 1
    }

    func display(title: String?, date: String, content: String?) {
        displayCallCount += 1
        lastDisplayedTitle = title
        lastDisplayedDate = date
        lastDisplayedContent = content
    }

    func displayImage(_ image: UIImage?) {
        displayImageCallCount += 1
        lastDisplayedImage = image
    }

    func displayLike(isFavorite: Bool) {
        displayLikeCallCount += 1
        lastIsFavorite = isFavorite
    }
}

final class ArticleRouterMock: ArticleRouterInput {
}

// MARK: - Favorite Screen Mocks

final class FavoriteViewMock: FavoriteViewInput {
    private(set) var setupCallCount = 0
    private(set) var reloadDataCallCount = 0
    private(set) var updateFavoriteCallCount = 0
    private(set) var updateSelectedCellCallCount = 0
    private(set) var showEmptyStateCallCount = 0

    private(set) var lastFavoriteIndexPath: IndexPath?
    private(set) var lastEmptyState: Bool?

    func setup() {
        setupCallCount += 1
    }

    func reloadData() {
        reloadDataCallCount += 1
    }

    func updateFavorite(at indexPath: IndexPath) {
        updateFavoriteCallCount += 1
        lastFavoriteIndexPath = indexPath
    }

    func updateSelectedCell() {
        updateSelectedCellCallCount += 1
    }

    func showEmptyState(_ isEmpty: Bool) {
        showEmptyStateCallCount += 1
        lastEmptyState = isEmpty
    }
}

final class FavoriteRouterMock: FavoriteRouterInput {
    private(set) var openArticleCallCount = 0
    private(set) var lastOpenedArticle: ArticleViewModel?

    func openArticle(article: ArticleViewModel) {
        openArticleCallCount += 1
        lastOpenedArticle = article
    }
}

// MARK: - Service Mocks

final class AuthServiceMock: AuthServiceProtocol {
    private(set) var loginCallCount = 0
    private(set) var signUpCallCount = 0
    private(set) var lastLoginPhone: String?
    private(set) var lastSignUpData: SignUpData?

    var loginResult: Result<Void, Error> = .success(())
    var signUpResult: Result<Void, Error> = .success(())

    func login(phone: String, completion: @escaping (Result<Void, Error>) -> Void) {
        loginCallCount += 1
        lastLoginPhone = phone
        completion(loginResult)
    }

    func signUp(data: SignUpData, completion: @escaping (Result<Void, Error>) -> Void) {
        signUpCallCount += 1
        lastSignUpData = data
        completion(signUpResult)
    }
}

final class NewsServiceMock: INewsService {
    private(set) var performNewsRequestCallCount = 0
    var newsResult: Result<NewsSource, Error> = .success(NewsSource(status: "ok", totalResults: 0, articles: []))

    func performNewsRequest(completion: @escaping (Result<NewsSource, Error>) -> Void) {
        performNewsRequestCallCount += 1
        DispatchQueue.main.async {
            completion(self.newsResult)
        }
    }
}

final class StorageServiceMock: IStorageService {
    private(set) var isArticleInFavoritesCallCount = 0
    private(set) var addToFavoritesCallCount = 0
    private(set) var removeFromFavoritesCallCount = 0
    private(set) var addObserverCallCount = 0
    private(set) var removeObserverCallCount = 0

    private(set) var lastCheckedTitle: String?
    private(set) var lastAddedTitle: String?
    private(set) var lastRemovedTitle: String?

    var favoritesTitles: Set<String> = []
    var articles: [ArticleEntity] = []
    private var observers: [NewsAppStorageObserver] = []

    func isArticleInFavorites(title: String) -> Bool {
        isArticleInFavoritesCallCount += 1
        lastCheckedTitle = title
        return favoritesTitles.contains(title)
    }

    func isEmailRegistered(_ email: String) -> Bool {
        return false
    }

    func addToFavorites(title: String, contents: String, publishedAt: Date, urlToImage: String?) {
        addToFavoritesCallCount += 1
        lastAddedTitle = title
        favoritesTitles.insert(title)
    }

    func removeFromFavorites(title: String) {
        removeFromFavoritesCallCount += 1
        lastRemovedTitle = title
        favoritesTitles.remove(title)
        observers.forEach { $0.didRemoveFromFavorites(title: title) }
    }

    func addObserver(_ observer: NewsAppStorageObserver) {
        addObserverCallCount += 1
        observers.append(observer)
    }

    func removeObserver(_ observer: NewsAppStorageObserver) {
        removeObserverCallCount += 1
        observers.removeAll { $0 === observer }
    }

    func addUser(userName: String, email: String, password: String) -> UserEntity {
        fatalError("Not implemented for testing")
    }

    func getUserByEmailAndPassword(email: String, password: String) -> UserEntity? {
        return nil
    }
}

final class ProgressServiceMock: IProgressService {
    private(set) var showCallCount = 0
    private(set) var hideCallCount = 0
    var isShown: Bool = false

    func show() {
        showCallCount += 1
        isShown = true
    }

    func showWithoutDim() {
        showCallCount += 1
        isShown = true
    }

    func showWithoutDim(timeOut: Int) {
        showCallCount += 1
        isShown = true
    }

    func show(style: ProgressStyle) {
        showCallCount += 1
        isShown = true
    }

    func showWithoutDim(style: ProgressStyle) {
        showCallCount += 1
        isShown = true
    }

    func hide() {
        hideCallCount += 1
        isShown = false
    }
}

final class ErrorServiceMock: IErrorService {
    private(set) var showErrorCallCount = 0
    private(set) var lastErrorText: String?

    func setDelegate(_ delegate: ErrorServiceDelegate) {}

    func show(errorText: String) {
        showErrorCallCount += 1
        lastErrorText = errorText
    }

    func show(with title: String?, errorText: String, completion: @escaping (() -> Void)) {
        showErrorCallCount += 1
        lastErrorText = errorText
        completion()
    }

    func show(title: String?, message: String, actionTitle: String?, cancelTitle: String?, actionType: UIAlertAction.Style, completion: @escaping (() -> Void)) {
        showErrorCallCount += 1
        lastErrorText = message
        completion()
    }

    func show(title: String?, message: String, actionTitle: String?, cancelTitle: String?, actionType: UIAlertAction.Style, actionHandler: @escaping (() -> Void), cancelHandler: @escaping (() -> Void)) {
        showErrorCallCount += 1
        lastErrorText = message
    }

    func show(title: String?, attributedMessage: NSAttributedString, actionTitle: String?, cancelTitle: String?, actionType: UIAlertAction.Style, actionHandler: (() -> Void)?, cancelHandler: (() -> Void)?) {
        showErrorCallCount += 1
        lastErrorText = attributedMessage.string
    }
}

final class ValidationServiceMock: ValidationService {
    private(set) var isValidCallCount = 0
    private(set) var lastValidatedField: SignUpField?
    private(set) var lastValidatedValue: String?

    var validationResult: Bool = true

    override func isValid(field: SignUpField, value: String) -> Bool {
        isValidCallCount += 1
        lastValidatedField = field
        lastValidatedValue = value
        return validationResult
    }
}

// MARK: - Test Helpers

extension Article {
    static func stub(
        author: String? = "Test Author",
        title: String? = "Test Title",
        description: String? = "Test Description",
        url: URL? = URL(string: "https://example.com"),
        urlToImage: URL? = nil,
        publishedAt: Date = Date()
    ) -> Article {
        return Article(
            author: author,
            title: title,
            description: description,
            url: url,
            urlToImage: urlToImage,
            publishedAt: publishedAt
        )
    }
}

extension NewsSource {
    static func stub(articles: [Article] = []) -> NewsSource {
        return NewsSource(status: "ok", totalResults: articles.count, articles: articles)
    }
}

// MARK: - Testable Presenter Wrappers

/// Testable version of NewsPresenter that allows dependency injection
final class TestableNewsPresenter: NewsViewOutput, NewsAppStorageObserver {
    private let view: NewsViewInput
    private let router: NewsRouterInput
    private let newsService: INewsService
    private let storage: IStorageService
    private let errorService: IErrorService

    private var articles: [ArticleViewModel] = []
    private var allArticles: [ArticleViewModel] = []
    private var searchText: String = ""

    init(view: NewsViewInput, router: NewsRouterInput, newsService: INewsService, storage: IStorageService, errorService: IErrorService) {
        self.view = view
        self.router = router
        self.newsService = newsService
        self.storage = storage
        self.errorService = errorService

        storage.addObserver(self)
    }

    func viewLoaded() {
        view.setup()
        loadArticles()
    }

    func viewWillAppear() {
        view.updateSelectedCell()
    }

    func numberOfRows() -> Int {
        return articles.count
    }

    func article(at indexPath: IndexPath) -> ArticleViewModel {
        return articles[indexPath.row]
    }

    func didSelectRow(at indexPath: IndexPath) {
        let article = articles[indexPath.row]
        router.openArticle(article: article)
    }

    func didTapFavorite(at indexPath: IndexPath) {
        let article = articles[indexPath.row]
        article.addOrRemoveFromFavorites()
        view.updateFavorite(at: indexPath)
    }

    func didUpdateSearch(text: String) {
        searchText = text
        applyFilter()
    }

    func didRemoveFromFavorites(title: String) {
        if let removedIndex = articles.firstIndex(where: { $0.title == title }) {
            view.updateFavorite(at: IndexPath(row: removedIndex, section: 0))
        }
    }

    func didAddToFavorites(article: ArticleEntity) {
    }

    private func loadArticles() {
        articles.removeAll(keepingCapacity: true)
        allArticles.removeAll(keepingCapacity: true)
        view.showLoading(true)

        newsService.performNewsRequest { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.view.showLoading(false)

                switch result {
                case .failure(let error):
                    self.errorService.show(errorText: error.localizedDescription)
                case .success(let newsSource):
                    self.allArticles = newsSource.articles.map { article in
                        ArticleViewModel(article: article, storage: self.storage)
                    }
                    self.applyFilter()
                }
            }
        }
    }

    private func applyFilter() {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            articles = allArticles
        } else {
            let query = searchText.lowercased()
            articles = allArticles.filter { ($0.title ?? "").lowercased().contains(query) }
        }
        view.reloadData()
    }
}

/// Testable version of FavoritePresenter that allows dependency injection
final class TestableFavoritePresenter: FavoriteViewOutput, NewsAppStorageObserver {
    private weak var view: FavoriteViewInput?
    private let router: FavoriteRouterInput
    private let storage: IStorageService

    private var articles: [ArticleViewModel] = []

    init(view: FavoriteViewInput, router: FavoriteRouterInput, storage: IStorageService) {
        self.view = view
        self.router = router
        self.storage = storage

        storage.addObserver(self)
    }

    func viewLoaded() {
        view?.setup()
        reloadFavorites()
    }

    func viewWillAppear() {
        reloadFavorites()
        view?.updateSelectedCell()
    }

    func numberOfRows() -> Int {
        return articles.count
    }

    func article(at indexPath: IndexPath) -> ArticleViewModel {
        return articles[indexPath.row]
    }

    func didSelectRow(at indexPath: IndexPath) {
        let article = articles[indexPath.row]
        router.openArticle(article: article)
    }

    func didTapFavorite(at indexPath: IndexPath) {
        let article = articles[indexPath.row]
        article.addOrRemoveFromFavorites()
    }

    func didRemoveFromFavorites(title: String) {
        if let removedIndex = articles.firstIndex(where: { $0.title == title }) {
            articles.remove(at: removedIndex)
            view?.reloadData()
            view?.showEmptyState(articles.isEmpty)
        }
    }

    func didAddToFavorites(article: ArticleEntity) {
        reloadFavorites()
    }

    private func reloadFavorites() {
        articles = storage.articles.map { ArticleViewModel(article: $0.toArticle(), storage: storage) }
        view?.reloadData()
        view?.showEmptyState(articles.isEmpty)
    }
}

