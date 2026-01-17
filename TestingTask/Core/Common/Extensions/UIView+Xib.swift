//
//  UIView+Xib.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import UIKit

extension UIView {
    static func loadFromXib() -> UIView? {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: String(describing: self), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView

        return view
    }
}
