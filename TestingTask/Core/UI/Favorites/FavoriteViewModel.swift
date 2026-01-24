//
//  FavoriteViewModel.swift
//  TestingTask
//
//  Migrated to SwiftUI
//

import Foundation
import Combine

@MainActor
class FavoriteViewModel: ObservableObject {
    @Published var articles: [ArticleViewModel] = []

    @Injected private var storage: StorageService?

    init() {
        storage?.addObserver(self)
    }

    func loadFavorites() {
        guard let storage = storage else { return }

        let favoriteArticles = storage.articles
        articles = favoriteArticles.map { entity in
            let article = entity.toArticle()
            return ArticleViewModel(article: article, storage: storage)
        }
    }

    func toggleFavorite(article: ArticleViewModel) {
        article.addOrRemoveFromFavorites()
        objectWillChange.send()
    }
}

extension FavoriteViewModel: NewsAppStorageObserver {
    func didRemoveFromFavorites(title: String) {
        loadFavorites()
    }

    func didAddToFavorites(article: ArticleEntity) {
        loadFavorites()
    }
}
