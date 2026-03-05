import Foundation
import UIKit
import Testing
@testable import TestingTask

@Suite("Login Presenter Tests")
struct LoginScreenPresenterTests {
    @Test("View load configures screen and disables confirm for empty phone")
    func viewLoadedConfiguresAndDisablesConfirm() {
        // Given
        let view = LoginViewMock()
        let router = LoginRouterMock()
        let sut = LoginScreenPresenter(view: view, router: router)

        // When
        sut.viewLoaded()

        // Then
        #expect(view.setupCallCount == 1)
        #expect(view.lastConfirmEnabled == false)
    }

    @Test("Phone changes update confirm button state")
    func phoneChangedUpdatesConfirmButtonState() {
        // Given
        let view = LoginViewMock()
        let router = LoginRouterMock()
        let sut = LoginScreenPresenter(view: view, router: router)

        // When
        sut.phoneChanged("123")
        let firstState = view.lastConfirmEnabled
        sut.phoneChanged("1234567")
        let secondState = view.lastConfirmEnabled

        // Then
        #expect(firstState == false)
        #expect(secondState == true)
    }

    @Test("Invalid phone does not trigger auth or navigation")
    func confirmTappedWithInvalidPhoneDoesNotNavigate() {
        // Given
        let view = LoginViewMock()
        let router = LoginRouterMock()
        let auth = AuthServiceMock(result: .success(()))
        let sut = LoginScreenPresenter(view: view, router: router)
        sut.authService = auth

        // When
        sut.phoneChanged("123")
        sut.confirmTapped()

        // Then
        #expect(auth.loginCallCount == 0)
        #expect(router.openMainCallCount == 0)
        #expect(router.openSignUpCallCount == 0)
    }

    @Test("Valid phone with successful auth opens main")
    func confirmTappedSuccessOpensMain() {
        // Given
        let view = LoginViewMock()
        let router = LoginRouterMock()
        let auth = AuthServiceMock(result: .success(()))
        let progress = ProgressServiceMock()
        let error = ErrorServiceMock()
        let sut = LoginScreenPresenter(view: view, router: router)
        sut.authService = auth
        sut.progressService = progress
        sut.errorService = error

        // When
        sut.phoneChanged("1234567")
        sut.confirmTapped()

        // Then
        #expect(auth.loginCallCount == 1)
        #expect(progress.showCallCount == 1)
        #expect(progress.hideCallCount == 1)
        #expect(router.openMainCallCount == 1)
        #expect(error.showErrorCallCount == 0)
    }

    @Test("Auth failure shows user-facing error")
    func confirmTappedFailureShowsError() {
        // Given
        let view = LoginViewMock()
        let router = LoginRouterMock()
        let auth = AuthServiceMock(result: .failure(AuthError.invalidPhone))
        let progress = ProgressServiceMock()
        let error = ErrorServiceMock()
        let sut = LoginScreenPresenter(view: view, router: router)
        sut.authService = auth
        sut.progressService = progress
        sut.errorService = error

        // When
        sut.phoneChanged("1234567")
        sut.confirmTapped()

        // Then
        #expect(auth.loginCallCount == 1)
        #expect(progress.showCallCount == 1)
        #expect(progress.hideCallCount == 1)
        #expect(router.openMainCallCount == 0)
        #expect(error.showErrorCallCount == 1)
        #expect(error.lastErrorText == "Invalid phone number")
    }

    @Test("Sign up action routes to sign-up screen")
    func signUpTappedOpensSignUpScreen() {
        // Given
        let view = LoginViewMock()
        let router = LoginRouterMock()
        let sut = LoginScreenPresenter(view: view, router: router)

        // When
        sut.signUpTapped()

        // Then
        #expect(router.openSignUpCallCount == 1)
        #expect(router.openMainCallCount == 0)
    }
}

