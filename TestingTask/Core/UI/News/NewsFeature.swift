//
//  NewsFeature.swift
//  TestingTask
//
//  TCA Feature for News
//

import ComposableArchitecture
import Foundation

@Reducer
struct NewsFeature {
    @ObservableState
    struct State: Equatable {
        var articles: [Article] = []
        var searchText: String = ""
        var isLoading: Bool = false
        var errorMessage: String?
        var allArticles: [Article] = []

        var filteredArticles: [Article] {
            if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return allArticles
            } else {
                let query = searchText.lowercased()
                return allArticles.filter { ($0.title ?? "").lowercased().contains(query) }
            }
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case loadArticles
        case articlesResponse(Result<NewsSource, Error>)
        case toggleFavorite(Article)
        case retryTapped
    }

    @Dependency(\.newsService) var newsService
    @Dependency(\.storageService) var storageService

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                // Filter happens automatically through computed property
                return .none

            case .onAppear:
                if state.articles.isEmpty {
                    return .send(.loadArticles)
                }
                return .none

            case .loadArticles:
                state.articles = []
                state.allArticles = []
                state.isLoading = true
                state.errorMessage = nil

                return .run { send in
                    let result = await newsService.fetchNews()
                    await send(.articlesResponse(result))
                }

            case .articlesResponse(.success(let newsSource)):
                state.isLoading = false
                state.allArticles = newsSource.articles
                state.articles = newsSource.articles
                return .none

            case .articlesResponse(.failure(let error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none

            case .toggleFavorite(let article):
                guard let title = article.title else { return .none }

                return .run { _ in
                    let isFavorite = await storageService.isArticleInFavorites(title)
                    if isFavorite {
                        await storageService.removeFromFavorites(title)
                    } else {
                        await storageService.addToFavorites(
                            title,
                            article.description ?? "",
                            article.publishedAt,
                            article.urlToImage?.absoluteString
                        )
                    }
                }

            case .retryTapped:
                return .send(.loadArticles)
            }
        }
    }
}
