//
//  SignUpScreenRouter.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import UIKit

class SignUpScreenRouter {
    weak var viewController: UIViewController?
    weak var transitionHandler: ViperModuleTransitionHandler?
    @Injected private var coordinator: ApplicationCoordinator?
    
    func createModule() -> UIViewController? {
        let vc = SignUpScreenViewController.loadFromXib()
        transitionHandler = vc
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
    func openMainScreen() {
        coordinator?.showMain()
    }
    
    func close() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
