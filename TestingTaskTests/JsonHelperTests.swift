//
//  JsonHelperTests.swift
//  TestingTaskTests
//
//  Unit tests for JsonHelper with Given/When/Then pattern
//

import Testing
import Foundation
@testable import TestingTask

@Suite("JsonHelper Tests")
struct JsonHelperTests {

    // MARK: - Test: Decode Successful Response with 200 Status
    @Test("Should successfully decode JSON data with 200 status code")
    func testDecodeSuccessfulResponseWith200() {
        // Given: JsonHelper and a valid JSON response with 200 status
        let sut = JsonHelper.shared
        let json = """
        {
            "status": "ok",
            "total_results": 2,
            "articles": []
        }
        """
        guard let data = json.data(using: .utf8),
              let url = URL(string: "https://example.com") else {
            Issue.record("Failed to create test data")
            return
        }

        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        // When: Decoding the response data
        let result: Result<NewsSource, Error> = sut.decodeData(
            response: response,
            data: data,
            NewsSource.self
        )

        // Then: Should successfully decode to NewsSource
        switch result {
        case .success(let newsSource):
            #expect(newsSource.status == "ok")
            #expect(newsSource.totalResults == 2)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }

    // MARK: - Test: Decode Successful Response with 201 Status
    @Test("Should successfully decode JSON data with 201 status code")
    func testDecodeSuccessfulResponseWith201() {
        // Given: JsonHelper and a valid JSON response with 201 status
        let sut = JsonHelper.shared
        let json = """
        {
            "status": "created",
            "total_results": 1,
            "articles": []
        }
        """
        guard let data = json.data(using: .utf8),
              let url = URL(string: "https://example.com") else {
            Issue.record("Failed to create test data")
            return
        }

        let response = HTTPURLResponse(
            url: url,
            statusCode: 201,
            httpVersion: nil,
            headerFields: nil
        )!

        // When: Decoding the response data
        let result: Result<NewsSource, Error> = sut.decodeData(
            response: response,
            data: data,
            NewsSource.self
        )

        // Then: Should successfully decode
        switch result {
        case .success(let newsSource):
            #expect(newsSource.status == "created")
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }

    // MARK: - Test: Fail on 400 Status Code
    @Test("Should return failure for 400 status code")
    func testFailureOn400Status() {
        // Given: JsonHelper and a response with 400 status
        let sut = JsonHelper.shared
        let json = """
        {
            "error": "Bad Request"
        }
        """
        guard let data = json.data(using: .utf8),
              let url = URL(string: "https://example.com") else {
            Issue.record("Failed to create test data")
            return
        }

        let response = HTTPURLResponse(
            url: url,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil
        )!

        // When: Attempting to decode the response
        let result: Result<NewsSource, Error> = sut.decodeData(
            response: response,
            data: data,
            NewsSource.self
        )

        // Then: Should return ErrorResponse with tech type
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error is ErrorResponse)
            if let errorResponse = error as? ErrorResponse {
                #expect(errorResponse.type == .tech)
            }
        }
    }

    // MARK: - Test: Fail on 500 Status Code
    @Test("Should return failure for 500 status code")
    func testFailureOn500Status() {
        // Given: JsonHelper and a response with 500 status
        let sut = JsonHelper.shared
        let json = """
        {
            "error": "Internal Server Error"
        }
        """
        guard let data = json.data(using: .utf8),
              let url = URL(string: "https://example.com") else {
            Issue.record("Failed to create test data")
            return
        }

        let response = HTTPURLResponse(
            url: url,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!

        // When: Attempting to decode the response
        let result: Result<NewsSource, Error> = sut.decodeData(
            response: response,
            data: data,
            NewsSource.self
        )

        // Then: Should return ErrorResponse
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error is ErrorResponse)
        }
    }

