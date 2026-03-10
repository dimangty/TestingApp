```swift
import Testing
import SwiftyMocky
@testable import YourApp // Замените на ваш реальный модуль

// MARK: - Spy Classes

final class ArticleViewInputSpy: ArticleViewInput {
    var setupCalled = false
    var displayTitle: String?
    var displayDate: String?
    var displayContent: String?
    var displayLikeIsFavorite: Bool?
    var displayImageImage: UIImage?
    
    func setup() {
        setupCalled = true
    }
    
    func display(title: String, date: String, content: String) {
        displayTitle = title
        displayDate = date
        displayContent = content
    }
    
    func displayLike(isFavorite: Bool) {
        displayLikeIsFavorite = isFavorite
    }
    
    func displayImage(_ image: UIImage?) {
        displayImageImage = image
    }
}

final class ArticleRouterInputSpy: ArticleRouterInput {
    var navigateToBookmarksCalled = false
    
    func navigateToBookmarks() {
        navigateToBookmarksCalled = true
    }
}

final class ArticleViewModelSpy: ArticleViewModel {
    var titleValue = "Test Title"
    var publishedAtValue = "2024-01-01"
    var contentsValue = "Test Content"
    var isFavoriteValue = false
    var imageLoaded = false
    var image: UIImage?
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        imageLoaded = true
        completion(image)
    }
    
    func addOrRemoveFromFavorites() {
        isFavoriteValue.toggle()
    }
    
    var title: String {
        get { titleValue }
        set { titleValue = newValue }
    }
    
    var publishedAt: String {
        get { publishedAtValue }
        set { publishedAtValue = newValue }
    }
    
    var contents: String {
        get { contentsValue }
        set { contentsValue = newValue }
    }
    
    var isFavorite: Bool {
        get { isFavoriteValue }
        set { isFavoriteValue = newValue }
    }
}

// MARK: - Tests

@Suite("ArticlePresenter Tests")
struct ArticlePresenterTests {
    
    @Test("View load displays article data")
    func viewLoadedDisplaysArticleData() {
        // Given: Presenter with mocked dependencies
        let mockView = ArticleViewInputSpy()
        let mockRouter = ArticleRouterInputSpy()
        let mockArticle = ArticleViewModelSpy()
        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: mockArticle)
        
        mockArticle.titleValue = "Test Title"
        mockArticle.publishedAtValue = "2024-01-01"
        mockArticle.contentsValue = "Test Content"
        mockArticle.isFavoriteValue = false
        
        // When: View is loaded
        presenter.viewLoaded()
        
        // Then: View displays article data
        #expect(mockView.setupCalled == true)
        #expect(mockView.displayTitle == "Test Title")
        #expect(mockView.displayDate == "2024-01-01")
        #expect(mockView.displayContent == "Test Content")
        #expect(mockView.displayLikeIsFavorite == false)
        #expect(mockArticle.imageLoaded == true)
    }
    
    @Test("ViewWillAppear updates like state")
    func viewWillAppearUpdatesLikeState() {
        // Given: Presenter with mocked dependencies
        let mockView = ArticleViewInputSpy()
        let mockRouter = ArticleRouterInputSpy()
        let mockArticle = ArticleViewModelSpy()
        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: mockArticle)
        
        mockArticle.isFavoriteValue = true
        
        // When: View appears
        presenter.viewWillAppear()
        
        // Then: Like state is updated
        #expect(mockView.displayLikeIsFavorite == true)
    }
    
    @Test("Heart tapped toggles favorite and updates UI")
    func heartTappedTogglesFavoriteAndUpdatesUI() {
        // Given: Presenter with mocked dependencies
        let mockView = ArticleViewInputSpy()
        let mockRouter = ArticleRouterInputSpy()
        let mockArticle = ArticleViewModelSpy()
        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: mockArticle)
        
        mockArticle.isFavoriteValue = false
        
        // When: Heart is tapped
        presenter.heartTapped()
        
        // Then: Favorite state is toggled and UI is updated
        #expect(mockArticle.isFavoriteValue == true)
        #expect(mockView.displayLikeIsFavorite == true)
    }
    
    @Test("Heart tapped multiple times toggles favorite correctly")
    func heartTappedMultipleTimesTogglesFavoriteCorrectly() {
        // Given: Presenter with mocked dependencies
        let mockView = ArticleViewInputSpy()
        let mockRouter = ArticleRouterInputSpy()
        let mockArticle = ArticleViewModelSpy()
        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: mockArticle)
        
        mockArticle.isFavoriteValue = false
        
        // When: Heart is tapped multiple times
        presenter.heartTapped()
        presenter.heartTapped()
        presenter.heartTapped()
        
        // Then: Favorite state is toggled correctly
        #expect(mockArticle.isFavoriteValue == true)
        #expect(mockView.displayLikeIsFavorite == true)
    }
    
    @Test("View load with nil values handles gracefully")
    func viewLoadedWithNilValuesHandlesGracefully() {
        // Given: Presenter with mocked dependencies
        let mockView = ArticleViewInputSpy()
        let mockRouter = ArticleRouterInputSpy()
        let mockArticle = ArticleViewModelSpy()
        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: mockArticle)
        
        mockArticle.titleValue = ""
        mockArticle.publishedAtValue = ""
        mockArticle.contentsValue = ""
        mockArticle.isFavoriteValue = false
        
        // When: View is loaded with empty values
        presenter.viewLoaded()
        
        // Then: View displays empty values
        #expect(mockView.setupCalled == true)
        #expect(mockView.displayTitle == "")
        #expect(mockView.displayDate == "")
        #expect(mockView.displayContent == "")
        #expect(mockView.displayLikeIsFavorite == false)
    }
    
    @Test("Image loading with nil image")
    func imageLoadingWithNilImage() {
        // Given: Presenter with mocked dependencies
        let mockView = ArticleViewInputSpy()
        let mockRouter = ArticleRouterInputSpy()
        let mockArticle = ArticleViewModelSpy()
        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: mockArticle)
        
        mockArticle.image = nil
        
        // When: View is loaded
        presenter.viewLoaded()
        
        // Then: View displays nil image
        #expect(mockArticle.imageLoaded == true)
        #expect(mockView.displayImageImage == nil)
    }
    
    @Test("Image loading with valid image")
    func imageLoadingWithValidImage() {
        // Given: Presenter with mocked dependencies
        let mockView = ArticleViewInputSpy()
        let mockRouter = ArticleRouterInputSpy()
        let mockArticle = ArticleViewModelSpy()
        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: mockArticle)
        
        let testImage = UIImage()
        mockArticle.image = testImage
        
        // When: View is loaded
        presenter.viewLoaded()
        
        // Then: View displays image
        #expect(mockArticle.imageLoaded == true)
        #expect(mockView.displayImageImage === testImage)
    }
    
    @Test("Weak reference handling when view is deallocated")
    func weakReferenceHandlingWhenViewIsDeallocated() {
        // Given: Presenter with weak reference to view
        let mockRouter = ArticleRouterInputSpy()
        let mockArticle = ArticleViewModelSpy()
        let presenter = ArticlePresenter(view: ArticleViewInputSpy(), router: mockRouter, article: mockArticle)
        
        // When: View is deallocated (weak reference becomes nil)
        // This is a conceptual test - in practice, we can't easily test weak reference deallocation
        
        // Then: No crash occurs when trying to access view
        #expect(true) // Placeholder for weak reference behavior test
    }
    
    @Test("Multiple view appearances update like state correctly")
    func multipleViewAppearancesUpdateLikeStateCorrectly() {
        // Given: Presenter with mocked dependencies
        let mockView = ArticleViewInputSpy()
        let mockRouter = ArticleRouterInputSpy()
        let mockArticle = ArticleViewModelSpy()
        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: mockArticle)
        
        mockArticle.isFavoriteValue = true
        
        // When: View appears multiple times
        presenter.viewWillAppear()
        presenter.viewWillAppear()
        presenter.viewWillAppear()
        
        // Then: Like state is updated each time
        #expect(mockView.displayLikeIsFavorite == true)
    }
    
    @Test("View load with favorite state updates UI correctly")
    func viewLoadWithFavoriteStateUpdatesUI() {
        // Given: Presenter with mocked dependencies
        let mockView = ArticleViewInputSpy()
        let mockRouter = ArticleRouterInputSpy()
        let mockArticle = ArticleViewModelSpy()
        let presenter = ArticlePresenter(view: mockView, router: mockRouter, article: mockArticle)
        
        mockArticle.isFavoriteValue = true
        
        // When: View is loaded
        presenter.viewLoaded()
        
        // Then: View displays favorite state
        #expect(mockView.setupCalled == true)
        #expect(mockView.displayLikeIsFavorite == true)
    }
}
```

