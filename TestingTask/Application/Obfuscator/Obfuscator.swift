//
//  Obfuscator.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import Foundation
extension String {
    
    func characters() -> [Character] {
        return self.map { $0 }
    }
    
}

final class Obfuscator {
    
    // MARK: - Variables
    
    //9f3b3102ab704b7c9a874ee92cdb288f
    let currateAPIkey: [UInt8] = [83, 89, 1, 89, 91, 89, 84, 89, 90, 86, 0, 5, 83, 89, 7, 85, 91, 83, 0, 3, 91, 89, 3, 87, 0, 86, 7, 86, 87, 3, 90, 7]//Зашифрованный ключ

    /// The salt used to obfuscate and reveal the string.
    private var salt: String
    
    // MARK: - Initialization
    
    @_optimize(none)
    init() {

        // Generate salt
        typealias C = Character
        let a1: C, a2: C
        (a1, a2) = ("a", "b")
        self.salt = String("00".characters().enumerated().map { i, e in
            if i == 0 { return a2 }
            else { return a1 }
        })
    }
    
    init(with salt: String) {
        self.salt = salt
    }
    
    // MARK: - Instance Methods
    #if DEBUG
    func bytesByObfuscatingString(string: String) -> [UInt8] {
        let text = [UInt8](string.utf8)
        let cipher = [UInt8](self.salt.utf8)
        let length = cipher.count
        
        var encrypted = [UInt8]()
        
        for t in text.enumerated() {
            encrypted.append(t.element ^ cipher[t.offset % length])
        }
        
        #if DEBUG
        pp("Salt used: \(self.salt)\n")
        pp("Swift Code:\n************")
        pp("// Original \"\(string)\"")
        pp("let key: [UInt8] = \(encrypted)\n")
        #endif
        
        return encrypted
    }
    #endif
    
    func reveal(key: [UInt8]) -> String {
        let cipher = [UInt8](self.salt.utf8)
        let length = cipher.count
        
        var decrypted = [UInt8]()
        
        for k in key.enumerated() {
            decrypted.append(k.element ^ cipher[k.offset % length])
        }
        
        return String(bytes: decrypted, encoding: .utf8)!
    }
}
