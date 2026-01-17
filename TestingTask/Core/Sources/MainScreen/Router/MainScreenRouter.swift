//
//  MainScreenRouter.swift
//  TestingTask
//
//  Created by DBykov on 19/07/2022.
//

import UIKit

class MainScreenRouter {
    weak var viewController: UIViewController?
    weak var transitionHandler: ViperModuleTransitionHandler?

    func createModule() -> UIViewController? {
        let vc = MainScreenViewController.loadFromXib()

        transitionHandler = vc

        let presenter = MainScreenPresenter(view: vc, router: self)

        vc.presenter = presenter

        self.viewController = vc

        return self.viewController
    }

    func openModule(with transitionHandler: ViperModuleTransitionHandler, transitionStyle: TransitionStyle) {
        if let vc = createModule() {
            transitionHandler.openModule(vc: vc, style: transitionStyle)
        }
    }
    
}

extension MainScreenRouter: MainScreenRouterInput {
    func openNextScreen() {
        if let transition = transitionHandler {
            MainScreenRouter().openModule(with: transition, transitionStyle: .push)
        }
    }
}
