//
//  LoginScreenViewInput.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

// sourcery: AutoMockable
protocol LoginScreenViewInput: AnyObject {
    func setup()
    func updateConfirmButton(enabled: Bool)
}
