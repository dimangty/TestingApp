//
//  FavoriteView.swift
//  TestingTask
//
//  Migrated to SwiftUI with TCA
//

import SwiftUI
import ComposableArchitecture

struct FavoriteView: View {
    @Perception.Bindable var store: StoreOf<FavoriteFeature>

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
                        NavigationLink(
                            state: AppFeature.Path.State.articleDetail(
                                ArticleDetailFeature.State(article: article)
                            )
                        ) {
                            ArticleRowView(
                                article: article,
                                isFavorite: true
                            ) {
                                store.send(.toggleFavorite(article))
                            }
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
