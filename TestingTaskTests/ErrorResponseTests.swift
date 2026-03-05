import Foundation
import Testing
@testable import TestingTask

@Suite("Error Response Tests")
struct ErrorResponseTests {
    @Test("Maps each error type to expected text")
    func getTypeReturnsExpectedMessageForEachKind() {
        // Given
        let auth = ErrorResponse(type: .auth)
        let network = ErrorResponse(type: .network)
        let tech = ErrorResponse(type: .tech)
        let other = ErrorResponse(type: .other)

        // When
        let authText = auth.getType()
        let networkText = network.getType()
        let techText = tech.getType()
        let otherText = other.getType()

        // Then
        #expect(authText == "Type error")
        #expect(networkText == "Network error")
        #expect(techText == "Tech error")
        #expect(otherText == "Other error")
    }

    @Test("Message init stores provided message")
    func messageInitializerStoresMessageValue() {
        // Given
        let sut = ErrorResponse(message: "Some message")

        // When
        let value = sut.message

        // Then
        #expect(value == "Some message")
    }
}
