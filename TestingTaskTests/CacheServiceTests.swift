import Foundation
import Testing
@testable import TestingTask

@Suite("Cache + DI Tests")
struct CacheServiceTests {
    @Test("Returns cached data while cache is fresh")
    func returnsCachedDataWhenNotExpired() {
        // Given
        var now = Date(timeIntervalSince1970: 1_000)
        let sut = CacheService(nowProvider: { now }, cacheExpirationInterval: 10)
        let expected = Self.fixtureNewsSource()
        sut.cacheNews(expected)

        // When
        now = Date(timeIntervalSince1970: 1_005)
        let result = sut.getCachedNews()

        // Then
        #expect(result?.totalResults == expected.totalResults)
        #expect(result?.articles.first?.title == expected.articles.first?.title)
    }

    @Test("Returns nil when cache is expired")
    func returnsNilWhenExpired() {
        // Given
        var now = Date(timeIntervalSince1970: 1_000)
        let sut = CacheService(nowProvider: { now }, cacheExpirationInterval: 10)
        sut.cacheNews(Self.fixtureNewsSource())

        // When
        now = Date(timeIntervalSince1970: 1_020)
        let result = sut.getCachedNews()

        // Then
        #expect(result == nil)
    }

    @Test("Clear cache removes cached object")
    func clearCacheRemovesValue() {
        // Given
        let sut = CacheService(nowProvider: Date.init, cacheExpirationInterval: 10)
        sut.cacheNews(Self.fixtureNewsSource())

        // When
        sut.clearCache()

        // Then
        #expect(sut.getCachedNews() == nil)
    }

    @Test("News service returns cache hit and skips re-caching")
    func newsServiceUsesCacheHit() {
        // Given
        let fakeCache = FakeCacheService()
        let cached = Self.fixtureNewsSource()
        fakeCache.cached = cached
        let sut = NewsService(cacheService: fakeCache)
        var receivedResult: Result<NewsSource, Error>?

        // When
        sut.performNewsRequest { result in
            receivedResult = result
        }

        // Then
        #expect(fakeCache.getCachedNewsCallCount == 1)
        #expect(fakeCache.cacheNewsCallCount == 0)

        switch receivedResult {
        case .success(let newsSource):
            #expect(newsSource.articles.count == cached.articles.count)
            #expect(newsSource.articles.first?.title == cached.articles.first?.title)
        default:
            #expect(false)
        }
    }

    @Test("Service locator can replace existing service in tests")
    func serviceLocatorSetServiceOverridesExistingInstance() {
        // Given
        let locator = ServiceLocator()
        let first = ValidationService()
        let second = ValidationService()
        locator.addService(service: first)

        // When
        locator.setService(service: second)
        let resolved: ValidationService? = locator.getService(type: ValidationService.self)

        // Then
        #expect(resolved === second)
        #expect(resolved !== first)
    }

    @Test("Configurator unit setup registers dependencies and clears cache")
    func configuratorSetupForUnitTestsRegistersServicesAndResetsState() {
        // Given
        CacheService.shared.cacheNews(Self.fixtureNewsSource())

        // When
        #if DEBUG
        Configurator.shared.setupForUnitTests()
        #else
        Configurator.shared.setup()
        #endif

        // Then
        let locator = Configurator.shared.serviceLocator
        let coordinator = locator.getService(type: ApplicationCoordinator.self)
        let validation = locator.getService(type: ValidationService.self)
        let auth = locator.getService(type: AuthServiceProtocol.self)
        #expect(coordinator != nil)
        #expect(validation != nil)
        #expect(auth != nil)
        #expect(CacheService.shared.getCachedNews() == nil)
    }

    private static func fixtureNewsSource() -> NewsSource {
        let article = Article(author: "Author",
                              title: "Title",
                              description: "Body",
                              url: URL(string: "https://example.com"),
                              urlToImage: nil,
                              publishedAt: Date(timeIntervalSince1970: 0))
        return NewsSource(status: "ok", totalResults: 1, articles: [article])
    }
}

private final class FakeCacheService: ICacheService {
    // SwiftMocky-style counters for interaction verification.
    private(set) var getCachedNewsCallCount = 0
    private(set) var cacheNewsCallCount = 0
    var cached: NewsSource?

    func getCachedNews() -> NewsSource? {
        getCachedNewsCallCount += 1
        return cached
    }

    func cacheNews(_ newsSource: NewsSource) {
        cacheNewsCallCount += 1
        cached = newsSource
    }

    func clearCache() {
        cached = nil
    }
}
