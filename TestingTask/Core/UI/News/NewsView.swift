//
//  NewsView.swift
//  TestingTask
//
//  Migrated to SwiftUI
//

import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else if let errorMessage = viewModel.errorMessage {
                VStack {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                    Button("Retry") {
                        viewModel.loadArticles()
                    }
                }
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
        .navigationTitle("News")
        .searchable(text: $viewModel.searchText, prompt: "Search by title")
        .onAppear {
            if viewModel.articles.isEmpty {
                viewModel.loadArticles()
            } else {
                viewModel.refreshIfNeeded()
            }
        }
    }
}
