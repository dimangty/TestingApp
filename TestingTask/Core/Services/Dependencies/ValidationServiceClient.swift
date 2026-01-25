//
//  ValidationServiceClient.swift
//  TestingTask
//
//  TCA Dependency for ValidationService
//

import ComposableArchitecture
import Foundation

struct ValidationServiceClient {
    var isValidPhone: @Sendable (String) -> Bool
    var isValidEmail: @Sendable (String) -> Bool
    var isValid: @Sendable (SignUpField, String) -> Bool
}

extension ValidationServiceClient: DependencyKey {
    static let liveValue = ValidationServiceClient(
        isValidPhone: { phone in
            let service = Configurator.shared.serviceLocator.getService(type: ValidationServiceProtocol.self)
            return service?.isValidPhone(phone) ?? false
        },
        isValidEmail: { email in
            let service = Configurator.shared.serviceLocator.getService(type: ValidationServiceProtocol.self)
            return service?.isValidEmail(email) ?? false
        },
        isValid: { field, value in
            let service = Configurator.shared.serviceLocator.getService(type: ValidationServiceProtocol.self)
            return service?.isValid(field: field, value: value) ?? false
        }
    )
}

extension DependencyValues {
    var validationService: ValidationServiceClient {
        get { self[ValidationServiceClient.self] }
        set { self[ValidationServiceClient.self] = newValue }
    }
}
