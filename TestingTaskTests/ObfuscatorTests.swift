import XCTest
@testable import TestingTask

final class ObfuscatorTests: XCTestCase {
    func test_reveal_returnsOriginalString() {
        // Given
        let salt = "ab"
        let original = "secret"
        let obfuscator = Obfuscator(with: salt)
        let key = obfuscatedBytes(for: original, salt: salt)

        // When
        let result = obfuscator.reveal(key: key)

        // Then
        XCTAssertEqual(result, original)
    }

    private func obfuscatedBytes(for string: String, salt: String) -> [UInt8] {
        let text = [UInt8](string.utf8)
        let cipher = [UInt8](salt.utf8)
        let length = cipher.count
        return text.enumerated().map { offset, byte in
            byte ^ cipher[offset % length]
        }
    }
}
