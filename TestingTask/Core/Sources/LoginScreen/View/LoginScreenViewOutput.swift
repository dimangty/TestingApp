//
//  LoginScreenViewOutput.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

protocol LoginScreenViewOutput {
    func viewLoaded()
    func phoneChanged(_ phone: String)
    func confirmTapped()
    func signUpTapped()
}
