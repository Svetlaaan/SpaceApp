//
//  TableViewController.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 22.07.2021.
//

import UIKit

final class TableViewController: UITableViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.rowHeight = UITableView.automaticDimension
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
	}
}
