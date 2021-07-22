//
//  SpacePhotoCell.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import UIKit

final class SpacePhotoCell: UITableViewCell {

	static let identifier = "SpacePhotoCell"

	func configure(with model: SpacePhotoDataResponse) {
		textLabel?.text = model.title
		textLabel?.font = .boldSystemFont(ofSize: 18)
		textLabel?.textAlignment = .center
	}
}
