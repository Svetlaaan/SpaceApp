//
//  HistoryViewController.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import UIKit
import CoreData

final class HistoryViewController: BaseViewController {

    private var coreDataStack = Container.shared.coreDataStack
    //	weak var tableViewController: UITableViewController?

    // FRC
    // Контроллер класса NSFetchedResultsController условно можно расположить между Core Data и ViewController,
    // в котором нам нужно отобразить данные из базы. Методы и свойства этого контроллера позволяют с удобством взаимодействовать,
    // представлять и управлять объектами из Core Data в связке с таблицами UITableView, для которых он наиболее адаптирован.
    // Этот контроллер умеет преобразовывать извлечённые объекты в элементы таблицы — секции и объекты этих секций.
    // FRC имеет протокол NSFetchedResultsControllerDelegate, который при делегировании позволяет отлавливать изменения
    // происходящих с объектами заданного запроса NSFetchRequest в момент инициализации контроллера.

    private lazy var frc: NSFetchedResultsController<MOSpacePhoto> = {
        let request = NSFetchRequest<MOSpacePhoto>(entityName: "MOSpacePhoto")
        request.sortDescriptors = [.init(key: "index", ascending: false)]

        let frc =  NSFetchedResultsController(fetchRequest: request,
                                              managedObjectContext: Container.shared.coreDataStack.backgroundContext,
                                              sectionNameKeyPath: "title",
                                              cacheName: nil)
        frc.delegate = self
        return frc
    }()

    // MARK: - BUTTONS

    // кнопка для возврата на главный экран
    private lazy var returnToMainVC: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(returnToMainPage) , for: .touchUpInside)
        return button
    }()

    // кнопка "Очистить историю"
    private lazy var clearHistoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash.circle.fill"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(clearHistoryButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "History"
        view.backgroundColor = .systemGray
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: returnToMainVC)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: clearHistoryButton)
        setAutoLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        // performFetch для извлечения выборки из базы данных
        // Метод возвращает булево значение. Если извлечение произведено успешно,
        // то вернётся булево true, а в противном случае — false.
        // После извлечения объекты находятся в свойстве контроллера fetchedObjects.
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
        let alert = UIAlertController(title: "Clear history", message: "Are you really want to clear all history?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (yesAction) in
            self.coreDataStack.deleteAll()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(yesAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    @objc func returnToMainPage() {
        navigationController?.popViewController(animated: true)
    }
}

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

//extension HistoryViewController: UITableViewDelegate {
//
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		tableView.deselectRow(at: indexPath, animated : true)
//
////		let pictureOfSpaceViewController = PictureOfSpaceViewController(networkService: networkService, imageUrl: dataSource[indexPath.row].url, date: dataSource[indexPath.row].date, explanation: dataSource[indexPath.row].explanation)
////		navigationController?.pushViewController(pictureOfSpaceViewController, animated: true)
//	}
//}

extension HistoryViewController: NSFetchedResultsControllerDelegate {

    // метод оповещает делегат о конце изменений
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
