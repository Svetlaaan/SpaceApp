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

	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.showsVerticalScrollIndicator = false
		return scrollView
	}()

	lazy var mainTitle: UILabel = {
		let mainLabel = UILabel()
		mainLabel.translatesAutoresizingMaskIntoConstraints = false
		mainLabel.text = "Space Photo of the Day:"
		mainLabel.font = UIFont.boldSystemFont(ofSize:30)
//		mainLabel.textColor = .white
		return mainLabel
	}()

	lazy var dateLabel: UILabel = {
		let dateLabel = UILabel()
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		dateLabel.text = "\(date)"
		dateLabel.font = UIFont.boldSystemFont(ofSize:30)
//		dateLabel.textColor = .white
		return dateLabel
	}()

	lazy var explanationLabel: UILabel = {
		let explanationLabel = UILabel()
		explanationLabel.translatesAutoresizingMaskIntoConstraints = false
		explanationLabel.text = "\(explanation)"
		explanationLabel.textAlignment = .justified
		explanationLabel.font = UIFont.boldSystemFont(ofSize:16)
//		explanationLabel.textColor = .white
		explanationLabel.numberOfLines = .min
		return explanationLabel
	}()

	init(networkService: NASANetworkServiceProtocol, imageUrl: String, date: String, explanation: String) {
		self.networkService = networkService
		self.imageUrl = imageUrl
		self.date = date
		self.explanation = explanation
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

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .white
		setAutoLayout()
		loadData()
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
			imageView.widthAnchor.constraint(equalToConstant: 300),
			imageView.heightAnchor.constraint(equalToConstant: 300),
			imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			imageView.topAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 50)
		])

		view.addSubview(scrollView)
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
			scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
		])

		scrollView.addSubview(explanationLabel)
		NSLayoutConstraint.activate([
			explanationLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
			explanationLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			explanationLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			explanationLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
		])
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
}