@Suite("Sign-Up Presenter Tests")
struct SignUpScreenPresenterTests {
    @Test("View load configures screen and disables create for empty fields")
    func viewLoadedConfiguresAndDisablesCreate() {
        // Given
        let view = SignUpViewMock()
        let router = SignUpRouterMock()
        let validation = ValidationService()
        let sut = SignUpScreenPresenter(view: view, router: router)
        sut.validationService = validation

        // When
        sut.viewLoaded()

        // Then
        #expect(view.setupCallCount == 1)
        #expect(view.lastCreateEnabled == false)
    }

    @Test("Valid fields enable create button")
    func fieldChangedWithValidValuesEnablesCreate() {
        // Given
        let view = SignUpViewMock()
        let router = SignUpRouterMock()
        let validation = ValidationService()
        let sut = SignUpScreenPresenter(view: view, router: router)
        sut.validationService = validation

        // When
        for field in SignUpField.allCases {
            let value = field == .email ? "test@mail.com" : (field == .phone ? "1234567" : "Value")
            sut.fieldChanged(field, value: value)
        }

        // Then
        #expect(view.lastCreateEnabled == true)
    }

    @Test("Successful account creation opens main")
    func createAccountTappedSuccessOpensMain() {
        // Given
        let view = SignUpViewMock()
        let router = SignUpRouterMock()
        let auth = AuthServiceMock(result: .success(()))
        let validation = ValidationService()
        let progress = ProgressServiceMock()
        let error = ErrorServiceMock()
        let sut = SignUpScreenPresenter(view: view, router: router)
        sut.authService = auth
        sut.validationService = validation
        sut.progressService = progress
        sut.errorService = error

        for field in SignUpField.allCases {
            let value = field == .email ? "test@mail.com" : (field == .phone ? "1234567" : "Value")
            sut.fieldChanged(field, value: value)
        }

        // When
        sut.createAccountTapped()

        // Then
        #expect(auth.signUpCallCount == 1)
        #expect(progress.showCallCount == 1)
        #expect(progress.hideCallCount == 1)
        #expect(router.openMainCallCount == 1)
        #expect(error.showErrorCallCount == 0)
    }

    @Test("Failed account creation shows error")
    func createAccountTappedFailureShowsError() {
        // Given
        let view = SignUpViewMock()
        let router = SignUpRouterMock()
        let auth = AuthServiceMock(result: .failure(AuthError.invalidData))
        let validation = ValidationService()
        let progress = ProgressServiceMock()
        let error = ErrorServiceMock()
        let sut = SignUpScreenPresenter(view: view, router: router)
        sut.authService = auth
        sut.validationService = validation
        sut.progressService = progress
        sut.errorService = error

        for field in SignUpField.allCases {
            let value = field == .email ? "test@mail.com" : (field == .phone ? "1234567" : "Value")
            sut.fieldChanged(field, value: value)
        }

        // When
        sut.createAccountTapped()

        // Then
        #expect(auth.signUpCallCount == 1)
        #expect(progress.showCallCount == 1)
        #expect(progress.hideCallCount == 1)
        #expect(router.openMainCallCount == 0)
        #expect(error.showErrorCallCount == 1)
        #expect(error.lastErrorText == "Sign up failed")
    }

    @Test("Back action closes module")
    func backTappedClosesModule() {
        // Given
        let view = SignUpViewMock()
        let router = SignUpRouterMock()
        let sut = SignUpScreenPresenter(view: view, router: router)

        // When
        sut.backTapped()

        // Then
        #expect(router.closeCallCount == 1)
        #expect(router.openMainCallCount == 0)
    }
}

@Suite("Article View Model + Presenter Tests")
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
        let view = ArticleViewMock()
        let router = ArticleRouterMock()
        let sut = ArticlePresenter(view: view, router: router, article: model)

        // When
        sut.viewLoaded()

        // Then
        #expect(view.setupCallCount == 1)
        #expect(view.lastTitle == "ArticleTitle")
        #expect(view.lastContent == "Body")
        #expect(view.lastLikeValue == false)
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
        let view = ArticleViewMock()
        let router = ArticleRouterMock()
        let sut = ArticlePresenter(view: view, router: router, article: model)

        // When
        sut.heartTapped()

        // Then
        #expect(storage.addToFavoritesCallCount == 1)
        #expect(storage.removeFromFavoritesCallCount == 0)
        #expect(view.lastLikeValue == true)
    }
}

