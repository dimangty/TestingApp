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
    @State private var selectedTab: Tab = .news

    private enum Tab {
        case news
        case favorites
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NewsView(store: store.scope(state: \.news, action: \.news))
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
                .tag(Tab.news)

            FavoriteView(store: store.scope(state: \.favorites, action: \.favorites))
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
                .tag(Tab.favorites)
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: selectedTab) { newValue in
            if newValue == .favorites {
                store.send(.favorites(.loadFavorites))
            }
        }
    }
}
