//
//  LoginScreenViewController.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import UIKit

class LoginScreenViewController: UIViewController, ViperModuleTransitionHandler {
    var presenter: LoginScreenViewOutput?

    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var confirmButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewLoaded()
    }

    @IBAction private func confirmTapped(_ sender: Any) {
        presenter?.confirmTapped()
    }

    @IBAction private func signUpTapped(_ sender: Any) {
        presenter?.signUpTapped()
    }

    @objc private func phoneEditingChanged() {
        presenter?.phoneChanged(phoneTextField.text ?? "")
    }
}

extension LoginScreenViewController: LoginScreenViewInput {
    func setup() {
        phoneTextField.keyboardType = .numberPad
        phoneTextField.delegate = self
        phoneTextField.addTarget(self, action: #selector(phoneEditingChanged), for: .editingChanged)

        confirmButton.isEnabled = false
        confirmButton.alpha = 0.5
    }

    func updateConfirmButton(enabled: Bool) {
        confirmButton.isEnabled = enabled
        confirmButton.alpha = enabled ? 1.0 : 0.5
    }
}

extension LoginScreenViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }

        let allowed = CharacterSet.decimalDigits
        if string.rangeOfCharacter(from: allowed.inverted) != nil {
            return false
        }

        let currentText = textField.text ?? ""
        guard let textRange = Range(range, in: currentText) else {
            return false
        }

        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        return updatedText.count <= 15
    }
}
