import UIKit

final class NewsRouter {
    weak var viewController: UIViewController?
    weak var transitionHandler: ViperModuleTransitionHandler?

    func createModule() -> UIViewController? {
        let vc = NewsViewController.loadFromXib()

        transitionHandler = vc

        let presenter = NewsPresenter(view: vc,
                                      router: self)
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

extension NewsRouter: NewsRouterInput {
    func openArticle(article: ArticleViewModel) {
        if let transition = transitionHandler {
            ArticleRouter(article: article).openModule(with: transition, transitionStyle: .push)
        }
    }
}
