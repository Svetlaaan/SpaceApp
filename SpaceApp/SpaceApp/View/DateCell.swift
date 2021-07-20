//
//  DateCell.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import UIKit

final class DateCell: UITableViewCell {

	static let identifier = "DateCell"

	func configure(with model: GetDayDataResponse) {
		textLabel?.text = model.title
	}
}
