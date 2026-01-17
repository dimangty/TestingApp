//
//  SignUpScreenViewInput.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

protocol SignUpScreenViewInput: AnyObject {
    func setup()
    func updateCreateButton(enabled: Bool)
}
