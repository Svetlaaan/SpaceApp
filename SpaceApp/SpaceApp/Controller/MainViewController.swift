//
//  MainViewController.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import UIKit
import CoreData

class MainViewController: BaseViewController {

    private let networkService: NASANetworkServiceProtocol
    private var dataSource = [SpacePhotoDataResponse]()
    private var coreDataStack = Container.shared.coreDataStack
    private let mainQueue = DispatchQueue.main

    // MARK: - Init
    init(networkService: NASANetworkServiceProtocol) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// заголовочное изображение
    private lazy var spaceshipImageView: UIImageView = {
        let image = UIImage(named: "space")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityLabel = "main image"
        return imageView
    }()

    /// лэйбл на заголовочном изображении
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Space photos"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 34)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Table view
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.accessibilityIdentifier = "main table"
        tableView.register(SpacePhotoCell.self, forCellReuseIdentifier: SpacePhotoCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        title = "Main"
        setConstraints()
        loadData()
    }

    deinit {
        NSLog("ViewController deinit")
    }

    // MARK: - Methods
    private func setConstraints() {
        view.addSubview(spaceshipImageView)
        let spaceshipImageViewConstraints = ([
            spaceshipImageView.topAnchor.constraint(equalTo: view.topAnchor),
            spaceshipImageView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            spaceshipImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spaceshipImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        view.addSubview(tableView)
        let tableViewConstraints = ([
            tableView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -(view.frame.height / 4)),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        spaceshipImageView.addSubview(mainLabel)
        let mainLabelConstraints = ([
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])

        NSLayoutConstraint.activate(spaceshipImageViewConstraints)
        NSLayoutConstraint.activate(tableViewConstraints)
        NSLayoutConstraint.activate(mainLabelConstraints)
    }

    /// загрузка данных
    private func loadData() {
        isLoading = true
        self.networkService.getDataFromAPI(with: { self.process($0) })
    }

    private func process(_ response: GetNASAAPIResponse) {
        mainQueue.async {
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

    /// алерт для отображения ошибки при загрузке данных
    private func showAlert(for error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.loadData()
        }

        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SpacePhotoCell.identifier, for: indexPath)
        (cell as? SpacePhotoCell)?.configure(with: dataSource[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataSource.count - 1, !isLoading {
            isLoading = true
            networkService.getDataFromAPI(with: { self.process($0) })
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /// синхронное сохранения данных о просмотренном изображении в Core Data
        coreDataStack.backgroundContext.performAndWait {
            let spacePhoto = MOSpacePhoto(context: coreDataStack.backgroundContext)
            spacePhoto.date = "\(dataSource[indexPath.row].date)"
            spacePhoto.explanation = "\(dataSource[indexPath.row].explanation)"
            spacePhoto.title = "\(dataSource[indexPath.row].title)"
            spacePhoto.url = "\(dataSource[indexPath.row].url)"
            try? coreDataStack.backgroundContext.save()
        }

        /// переход на экран для просмотра изображения и его описания
        let pictureOfSpaceVC =
            PictureOfSpaceViewController(networkService: networkService,
                                         imageUrl: dataSource[indexPath.row].url,
                                         date: dataSource[indexPath.row].date,
                                         explanation: dataSource[indexPath.row].explanation,
                                         photoTitle: dataSource[indexPath.row].title)
        navigationController?.pushViewController(pictureOfSpaceVC, animated: true)
    }
}
