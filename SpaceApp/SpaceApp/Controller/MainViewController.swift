//
//  MainViewController.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import UIKit
import CoreData

// сбрасывается при новом запуске
var indexRec = 0

class MainViewController: BaseViewController {

    private let networkService: NASANetworkServiceProtocol
    private var dataSource = [SpacePhotoDataResponse]()
    private var coreDataStack = Container.shared.coreDataStack

    init(networkService: NASANetworkServiceProtocol) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - BUTTONS

    /// кнопка "О приложении"
    private lazy var aboutAppButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(aboutAppButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    /// кнопка "История просмотра"
    private lazy var historyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "clock.fill"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // Header image
    private lazy var spaceshipImageView: UIImageView = {
        let image = UIImage(named: "space")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - LABELS
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Click on title to see a photo from space"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textAlignment = .center
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 34)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - TABLE VIEW
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SpacePhotoCell.self, forCellReuseIdentifier: SpacePhotoCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Варианты установки имени пользователя в title:
        // 1. пользователь при запуске приложения ввел имя и нажал кнопку "Send" - берется имя из user defaults
        // 2. пользователь при запуске приложения нажал кнопку "Skip", ранее имя уже вводилось - берется имя из user defaults
        // 3. пользователь при запуске приложения нажал кнопку "Skip", ранее имя не вводилось - берется дефолтное значение
        title = "Hey, \(UserSettings.userName ?? "Unknown")"

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: aboutAppButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: historyButton)
        setAutoLayout()
        loadData()
    }

    deinit {
        print("ViewController deinit")
    }

    // MARK: - METHODS

    private func setAutoLayout() {
        view.addSubview(spaceshipImageView)
        let spaceshipImageViewConstraints = ([
            spaceshipImageView.topAnchor.constraint(equalTo: view.topAnchor),
            spaceshipImageView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            spaceshipImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spaceshipImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        view.addSubview(tableView)
        let tableViewConstraints = ([
            tableView.topAnchor.constraint(equalTo: view.centerYAnchor),
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

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataSource.count - 1, !isLoading {
            isLoading = true
            networkService.getDataFromAPI(with: { self.process($0) })
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,animated : true)

        // синхронное выполнение сохранения инфы о просмотренном изображении в CD
        coreDataStack.backgroundContext.performAndWait {
            indexRec += 1
            let spacePhoto = MOSpacePhoto(context: coreDataStack.backgroundContext)
            spacePhoto.date = "\(dataSource[indexPath.row].date)"
            spacePhoto.explanation = "\(dataSource[indexPath.row].explanation)"
            spacePhoto.title = "\(dataSource[indexPath.row].title)"
            spacePhoto.url = "\(dataSource[indexPath.row].url)"
            spacePhoto.index = Int16(indexRec)
            try? coreDataStack.backgroundContext.save()

            // DEBUG PRINT
            debugPrint("New - \(spacePhoto.title)")
            let context = coreDataStack.viewContext
            context.performAndWait {
                let request = NSFetchRequest<MOSpacePhoto>(entityName: "MOSpacePhoto")
                let result = try? request.execute()
                result?.forEach {
                    debugPrint($0.title)
                }
            }
        }

        let pictureOfSpaceViewController = PictureOfSpaceViewController(networkService: networkService, imageUrl: dataSource[indexPath.row].url, date: dataSource[indexPath.row].date, explanation: dataSource[indexPath.row].explanation)
        navigationController?.pushViewController(pictureOfSpaceViewController, animated: true)
    }
}
