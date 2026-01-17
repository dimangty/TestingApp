//
//  SignUpScreenViewController.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import UIKit

class SignUpScreenViewController: UIViewController {
    var presenter: SignUpScreenViewOutput?

    @IBOutlet private weak var firstNameField: UITextField!
    @IBOutlet private weak var lastNameField: UITextField!
    @IBOutlet private weak var genderField: UITextField!
    @IBOutlet private weak var birthDateField: UITextField!
    @IBOutlet private weak var countryField: UITextField!
    @IBOutlet private weak var cityField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var phoneField: UITextField!
    @IBOutlet private weak var createAccountButton: UIButton!

    private let genderOptions = ["Male", "Female", "Other"]
    private let countryOptions = ["USA", "UK", "Germany", "France"]
    private let cityOptions = ["New York", "London", "Berlin", "Paris"]
    private let birthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewLoaded()
    }

    @IBAction private func createAccountTapped(_ sender: Any) {
        presenter?.createAccountTapped()
    }

    @IBAction private func backTapped(_ sender: Any) {
        presenter?.backTapped()
    }

    @objc private func fieldEditingChanged(_ sender: UITextField) {
        guard let field = SignUpField(rawValue: sender.tag) else {
            return
        }
        presenter?.fieldChanged(field, value: sender.text ?? "")
    }

    private func setField(_ field: SignUpField, textField: UITextField, value: String) {
        textField.text = value
        presenter?.fieldChanged(field, value: value)
    }

    private func presentOptions(title: String,
                                options: [String],
                                field: SignUpField,
                                textField: UITextField) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        for option in options {
            alert.addAction(UIAlertAction(title: option, style: .default, handler: { [weak self] _ in
                self?.setField(field, textField: textField, value: option)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popover = alert.popoverPresentationController {
            popover.sourceView = textField
            popover.sourceRect = textField.bounds
        }
        present(alert, animated: true, completion: nil)
    }

    private func presentBirthDatePicker(textField: UITextField) {
        let alert = UIAlertController(title: "Select date", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.frame = CGRect(x: 0, y: 20, width: alert.view.bounds.width - 20, height: 160)
        alert.view.addSubview(datePicker)

        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
            let value = self?.birthDateFormatter.string(from: datePicker.date) ?? ""
            self?.setField(.birthDate, textField: textField, value: value)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popover = alert.popoverPresentationController {
            popover.sourceView = textField
            popover.sourceRect = textField.bounds
        }
        present(alert, animated: true, completion: nil)
    }
}

extension SignUpScreenViewController: SignUpScreenViewInput {
    func setup() {
        let fields: [SignUpField: UITextField] = [
            .firstName: firstNameField,
            .lastName: lastNameField,
            .gender: genderField,
            .birthDate: birthDateField,
            .country: countryField,
            .city: cityField,
            .email: emailField,
            .phone: phoneField
        ]

        for (field, textField) in fields {
            textField.tag = field.rawValue
            textField.addTarget(self, action: #selector(fieldEditingChanged), for: .editingChanged)
        }

        emailField.keyboardType = .emailAddress
        phoneField.keyboardType = .numberPad
        phoneField.delegate = self
        genderField.delegate = self
        birthDateField.delegate = self
        countryField.delegate = self
        cityField.delegate = self

        createAccountButton.isEnabled = false
        createAccountButton.alpha = 0.5
    }

    func updateCreateButton(enabled: Bool) {
        createAccountButton.isEnabled = enabled
        createAccountButton.alpha = enabled ? 1.0 : 0.5
    }
}

extension SignUpScreenViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == genderField {
            presentOptions(title: "Gender", options: genderOptions, field: .gender, textField: textField)
            return false
        }
        if textField == birthDateField {
            presentBirthDatePicker(textField: textField)
            return false
        }
        if textField == countryField {
            presentOptions(title: "Country", options: countryOptions, field: .country, textField: textField)
            return false
        }
        if textField == cityField {
            presentOptions(title: "City", options: cityOptions, field: .city, textField: textField)
            return false
        }
        return true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField != phoneField {
            return true
        }

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
