//
//  LoginFeature.swift
//  TestingTask
//
//  TCA Feature for Login
//

import ComposableArchitecture
import Foundation

@Reducer
struct LoginFeature {
    @ObservableState
    struct State: Equatable {
        var phone: String = ""
        var isLoading: Bool = false
        var errorMessage: String?

        var isPhoneValid: Bool {
            // Simple phone validation - can be enhanced
            phone.count >= 10 && phone.allSatisfy { $0.isNumber || $0 == "+" || $0 == "-" || $0 == " " || $0 == "(" || $0 == ")" }
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case loginButtonTapped
        case signUpButtonTapped
        case loginResponse(Result<Void, Error>)
    }

    @Dependency(\.authService) var authService
    @Dependency(\.validationService) var validationService

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .loginButtonTapped:
                guard state.isPhoneValid else { return .none }

                state.isLoading = true
                state.errorMessage = nil
                let phone = state.phone

                return .run { send in
                    let result = await authService.login(phone)
                    await send(.loginResponse(result))
                }

            case .signUpButtonTapped:
                return .none

            case .loginResponse(.success):
                state.isLoading = false
                return .none

            case .loginResponse(.failure(let error)):
                state.isLoading = false
                state.errorMessage = "Invalid phone number"
                return .none
            }
        }
    }
}
