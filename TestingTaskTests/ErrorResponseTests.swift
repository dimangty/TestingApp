//
//  ErrorResponseTests.swift
//  TestingTaskTests
//
//  Unit tests for ErrorResponse with Given/When/Then pattern
//

import Testing
import Foundation
@testable import TestingTask

@Suite("ErrorResponse Tests")
struct ErrorResponseTests {

    // MARK: - Test: Initialize with Message
    @Test("Should initialize ErrorResponse with message")
    func testInitializeWithMessage() {
        // Given: An error message
        let message = "Network connection failed"

        // When: Creating ErrorResponse with message
        let sut = ErrorResponse(message: message)

        // Then: Should store the message correctly
        #expect(sut.message == message)
        #expect(sut.type == .other) // Default type
    }

    // MARK: - Test: Initialize with Auth Error Type
    @Test("Should initialize ErrorResponse with auth error type")
    func testInitializeWithAuthType() {
        // Given: An auth error type
        let errorType = ErrorType.auth

        // When: Creating ErrorResponse with auth type
        let sut = ErrorResponse(type: errorType)

        // Then: Should store the type correctly
        #expect(sut.type == .auth)
        #expect(sut.message == "") // Default empty message
    }

    // MARK: - Test: Initialize with Network Error Type
    @Test("Should initialize ErrorResponse with network error type")
    func testInitializeWithNetworkType() {
        // Given: A network error type
        let errorType = ErrorType.network

        // When: Creating ErrorResponse with network type
        let sut = ErrorResponse(type: errorType)

        // Then: Should store the type correctly
        #expect(sut.type == .network)
    }

    // MARK: - Test: Initialize with Tech Error Type
    @Test("Should initialize ErrorResponse with tech error type")
    func testInitializeWithTechType() {
        // Given: A tech error type
        let errorType = ErrorType.tech

        // When: Creating ErrorResponse with tech type
        let sut = ErrorResponse(type: errorType)

        // Then: Should store the type correctly
        #expect(sut.type == .tech)
    }

    // MARK: - Test: Initialize with Other Error Type
    @Test("Should initialize ErrorResponse with other error type")
    func testInitializeWithOtherType() {
        // Given: An other error type
        let errorType = ErrorType.other

        // When: Creating ErrorResponse with other type
        let sut = ErrorResponse(type: errorType)

        // Then: Should store the type correctly
        #expect(sut.type == .other)
    }

    // MARK: - Test: Get Auth Type String
    @Test("Should return correct string for auth error type")
    func testGetAuthTypeString() {
        // Given: An ErrorResponse with auth type
        let sut = ErrorResponse(type: .auth)

        // When: Getting the type string
        let typeString = sut.getType()

        // Then: Should return "Type error"
        #expect(typeString == "Type error")
    }

    // MARK: - Test: Get Network Type String
    @Test("Should return correct string for network error type")
    func testGetNetworkTypeString() {
        // Given: An ErrorResponse with network type
        let sut = ErrorResponse(type: .network)

        // When: Getting the type string
        let typeString = sut.getType()

        // Then: Should return "Network error"
        #expect(typeString == "Network error")
    }

    // MARK: - Test: Get Tech Type String
    @Test("Should return correct string for tech error type")
    func testGetTechTypeString() {
        // Given: An ErrorResponse with tech type
        let sut = ErrorResponse(type: .tech)

        // When: Getting the type string
        let typeString = sut.getType()

        // Then: Should return "Tech error"
        #expect(typeString == "Tech error")
    }

    // MARK: - Test: Get Other Type String
    @Test("Should return correct string for other error type")
    func testGetOtherTypeString() {
        // Given: An ErrorResponse with other type
        let sut = ErrorResponse(type: .other)

        // When: Getting the type string
        let typeString = sut.getType()

        // Then: Should return "Other error"
        #expect(typeString == "Other error")
    }

    // MARK: - Test: ErrorResponse is an Error
    @Test("Should conform to Error protocol")
    func testErrorProtocolConformance() {
        // Given: An ErrorResponse instance
        let sut = ErrorResponse(message: "Test error")

        // When: Treating as Error type
        let error: Error = sut

        // Then: Should be castable back to ErrorResponse
        #expect(error is ErrorResponse)
        if let errorResponse = error as? ErrorResponse {
            #expect(errorResponse.message == "Test error")
        } else {
            Issue.record("Failed to cast Error to ErrorResponse")
        }
    }

    // MARK: - Test: All Error Types Coverage
    @Test("Should cover all error types with correct strings")
    func testAllErrorTypesCoverage() {
        // Given: All error types
        let errorTypes: [ErrorType] = [.auth, .network, .tech, .other]

        // When: Creating ErrorResponse for each type and getting type strings
        let typeStrings = errorTypes.map { type in
            let error = ErrorResponse(type: type)
            return error.getType()
        }

        // Then: Should have unique type strings for each type
        #expect(typeStrings.count == 4)
        #expect(typeStrings.contains("Type error"))
        #expect(typeStrings.contains("Network error"))
        #expect(typeStrings.contains("Tech error"))
        #expect(typeStrings.contains("Other error"))
    }

    // MARK: - Test: Message and Type Can Coexist
    @Test("Should handle both message and type independently")
    func testMessageAndTypeIndependence() {
        // Given: An ErrorResponse with message
        let errorWithMessage = ErrorResponse(message: "Custom message")
        errorWithMessage.type = .network

        // When: Accessing both message and type
        let message = errorWithMessage.message
        let typeString = errorWithMessage.getType()

        // Then: Both should be accessible
        #expect(message == "Custom message")
        #expect(typeString == "Network error")
    }

    // MARK: - Test: Default Values
    @Test("Should have correct default values")
    func testDefaultValues() {
        // Given/When: Creating ErrorResponse with message only
        let sut = ErrorResponse(message: "Error occurred")

        // Then: Type should default to .other
        #expect(sut.type == .other)
        #expect(sut.getType() == "Other error")
    }
}
