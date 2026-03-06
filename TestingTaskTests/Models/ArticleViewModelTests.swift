import Testing
import Foundation
@testable import TestingTask

@Suite("ArticleViewModel Tests")
struct ArticleViewModelTests {
    // These tests use StorageServiceMock to verify side effects of
    // favorite toggling without touching persistent storage.

    // MARK: - Properties

    @Test("title returns article title")
    func title_returnsArticleTitle() {
        // Given
        let article = Article.stub(title: "Test Title")
        let storage = StorageServiceMock()
        let sut = ArticleViewModel(article: article, storage: storage)

        // When
        let result = sut.title

        // Then
        #expect(result == "Test Title")
    }

    @Test("title returns nil when article has no title")
    func title_noTitle_returnsNil() {
        // Given
        let article = Article.stub(title: nil)
        let storage = StorageServiceMock()
        let sut = ArticleViewModel(article: article, storage: storage)

        // When
        let result = sut.title

        // Then
        #expect(result == nil)
    }

    @Test("contents returns article description")
    func contents_returnsDescription() {
        // Given
        let article = Article.stub(description: "Test Description")
        let storage = StorageServiceMock()
        let sut = ArticleViewModel(article: article, storage: storage)

        // When
        let result = sut.contents

        // Then
        #expect(result == "Test Description")
    }

    @Test("contents returns nil when article has no description")
    func contents_noDescription_returnsNil() {
        // Given
        let article = Article.stub(description: nil)
        let storage = StorageServiceMock()
        let sut = ArticleViewModel(article: article, storage: storage)

        // When
        let result = sut.contents

        // Then
        #expect(result == nil)
    }

    @Test("publishedAt formats date correctly")
    func publishedAt_formatsDateCorrectly() {
        // Given
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: "2024-03-15")!

        let article = Article.stub(publishedAt: date)
        let storage = StorageServiceMock()
        let sut = ArticleViewModel(article: article, storage: storage)

        // When
        let result = sut.publishedAt

