//
//  ViewController.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import UIKit

class ViewController: BaseViewController {

	private let networkService: NASANetworkServiceProtocol
	private var dataSource = [GetDayDataResponse]()

	init(networkService: NASANetworkServiceProtocol) {
		self.networkService = networkService
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	/// кнопка "О приложении"
	private lazy var aboutAppButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
		button.tintColor = .black
		button.addTarget(self, action: #selector(aboutAppButtonTapped), for: .touchUpInside)
		return button
	}()

	/// кнопка "История просмотра"
	private lazy var historyButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(systemName: "clock.fill"), for: .normal)
		button.tintColor = .black
		button.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
		return button
	}()

	private lazy var mainLabel: UILabel = {
		let label = UILabel()
		label.text = "Click on title to see a random photo from space"
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 3
		label.textAlignment = .center
		label.font = .boldSystemFont(ofSize: 34)
		return label
	}()

	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(DateCell.self, forCellReuseIdentifier: DateCell.identifier)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.showsVerticalScrollIndicator = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white

		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: aboutAppButton)
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: historyButton)
		title = "NASA Pic Of Random Day"
		setAutoLayout()
		loadData()
	}

	deinit {
		print("ViewController deinit")
	}

	private func setAutoLayout() {
		view.addSubview(tableView)
		let tableViewConstraints = ([
			tableView.topAnchor.constraint(equalTo: view.centerYAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])

		view.addSubview(mainLabel)
		let mainLabelConstraints = ([
			mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			mainLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor),
			mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
		])

		NSLayoutConstraint.activate(tableViewConstraints)
		NSLayoutConstraint.activate(mainLabelConstraints)
	}

	private func loadData() {
		isLoading = true
		self.networkService.getDataFromAPI(with: {self.process($0)})
	}

	private func process(_ response: GetNASAAPIResponse) {
		DispatchQueue.main.async {
			switch response {
			case .success(let data):
				self.dataSource.append(contentsOf: data)
				self.tableView.reloadData()
			case .failure(let error):
				self.showAlert(for: error)
			}
			self.isLoading = false
		}
	}

	private func showAlert(for error: NetworkServiceError) {
		let alert = UIAlertController(title: "ОШИБКА",
									  message: message(for: error),
									  preferredStyle: .alert)
		present(alert, animated: true)
	}

	private func message(for error: NetworkServiceError) -> String {
		switch error {
		case .network:
			return "Упал запрос"
		case .decodable:
			return "Не смогли распарсить"
		case .unknown:
			return "Непонятная ошибка"
		}
	}

	@objc func aboutAppButtonTapped() {
		let aboutController = AboutViewController()
		navigationController?.pushViewController(aboutController, animated: true)
	}

	@objc func historyButtonTapped() {
		let historyController = HistoryViewController()
		navigationController?.pushViewController(historyController, animated: true)
	}

}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		dataSource.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: DateCell.identifier, for: indexPath)
		(cell as? DateCell)?.configure(with: dataSource[indexPath.row])
		return cell
	}
}

extension ViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row == dataSource.count - 1, !isLoading {
			isLoading = true
			networkService.getDataFromAPI(with: { self.process($0) })
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath,animated : true)
		let pictureOfSpaceViewController = PictureOfSpaceViewController(networkService: networkService, imageUrl: dataSource[indexPath.row].url, date: dataSource[indexPath.row].date, explanation: dataSource[indexPath.row].explanation)
		navigationController?.pushViewController(pictureOfSpaceViewController, animated: true)
	}
}
