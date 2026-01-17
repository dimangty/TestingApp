//
//  SignUpScreenPresenter.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

class SignUpScreenPresenter {
    private weak var view: SignUpScreenViewInput?
    private let router: SignUpScreenRouterInput

    @Injected var authService: AuthService?
    @Injected var validationService: ValidationService?
    @Injected var progressService: ProgressService?
    @Injected var errorService: ErrorService?

    private var fields: [SignUpField: String] = [:]

    init(view: SignUpScreenViewInput, router: SignUpScreenRouterInput) {
        self.view = view
        self.router = router
    }

    private func updateCreateState() {
        let isValid = SignUpField.allCases.allSatisfy { field in
            let value = fields[field] ?? ""
            return validationService?.isValid(field: field, value: value) ?? false
        }
        view?.updateCreateButton(enabled: isValid)
    }
}

extension SignUpScreenPresenter: SignUpScreenViewOutput {
    func viewLoaded() {
        view?.setup()
        updateCreateState()
    }

    func fieldChanged(_ field: SignUpField, value: String) {
        fields[field] = value
        updateCreateState()
    }

    func createAccountTapped() {
        let isValid = SignUpField.allCases.allSatisfy { field in
            let value = fields[field] ?? ""
            return validationService?.isValid(field: field, value: value) ?? false
        }

        guard isValid else {
            updateCreateState()
            return
        }

        progressService?.show()
        let payload = SignUpData(fields: fields)
        authService?.signUp(data: payload, completion: { [weak self] result in
            self?.progressService?.hide()
            switch result {
            case .success:
                self?.router.close()
            case .failure:
                self?.errorService?.show(errorText: "Sign up failed")
            }
        })
    }

    func backTapped() {
        router.close()
    }
}
