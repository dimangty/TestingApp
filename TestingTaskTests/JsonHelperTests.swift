import Foundation
import Testing
@testable import TestingTask

@Suite("JSON Helper Tests")
struct JsonHelperTests {
    private struct Sample: Codable {
        let firstName: String
        let createdAt: Date
    }

    @Test("Decodes snake_case JSON for success status")
    func decodeDataSuccessStatusReturnsDecodedModel() {
        // Given
        let json = """
        {"first_name":"Ivan","created_at":"2024-01-02T03:04:05Z"}
        """
        let data = Data(json.utf8)
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!

        // When
        let result: Result<Sample, Error> = JsonHelper.shared.decodeData(response: response, data: data, Sample.self)

        // Then
        switch result {
        case .success(let sample):
            #expect(sample.firstName == "Ivan")
            #expect(sample.createdAt == Date(timeIntervalSince1970: 1_704_164_645))
        case .failure:
            #expect(false)
        }
    }

    @Test("Returns tech error for non-success status")
    func decodeDataErrorStatusReturnsTechError() {
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
            #expect(false)
        case .failure(let error):
            let responseError = error as? ErrorResponse
            switch responseError?.type {
            case .tech:
                #expect(true)
            default:
                #expect(false)
            }
        }
    }

    @Test("Returns decode failure for malformed success payload")
    func decodeDataMalformedPayloadReturnsFailure() {
        // Given
        let malformed = Data("{\"first_name\":123}".utf8)
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!

        // When
        let result: Result<Sample, Error> = JsonHelper.shared.decodeData(response: response, data: malformed, Sample.self)

        // Then
        switch result {
        case .success:
            #expect(false)
        case .failure:
            #expect(true)
        }
    }
}
