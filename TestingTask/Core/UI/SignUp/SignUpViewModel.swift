//
//  SignUpViewModel.swift
//  TestingTask
//
//  Migrated to SwiftUI
//

import Foundation
import Combine

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var gender: String = ""
    @Published var birthDate: Date = Date()
    @Published var country: String = ""
    @Published var city: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    @Injected private var authService: AuthServiceProtocol?
    @Injected private var validationService: ValidationServiceProtocol?
    @Injected private var navigationService: NavigationService?

    let genderOptions = ["Male", "Female", "Other"]
    let countryOptions = ["USA", "UK", "Germany", "France"]
    let cityOptions = ["New York", "London", "Berlin", "Paris"]

    var isFormValid: Bool {
        let fields: [SignUpField: String] = [
            .firstName: firstName,
            .lastName: lastName,
            .gender: gender,
            .birthDate: birthDateString,
            .country: country,
            .city: city,
            .email: email,
            .phone: phone
        ]

        return SignUpField.allCases.allSatisfy { field in
            let value = fields[field] ?? ""
            return validationService?.isValid(field: field, value: value) ?? false
        }
    }

    var birthDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: birthDate)
    }

    func createAccount() {
        guard isFormValid else { return }

        isLoading = true
        errorMessage = nil

        let fields: [SignUpField: String] = [
            .firstName: firstName,
            .lastName: lastName,
            .gender: gender,
            .birthDate: birthDateString,
            .country: country,
            .city: city,
            .email: email,
            .phone: phone
        ]

        let payload = SignUpData(fields: fields)

        authService?.signUp(data: payload) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.navigationService?.push(.main)
                case .failure:
                    self?.errorMessage = "Sign up failed"
                }
            }
        }
    }

    func goBack() {
        navigationService?.pop()
    }
}
