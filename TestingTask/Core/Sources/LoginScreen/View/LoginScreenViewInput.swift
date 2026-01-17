//
//  LoginScreenViewInput.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

protocol LoginScreenViewInput: AnyObject {
    func setup()
    func updateConfirmButton(enabled: Bool)
}
