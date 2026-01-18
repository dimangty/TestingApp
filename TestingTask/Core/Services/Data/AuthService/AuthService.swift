//
//  AuthService.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import Foundation

enum AuthError: Error {
    case invalidPhone
    case invalidData
}

protocol AuthServiceProtocol: AnyObject {
    func login(phone: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signUp(data: SignUpData, completion: @escaping (Result<Void, Error>) -> Void)
}

class AuthService: AuthServiceProtocol {
    func login(phone: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let digitsOnly = phone.filter { $0.isNumber }
        guard digitsOnly.count >= 7, digitsOnly.count <= 15 else {
            completion(.failure(AuthError.invalidPhone))
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            completion(.success(()))
        }
    }

    func signUp(data: SignUpData, completion: @escaping (Result<Void, Error>) -> Void) {
        if data.fields.isEmpty {
            completion(.failure(AuthError.invalidData))
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            completion(.success(()))
        }
    }
}
