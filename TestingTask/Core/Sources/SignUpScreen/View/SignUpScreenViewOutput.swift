//
//  SignUpScreenViewOutput.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

protocol SignUpScreenViewOutput {
    func viewLoaded()
    func fieldChanged(_ field: SignUpField, value: String)
    func createAccountTapped()
    func backTapped()
}
