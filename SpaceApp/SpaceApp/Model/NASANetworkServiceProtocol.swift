//
//  NASANetworkServiceProtocol.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import Foundation

typealias GetNASAAPIResponse = Result<[GetDayDataResponse], NetworkServiceError>

protocol NASANetworkServiceProtocol {
	func getDataFromAPI(with completion: @escaping (GetNASAAPIResponse) ->Void)
	func loadImage(imageUrl: String, completion: @escaping (Data?) -> Void)
}
