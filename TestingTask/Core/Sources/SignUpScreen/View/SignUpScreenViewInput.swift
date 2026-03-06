//
//  SignUpScreenViewInput.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

// sourcery: AutoMockable
protocol SignUpScreenViewInput: AnyObject {
    func setup()
    func updateCreateButton(enabled: Bool)
}
