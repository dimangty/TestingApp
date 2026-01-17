//
//  UIViewController+Style.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import UIKit
extension UIViewController {
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController && navigationController != nil
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController

        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
}
