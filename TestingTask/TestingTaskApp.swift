//
//  TestingTaskApp.swift
//  TestingTask
//
//  SwiftUI App Entry Point
//

import SwiftUI

@main
struct TestingTaskApp: App {
    @StateObject private var navigationService: NavigationService

    init() {
        Configurator.shared.setup()
        let service = NavigationService()
        _navigationService = StateObject(wrappedValue: service)
        Configurator.shared.serviceLocator.addService(service: service)
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationService.path) {
                LoginView()
                    .navigationDestination(for: NavigationRoute.self) { route in
                        switch route {
                        case .signUp:
                            SignUpView()
                        case .main:
                            MainTabView()
                        case .article(let article):
                            ArticleDetailView(article: article)
                        }
                    }
            }
            .environmentObject(navigationService)
        }
    }
}
