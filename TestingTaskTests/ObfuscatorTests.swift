import XCTest
@testable import TestingTask

final class ObfuscatorTests: XCTestCase {
    // MARK: - reveal(key:)

    func test_reveal_returnsOriginalString() {
        // Given
        let salt = "ab"
        let original = "secret"
        let obfuscator = Obfuscator(with: salt)
        // Build a key using the same XOR scheme expected by Obfuscator.
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
        // Repeating-key XOR: each byte is XOR'ed with salt byte by index.
        return text.enumerated().map { offset, byte in
            byte ^ cipher[offset % length]
        }
    }
}
