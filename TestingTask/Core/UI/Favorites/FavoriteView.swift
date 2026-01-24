//
//  FavoriteView.swift
//  TestingTask
//
//  Migrated to SwiftUI
//

import SwiftUI

struct FavoriteView: View {
    @StateObject private var viewModel = FavoriteViewModel()

    var body: some View {
        Group {
            if viewModel.articles.isEmpty {
                VStack {
                    Text("No favorites yet")
                        .foregroundColor(.secondary)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.articles, id: \.title) { article in
                        NavigationLink(value: NavigationRoute.article(article)) {
                            ArticleRowView(article: article) {
                                viewModel.toggleFavorite(article: article)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Favorites")
        .onAppear {
            viewModel.loadFavorites()
        }
    }
}
