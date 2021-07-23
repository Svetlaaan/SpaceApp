//
//  StartViewController.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 21.07.2021.
//

import UIKit

final class StartViewController: BaseViewController {

    let service = NASANetworkService()

    // MARK: - BUTTONS

    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Send", for: .normal)
        button.tintColor = .darkGray
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Skip", for: .normal)
        button.tintColor = .darkGray
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var backgroundImageView: UIImageView = {
        let image = UIImage(named: "space")
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.center = view.center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        textField.center = view.center
        textField.placeholder = "Enter your name"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.delegate = self
        return textField
    }()

    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAutoLayout()
        starsAnimation()
    }

    private func setAutoLayout() {

        view.addSubview(backgroundImageView)
        let backgroundImageViewConstraints = ([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.addSubview(textField)
        let textFieldConstraints = ([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        view.addSubview(sendButton)
        let saveButtonConstraints = ([
            sendButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            sendButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
            sendButton.widthAnchor.constraint(equalToConstant: 130),
            sendButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        view.addSubview(skipButton)
        let skipButtonConstraints = ([
            skipButton.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            skipButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
            skipButton.widthAnchor.constraint(equalToConstant: 130),
            skipButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate(textFieldConstraints)
        NSLayoutConstraint.activate(backgroundImageViewConstraints)
        NSLayoutConstraint.activate(saveButtonConstraints)
        NSLayoutConstraint.activate(skipButtonConstraints)
    }

    private func starsAnimation() {

    }

    @objc func sendButtonTapped() {
        let userName = textField.text?.trimmingCharacters(in: .whitespaces)
        if let userName = userName, userName.count > 0 {
            UserSettings.userName = userName
        }
        let viewController = MainViewController(networkService: service)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc func skipButtonTapped() {
        let viewController = MainViewController(networkService: service)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension StartViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text else { return false }
        let editedText = (text as NSString).replacingCharacters(in: range, with: string)
        let trimmingEditedString = editedText.trimmingCharacters(in: .whitespaces)

        if !editedText.isEmpty, trimmingEditedString.count > 0  {
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
        return true
    }
}
