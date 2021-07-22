//
//  GetDataResponse.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import Foundation

struct SpacePhotoDataResponse: Decodable {
	let date: String
	let explanation: String
	let title: String
	let url: String
}
