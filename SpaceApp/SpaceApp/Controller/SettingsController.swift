//
//  SettingsController.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 24.07.2021.
//

import UIKit

final class SettingsController: BaseViewController {

    private let userSettings = UserSettingsService()

    /// backgroundView
    private lazy var backgroundView: GradientView = {
        let backgroundView = GradientView()
        backgroundView.startColor = .darkGray
        backgroundView.endColor = .white
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()

    /// TextField для ввода имени пользователя
    private lazy var nameTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        textField.placeholder = "Enter your name"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    /// TextField для ввода email пользователя
    private lazy var emailTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        textField.placeholder = "Enter your email"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    /// UILabel
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name *"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// UILabel
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email *"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// кнопка "О разработчике"
    private lazy var aboutDevButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(aboutDevButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    /// кнопка "Очистить историю"
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

    /// кнопка "Сохранить"
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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: aboutDevButton)
        view.backgroundColor = .white

        setLabelAndBackgroundViewConstraints()
        setTextFieldConstraints()
        setButtonsConstraints()
        setTextLabel()
        setStatusButton()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view,
                                                              action: #selector(UIView.endEditing(_:))))
    }

    // MARK: - Methods
    private func setLabelAndBackgroundViewConstraints() {
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

        NSLayoutConstraint.activate(backgroundViewConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(emailLabelConstraints)
    }

    private func setTextFieldConstraints() {
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

        NSLayoutConstraint.activate(nameTextFieldConstraints)
        NSLayoutConstraint.activate(emailTextFieldConstraints)
    }

    private func setButtonsConstraints() {
        view.addSubview(saveButton)
        let saveButtonConstraints = ([
            saveButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: view.frame.height / 10),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width / 10),
            saveButton.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        view.addSubview(clearButton)
        let clearButtonConstraints = ([
            clearButton.topAnchor.constraint(equalTo: saveButton.topAnchor),
            clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(view.frame.width / 10)),
            clearButton.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
            clearButton.heightAnchor.constraint(equalToConstant: 40)
        ])

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

    @objc func aboutDevButtonTapped() {
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
