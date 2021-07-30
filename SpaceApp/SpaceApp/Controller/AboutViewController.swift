//
//  AboutViewController.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import UIKit

final class AboutViewController: BaseViewController {

    /// Кнопка для возврата на главный экран
    private lazy var returnToMainVC: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(returnToMainPage), for: .touchUpInside)
        return button
    }()

    /// Фоновое изображение
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImage(named: "space")
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.center = view.center
        return imageView
    }()

    /// Контактные данные разработчика
    private lazy var contactsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "contacts")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "About developer"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: returnToMainVC)
        setConstraints()
    }

    // MARK: - Methods
    private func setConstraints() {
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(contactsImageView)

        let contactsImageViewConstraints = ([
            contactsImageView.widthAnchor.constraint(equalToConstant: 300),
            contactsImageView.heightAnchor.constraint(equalToConstant: 200),
            contactsImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contactsImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate(contactsImageViewConstraints)
    }

    @objc func returnToMainPage() {
        navigationController?.popViewController(animated: true)
    }
}
