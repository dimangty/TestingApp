//
//  TestConfigurator.swift
//  TestingTaskTests
//
//  Test configurator for setting up dependency injection in unit tests
//  Following Mobile Testing Guidelines v3 recommendations
//
//  Usage:
//  - Call TestConfigurator.setupForTesting() at the start of each test
//  - Register mock services using registerService() method
//
//  Ensures presenters can access mocked dependencies through @Injected property wrapper
//

import Foundation
@testable import TestingTask

/// Test configurator for managing dependency injection in unit tests
/// Provides service registration through the shared configurator
final class TestConfigurator {

    private init() {}

    /// Sets up test environment with fresh service locator
    /// Call this method at the start of each test
    /// - Returns: The shared ServiceLocator instance
    @discardableResult
    static func setupForTesting() -> ServiceLocator {
        // Simply return the shared service locator
        // Tests will register their mocks directly into it
        return Configurator.shared.serviceLocator
    }

    /// Registers a service in the Configurator's service locator
    /// - Parameter service: The service instance to register
    static func registerService<T>(service: T) {
        Configurator.shared.serviceLocator.addService(service: service)
    }

    /// Retrieves a service from the Configurator's service locator
    /// - Parameter type: The type of service to retrieve
    /// - Returns: The service instance if registered, nil otherwise
    static func getService<T>(type: T.Type) -> T? {
        return Configurator.shared.serviceLocator.getService(type: type)
    }
}
