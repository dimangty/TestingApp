//
//  LoginViewModel.swift
//  TestingTask
//
//  Migrated to SwiftUI
//

import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var phone: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    @Injected private var authService: AuthServiceProtocol?
    @Injected private var validationService: ValidationServiceProtocol?
    @Injected private var navigationService: NavigationService?

    var isPhoneValid: Bool {
        validationService?.isValidPhone(phone) ?? false
    }

    func login() {
        guard isPhoneValid else { return }

        isLoading = true
        errorMessage = nil

        authService?.login(phone: phone) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.navigationService?.push(.main)
                case .failure:
                    self?.errorMessage = "Invalid phone number"
                }
            }
        }
    }

    func navigateToSignUp() {
        navigationService?.push(.signUp)
    }
}
