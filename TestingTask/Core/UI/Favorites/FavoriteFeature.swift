//
//  FavoriteFeature.swift
//  TestingTask
//
//  TCA Feature for Favorites
//

import ComposableArchitecture
import Foundation

@Reducer
struct FavoriteFeature {
    @ObservableState
    struct State: Equatable {
        var articles: [Article] = []
        var isLoading: Bool = false
    }

    enum Action {
        case onAppear
        case loadFavorites
        case favoritesLoaded([Article])
        case toggleFavorite(Article)
    }

    @Dependency(\.storageService) var storageService

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.loadFavorites)

            case .loadFavorites:
                state.isLoading = true

                return .run { send in
                    let entities = await storageService.getFavorites()
                    let articles = entities.map { $0.toArticle() }
                    await send(.favoritesLoaded(articles))
                }

            case .favoritesLoaded(let articles):
                state.isLoading = false
                state.articles = articles
                return .none

            case .toggleFavorite(let article):
                guard let title = article.title else { return .none }

                return .run { send in
                    await storageService.removeFromFavorites(title)
                    await send(.loadFavorites)
                }
            }
        }
    }
}
