//
//  MainTabView.swift
//  TestingTask
//
//  Migrated to SwiftUI
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NewsView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }

            FavoriteView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}
