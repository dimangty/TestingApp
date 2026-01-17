import Foundation

final class NewsPresenter {
    private weak var view: NewsViewInput?
    private let router: NewsRouterInput
    
    
    
    @Injected private var newsService: NewsService?
    @Injected private var storage: StorageService?
    @Injected private var errorService: ErrorService?
    
    private var articles: [ArticleViewModel] = []

    init(view: NewsViewInput, router: NewsRouterInput) {
        self.view = view
        self.router = router

        storage?.addObserver(self)
    }

    private func loadArticles() {
        articles.removeAll(keepingCapacity: true)
        view?.showLoading(true)

        newsService?.performNewsRequest { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self, let storage = self.storage else { return }
                self.view?.showLoading(false)

                switch result {
                case .failure(let error):
                    self.errorService?.show(errorText: error.localizedDescription)
                case .success(let newsSource):
                    self.articles = newsSource.articles.map { article in
                        ArticleViewModel(article: article, storage: storage)
                    }
                    self.view?.reloadData()
                }
            }
        }
    }

}

extension NewsPresenter: NewsViewOutput {
    func viewLoaded() {
        view?.setup()
        loadArticles()
    }

    func viewWillAppear() {
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
        view?.updateFavorite(at: indexPath)
    }
}

extension NewsPresenter: NewsAppStorageObserver {
    func didRemoveFromFavorites(title: String) {
        if let removedIndex = articles.firstIndex(where: { $0.title == title }) {
            view?.updateFavorite(at: IndexPath(row: removedIndex, section: 0))
        }
    }

    func didAddToFavorites(article: ArticleEntity) {
    }
}
