//
//  UIViewController+init.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import UIKit

extension UIViewController {
    static func loadFromXib(bundle: Bundle? = nil, overriddenXib: String? = nil) -> Self {
        return self.init(nibName: overriddenXib ?? String(describing: self), bundle: bundle)
    }
}
