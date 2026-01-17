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
        let tabBarController = UITabBarController()

        let newsViewController = NewsRouter().createModule() ?? UIViewController()
        newsViewController.title = "News"
        let newsNavigationController = UINavigationController(rootViewController: newsViewController)
        newsNavigationController.tabBarItem = UITabBarItem(title: "News",
                                                           image: UIImage(systemName: "newspaper"),
                                                           selectedImage: UIImage(systemName: "newspaper.fill"))

        let favoritesViewController = FavoriteRouter().createModule() ?? UIViewController()
        favoritesViewController.title = "Favorites"
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
        favoritesNavigationController.tabBarItem = UITabBarItem(title: "Favorites",
                                                                image: UIImage(systemName: "heart"),
                                                                selectedImage: UIImage(systemName: "heart.fill"))

        tabBarController.viewControllers = [newsNavigationController, favoritesNavigationController]
        setRootViewController(tabBarController)
    }
}


extension UIApplication {

    var appDelegate: AppDelegate {
        return delegate as? AppDelegate ?? AppDelegate()
    }
}
