//
//  ApplicationCoordinator.swift
//  TestingTask
//
//  Created by Дмитрий Быков on 17.01.2026.
//
import UIKit

class ApplicationCoordinator {
    private var window: UIWindow? {
        return UIApplication.shared.appDelegate.window
    }
    
    private func setRootViewController(_ vc: UIViewController) {
        self.window?.rootViewController = vc
    }
    
    func start() {
        setRootViewController(UINavigationController(rootViewController: LoginScreenRouter().createModule() ?? UIViewController()))
    }
    
    func showMain() {
        setRootViewController(UINavigationController(rootViewController: NewsRouter().createModule() ?? UIViewController()))
    }
}


extension UIApplication {

    var appDelegate: AppDelegate {
        return delegate as? AppDelegate ?? AppDelegate()
    }
}
