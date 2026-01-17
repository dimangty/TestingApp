import UIKit

final class ArticlePresenter {
    private weak var view: ArticleViewInput?
    private let router: ArticleRouterInput
    private let article: ArticleViewModel

    init(view: ArticleViewInput, router: ArticleRouterInput, article: ArticleViewModel) {
        self.view = view
        self.router = router
        self.article = article
    }

    private func updateLikeState() {
        view?.displayLike(isFavorite: article.isFavorite)
    }

    private func loadImage() {
        article.loadImage { [weak self] image in
            self?.view?.displayImage(image)
        }
    }
}

extension ArticlePresenter: ArticleViewOutput {
    func viewLoaded() {
        view?.setup()
        view?.display(title: article.title,
                      date: article.publishedAt,
                      content: article.contents)
        updateLikeState()
        loadImage()
    }

    func viewWillAppear() {
        updateLikeState()
    }

    func heartTapped() {
        article.addOrRemoveFromFavorites()
        updateLikeState()
    }
}
