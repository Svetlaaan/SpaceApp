//
//  PictureOfSpaceViewController.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import UIKit

final class PictureOfSpaceViewController: BaseViewController {

    private let date: String
    private let explanation: String
    private let imageUrl: String
    private let photoTitle: String
    private let networkService: NASANetworkServiceProtocol

    /// UIScrollView для текста описания изображения
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    /// Изображение
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Buttons

    /// Кнопка для возврата на главный экран
    private lazy var returnToMainVC: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(returnToMainVCButtonPressed), for: .touchUpInside)
        return button
    }()

    /// Кнопка "поделиться"
    lazy private var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        return button
    }()

    // MARK: - Labels

    /// Название изображения
    lazy var mainTitle: UILabel = {
        let mainLabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.text = "\(photoTitle)"
        mainLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return mainLabel
    }()

    /// Дата фотографии
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = "\(date)"
        dateLabel.font = UIFont.boldSystemFont(ofSize: 20)
        return dateLabel
    }()

    /// Описание изображения
    lazy var explanationLabel: UILabel = {
        let explanationLabel = UILabel()
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.text = "\(explanation)"
        explanationLabel.textAlignment = .justified
        explanationLabel.font = UIFont.boldSystemFont(ofSize: 16)
        explanationLabel.numberOfLines = .min
        return explanationLabel
    }()

    // MARK: - Init
    init(networkService: NASANetworkServiceProtocol,
         imageUrl: String,
         date: String,
         explanation: String,
         photoTitle: String) {
        self.networkService = networkService
        self.imageUrl = imageUrl
        self.date = date
        self.explanation = explanation
        self.photoTitle = photoTitle
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setNavigationBarButtonItems()
        setConstraints()
        loadData()
    }

    deinit {
        NSLog("ImageViewController deinit")
    }

    private func setConstraints() {

        view.addSubview(mainTitle)
        NSLayoutConstraint.activate([
            mainTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])

        view.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: mainTitle.topAnchor, constant: 50)
        ])

        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 50)
        ])

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])

        scrollView.addSubview(explanationLabel)
        NSLayoutConstraint.activate([
            explanationLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            explanationLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            explanationLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            explanationLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    /// Настройка кнопок  для Navigation Controller
    private func setNavigationBarButtonItems() {
        let returnTo = UIBarButtonItem(customView: returnToMainVC)
        let share = UIBarButtonItem(customView: shareButton)

        navigationItem.setLeftBarButton(returnTo, animated: true)
        navigationItem.setRightBarButton(share, animated: true)
    }

    /// Загрузка изображения
    private func loadData() {
        self.isLoading = true
        networkService.loadImage(imageUrl: imageUrl) { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let data):
                    if let data = data {
                        self.imageView.image = UIImage(data: data)
                    }
                case .failure(let error):
                    self.showAlert(for: error)
                }
                self.isLoading = false
            }
        }
    }

    private func showAlert(for error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.loadData()
        } /////////////////

        alert.addAction(okAction)
        present(alert, animated: true)
    }

    @objc func returnToMainVCButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc func shareButtonPressed() {
        let shareController = UIActivityViewController(activityItems: [imageView.image as Any ],
                                                       applicationActivities: nil)

        shareController.popoverPresentationController?.sourceView = self.view
        shareController.completionWithItemsHandler = { activity, completed, items, error in
            NSLog("Activity: \(String(describing: activity)) Success: \(completed) Items: \(String(describing: items)) Error: \(String(describing: error))")
        }
        self.present(shareController, animated: true, completion: nil)
    }
}
