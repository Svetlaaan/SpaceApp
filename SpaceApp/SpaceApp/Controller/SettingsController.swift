//
//  SettingsController.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 24.07.2021.
//

import UIKit

final class SettingsController: BaseViewController {

    private let userSettings = UserSettingsService()

    private lazy var backgroundView: GradientView = {
        let backgroundView = GradientView()
        backgroundView.startColor = .darkGray
        backgroundView.endColor = .white
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        textField.placeholder = "Enter your name"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        textField.placeholder = "Enter your email"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name *"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email *"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// кнопка "О приложении"
    private lazy var aboutAppButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(aboutAppButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Clear", for: .normal)
        button.tintColor = .darkGray
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Save", for: .normal)
        button.tintColor = .darkGray
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: aboutAppButton)
        view.backgroundColor = .white
        setAutoLayout()
        setTextLabel()
        setStatusButton()
    }

    private func setAutoLayout() {
        view.addSubview(backgroundView)
        let backgroundViewConstraints = ([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.addSubview(nameLabel)
        let nameLabelConstraints = ([
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 4),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])

        view.addSubview(emailLabel)
        let emailLabelConstraints = ([
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: view.frame.height / 10),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])

        view.addSubview(nameTextField)
        let nameTextFieldConstraints = ([
            nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 30),
            nameTextField.widthAnchor.constraint(equalToConstant: view.frame.width / 2)
        ])

        view.addSubview(emailTextField)
        let emailTextFieldConstraints = ([
            emailTextField.topAnchor.constraint(equalTo: emailLabel.topAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            emailTextField.widthAnchor.constraint(equalToConstant: view.frame.width / 2)
        ])

        view.addSubview(saveButton)
        let saveButtonConstraints = ([
            saveButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: view.frame.height / 10),
            saveButton.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: view.frame.width / 4),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        view.addSubview(clearButton)
        let clearButtonConstraints = ([
            clearButton.topAnchor.constraint(equalTo: saveButton.topAnchor),
            clearButton.leadingAnchor.constraint(equalTo: saveButton.trailingAnchor, constant: 30),
            clearButton.widthAnchor.constraint(equalToConstant: view.frame.width / 4),
            clearButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate(backgroundViewConstraints)
        NSLayoutConstraint.activate(nameTextFieldConstraints)
        NSLayoutConstraint.activate(emailTextFieldConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(emailLabelConstraints)
        NSLayoutConstraint.activate(saveButtonConstraints)
        NSLayoutConstraint.activate(clearButtonConstraints)
    }

    private func setTextLabel() {
        guard let userName: String = userSettings.object(for: "userName") else { return }
        nameTextField.text = userName
        guard let userEmail: String = userSettings.object(for: "userEmail") else { return }
        emailTextField.text = userEmail
    }

    private func setStatusButton() {
        guard let nameText = nameTextField.text else { return }
        guard let emailText = emailTextField.text else { return }

        if !nameText.isEmpty ||
           !emailText.isEmpty {
            saveButton.isEnabled = false
            clearButton.isEnabled = true
        } else if nameText.isEmpty,
                  emailText.isEmpty {
            saveButton.isEnabled = false
            clearButton.isEnabled = false
        }
    }

    @objc func aboutAppButtonTapped() {
        let aboutController = AboutViewController()
        navigationController?.pushViewController(aboutController, animated: true)
    }

    @objc func saveButtonTapped() {
        let userName = nameTextField.text?.trimmingCharacters(in: .whitespaces)
        let userEmail = emailTextField.text?.trimmingCharacters(in: .whitespaces)
        let nameUserInDefaults: String? = userSettings.object(for: "userName")
        let emailUserInDefaults: String? = userSettings.object(for: "userEmail")

        if userName != nameUserInDefaults ||
            userEmail != emailUserInDefaults {
            if let userName = userName,
               !userName.isEmpty,
               userName != nameUserInDefaults {
                userSettings.save(object: userName, for: "userName")
            }
            if let userEmail = userEmail,
               !userEmail.isEmpty,
               userEmail != emailUserInDefaults {
                userSettings.save(object: userEmail, for: "userEmail")
            }
            for view in self.view.subviews {
                if let textField = view as? UITextField {
                    textField.isEnabled = false
                }
            }
            saveButton.isEnabled = false
            let alert = UIAlertController(title: nil,
                                          message: "Data saved",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }

    }

    @objc func clearButtonTapped() {
        let nameUserInDefaults: String? = userSettings.object(for: "userName")
        let emailUserInDefaults: String? = userSettings.object(for: "userEmail")

        if nameUserInDefaults != nil {
            userSettings.removeObjectForKey(for: "userName")
        }
        if emailUserInDefaults != nil {
            userSettings.removeObjectForKey(for: "userEmail")
        }
        for view in self.view.subviews {
            if let textField = view as? UITextField {
                textField.text = ""
                textField.isEnabled = true
            }
        }

        let alert = UIAlertController(title: nil,
                                      message: "Data cleared",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension SettingsController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        guard let firstText = textField.text else { return false }
        let editedText = (firstText as NSString).replacingCharacters(in: range, with: string)
        let trimmingEditedString = editedText.trimmingCharacters(in: .whitespaces)
        let secondTextField = (textField == nameTextField ? emailTextField : nameTextField)
        guard let secondText = secondTextField.text else { return false }
        let trimmingSecondText = secondText.trimmingCharacters(in: .whitespaces)

        if !editedText.isEmpty, !trimmingEditedString.isEmpty,
           !secondText.isEmpty, !trimmingSecondText.isEmpty {
            saveButton.isEnabled = true
            clearButton.isEnabled = true
        } else if editedText.isEmpty || trimmingEditedString.isEmpty ||
                  secondText.isEmpty || trimmingSecondText.isEmpty {
            saveButton.isEnabled = false
            if !secondText.isEmpty || !trimmingSecondText.isEmpty {
                clearButton.isEnabled = true
            }
        } else {
            saveButton.isEnabled = false
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let firstText = textField.text else { return }
        let trimmingFirstString = firstText.trimmingCharacters(in: .whitespaces)
        let secondTextField = (textField == nameTextField ? emailTextField : nameTextField)
        guard let secondText = secondTextField.text else { return }
        let trimmingSecondText = secondText.trimmingCharacters(in: .whitespaces)

        if trimmingSecondText.isEmpty ||
           trimmingFirstString.isEmpty {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }

        if !trimmingFirstString.isEmpty ||
           !trimmingSecondText.isEmpty {
            clearButton.isEnabled = true
        } else {
            clearButton.isEnabled = false
        }
    }
}
