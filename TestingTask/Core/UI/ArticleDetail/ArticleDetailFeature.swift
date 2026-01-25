//
//  ArticleDetailFeature.swift
//  TestingTask
//
//  TCA Feature for ArticleDetail
//

import ComposableArchitecture
import Foundation

@Reducer
struct ArticleDetailFeature {
    @ObservableState
    struct State: Equatable {
        let article: Article
        var isFavorite: Bool = false
    }

    enum Action {
        case onAppear
        case toggleFavorite
        case favoriteStatusChanged(Bool)
    }

    @Dependency(\.storageService) var storageService

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard let title = state.article.title else { return .none }

                return .run { send in
                    let isFavorite = await storageService.isArticleInFavorites(title)
                    await send(.favoriteStatusChanged(isFavorite))
                }

            case .toggleFavorite:
                guard let title = state.article.title else { return .none }

                return .run { [article = state.article, isFavorite = state.isFavorite] send in
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
                    let newStatus = await storageService.isArticleInFavorites(title)
                    await send(.favoriteStatusChanged(newStatus))
                }

            case .favoriteStatusChanged(let isFavorite):
                state.isFavorite = isFavorite
                return .none
            }
        }
    }
}
