//
//  CacheServiceTests.swift
//  TestingTaskTests
//
//  Unit tests for CacheService with Given/When/Then pattern
//

import Testing
import Foundation
@testable import TestingTask

@Suite("CacheService Tests")
struct CacheServiceTests {

    // MARK: - Test: Cache News Successfully
    @Test("Should cache news and return it when not expired")
    func testCacheNewsSuccessfully() {
        // Given: A cache service with a fixed time provider and sample news
        let fixedDate = Date(timeIntervalSince1970: 1000)
        var currentTime = fixedDate
        let nowProvider = { currentTime }

        let sut = CacheService(nowProvider: nowProvider, cacheExpirationInterval: 300)

        let sampleArticle = Article(
            author: "Test Author",
            title: "Test Title",
            description: "Test Description",
            url: URL(string: "https://example.com"),
            urlToImage: nil,
            publishedAt: fixedDate
        )
        let sampleNews = NewsSource(status: "ok", totalResults: 1, articles: [sampleArticle])

        // When: News is cached
        sut.cacheNews(sampleNews)

        // Then: Cached news should be returned
        let cachedNews = sut.getCachedNews()
        #expect(cachedNews != nil)
        #expect(cachedNews?.articles.count == 1)
        #expect(cachedNews?.articles.first?.title == "Test Title")
    }

    // MARK: - Test: Cache Expiration
    @Test("Should return nil when cache has expired")
    func testCacheExpiration() {
        // Given: A cache service with 5 minutes expiration and cached news
        let fixedDate = Date(timeIntervalSince1970: 1000)
        var currentTime = fixedDate
        let nowProvider = { currentTime }

        let sut = CacheService(nowProvider: nowProvider, cacheExpirationInterval: 300) // 5 minutes

        let sampleArticle = Article(
            author: "Test Author",
            title: "Test Title",
            description: "Test Description",
            url: URL(string: "https://example.com"),
            urlToImage: nil,
            publishedAt: fixedDate
        )
        let sampleNews = NewsSource(status: "ok", totalResults: 1, articles: [sampleArticle])

        sut.cacheNews(sampleNews)

        // When: Time advances beyond expiration interval (6 minutes)
        currentTime = fixedDate.addingTimeInterval(360)

        // Then: Cache should return nil (expired)
        let cachedNews = sut.getCachedNews()
        #expect(cachedNews == nil)
    }

    // MARK: - Test: Cache Within Expiration Window
    @Test("Should return cached news when within expiration window")
    func testCacheWithinExpirationWindow() {
        // Given: A cache service with cached news
        let fixedDate = Date(timeIntervalSince1970: 1000)
        var currentTime = fixedDate
        let nowProvider = { currentTime }

        let sut = CacheService(nowProvider: nowProvider, cacheExpirationInterval: 300) // 5 minutes

        let sampleArticle = Article(
            author: "Test Author",
            title: "Test Title",
            description: "Test Description",
            url: URL(string: "https://example.com"),
            urlToImage: nil,
            publishedAt: fixedDate
        )
        let sampleNews = NewsSource(status: "ok", totalResults: 1, articles: [sampleArticle])

        sut.cacheNews(sampleNews)

        // When: Time advances by 2 minutes (within expiration window)
        currentTime = fixedDate.addingTimeInterval(120)

        // Then: Cached news should still be returned
        let cachedNews = sut.getCachedNews()
        #expect(cachedNews != nil)
        #expect(cachedNews?.articles.first?.title == "Test Title")
    }

    // MARK: - Test: Get Cached News When Empty
    @Test("Should return nil when no news is cached")
    func testGetCachedNewsWhenEmpty() {
        // Given: A new cache service with no cached data
        let sut = CacheService()

        // When: Attempting to get cached news
        let cachedNews = sut.getCachedNews()

        // Then: Should return nil
        #expect(cachedNews == nil)
    }

    // MARK: - Test: Clear Cache
    @Test("Should clear cached news when clearCache is called")
    func testClearCache() {
        // Given: A cache service with cached news
        let fixedDate = Date(timeIntervalSince1970: 1000)
        let nowProvider = { fixedDate }

        let sut = CacheService(nowProvider: nowProvider, cacheExpirationInterval: 300)

        let sampleArticle = Article(
            author: "Test Author",
            title: "Test Title",
            description: "Test Description",
            url: URL(string: "https://example.com"),
            urlToImage: nil,
            publishedAt: fixedDate
        )
        let sampleNews = NewsSource(status: "ok", totalResults: 1, articles: [sampleArticle])

        sut.cacheNews(sampleNews)
        #expect(sut.getCachedNews() != nil)

        // When: Cache is cleared
        sut.clearCache()

        // Then: Cached news should be nil
        let cachedNews = sut.getCachedNews()
        #expect(cachedNews == nil)
    }

    // MARK: - Test: Update Cached News
    @Test("Should update cached news when caching new data")
    func testUpdateCachedNews() {
        // Given: A cache service with initially cached news
        let fixedDate = Date(timeIntervalSince1970: 1000)
        let nowProvider = { fixedDate }

        let sut = CacheService(nowProvider: nowProvider, cacheExpirationInterval: 300)

        let firstArticle = Article(
            author: "First Author",
            title: "First Title",
            description: "First Description",
            url: URL(string: "https://example.com/1"),
            urlToImage: nil,
            publishedAt: fixedDate
        )
        let firstNews = NewsSource(status: "ok", totalResults: 1, articles: [firstArticle])
        sut.cacheNews(firstNews)

        // When: New news is cached
        let secondArticle = Article(
            author: "Second Author",
            title: "Second Title",
            description: "Second Description",
            url: URL(string: "https://example.com/2"),
            urlToImage: nil,
            publishedAt: fixedDate
        )
        let secondNews = NewsSource(status: "ok", totalResults: 1, articles: [secondArticle])
        sut.cacheNews(secondNews)

        // Then: Should return the new cached news
        let cachedNews = sut.getCachedNews()
        #expect(cachedNews?.articles.first?.title == "Second Title")
        #expect(cachedNews?.articles.first?.author == "Second Author")
    }

    // MARK: - Test: Cache Boundary - Exact Expiration Time
    @Test("Should return nil at exact expiration boundary")
    func testCacheBoundaryExactExpiration() {
        // Given: A cache service with 300 seconds expiration
        let fixedDate = Date(timeIntervalSince1970: 1000)
        var currentTime = fixedDate
        let nowProvider = { currentTime }

        let sut = CacheService(nowProvider: nowProvider, cacheExpirationInterval: 300)

        let sampleArticle = Article(
            author: "Test Author",
            title: "Test Title",
            description: "Test Description",
            url: URL(string: "https://example.com"),
            urlToImage: nil,
            publishedAt: fixedDate
        )
        let sampleNews = NewsSource(status: "ok", totalResults: 1, articles: [sampleArticle])
        sut.cacheNews(sampleNews)

        // When: Time advances exactly to expiration time (300 seconds)
        currentTime = fixedDate.addingTimeInterval(300)

        // Then: Cache should be expired (>= comparison)
        let cachedNews = sut.getCachedNews()
        #expect(cachedNews == nil)
    }
}
