//
//  IErrorService.swift
//  EvrazAuth
//
//  Created by DBykov on 21.03.2018.
//  Copyright © 2018 MSTeam. All rights reserved.
//

import UIKit

protocol IErrorService {
    func setDelegate(_ delegate: ErrorServiceDelegate)

    func show(errorText: String)

    func show(with title: String?, errorText: String, completion: @escaping (() -> Void))
   
    func show(title: String?,
              message: String,
              actionTitle: String?,
              cancelTitle: String?,
              actionType: UIAlertAction.Style,
              completion: @escaping (() -> Void))

    func show(title: String?,
              message: String,
              actionTitle: String?,
              cancelTitle: String?,
              actionType: UIAlertAction.Style,
              actionHandler: @escaping (() -> Void),
              cancelHandler: @escaping (() -> Void))

    func show(title: String?,
              attributedMessage: NSAttributedString,
              actionTitle: String?,
              cancelTitle: String?,
              actionType: UIAlertAction.Style,
              actionHandler: (() -> Void)?,
              cancelHandler: (() -> Void)?)

}

extension IErrorService {
    func show(with title: String? = nil, errorText: String, completion: @escaping (() -> Void)) {
        self.show(with: title, errorText: errorText, completion: completion)
    }
}
