//
//  ErrorService.swift
//  EvrazAuth
//
//  Created by Created by DBykov on 25.04.2021.
//  Copyright © 2018 MSTeam. All rights reserved.
//

import UIKit

class ErrorService: IErrorService {
    private weak var delegate: ErrorServiceDelegate?

    func setDelegate(_ delegate: ErrorServiceDelegate) {
        self.delegate = delegate
    }

    func show(errorText: String) {
        show(message: errorText)
    }

    func show(with title: String?, errorText: String, completion: @escaping (() -> Void)) {
        show(with: title, message: errorText, actionHandler: completion)
    }
    

    func show(title: String?,
              message: String,
              actionTitle: String?,
              cancelTitle: String?,
              actionType: UIAlertAction.Style,
            completion: @escaping (() -> Void)) {

        show(with: title,
             message: message,
             actionTitle: actionTitle,
             cancelTitle: cancelTitle,
             actionType: actionType,
             actionHandler: completion)
    }

    func show(title: String?,
              message: String,
              actionTitle: String?,
              cancelTitle: String?,
              actionType: UIAlertAction.Style,
              actionHandler: @escaping (() -> Void),
              cancelHandler: @escaping (() -> Void)) {

        show(with: title,
             message: message,
             actionTitle: actionTitle,
             cancelTitle: cancelTitle,
             actionType: actionType,
             actionHandler: actionHandler,
             cancelHandler: cancelHandler)
    }

    func show(title: String?,
              attributedMessage: NSAttributedString,
              actionTitle: String?,
              cancelTitle: String?,
              actionType: UIAlertAction.Style,
              actionHandler: (() -> Void)?,
              cancelHandler: (() -> Void)?) {

        show(with: title,
             message: nil,
             attributedMessage: attributedMessage,
             actionTitle: actionTitle,
             cancelTitle: cancelTitle,
             actionType: actionType,
             actionHandler: actionHandler,
             cancelHandler: cancelHandler)
    }

}

extension ErrorService {
    private func show(with title: String? = nil,
                      message: String?,
                      attributedMessage: NSAttributedString? = nil,
                      actionTitle: String? = nil,
                      cancelTitle: String? = nil,
                      actionType: UIAlertAction.Style = .default,
                      actionHandler: (() -> Void)? = nil,
                      cancelHandler: (() -> Void)? = nil) {

        assert(Thread.isMainThread, "Working with UI from background")

        if let view = CommonAlertView.loadFromXib() as? CommonAlertView {
            let alert = UIAlertController(customView: view)
            let actionTitle = actionTitle ?? "OK"
            view.configure(title: title,
                           message: message,
                           attributedMessage: attributedMessage,
                           actionTitle: actionTitle,
                           cancelTitle: cancelTitle,
                           actionType: actionType,
                           actionHandler: { [weak alert] in
                                alert?.dismiss(animated: true)
                                actionHandler?()
            },
                           cancelHandler: { [weak alert] in
                                alert?.dismiss(animated: true)
                                cancelHandler?()
            })

            var topController = UIApplication.shared.keyWindow?.rootViewController
            while topController?.presentedViewController != nil && (topController?.presentedViewController as? UIAlertController) == nil {
                topController = topController?.presentedViewController
            }
            topController?.present(alert, animated: true)
        }
    }
}
