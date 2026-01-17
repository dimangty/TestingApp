//
//  UIAlertController+Styles.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import UIKit
extension UIAlertController {
    open override func viewDidLayoutSubviews() {
        setStyle()
    }

    func setStyle() {
        if let title = title {
            let font = UIFont.systemFont(ofSize: 15, weight: .medium)
            let attributedTitle = NSAttributedString(string: title,
                                                     attributes: [NSAttributedString.Key.font: font,
                                                                  NSAttributedString.Key.foregroundColor: UIColor.black])
            self.setValue(attributedTitle, forKey: "attributedTitle")
        }

        if let message = message {
            let attributedMessage = NSAttributedString(string: message, attributes: [.foregroundColor: UIColor.black])
            self.setValue(attributedMessage, forKey: "attributedMessage")
        }

        self.view.tintColor = UIColor(red: 86.0/255.0, green: 92.0/255.0, blue: 109.0/255.0, alpha: 1)
    }



    convenience init(customView: UIView) {
        self.init(title: "", message: nil, preferredStyle: .alert)

        let padding: CGFloat = 25
        view.addConstraint(NSLayoutConstraint(item: view,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: UIScreen.main.bounds.width - 2 * padding))

        setStyle()
        for subview in view.subviews {
            subview.alpha = 0
        }
        view.addSubviewAligned(customView)
    }
}
