import UIKit

final class FavoriteRouter {
    weak var viewController: UIViewController?
    weak var transitionHandler: ViperModuleTransitionHandler?

    func createModule() -> UIViewController? {
        let vc = FavoriteViewController()

        transitionHandler = vc

        let presenter = FavoritePresenter(view: vc,
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

extension FavoriteRouter: FavoriteRouterInput {
    func openArticle(article: ArticleViewModel) {
        if let transition = transitionHandler {
            ArticleRouter(article: article).openModule(with: transition, transitionStyle: .push)
        }
    }
}
