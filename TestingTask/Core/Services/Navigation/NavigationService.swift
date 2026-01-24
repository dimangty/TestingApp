//
//  NavigationService.swift
//  TestingTask
//
//  Created by Codex on 2025-02-02.
//

import SwiftUI

enum NavigationRoute: Hashable {
    case signUp
    case main
    case article(ArticleViewModel)
}

@MainActor
final class NavigationService: ObservableObject {
    @Published var path: [NavigationRoute] = []

    func push(_ route: NavigationRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}
