//
//  TestingTaskApp.swift
//  TestingTask
//
//  SwiftUI App Entry Point with TCA
//

import SwiftUI
import ComposableArchitecture

@main
struct TestingTaskApp: App {
    init() {
        // Initialize services
        Configurator.shared.setup()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LoginView(
                    store: Store(initialState: LoginFeature.State()) {
                        LoginFeature()
                    }
                )
            }
        }
    }
}
