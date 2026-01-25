//
//  NewsView.swift
//  TestingTask
//
//  Migrated to SwiftUI with TCA
//

import SwiftUI
import ComposableArchitecture

struct NewsView: View {
    @Perception.Bindable var store: StoreOf<NewsFeature>

    var body: some View {
        Group {
            if store.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else if let errorMessage = store.errorMessage {
                VStack {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                    Button("Retry") {
                        store.send(.retryTapped)
                    }
                }
            } else {
                List {
                    ForEach(store.filteredArticles, id: \.title) { article in
                        ArticleRowView(
                            article: article,
                            isFavorite: false // Will be updated dynamically
                        ) {
                            store.send(.toggleFavorite(article))
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("News")
        .searchable(text: $store.searchText, prompt: "Search by title")
        .onAppear {
            store.send(.onAppear)
        }
    }
}
