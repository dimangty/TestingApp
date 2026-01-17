//
//  LoginScreenRouter.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import UIKit

class LoginScreenRouter {
    weak var viewController: UIViewController?
    weak var transitionHandler: ViperModuleTransitionHandler?
    
    @Injected private var coordinator: ApplicationCoordinator?
    
    func createModule() -> UIViewController? {
        let vc = LoginScreenViewController.loadFromXib()
        transitionHandler = vc
        
        let presenter = LoginScreenPresenter(view: vc, router: self)
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

extension LoginScreenRouter: LoginScreenRouterInput {
    func openMainScreen() {
        coordinator?.showMain()
    }

    func openSignUpScreen() {
        if let transition = transitionHandler {
            SignUpScreenRouter().openModule(with: transition, transitionStyle: .push)
        }
    }
}
