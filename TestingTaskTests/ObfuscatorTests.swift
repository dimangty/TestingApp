import Foundation
import Testing
@testable import TestingTask

@Suite("Obfuscator Tests")
struct ObfuscatorTests {
    @Test("Reveal returns original text for obfuscated bytes")
    func revealReturnsOriginalString() {
        // Given
        let salt = "ab"
        let original = "secret"
        let sut = Obfuscator(with: salt)
        let encrypted = obfuscatedBytes(for: original, salt: salt)

        // When
        let value = sut.reveal(key: encrypted)

        // Then
        #expect(value == original)
    }

    @Test("String characters helper returns per-character array")
    func stringCharactersReturnsCharacterArray() {
        // Given
        let input = "abc"

        // When
        let chars = input.characters()

        // Then
        #expect(chars.count == 3)
        #expect(chars[0] == Character("a"))
        #expect(chars[1] == Character("b"))
        #expect(chars[2] == Character("c"))
    }

    #if DEBUG
    @Test("Debug obfuscation helper can be reversed by reveal")
    func bytesByObfuscatingStringRoundTrip() {
        // Given
        let original = "payload"
        let sut = Obfuscator(with: "ab")

        // When
        let bytes = sut.bytesByObfuscatingString(string: original)
        let revealed = sut.reveal(key: bytes)

        // Then
        #expect(revealed == original)
    }
    #endif

    private func obfuscatedBytes(for value: String, salt: String) -> [UInt8] {
        let text = [UInt8](value.utf8)
        let cipher = [UInt8](salt.utf8)
        let length = cipher.count
        return text.enumerated().map { offset, byte in
            byte ^ cipher[offset % length]
        }
    }
}
