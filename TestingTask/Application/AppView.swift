//
//  AppView.swift
//  TestingTask
//
//  Main App View with Navigation
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    @Perception.Bindable var store: StoreOf<AppFeature>

    var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: \.path)) {
            LoginView(store: store.scope(state: \.login, action: \.login))
        } destination: { store in
            switch store.case {
            case .signUp(let store):
                SignUpView(store: store)
            case .main(let store):
                MainTabView(store: store)
            case .articleDetail(let store):
                ArticleDetailView(store: store)
            }
        }
    }
}
