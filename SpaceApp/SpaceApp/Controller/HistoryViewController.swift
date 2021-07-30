//
//  HistoryViewController.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import UIKit
import CoreData

final class HistoryViewController: BaseViewController {

    private let networkService = NASANetworkService()
    private var coreDataStack = Container.shared.coreDataStack

    /// NSFetchedResultsController
    private lazy var frc: NSFetchedResultsController<MOSpacePhoto> = {
        let request = NSFetchRequest<MOSpacePhoto>(entityName: "MOSpacePhoto")
        request.sortDescriptors = [.init(key: "title", ascending: false)]

        let frc = NSFetchedResultsController(fetchRequest: request,
                                              managedObjectContext: Container.shared.coreDataStack.backgroundContext,
                                              sectionNameKeyPath: "title",
                                              cacheName: nil)
        frc.delegate = self
        return frc
    }()

    /// кнопка "Очистить историю"
    private lazy var clearHistoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash.circle.fill"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(clearHistoryButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    /// Table View
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "History"
        view.backgroundColor = .systemGray
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: clearHistoryButton)
        setAutoLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        try? frc.performFetch()
    }

    private func setAutoLayout() {
        view.addSubview(tableView)
        let tableViewConstraints = ([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        NSLayoutConstraint.activate(tableViewConstraints)
    }

    @objc func clearHistoryButtonTapped() {
        let alert = UIAlertController(title: "Clear history",
                                      message: "Are you really want to clear all history?",
                                      preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.coreDataStack.deleteAll()
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)

        alert.addAction(yesAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

}

// MARK: - UITableViewDataSource
extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = frc.sections else { return 0 }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell")
        let photo = frc.object(at: indexPath)
        let title = photo.title
        cell?.textLabel?.text = title
        return cell ?? UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return frc.sections?.count ?? 0
    }

}

// MARK: - UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

        let selectedObject = frc.object(at: indexPath)
        let pictureOfSpaceViewController = PictureOfSpaceViewController(networkService: networkService,
                                                                        imageUrl: selectedObject.url,
                                                                        date: selectedObject.date,
                                                                        explanation: selectedObject.explanation,
                                                                        photoTitle: selectedObject.title)
		navigationController?.pushViewController(pictureOfSpaceViewController, animated: true)
	}
}

// MARK: - NSFetchedResultsControllerDelegate
extension HistoryViewController: NSFetchedResultsControllerDelegate {

    // метод оповещает делегат о конце изменений
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
