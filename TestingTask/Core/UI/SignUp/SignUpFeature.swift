//
//  SignUpFeature.swift
//  TestingTask
//
//  TCA Feature for SignUp
//

import ComposableArchitecture
import Foundation

@Reducer
struct SignUpFeature {
    @ObservableState
    struct State: Equatable {
        var firstName: String = ""
        var lastName: String = ""
        var gender: String = ""
        var birthDate: Date = Date()
        var country: String = ""
        var city: String = ""
        var email: String = ""
        var phone: String = ""
        var isLoading: Bool = false
        var errorMessage: String?

        let genderOptions = ["Male", "Female", "Other"]
        let countryOptions = ["USA", "UK", "Germany", "France"]
        let cityOptions = ["New York", "London", "Berlin", "Paris"]

        var isFormValid: Bool {
            // Check all fields are valid
            return !firstName.isEmpty && firstName.count >= 2
                && !lastName.isEmpty && lastName.count >= 2
                && !gender.isEmpty
                && !country.isEmpty
                && !city.isEmpty
                && !email.isEmpty
                && !phone.isEmpty
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case createAccountTapped
        case backButtonTapped
        case signUpResponse(Result<Void, Error>)
    }

    @Dependency(\.authService) var authService
    @Dependency(\.validationService) var validationService

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .createAccountTapped:
                guard state.isFormValid else { return .none }

                state.isLoading = true
                state.errorMessage = nil

                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                let birthDateString = formatter.string(from: state.birthDate)

                let fields: [SignUpField: String] = [
                    .firstName: state.firstName,
                    .lastName: state.lastName,
                    .gender: state.gender,
                    .birthDate: birthDateString,
                    .country: state.country,
                    .city: state.city,
                    .email: state.email,
                    .phone: state.phone
                ]

                let payload = SignUpData(fields: fields)

                return .run { send in
                    let result = await authService.signUp(payload)
                    await send(.signUpResponse(result))
                }

            case .backButtonTapped:
                return .none

            case .signUpResponse(.success):
                state.isLoading = false
                return .none

            case .signUpResponse(.failure):
                state.isLoading = false
                state.errorMessage = "Sign up failed"
                return .none
            }
        }
    }
}
