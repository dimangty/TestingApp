import Foundation

final class FavoritePresenter {
    private weak var view: FavoriteViewInput?
    private let router: FavoriteRouterInput

    @Injected private var storage: StorageService?

    private var articles: [ArticleViewModel] = []

    init(view: FavoriteViewInput, router: FavoriteRouterInput) {
        self.view = view
        self.router = router

        storage?.addObserver(self)
    }

    deinit {
        storage?.removeObserver(self)
    }

    private func reloadFavorites() {
        guard let storage = storage else { return }
        articles = storage.articles.map { ArticleViewModel(article: $0.toArticle(), storage: storage) }
        view?.reloadData()
        view?.showEmptyState(articles.isEmpty)
    }
}

extension FavoritePresenter: FavoriteViewOutput {
    func viewLoaded() {
        view?.setup()
        reloadFavorites()
    }

    func viewWillAppear() {
        reloadFavorites()
        view?.updateSelectedCell()
    }

    func numberOfRows() -> Int {
        return articles.count
    }

    func article(at indexPath: IndexPath) -> ArticleViewModel {
        return articles[indexPath.row]
    }

    func didSelectRow(at indexPath: IndexPath) {
        let article = articles[indexPath.row]
        router.openArticle(article: article)
    }

    func didTapFavorite(at indexPath: IndexPath) {
        let article = articles[indexPath.row]
        article.addOrRemoveFromFavorites()
    }
}

extension FavoritePresenter: NewsAppStorageObserver {
    func didRemoveFromFavorites(title: String) {
        if let removedIndex = articles.firstIndex(where: { $0.title == title }) {
            articles.remove(at: removedIndex)
            view?.reloadData()
            view?.showEmptyState(articles.isEmpty)
        }
    }

    func didAddToFavorites(article: ArticleEntity) {
        reloadFavorites()
    }
}
