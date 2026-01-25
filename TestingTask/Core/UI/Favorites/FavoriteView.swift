//
//  FavoriteView.swift
//  TestingTask
//
//  Migrated to SwiftUI with TCA
//

import SwiftUI
import ComposableArchitecture

struct FavoriteView: View {
    let store: StoreOf<FavoriteFeature>

    var body: some View {
        Group {
            if store.articles.isEmpty {
                VStack {
                    Text("No favorites yet")
                        .foregroundColor(.secondary)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(store.articles, id: \.title) { article in
                        ArticleRowView(
                            article: article,
                            isFavorite: true
                        ) {
                            store.send(.toggleFavorite(article))
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Favorites")
        .onAppear {
            store.send(.onAppear)
        }
    }
}
