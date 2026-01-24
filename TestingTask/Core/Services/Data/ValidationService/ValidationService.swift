//
//  ValidationService.swift
//  TestingTask
//
//  Created for SwiftUI migration
//

import Foundation

protocol ValidationServiceProtocol {
    func isValid(field: SignUpField, value: String) -> Bool
    func isValidPhone(_ phone: String) -> Bool
    func isValidEmail(_ email: String) -> Bool
}

class ValidationService: ValidationServiceProtocol {

    func isValid(field: SignUpField, value: String) -> Bool {
        switch field {
        case .firstName, .lastName:
            return !value.isEmpty && value.count >= 2
        case .gender:
            return !value.isEmpty
        case .birthDate:
            return !value.isEmpty
        case .country:
            return !value.isEmpty
        case .city:
            return !value.isEmpty
        case .email:
            return isValidEmail(value)
        case .phone:
            return isValidPhone(value)
        }
    }

    func isValidPhone(_ phone: String) -> Bool {
        let digitsOnly = phone.filter { $0.isNumber }
        return digitsOnly.count >= 7 && digitsOnly.count <= 15
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
