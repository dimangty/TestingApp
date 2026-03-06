//
//  ObfuscatorTests.swift
//  TestingTaskTests
//
//  Unit tests for Obfuscator with Given/When/Then pattern
//

import Testing
import Foundation
@testable import TestingTask

@Suite("Obfuscator Tests")
struct ObfuscatorTests {

    // MARK: - Test: Reveal Obfuscated Key
    @Test("Should reveal obfuscated currate API key correctly")
    func testRevealCurrateAPIKey() {
        // Given: An obfuscator instance with default salt
        let sut = Obfuscator()

        // When: Revealing the encrypted currate API key
        let revealedKey = sut.reveal(key: sut.currateAPIkey)

        // Then: Should return the decrypted API key (32 character hex string)
        #expect(revealedKey.count == 32)
        #expect(revealedKey == "9f3b3102ab704b7c9a874ee92cdb288f")
    }

    // MARK: - Test: Reveal with Custom Salt
    @Test("Should reveal key using custom salt")
    func testRevealWithCustomSalt() {
        // Given: An obfuscator with custom salt "ba"
        let customSalt = "ba"
        let sut = Obfuscator(with: customSalt)

        // When: Revealing an encrypted key that was encrypted with "ba"
        // The currateAPIkey was encrypted with "ba" salt
        let revealedKey = sut.reveal(key: sut.currateAPIkey)

        // Then: Should correctly decrypt the key
        #expect(revealedKey == "9f3b3102ab704b7c9a874ee92cdb288f")
    }

#if DEBUG
    // MARK: - Test: Encrypt and Decrypt Round Trip
    @Test("Should encrypt and then decrypt string back to original")
    func testEncryptDecryptRoundTrip() {
        // Given: An obfuscator and a test string
        let testString = "TestSecret123"
        let sut = Obfuscator(with: "test")

        // When: Encrypting and then decrypting the string
        let encrypted = sut.bytesByObfuscatingString(string: testString)
        let decrypted = sut.reveal(key: encrypted)

        // Then: Decrypted string should match original
        #expect(decrypted == testString)
    }

    // MARK: - Test: Different Salts Produce Different Results
    @Test("Should produce different encrypted values with different salts")
    func testDifferentSaltsProduceDifferentResults() {
        // Given: Two obfuscators with different salts
        let testString = "Secret"
        let obfuscator1 = Obfuscator(with: "salt1")
        let obfuscator2 = Obfuscator(with: "salt2")

        // When: Encrypting same string with different salts
        let encrypted1 = obfuscator1.bytesByObfuscatingString(string: testString)
        let encrypted2 = obfuscator2.bytesByObfuscatingString(string: testString)

        // Then: Encrypted values should be different
        #expect(encrypted1 != encrypted2)
    }

    // MARK: - Test: Empty String Encryption
    @Test("Should handle empty string encryption")
    func testEmptyStringEncryption() {
        // Given: An obfuscator and an empty string
        let emptyString = ""
        let sut = Obfuscator(with: "test")

        // When: Encrypting and decrypting empty string
        let encrypted = sut.bytesByObfuscatingString(string: emptyString)
        let decrypted = sut.reveal(key: encrypted)

        // Then: Should return empty string
        #expect(encrypted.isEmpty)
        #expect(decrypted == emptyString)
    }

    // MARK: - Test: Long String Encryption
    @Test("Should handle long string encryption")
    func testLongStringEncryption() {
        // Given: An obfuscator and a long string
        let longString = String(repeating: "A", count: 1000)
        let sut = Obfuscator(with: "test")

        // When: Encrypting and decrypting long string
        let encrypted = sut.bytesByObfuscatingString(string: longString)
        let decrypted = sut.reveal(key: encrypted)

        // Then: Should correctly decrypt to original
        #expect(decrypted == longString)
        #expect(encrypted.count == 1000)
    }

    // MARK: - Test: Special Characters Encryption
    @Test("Should handle special characters in encryption")
    func testSpecialCharactersEncryption() {
        // Given: An obfuscator and a string with special characters
        let specialString = "!@#$%^&*()_+-=[]{}|;':\",./<>?"
        let sut = Obfuscator(with: "test")

        // When: Encrypting and decrypting special characters
        let encrypted = sut.bytesByObfuscatingString(string: specialString)
        let decrypted = sut.reveal(key: encrypted)

        // Then: Should correctly decrypt to original
        #expect(decrypted == specialString)
    }

    // MARK: - Test: Unicode Characters Encryption
    @Test("Should handle unicode characters in encryption")
    func testUnicodeCharactersEncryption() {
        // Given: An obfuscator and a string with unicode characters
        let unicodeString = "Hello мир 世界 🌍"
        let sut = Obfuscator(with: "test")

        // When: Encrypting and decrypting unicode string
        let encrypted = sut.bytesByObfuscatingString(string: unicodeString)
        let decrypted = sut.reveal(key: encrypted)

        // Then: Should correctly decrypt to original
        #expect(decrypted == unicodeString)
    }
#endif

    // MARK: - Test: Consistent Decryption with Same Salt
    @Test("Should consistently decrypt with same salt")
    func testConsistentDecryptionWithSameSalt() {
        // Given: An obfuscator with specific salt and encrypted bytes
        let salt = "ba"
        let sut = Obfuscator(with: salt)

        // When: Decrypting the currate API key multiple times
        let result1 = sut.reveal(key: sut.currateAPIkey)
        let result2 = sut.reveal(key: sut.currateAPIkey)
        let result3 = sut.reveal(key: sut.currateAPIkey)

        // Then: All results should be identical
        #expect(result1 == result2)
        #expect(result2 == result3)
        #expect(result1 == "9f3b3102ab704b7c9a874ee92cdb288f")
    }

    // MARK: - Test: Default Obfuscator Salt Generation
    @Test("Should generate correct default salt")
    func testDefaultSaltGeneration() {
        // Given: A default obfuscator instance
        let sut = Obfuscator()

        // When: Revealing the API key with default salt
        let revealed = sut.reveal(key: sut.currateAPIkey)

        // Then: Should correctly decrypt (verifying salt is "ba")
        #expect(revealed == "9f3b3102ab704b7c9a874ee92cdb288f")
    }
}