@Suite("News + Favorite Presenter Smoke Tests")
struct NewsAndFavoritePresenterTests {
    @Test("News presenter loads cached articles and filters by search")
    func newsPresenterLoadsAndFiltersCachedArticles() {
        // Given
        bootstrapUnitDI()
        let uniquePrefix = "news-\(UUID().uuidString)"
        let source = NewsSource(status: "ok", totalResults: 2, articles: [
            Article(author: "A", title: "\(uniquePrefix)-alpha", description: "D1", url: nil, urlToImage: nil, publishedAt: Date(timeIntervalSince1970: 0)),
            Article(author: "B", title: "\(uniquePrefix)-beta", description: "D2", url: nil, urlToImage: nil, publishedAt: Date(timeIntervalSince1970: 60))
        ])
        CacheService.shared.cacheNews(source)

        let reloadSemaphore = DispatchSemaphore(value: 0)
        let view = NewsViewMock(onReloadData: { reloadSemaphore.signal() })
        let router = NewsRouterMock()
        let sut = NewsPresenter(view: view, router: router)

        // When
        sut.viewLoaded()
        let waitResult = reloadSemaphore.wait(timeout: .now() + 2)
        sut.didUpdateSearch(text: "alpha")

        // Then
        switch waitResult {
        case .success:
            #expect(true)
        case .timedOut:
            #expect(false)
        }
        #expect(view.setupCallCount == 1)
        #expect(sut.numberOfRows() == 1)

        sut.didSelectRow(at: IndexPath(row: 0, section: 0))
        #expect(router.openArticleCallCount == 1)

        CacheService.shared.clearCache()
    }

    @Test("Favorite presenter shows non-empty state when storage contains favorites")
    func favoritePresenterShowsDataFromStorage() {
        // Given
        bootstrapUnitDI()
        let title = "favorite-\(UUID().uuidString)"
        let storage = StorageService.shared
        storage.addToFavorites(title: title,
                               contents: "Body",
                               publishedAt: Date(timeIntervalSince1970: 0),
                               urlToImage: nil)
        defer {
            storage.removeFromFavorites(title: title)
        }

        let view = FavoriteViewMock()
        let router = FavoriteRouterMock()
        let sut = FavoritePresenter(view: view, router: router)

        // When
        sut.viewLoaded()

        // Then
        #expect(view.setupCallCount == 1)
        #expect(view.reloadDataCallCount >= 1)
        #expect(view.lastEmptyState == false)
        #expect(sut.numberOfRows() >= 1)
    }
}

private func bootstrapUnitDI() {
    #if DEBUG
    Configurator.shared.setupForUnitTests()
    #else
    Configurator.shared.setup()
    #endif
}

// SwiftMocky-style protocol mocks: call counters + captured arguments.
private final class LoginViewMock: LoginScreenViewInput {
    private(set) var setupCallCount = 0
    private(set) var lastConfirmEnabled = false

    func setup() {
        setupCallCount += 1
    }

    func updateConfirmButton(enabled: Bool) {
        lastConfirmEnabled = enabled
    }
}

private final class LoginRouterMock: LoginScreenRouterInput {
    private(set) var openMainCallCount = 0
    private(set) var openSignUpCallCount = 0

    func openMainScreen() {
        openMainCallCount += 1
    }

    func openSignUpScreen() {
        openSignUpCallCount += 1
    }
}

private final class SignUpViewMock: SignUpScreenViewInput {
    private(set) var setupCallCount = 0
    private(set) var lastCreateEnabled = false

    func setup() {
        setupCallCount += 1
    }

    func updateCreateButton(enabled: Bool) {
        lastCreateEnabled = enabled
    }
}

private final class SignUpRouterMock: SignUpScreenRouterInput {
    private(set) var closeCallCount = 0
    private(set) var openMainCallCount = 0

