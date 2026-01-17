//
//  UIView+Constraints.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import UIKit

extension UIView {
    static let defaultAnimationDuration = 0.3
    static let defaultHudBackgroundColor = UIColor.black.withAlphaComponent(0.85)
    func addSubviewAligned(_ subview: UIView) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subview]|", options: [], metrics: nil, views: ["subview": subview]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subview]|", options: [], metrics: nil, views: ["subview": subview]))
    }

    func addSubviewCentered(_ subview: UIView) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false

        self.addConstraints([NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
    }
}
