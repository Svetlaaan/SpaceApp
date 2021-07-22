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
	private lazy var frc: NSFetchedResultsController<MOSpacePhoto> = {
		let request = NSFetchRequest<MOSpacePhoto>(entityName: "MOSpacePhoto")
		request.sortDescriptors = [.init(key: "date", ascending: true)]

		let frc =  NSFetchedResultsController(fetchRequest: request,
											  managedObjectContext: Container.shared.coreDataStack.viewContext,
											  sectionNameKeyPath: "title",
											  cacheName: nil)
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

	private lazy var tableView: UITableView = {
		let tableView = UITableView()
//		tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.identifier)
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
		tableView.dataSource = self
//		tableView.delegate = self
		tableView.showsVerticalScrollIndicator = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "History"
		view.backgroundColor = .systemGray
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: clearHistoryButton)
//		setupChild()
		setAutoLayout()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)

		try? frc.performFetch()
	}

//	func setupChild() {
//		let childViewController = TableViewController()
//		childViewController.view.translatesAutoresizingMaskIntoConstraints = false
//
//		view.addSubview(childViewController.view)
//		addChild(childViewController)
//		childViewController.didMove(toParent: self)
//		childViewController.tableView.dataSource = self
//		tableViewController = childViewController
//
//		NSLayoutConstraint.activate([
//			childViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//			childViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//			childViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//			childViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//		])
//	}

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
		let alert = UIAlertController(title: "Clear history", message: "Are you sure you want to clear all history?", preferredStyle: .alert)
		let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (yesAction) in
			self.coreDataStack.deleteAll()
			try? self.frc.performFetch()
//			self.tableViewController?.tableView.reloadData()
			self.tableView.reloadData()
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

		alert.addAction(yesAction)
		alert.addAction(cancelAction)

		present(alert, animated: true, completion: nil)
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