        // Then
        // The exact month text may vary by locale, so we assert on stable
        // parts while still validating that formatting happened.
        #expect(result.contains("15"))
        #expect(result.contains("March") || result.contains("марта") || result.contains("3"))
    }

    // MARK: - isFavorite

    @Test("isFavorite returns true when article is in favorites")
    func isFavorite_inFavorites_returnsTrue() {
        // Given
        let article = Article.stub(title: "Favorite Article")
        let storage = StorageServiceMock()
        storage.favoritesTitles = ["Favorite Article"]
        let sut = ArticleViewModel(article: article, storage: storage)

        // When
        let result = sut.isFavorite

        // Then
        #expect(result == true)
    }

    @Test("isFavorite returns false when article is not in favorites")
    func isFavorite_notInFavorites_returnsFalse() {
        // Given
        let article = Article.stub(title: "Not Favorite")
        let storage = StorageServiceMock()
        storage.favoritesTitles = ["Other Article"]
        let sut = ArticleViewModel(article: article, storage: storage)

        // When
        let result = sut.isFavorite

        // Then
        #expect(result == false)
    }

    @Test("isFavorite returns false when article has no title")
    func isFavorite_noTitle_returnsFalse() {
        // Given
        let article = Article.stub(title: nil)
        let storage = StorageServiceMock()
        let sut = ArticleViewModel(article: article, storage: storage)

        // When
        let result = sut.isFavorite

        // Then
        #expect(result == false)
    }

    @Test("isFavorite checks storage for article title")
    func isFavorite_checksStorage() {
        // Given
        let article = Article.stub(title: "Test Article")
        let storage = StorageServiceMock()
        let sut = ArticleViewModel(article: article, storage: storage)

        // When
        _ = sut.isFavorite

        // Then
        #expect(storage.isArticleInFavoritesCallCount == 1)
        #expect(storage.lastCheckedTitle == "Test Article")
    }

    // MARK: - addOrRemoveFromFavorites

    @Test("addOrRemoveFromFavorites adds article when not favorite")
    func addOrRemoveFromFavorites_notFavorite_addsToFavorites() {
        // Given
        let article = Article.stub(
            title: "New Article",
            description: "Description"
        )
        let storage = StorageServiceMock()
        storage.favoritesTitles = []
        let sut = ArticleViewModel(article: article, storage: storage)

        // When
        sut.addOrRemoveFromFavorites()

        // Then
        #expect(storage.addToFavoritesCallCount == 1)
        #expect(storage.lastAddedTitle == "New Article")
    }

    @Test("addOrRemoveFromFavorites removes article when favorite")
    func addOrRemoveFromFavorites_isFavorite_removesFromFavorites() {
        // Given
        let article = Article.stub(title: "Existing Favorite")
        let storage = StorageServiceMock()
        storage.favoritesTitles = ["Existing Favorite"]
        let sut = ArticleViewModel(article: article, storage: storage)

        // When
        sut.addOrRemoveFromFavorites()

        // Then
        #expect(storage.removeFromFavoritesCallCount == 1)
        #expect(storage.lastRemovedTitle == "Existing Favorite")
    }

    @Test("addOrRemoveFromFavorites does nothing when no title")
    func addOrRemoveFromFavorites_noTitle_doesNothing() {
        // Given
        let article = Article.stub(title: nil)
        let storage = StorageServiceMock()
        let sut = ArticleViewModel(article: article, storage: storage)

        // When
        sut.addOrRemoveFromFavorites()

        // Then
        #expect(storage.addToFavoritesCallCount == 0)
        #expect(storage.removeFromFavoritesCallCount == 0)
    }

    @Test("addOrRemoveFromFavorites toggles state correctly")
    func addOrRemoveFromFavorites_togglesState() {
        // Given
        let article = Article.stub(title: "Toggle Article")
        let storage = StorageServiceMock()
        storage.favoritesTitles = []
        let sut = ArticleViewModel(article: article, storage: storage)

        // When - first toggle adds
        sut.addOrRemoveFromFavorites()
        #expect(sut.isFavorite == true)

        // When - second toggle removes
        sut.addOrRemoveFromFavorites()
        #expect(sut.isFavorite == false)
    }

    @Test("addOrRemoveFromFavorites passes correct data to storage")
    func addOrRemoveFromFavorites_passesCorrectData() {
        // Given
        let date = Date()
        let article = Article.stub(
            title: "Article Title",
            description: "Article Content",
            urlToImage: URL(string: "https://example.com/image.jpg"),
            publishedAt: date
        )
        let storage = StorageServiceMock()
        storage.favoritesTitles = []
        let sut = ArticleViewModel(article: article, storage: storage)

        // When
        sut.addOrRemoveFromFavorites()

        // Then - verify correct title was used
        #expect(storage.lastAddedTitle == "Article Title")
    }

    // MARK: - Multiple ViewModels

    @Test("multiple viewModels share storage state")
    func multipleViewModels_shareStorageState() {
        // Given
        let article1 = Article.stub(title: "Article 1")
        let article2 = Article.stub(title: "Article 2")
        let storage = StorageServiceMock()
        let vm1 = ArticleViewModel(article: article1, storage: storage)
        let vm2 = ArticleViewModel(article: article2, storage: storage)

        // When
        vm1.addOrRemoveFromFavorites() // Adds Article 1

        // Then
        // Both view models observe the same underlying storage state.
        #expect(vm1.isFavorite == true)
        #expect(vm2.isFavorite == false)
        #expect(storage.favoritesTitles.contains("Article 1"))
        #expect(!storage.favoritesTitles.contains("Article 2"))
    }

    // MARK: - Edge Cases

    @Test("title with special characters works correctly")
    func title_specialCharacters_worksCorrectly() {
        // Given
        let article = Article.stub(title: "Test <script>alert('XSS')</script> Title")
        let storage = StorageServiceMock()
        let sut = ArticleViewModel(article: article, storage: storage)

        // When
        let result = sut.title

        // Then
        #expect(result == "Test <script>alert('XSS')</script> Title")
    }

    @Test("title with unicode works correctly")
    func title_unicode_worksCorrectly() {
        // Given
        let article = Article.stub(title: "Новости на русском языке")
        let storage = StorageServiceMock()
        let sut = ArticleViewModel(article: article, storage: storage)

        // When
        let result = sut.title

        // Then
        #expect(result == "Новости на русском языке")
    }

    @Test("empty title string is different from nil")
    func title_emptyString_differentFromNil() {
        // Given
        let articleWithEmpty = Article.stub(title: "")
        let articleWithNil = Article.stub(title: nil)
        let storage = StorageServiceMock()
        let vmEmpty = ArticleViewModel(article: articleWithEmpty, storage: storage)
        let vmNil = ArticleViewModel(article: articleWithNil, storage: storage)

        // Then
        // Empty and nil titles are different states and should remain distinct.
        #expect(vmEmpty.title == "")
        #expect(vmNil.title == nil)
    }
}
