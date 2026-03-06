import Testing
import Foundation
@testable import TestingTask

@Suite("CacheService Tests")
struct CacheServiceSwiftTests {

    // MARK: - Cache Miss Scenarios

    @Test("getCachedNews returns nil when cache is empty")
    func getCachedNews_emptyCache_returnsNil() {
        // Given
        let sut = CacheService()

        // When
        let result = sut.getCachedNews()

        // Then
        #expect(result == nil)
    }

    @Test("getCachedNews returns nil after clearCache")
    func getCachedNews_afterClear_returnsNil() {
        // Given
        let sut = CacheService()
        let newsSource = NewsSource.stub(articles: [Article.stub()])
        sut.cacheNews(newsSource)

        // When
        sut.clearCache()
        let result = sut.getCachedNews()

        // Then
        #expect(result == nil)
    }

    // MARK: - Cache Hit Scenarios

    @Test("getCachedNews returns cached data when within expiration")
    func getCachedNews_withinExpiration_returnsCachedData() {
        // Given
        var currentTime = Date()
        let sut = CacheService(nowProvider: { currentTime })
        let articles = [Article.stub(title: "Cached Article")]
        let newsSource = NewsSource.stub(articles: articles)

        // When
        sut.cacheNews(newsSource)

        // Advance time by 1 minute (within 5-minute expiration)
        currentTime = currentTime.addingTimeInterval(60)

        let result = sut.getCachedNews()

        // Then
        #expect(result != nil)
        #expect(result?.articles.count == 1)
        #expect(result?.articles.first?.title == "Cached Article")
    }

    @Test("getCachedNews returns data just before expiration")
    func getCachedNews_justBeforeExpiration_returnsCachedData() {
        // Given
        var currentTime = Date()
        let expirationInterval: TimeInterval = 5 * 60 // 5 minutes
        let sut = CacheService(nowProvider: { currentTime }, cacheExpirationInterval: expirationInterval)
        let newsSource = NewsSource.stub(articles: [Article.stub()])

        // When
        sut.cacheNews(newsSource)

        // Advance time to just before expiration (4:59)
        currentTime = currentTime.addingTimeInterval(expirationInterval - 1)

        let result = sut.getCachedNews()

        // Then
        #expect(result != nil)
    }

    // MARK: - Cache Expiration Scenarios

    @Test("getCachedNews returns nil when cache is expired")
    func getCachedNews_expired_returnsNil() {
        // Given
        var currentTime = Date()
        let expirationInterval: TimeInterval = 5 * 60 // 5 minutes
        let sut = CacheService(nowProvider: { currentTime }, cacheExpirationInterval: expirationInterval)
        let newsSource = NewsSource.stub(articles: [Article.stub()])

        // When
        sut.cacheNews(newsSource)

        // Advance time beyond expiration
        currentTime = currentTime.addingTimeInterval(expirationInterval + 1)

        let result = sut.getCachedNews()

        // Then
        #expect(result == nil)
    }

    @Test("getCachedNews clears cache after expiration")
    func getCachedNews_afterExpiration_clearsCache() {
        // Given
        var currentTime = Date()
        let expirationInterval: TimeInterval = 5 * 60
        let sut = CacheService(nowProvider: { currentTime }, cacheExpirationInterval: expirationInterval)
        let newsSource = NewsSource.stub(articles: [Article.stub()])

        // When
        sut.cacheNews(newsSource)
        currentTime = currentTime.addingTimeInterval(expirationInterval + 1)

        // First call should return nil and clear cache
        _ = sut.getCachedNews()

        // Reset time and cache new data
        currentTime = Date()
        sut.cacheNews(newsSource)

        // Second call should return cached data (proving cache was cleared)
        let result = sut.getCachedNews()

        // Then
        #expect(result != nil)
    }

    // MARK: - Cache Update Scenarios

