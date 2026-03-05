import Foundation
import Testing
@testable import TestingTask

@Suite("Formatter and Request Tests")
struct DateExtensionsTests {
    @Test("Date toString formats using provided pattern")
    func toStringFormatsDateWithExpectedPattern() {
        // Given
        var components = DateComponents()
        components.year = 2024
        components.month = 2
        components.day = 3
        components.hour = 12
        components.minute = 34
        components.timeZone = TimeZone(secondsFromGMT: 0)
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: components) ?? Date(timeIntervalSince1970: 0)

        // When
        let value = date.toString(format: "dd.MM.yyyy")

        // Then
        #expect(value == "03.02.2024")
    }

    @Test("Currency list request path is stable")
    func requestCurrencyListHasExpectedValue() {
        // Given
        let request = Requests.currencyList

        // When
        let path = request.value

        // Then
        #expect(path == "?get=currency_list")
    }

    @Test("Rates request interpolates pairs parameter")
    func requestRatesBuildsExpectedPath() {
        // Given
        let request = Requests.rates(pairs: "USDRUB,EURRUB")

        // When
        let path = request.value

        // Then
        #expect(path == "?get=rates&pairs=USDRUB,EURRUB")
    }

    @Test("Network configuration returns base url and key shape")
    func networkConfigurationContainsBaseUrlAndKeyEntry() {
        // Given
        let configuration = NetworkConfiguration()

        // When
        let baseURL = configuration.getBaseUrl()
        let keyDictionary = configuration.getKey()

        // Then
        #expect(baseURL == "https://currate.ru/api/")
        #expect(keyDictionary.keys.contains("key"))
    }
}
