//
//  LoginScreenPresenter.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

class LoginScreenPresenter {
    private weak var view: LoginScreenViewInput?
    private let router: LoginScreenRouterInput

    @Injected var authService: AuthServiceProtocol?
    @Injected var progressService: ProgressService?
    @Injected var errorService: ErrorService?

    private var phone: String = ""

    init(view: LoginScreenViewInput, router: LoginScreenRouterInput) {
        self.view = view
        self.router = router
    }

    private var isPhoneValid: Bool {
        return phone.count >= 7 && phone.count <= 15
    }

    private func updateConfirmState() {
        view?.updateConfirmButton(enabled: isPhoneValid)
    }
}

extension LoginScreenPresenter: LoginScreenViewOutput {
    func viewLoaded() {
        view?.setup()
        updateConfirmState()
    }

    func phoneChanged(_ phone: String) {
        self.phone = phone
        updateConfirmState()
    }

    func confirmTapped() {
        guard isPhoneValid else {
            updateConfirmState()
            return
        }

        progressService?.show()
        authService?.login(phone: phone, completion: { [weak self] result in
            self?.progressService?.hide()
            switch result {
            case .success:
                self?.router.openMainScreen()
            case .failure:
                self?.errorService?.show(errorText: "Invalid phone number")
            }
        })
    }
    
    func signUpTapped() {
        router.openSignUpScreen()
    }
}