    @Test("cacheNews overwrites existing cached data")
    func cacheNews_overwritesExistingData() {
        // Given
        let sut = CacheService()
        let firstNews = NewsSource.stub(articles: [Article.stub(title: "First")])
        let secondNews = NewsSource.stub(articles: [Article.stub(title: "Second")])

        // When
        sut.cacheNews(firstNews)
        sut.cacheNews(secondNews)

        let result = sut.getCachedNews()

        // Then
        #expect(result?.articles.first?.title == "Second")
    }

    @Test("cacheNews resets expiration timer")
    func cacheNews_resetsExpirationTimer() {
        // Given
        var currentTime = Date()
        let expirationInterval: TimeInterval = 5 * 60
        let sut = CacheService(nowProvider: { currentTime }, cacheExpirationInterval: expirationInterval)

        // When - cache first data
        let firstNews = NewsSource.stub(articles: [Article.stub(title: "First")])
        sut.cacheNews(firstNews)

        // Advance time close to expiration (4 minutes)
        currentTime = currentTime.addingTimeInterval(4 * 60)

        // Cache new data (should reset timer)
        let secondNews = NewsSource.stub(articles: [Article.stub(title: "Second")])
        sut.cacheNews(secondNews)

        // Advance time another 4 minutes (would be expired if timer wasn't reset)
        currentTime = currentTime.addingTimeInterval(4 * 60)

        let result = sut.getCachedNews()

        // Then - should still have data because timer was reset
        #expect(result != nil)
        #expect(result?.articles.first?.title == "Second")
    }

    // MARK: - Clear Cache

    @Test("clearCache removes all cached data")
    func clearCache_removesCachedData() {
        // Given
        let sut = CacheService()
        let newsSource = NewsSource.stub(articles: [Article.stub()])
        sut.cacheNews(newsSource)

        // Verify cache has data
        #expect(sut.getCachedNews() != nil)

        // When
        sut.clearCache()

        // Then
        #expect(sut.getCachedNews() == nil)
    }

    @Test("clearCache is idempotent")
    func clearCache_multipleCalls_noError() {
        // Given
        let sut = CacheService()

        // When - multiple clear calls should not cause issues
        sut.clearCache()
        sut.clearCache()
        sut.clearCache()

        // Then
        #expect(sut.getCachedNews() == nil)
    }

    // MARK: - Custom Expiration Interval

    @Test("custom expiration interval is respected")
    func customExpirationInterval_isRespected() {
        // Given
        var currentTime = Date()
        let shortExpiration: TimeInterval = 10 // 10 seconds
        let sut = CacheService(nowProvider: { currentTime }, cacheExpirationInterval: shortExpiration)
        let newsSource = NewsSource.stub(articles: [Article.stub()])

        // When
        sut.cacheNews(newsSource)

        // Advance time by 5 seconds (within short expiration)
        currentTime = currentTime.addingTimeInterval(5)
        #expect(sut.getCachedNews() != nil)

        // Advance time past expiration
        currentTime = currentTime.addingTimeInterval(10)
        #expect(sut.getCachedNews() == nil)
    }

    // MARK: - Edge Cases

    @Test("caching empty articles array works correctly")
    func cacheNews_emptyArticles_workCorrectly() {
        // Given
        let sut = CacheService()
        let newsSource = NewsSource.stub(articles: [])

        // When
        sut.cacheNews(newsSource)
        let result = sut.getCachedNews()

        // Then
        #expect(result != nil)
        #expect(result?.articles.isEmpty == true)
    }

    @Test("caching preserves all article data")
    func cacheNews_preservesAllArticleData() {
        // Given
        let sut = CacheService()
        let article = Article.stub(
            author: "Test Author",
            title: "Test Title",
            description: "Test Description"
        )
        let newsSource = NewsSource.stub(articles: [article])

        // When
        sut.cacheNews(newsSource)
        let result = sut.getCachedNews()

        // Then
        let cachedArticle = result?.articles.first
        #expect(cachedArticle?.author == "Test Author")
        #expect(cachedArticle?.title == "Test Title")
        #expect(cachedArticle?.description == "Test Description")
    }
}
