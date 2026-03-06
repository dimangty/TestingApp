//
//  DateExtensionsTests.swift
//  TestingTaskTests
//
//  Unit tests for Date extension with Given/When/Then pattern
//

import Testing
import Foundation
@testable import TestingTask

@Suite("Date Extensions Tests")
struct DateExtensionsTests {

    // MARK: - Test: Format Date with dd.MM.yyyy Pattern
    @Test("Should format date with dd.MM.yyyy pattern correctly")
    func testFormatDateWithDayMonthYearPattern() {
        // Given: A specific date (January 15, 2023)
        var components = DateComponents()
        components.year = 2023
        components.month = 1
        components.day = 15
        components.hour = 10
        components.minute = 30
        let calendar = Calendar.current
        guard let date = calendar.date(from: components) else {
            Issue.record("Failed to create date from components")
            return
        }

        // When: Formatting date with "dd.MM.yyyy" pattern
        let formattedDate = date.toString(format: "dd.MM.yyyy")

        // Then: Should return date in expected format
        #expect(formattedDate == "15.01.2023")
    }

    // MARK: - Test: Format Date with Full DateTime Pattern
    @Test("Should format date with full datetime pattern")
    func testFormatDateWithFullDateTimePattern() {
        // Given: A specific date and time
        var components = DateComponents()
        components.year = 2023
        components.month = 6
        components.day = 20
        components.hour = 14
        components.minute = 45
        components.second = 30
        let calendar = Calendar.current
        guard let date = calendar.date(from: components) else {
            Issue.record("Failed to create date from components")
            return
        }

        // When: Formatting date with "dd.MM.yyyy HH:mm:ss" pattern
        let formattedDate = date.toString(format: "dd.MM.yyyy HH:mm:ss")

        // Then: Should return full datetime in expected format
        #expect(formattedDate == "20.06.2023 14:45:30")
    }

    // MARK: - Test: Format Date with Time Only Pattern
    @Test("Should format date showing only time")
    func testFormatDateWithTimeOnly() {
        // Given: A specific date and time
        var components = DateComponents()
        components.year = 2023
        components.month = 3
        components.day = 10
        components.hour = 9
        components.minute = 5
        let calendar = Calendar.current
        guard let date = calendar.date(from: components) else {
            Issue.record("Failed to create date from components")
            return
        }

        // When: Formatting date with "HH:mm" pattern
        let formattedTime = date.toString(format: "HH:mm")

        // Then: Should return time in expected format
        #expect(formattedTime == "09:05")
    }

    // MARK: - Test: Format Date with Month Name Pattern
    @Test("Should format date with month name in Russian locale")
    func testFormatDateWithMonthName() {
        // Given: A specific date
        var components = DateComponents()
        components.year = 2023
        components.month = 12
        components.day = 25
        let calendar = Calendar.current
        guard let date = calendar.date(from: components) else {
            Issue.record("Failed to create date from components")
            return
        }

        // When: Formatting date with "dd MMMM yyyy" pattern
        let formattedDate = date.toString(format: "dd MMMM yyyy")

        // Then: Should return date with Russian month name
        // Note: Expecting Russian locale as set in extension
        #expect(formattedDate.contains("2023"))
        #expect(formattedDate.contains("25"))
    }

    // MARK: - Test: Format Date with Year Only
    @Test("Should format date showing only year")
    func testFormatDateWithYearOnly() {
        // Given: A date in year 2024
        var components = DateComponents()
        components.year = 2024
        components.month = 7
        components.day = 4
        let calendar = Calendar.current
        guard let date = calendar.date(from: components) else {
            Issue.record("Failed to create date from components")
            return
        }

        // When: Formatting date with "yyyy" pattern
        let formattedYear = date.toString(format: "yyyy")

        // Then: Should return only the year
        #expect(formattedYear == "2024")
    }

    // MARK: - Test: Format Date with Custom Pattern
    @Test("Should format date with custom pattern")
    func testFormatDateWithCustomPattern() {
        // Given: A specific date
        var components = DateComponents()
        components.year = 2023
        components.month = 8
        components.day = 9
        let calendar = Calendar.current
        guard let date = calendar.date(from: components) else {
            Issue.record("Failed to create date from components")
            return
        }

        // When: Formatting date with custom "yyyy-MM-dd" pattern
        let formattedDate = date.toString(format: "yyyy-MM-dd")

        // Then: Should return date in custom format
        #expect(formattedDate == "2023-08-09")
    }

    // MARK: - Test: Format Date with Weekday
    @Test("Should format date showing weekday")
    func testFormatDateWithWeekday() {
        // Given: A specific date (known to be Sunday, January 1, 2023)
        var components = DateComponents()
        components.year = 2023
        components.month = 1
        components.day = 1
        let calendar = Calendar.current
        guard let date = calendar.date(from: components) else {
            Issue.record("Failed to create date from components")
            return
        }

        // When: Formatting date with "EEEE, dd MMMM yyyy" pattern
        let formattedDate = date.toString(format: "EEEE, dd MMMM yyyy")

        // Then: Should include weekday name (in Russian locale)
        #expect(formattedDate.contains("2023"))
        #expect(formattedDate.contains("01"))
    }

    // MARK: - Test: Format Different Dates Produces Different Results
    @Test("Should produce different formatted strings for different dates")
    func testDifferentDatesDifferentFormats() {
        // Given: Two different dates
        let calendar = Calendar.current
        var components1 = DateComponents()
        components1.year = 2023
        components1.month = 1
        components1.day = 1

        var components2 = DateComponents()
        components2.year = 2023
        components2.month = 12
        components2.day = 31

        guard let date1 = calendar.date(from: components1),
              let date2 = calendar.date(from: components2) else {
            Issue.record("Failed to create dates from components")
            return
        }

        // When: Formatting both dates with same pattern
        let formatted1 = date1.toString(format: "dd.MM.yyyy")
        let formatted2 = date2.toString(format: "dd.MM.yyyy")

        // Then: Formatted strings should be different
        #expect(formatted1 != formatted2)
        #expect(formatted1 == "01.01.2023")
        #expect(formatted2 == "31.12.2023")
    }
}
