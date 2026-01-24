//
//  NewsViewModel.swift
//  TestingTask
//
//  Migrated to SwiftUI
//

import Foundation
import Combine

@MainActor
class NewsViewModel: ObservableObject {
    @Published var articles: [ArticleViewModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    @Injected private var newsService: NewsService?
    @Injected private var storage: StorageService?

    private var allArticles: [ArticleViewModel] = []
    private var cancellables = Set<AnyCancellable>()

    init() {
        storage?.addObserver(self)

        $searchText
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.applyFilter()
            }
            .store(in: &cancellables)
    }

    func loadArticles() {
        articles.removeAll()
        allArticles.removeAll()
        isLoading = true
        errorMessage = nil

        newsService?.performNewsRequest { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self, let storage = self.storage else { return }
                self.isLoading = false

                switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .success(let newsSource):
                    self.allArticles = newsSource.articles.map { article in
                        ArticleViewModel(article: article, storage: storage)
                    }
                    self.applyFilter()
                }
            }
        }
    }

    private func applyFilter() {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            articles = allArticles
        } else {
            let query = searchText.lowercased()
            articles = allArticles.filter { ($0.title ?? "").lowercased().contains(query) }
        }
    }

    func toggleFavorite(article: ArticleViewModel) {
        article.addOrRemoveFromFavorites()
        objectWillChange.send()
    }

    func refreshIfNeeded() {
        objectWillChange.send()
    }
}

extension NewsViewModel: NewsAppStorageObserver {
    func didRemoveFromFavorites(title: String) {
        objectWillChange.send()
    }

    func didAddToFavorites(article: ArticleEntity) {
        objectWillChange.send()
    }
}
