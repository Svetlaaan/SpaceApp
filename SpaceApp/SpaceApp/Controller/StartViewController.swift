//
//  StartViewController.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 21.07.2021.
//

import UIKit

final class StartViewController: BaseViewController {

    let service = NASANetworkService()
    private var dataSource = [SpacePhotoDataResponse]()
    private let mainQueue = DispatchQueue.main

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    lazy private var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        return button
    }()

    lazy var mainTitle: UILabel = {
        let mainLabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.text = "photoTitle"
        mainLabel.font = UIFont.boldSystemFont(ofSize: 16)
        //        mainLabel.textColor = .white
        return mainLabel
    }()

    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = "date)"
        dateLabel.font = UIFont.boldSystemFont(ofSize: 20)
        //        dateLabel.textColor = .white
        return dateLabel
    }()

    lazy var explanationLabel: UILabel = {
        let explanationLabel = UILabel()
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.text = "(explanation)"
        explanationLabel.textAlignment = .justified
        explanationLabel.font = UIFont.boldSystemFont(ofSize: 16)
        //        explanationLabel.textColor = .white
        explanationLabel.numberOfLines = .min
        return explanationLabel
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
//        overrideUserInterfaceStyle = .dark
        setNavigationBarButtonItems()
        setAutoLayout()
//        loadData()
    }

    deinit {
        print("ImageViewController deinit")
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
//        let returnTo = UIBarButtonItem(customView: returnToMainVC)
//        let addToFavorite = UIBarButtonItem(customView: favoriteButton)
        let share = UIBarButtonItem(customView: shareButton)

//        navigationItem.setLeftBarButton(returnTo, animated: true)
        navigationItem.setRightBarButton(share, animated: true)
    }

    @objc func shareButtonPressed() {
        let shareController = UIActivityViewController(activityItems: [imageView.image as Any ],
                                                       applicationActivities: nil)

//        shareController.excludedActivityTypes = [.postToTwitter, .postToVimeo, .saveToCameraRoll]
        shareController.popoverPresentationController?.sourceView = self.view
        // Обработка выполнения остальных Activity Types
        shareController.completionWithItemsHandler = { activity, completed, items, error in
            print("Activity: \(String(describing: activity)) Success: \(completed) Items: \(String(describing: items)) Error: \(String(describing: error))")
        }
        self.present(shareController, animated: true, completion: nil)
    }

//    private func loadData() {
//        isLoading = true
//        self.service.getDataFromAPI(count: "0", with: { self.process($0) })
//    }

//    private func loadData() {
//        self.isLoading = true
//        service.loadImage(imageUrl: imageUrl) { data in
//            if let data = data, let image = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    self.imageView.image = image
//                    self.isLoading = false
//                }
//            }
//        }
//    }

    private func process(_ response: GetNASAAPIResponse) {
        mainQueue.async {
            switch response {
            case .success(let data):
                self.dataSource.append(contentsOf: data)
//                self.tableView.reloadData()
            case .failure(let error):
                self.showAlert(for: error)
            }
            self.isLoading = false
        }
    }

    private func showAlert(for error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//        let alert = UIAlertController(title: "ОШИБКА",
//                                      message: message(for: error),
//                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

}
