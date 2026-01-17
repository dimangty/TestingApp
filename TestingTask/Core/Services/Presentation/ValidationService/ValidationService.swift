//
//  ValidationService.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import Foundation

class ValidationService {
    func isValid(field: SignUpField, value: String) -> Bool {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        switch field {
        case .firstName, .lastName, .gender, .birthDate, .country, .city:
            return !trimmed.isEmpty
        case .email:
            return isValidEmail(trimmed)
        case .phone:
            return isValidPhone(trimmed)
        }
    }

    private func isValidEmail(_ value: String) -> Bool {
        if value.isEmpty {
            return false
        }
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: value)
    }

    private func isValidPhone(_ value: String) -> Bool {
        let digits = value.filter { $0.isNumber }
        guard digits.count >= 7, digits.count <= 15 else {
            return false
        }
        return digits.count == value.count
    }
}
