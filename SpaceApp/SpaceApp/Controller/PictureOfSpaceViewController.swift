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
    private let networkService: NASANetworkServiceProtocol
    private let imageUrl: String
    private let photoTitle: String

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    // MARK: - Buttons

//     кнопка для возврата на главный экран
    private lazy var returnToMainVC: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(returnToMainVCButtonPressed), for: .touchUpInside)
        return button
    }()

    // кнопка для добавления в избранное
//    lazy private var favoriteButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
//        button.tintColor = .black
//        button.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
//        return button
//    }()

    // кнопка поделиться
    lazy private var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        return button
    }()

    // MARK: - Labels

    lazy var mainTitle: UILabel = {
        let mainLabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.text = "\(photoTitle)"
        mainLabel.font = UIFont.boldSystemFont(ofSize: 16)
        //		mainLabel.textColor = .white
        return mainLabel
    }()

    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = "\(date)"
        dateLabel.font = UIFont.boldSystemFont(ofSize: 20)
        //		dateLabel.textColor = .white
        return dateLabel
    }()

    lazy var explanationLabel: UILabel = {
        let explanationLabel = UILabel()
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.text = "\(explanation)"
        explanationLabel.textAlignment = .justified
        explanationLabel.font = UIFont.boldSystemFont(ofSize: 16)
        //		explanationLabel.textColor = .white
        explanationLabel.numberOfLines = .min
        return explanationLabel
    }()

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

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
//        overrideUserInterfaceStyle = .dark
        setNavigationBarButtonItems()
        setAutoLayout()
        loadData()
    }

    deinit {
        NSLog("ImageViewController deinit")
    }

    private func setAutoLayout() {

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

    private func setNavigationBarButtonItems() {
        let returnTo = UIBarButtonItem(customView: returnToMainVC)
//        let addToFavorite = UIBarButtonItem(customView: favoriteButton)
        let share = UIBarButtonItem(customView: shareButton)

        navigationItem.setLeftBarButton(returnTo, animated: true)
        navigationItem.setRightBarButton(share, animated: true)
    }

    // Нужна оптимизация загрузки изображения
    private func loadData() {
        self.isLoading = true
        networkService.loadImage(imageUrl: imageUrl) { data in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.isLoading = false
                }
            }
        }
    }

    @objc func returnToMainVCButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

//    @objc func favoriteButtonPressed() {
//        NSLog("favorite button tapped")
//        favoriteButton.tintColor = .orange
//    }

    @objc func shareButtonPressed() {
        let shareController = UIActivityViewController(activityItems: [imageView.image as Any ],
                                                       applicationActivities: nil)

//        shareController.excludedActivityTypes = [.postToTwitter, .postToVimeo, .saveToCameraRoll]
        shareController.popoverPresentationController?.sourceView = self.view
        // Обработка выполнения остальных Activity Types
        shareController.completionWithItemsHandler = { activity, completed, items, error in
            NSLog("Activity: \(String(describing: activity)) Success: \(completed) Items: \(String(describing: items)) Error: \(String(describing: error))")
        }
        self.present(shareController, animated: true, completion: nil)
    }
}