    func close() {
        closeCallCount += 1
    }

    func openMainScreen() {
        openMainCallCount += 1
    }
}

private final class AuthServiceMock: AuthServiceProtocol {
    private(set) var loginCallCount = 0
    private(set) var signUpCallCount = 0
    let result: Result<Void, Error>

    init(result: Result<Void, Error>) {
        self.result = result
    }

    func login(phone: String, completion: @escaping (Result<Void, Error>) -> Void) {
        loginCallCount += 1
        completion(result)
    }

    func signUp(data: SignUpData, completion: @escaping (Result<Void, Error>) -> Void) {
        signUpCallCount += 1
        completion(result)
    }
}

private final class ProgressServiceMock: ProgressService {
    private(set) var showCallCount = 0
    private(set) var hideCallCount = 0

    override func show() {
        showCallCount += 1
    }

    override func hide() {
        hideCallCount += 1
    }
}

private final class ErrorServiceMock: ErrorService {
    private(set) var showErrorCallCount = 0
    private(set) var lastErrorText: String?

    override func show(errorText: String) {
        showErrorCallCount += 1
        lastErrorText = errorText
    }
}

private final class ArticleRouterMock: ArticleRouterInput {}

private final class ArticleViewMock: ArticleViewInput {
    private(set) var setupCallCount = 0
    private(set) var lastTitle: String?
    private(set) var lastDate: String?
    private(set) var lastContent: String?
    private(set) var lastLikeValue: Bool?

    func setup() {
        setupCallCount += 1
    }

    func display(title: String?, date: String, content: String?) {
        lastTitle = title
        lastDate = date
        lastContent = content
    }

    func displayImage(_ image: UIImage?) {
    }

    func displayLike(isFavorite: Bool) {
        lastLikeValue = isFavorite
    }
}

private final class ArticleStorageSpy: IStorageService {
    private(set) var addToFavoritesCallCount = 0
    private(set) var removeFromFavoritesCallCount = 0
    private var favoriteTitles = Set<String>()

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

private final class NewsViewMock: NewsViewInput {
    private(set) var setupCallCount = 0
    private(set) var showLoadingValues: [Bool] = []
    private(set) var reloadDataCallCount = 0
    private(set) var updateFavoriteCallCount = 0
    private(set) var updateSelectedCellCallCount = 0

    private let onReloadData: (() -> Void)?

    init(onReloadData: (() -> Void)? = nil) {
        self.onReloadData = onReloadData
    }

    func setup() {
        setupCallCount += 1
    }

    func showLoading(_ isLoading: Bool) {
        showLoadingValues.append(isLoading)
    }

    func reloadData() {
        reloadDataCallCount += 1
        onReloadData?()
    }

    func updateFavorite(at indexPath: IndexPath) {
        updateFavoriteCallCount += 1
    }

    func updateSelectedCell() {
        updateSelectedCellCallCount += 1
    }
}

private final class NewsRouterMock: NewsRouterInput {
    private(set) var openArticleCallCount = 0

    func openArticle(article: ArticleViewModel) {
        openArticleCallCount += 1
    }
}

private final class FavoriteViewMock: FavoriteViewInput {
    private(set) var setupCallCount = 0
    private(set) var reloadDataCallCount = 0
    private(set) var updateFavoriteCallCount = 0
    private(set) var updateSelectedCellCallCount = 0
    private(set) var lastEmptyState: Bool?

    func setup() {
        setupCallCount += 1
    }

    func reloadData() {
        reloadDataCallCount += 1
    }

    func updateFavorite(at indexPath: IndexPath) {
        updateFavoriteCallCount += 1
    }

    func updateSelectedCell() {
        updateSelectedCellCallCount += 1
    }

    func showEmptyState(_ isEmpty: Bool) {
        lastEmptyState = isEmpty
    }
}

private final class FavoriteRouterMock: FavoriteRouterInput {
    private(set) var openArticleCallCount = 0

    func openArticle(article: ArticleViewModel) {
        openArticleCallCount += 1
    }
}
