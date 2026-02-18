import XCTest
@testable import TestingTask

final class CacheServiceTests: XCTestCase {
    private struct Fixtures {
        static func newsSource() -> NewsSource {
            let article = Article(author: "A",
                                  title: "T",
                                  description: "D",
                                  url: URL(string: "https://example.com"),
                                  urlToImage: nil,
                                  publishedAt: Date(timeIntervalSince1970: 0))
            return NewsSource(status: "ok", totalResults: 1, articles: [article])
        }
    }

    func test_getCachedNews_returnsCachedWhenNotExpired() {
        // Given
        var now = Date(timeIntervalSince1970: 1000)
        let service = CacheService(nowProvider: { now }, cacheExpirationInterval: 10)
        let expected = Fixtures.newsSource()
        service.cacheNews(expected)

        // When
        now = Date(timeIntervalSince1970: 1005)
        let result = service.getCachedNews()

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.totalResults, expected.totalResults)
    }

    func test_getCachedNews_returnsNilWhenExpired() {
        // Given
        var now = Date(timeIntervalSince1970: 1000)
        let service = CacheService(nowProvider: { now }, cacheExpirationInterval: 10)
        service.cacheNews(Fixtures.newsSource())

        // When
        now = Date(timeIntervalSince1970: 1015)
        let result = service.getCachedNews()

        // Then
        XCTAssertNil(result)
    }

    func test_clearCache_removesCachedData() {
        // Given
        let service = CacheService(nowProvider: Date.init, cacheExpirationInterval: 10)
        service.cacheNews(Fixtures.newsSource())

        // When
        service.clearCache()

        // Then
        XCTAssertNil(service.getCachedNews())
    }
}
