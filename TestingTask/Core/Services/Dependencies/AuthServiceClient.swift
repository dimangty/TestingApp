//
//  AuthServiceClient.swift
//  TestingTask
//
//  TCA Dependency for AuthService
//

import ComposableArchitecture
import Foundation

struct AuthServiceClient {
    var login: @Sendable (String) async -> Result<Void, Error>
    var signUp: @Sendable (SignUpData) async -> Result<Void, Error>
}

extension AuthServiceClient: DependencyKey {
    static let liveValue = AuthServiceClient(
        login: { phone in
            await withCheckedContinuation { continuation in
                let service = Configurator.shared.serviceLocator.getService(type: AuthServiceProtocol.self)
                service?.login(phone: phone) { result in
                    continuation.resume(returning: result)
                }
            }
        },
        signUp: { data in
            await withCheckedContinuation { continuation in
                let service = Configurator.shared.serviceLocator.getService(type: AuthServiceProtocol.self)
                service?.signUp(data: data) { result in
                    continuation.resume(returning: result)
                }
            }
        }
    )
}

extension DependencyValues {
    var authService: AuthServiceClient {
        get { self[AuthServiceClient.self] }
        set { self[AuthServiceClient.self] = newValue }
    }
}
