//
//  CommonAlertView.swift
//  EvrazAuth
//
//  Created by DBykov on 18/07/2018.
//  Copyright © 2018 MSTeam. All rights reserved.
//

import UIKit

class CommonAlertView: UIView {
    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var imageBackgroundView: UIView?
    @IBOutlet weak var imageView: UIImageView?

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var textLabel: UILabel?

    @IBOutlet weak var cancelView: UIView?
    @IBOutlet weak var cancelLabel: UILabel?

    @IBOutlet weak var actionView: UIView?
    @IBOutlet weak var actionLabel: UILabel?

    @IBOutlet weak var destructiveActionView: UIView?
    @IBOutlet weak var destructiveActionLabel: UILabel?

    private var cancelHandler: (() -> Void)?
    private var actionHandler: (() -> Void)?

    func configure(title: String?,
                   message: String?,
                   attributedMessage: NSAttributedString?,
                   actionTitle: String,
                   cancelTitle: String? = nil,
                   actionType: UIAlertAction.Style = .default,
                   actionHandler: (() -> Void)? = nil,
                   cancelHandler: (() -> Void)? = nil) {

   
        imageBackgroundView?.removeFromSuperview()
        

        if let title = title {
            titleLabel?.text = title
        } else {
            titleLabel?.removeFromSuperview()
        }

        if let message = message {
            textLabel?.text = message
        } else if let attributedMessage = attributedMessage {
            textLabel?.attributedText = attributedMessage
        } else {
            textLabel?.removeFromSuperview()
        }

        if let cancelTitle = cancelTitle {
            cancelLabel?.text = cancelTitle
        } else {
            cancelView?.removeFromSuperview()
        }

        if actionType == .destructive {
            destructiveActionLabel?.text = actionTitle
            actionView?.removeFromSuperview()
        } else {
            actionLabel?.text = actionTitle
            destructiveActionView?.removeFromSuperview()
        }

        stackView.spacing = 0.5

        self.actionHandler = actionHandler
        self.cancelHandler = cancelHandler
    }

    @IBAction private func cancelButtonTapped() {
        cancelHandler?()
    }

    @IBAction private func actionButtonTapped() {
        actionHandler?()
    }
}
