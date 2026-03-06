//
//  TestConfigurator.swift
//  TestingTaskTests
//
//  Created for unit testing with dependency injection
//

import Foundation
@testable import TestingTask

/// Test configurator for setting up mock dependencies in unit tests
/// Provides isolated service locator instance to avoid interfering with production code
final class TestConfigurator {
    let serviceLocator = ServiceLocator()

    /// Register mock services for testing
    /// This setup mirrors the production Configurator but allows injecting mocks
    func setupMocks() {
        // Services will be registered individually in each test
        // This keeps tests isolated and independent
    }

    /// Register a specific service for testing
    /// - Parameter service: The service (or mock) to register
    func registerService<T>(service: T) {
        serviceLocator.addService(service: service)
    }

    /// Get a registered service
    /// - Parameter type: The type of service to retrieve
    /// - Returns: The service instance if registered
    func getService<T>(type: T.Type) -> T? {
        return serviceLocator.getService(type: type)
    }

    /// Clear all registered services
    /// Should be called in tearDown to ensure test isolation
    func reset() {
        // ServiceLocator doesn't have a clear method, but we can create a new instance
        // For now, tests should create new TestConfigurator instances
    }
}
