//
//  StartViewController.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 21.07.2021.
//

import UIKit

final class StartViewController: BaseViewController {

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
		let textField = UITextField(frame:CGRect(x: 0, y: 0, width: 50, height: 30))
		textField.backgroundColor = .lightGray
		textField.placeholder = "Enter your name"
		textField.borderStyle = .roundedRect
		textField.font = UIFont.systemFont(ofSize: 20)
		textField.autocorrectionType = .no
		textField.keyboardType = .default
		textField.returnKeyType = .done
		textField.clearButtonMode = UITextField.ViewMode.whileEditing
		textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
		textField.isSelected = false
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(backgroundImageView)
		setAutoLayout()
	}

	private func setAutoLayout() {
		backgroundImageView.addSubview(textField)
		let textFieldConstraints = ([
			textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),

		])

		NSLayoutConstraint.activate(textFieldConstraints)
	}
}
