//
//  ProgressHudView.swift
//  Westwing
//
//  Created by dbykov on 02.12.2020.
//  Copyright © 2020 Westwing Group GmbH. All rights reserved.
//

import UIKit

enum ProgressStyle {
    case standard
    case uploading

    var localizedTitle: String {
        switch self {
        case .standard:
            return "Loading"
        case .uploading:
            return "Uploading"
        }
    }
}

class ProgressHudView: UIView {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var activityView: UIView!

    class func createView(style: ProgressStyle = .standard) -> ProgressHudView {
        let view = ProgressHudView.loadFromXib() as? ProgressHudView ?? ProgressHudView()
        view.setStyle(style: style)
        return view
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.text = ""
        activityView.layer.cornerRadius = 8
        activityView.backgroundColor = UIColor.white
    }

    func setStyle(style: ProgressStyle) {
        titleLabel.text = style.localizedTitle
    }
}
