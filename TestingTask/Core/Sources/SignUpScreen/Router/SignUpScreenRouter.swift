//
//  SignUpScreenRouter.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import UIKit

class SignUpScreenRouter {
    weak var viewController: UIViewController?

    func createModule() -> UIViewController? {
        let vc = SignUpScreenViewController.loadFromXib()
        let presenter = SignUpScreenPresenter(view: vc, router: self)
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

extension SignUpScreenRouter: SignUpScreenRouterInput {
    func close() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
