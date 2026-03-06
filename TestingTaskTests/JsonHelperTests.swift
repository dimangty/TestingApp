import XCTest
@testable import TestingTask

final class JsonHelperTests: XCTestCase {
    // Local sample model used to verify key decoding and date strategy.
    private struct Sample: Codable, Equatable {
        let firstName: String
        let createdAt: Date
    }

    // MARK: - decodeData(response:data:_:)

    func test_decodeData_whenStatusIsSuccess_returnsDecodedModel() throws {
        // Given
        // JSON uses snake_case keys and ISO 8601 date string.
        let json = """
        {"first_name":"Ivan","created_at":"2024-01-02T03:04:05Z"}
        """
        let data = try XCTUnwrap(json.data(using: .utf8))
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!

        // When
        let result: Result<Sample, Error> = JsonHelper.shared.decodeData(response: response, data: data, Sample.self)

        // Then
        switch result {
        case .success(let model):
            XCTAssertEqual(model.firstName, "Ivan")
            // 2024-01-02T03:04:05Z
            XCTAssertEqual(model.createdAt, Date(timeIntervalSince1970: 1704164645))
        case .failure(let error):
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_decodeData_whenStatusIsError_returnsTechError() {
        // Given
        let data = Data("{}".utf8)
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                       statusCode: 500,
                                       httpVersion: nil,
                                       headerFields: nil)!

        // When
        let result: Result<Sample, Error> = JsonHelper.shared.decodeData(response: response, data: data, Sample.self)

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure")
        case .failure(let error):
            // Non-2xx responses should map to a technical error.
            let responseError = error as? ErrorResponse
            XCTAssertEqual(responseError?.type, .tech)
        }
    }
}
