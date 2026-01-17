import UIKit

final class ArticleRouter {
    private let article: ArticleViewModel
    weak var viewController: UIViewController?
    weak var transitionHandler: ViperModuleTransitionHandler?

    init(article: ArticleViewModel) {
        self.article = article
    }

    func createModule() -> UIViewController? {
        let vc = ArticleViewController.loadFromXib()

        transitionHandler = vc

        let presenter = ArticlePresenter(view: vc, router: self, article: article)
        vc.presenter = presenter

        viewController = vc

        return viewController
    }

    func openModule(with transitionHandler: ViperModuleTransitionHandler, transitionStyle: TransitionStyle) {
        if let vc = createModule() {
            transitionHandler.openModule(vc: vc, style: transitionStyle)
        }
    }
}

extension ArticleRouter: ArticleRouterInput {
}