    // MARK: - Test: Handle Invalid JSON with 200 Status
    @Test("Should return decoding error for invalid JSON despite 200 status")
    func testInvalidJSONWith200Status() {
        // Given: JsonHelper and invalid JSON data with 200 status
        let sut = JsonHelper.shared
        let invalidJson = "{ invalid json }"
        guard let data = invalidJson.data(using: .utf8),
              let url = URL(string: "https://example.com") else {
            Issue.record("Failed to create test data")
            return
        }

        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        // When: Attempting to decode invalid JSON
        let result: Result<NewsSource, Error> = sut.decodeData(
            response: response,
            data: data,
            NewsSource.self
        )

        // Then: Should return decoding failure
        switch result {
        case .success:
            Issue.record("Expected decoding failure but got success")
        case .failure(let error):
            #expect(error is DecodingError)
        }
    }

    // MARK: - Test: Decode with Snake Case Conversion
    @Test("Should convert snake_case JSON keys to camelCase")
    func testSnakeCaseConversion() {
        // Given: JsonHelper and JSON with snake_case keys
        let sut = JsonHelper.shared
        let json = """
        {
            "status": "ok",
            "total_results": 5,
            "articles": []
        }
        """
        guard let data = json.data(using: .utf8),
              let url = URL(string: "https://example.com") else {
            Issue.record("Failed to create test data")
            return
        }

        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        // When: Decoding data with snake_case keys
        let result: Result<NewsSource, Error> = sut.decodeData(
            response: response,
            data: data,
            NewsSource.self
        )

        // Then: Should successfully map to camelCase properties
        switch result {
        case .success(let newsSource):
            #expect(newsSource.totalResults == 5)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }

    // MARK: - Test: Decode ISO8601 Date
    @Test("Should decode ISO8601 date format")
    func testISO8601DateDecoding() {
        // Given: JsonHelper and JSON with ISO8601 date
        let sut = JsonHelper.shared
        let json = """
        {
            "author": "Test Author",
            "title": "Test Title",
            "description": "Test Description",
            "url": "https://example.com",
            "url_to_image": null,
            "published_at": "2023-01-15T10:30:00Z"
        }
        """
        guard let data = json.data(using: .utf8),
              let url = URL(string: "https://example.com") else {
            Issue.record("Failed to create test data")
            return
        }

        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        // When: Decoding article with ISO8601 date
        let result: Result<Article, Error> = sut.decodeData(
            response: response,
            data: data,
            Article.self
        )

        // Then: Should successfully decode the date
        switch result {
        case .success(let article):
            #expect(article.title == "Test Title")
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: article.publishedAt)
            #expect(components.year == 2023)
            #expect(components.month == 1)
            #expect(components.day == 15)
        case .failure:
            Issue.record("Expected success but got failure")
        }
    }

    // MARK: - Test: Boundary Status Codes
    @Test("Should handle boundary status codes correctly")
    func testBoundaryStatusCodes() {
        // Given: JsonHelper and valid JSON data
        let sut = JsonHelper.shared
        let json = """
        {
            "status": "ok",
            "total_results": 0,
            "articles": []
        }
        """
        guard let data = json.data(using: .utf8),
              let url = URL(string: "https://example.com") else {
            Issue.record("Failed to create test data")
            return
        }

        // When/Then: Testing boundary status codes
        // 199 should fail (< 200)
        let response199 = HTTPURLResponse(url: url, statusCode: 199, httpVersion: nil, headerFields: nil)!
        let result199: Result<NewsSource, Error> = sut.decodeData(response: response199, data: data, NewsSource.self)
        #expect(result199.isFailure())

        // 200 should succeed (>= 200)
        let response200 = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let result200: Result<NewsSource, Error> = sut.decodeData(response: response200, data: data, NewsSource.self)
        #expect(result200.isSuccess())

        // 399 should succeed (< 400)
        let response399 = HTTPURLResponse(url: url, statusCode: 399, httpVersion: nil, headerFields: nil)!
        let result399: Result<NewsSource, Error> = sut.decodeData(response: response399, data: data, NewsSource.self)
        #expect(result399.isSuccess())

        // 400 should fail (>= 400)
        let response400 = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
        let result400: Result<NewsSource, Error> = sut.decodeData(response: response400, data: data, NewsSource.self)
        #expect(result400.isFailure())
    }
}

// MARK: - Result Extension for Testing
private extension Result {
    func isSuccess() -> Bool {
        if case .success = self {
            return true
        }
        return false
    }

    func isFailure() -> Bool {
        if case .failure = self {
            return true
        }
        return false
    }
}
