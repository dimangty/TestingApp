//
//  MainTabView.swift
//  TestingTask
//
//  Migrated to SwiftUI with TCA
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
    let store: StoreOf<MainTabFeature>

    var body: some View {
        TabView {
            NewsView(store: store.scope(state: \.news, action: \.news))
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }

            FavoriteView(store: store.scope(state: \.favorites, action: \.favorites))
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}
