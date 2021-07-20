//
//  NASANetworkService.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import Foundation

final class NASANetworkService {

	private let session: URLSession = .shared
	private let decoder = JSONDecoder()
}

extension NASANetworkService: NASANetworkServiceProtocol {

	func getDataFromAPI(with completion: @escaping (GetNASAAPIResponse) -> Void) {
		var components = URLComponents(string: Constants.urlString)
		components?.queryItems = [
			URLQueryItem(name: "count", value: Constants.count),
			URLQueryItem(name: "api_key", value: Constants.api_key)
		]

		guard let url = components?.url else {
			completion(.failure(.unknown))
			return
		}

		var request = URLRequest(url: url)
		request.httpMethod = "GET"

		session.dataTask(with: request) { (rawData, responce, taskError) in
			do {
				let data = try self.httpResponse(data: rawData, response: responce)
				let responce = try self.decoder.decode([GetDayDataResponse].self, from: data)
				completion(.success(responce))
			} catch let error as NetworkServiceError {
				completion(.failure(error))
			} catch {
				completion(.failure(.decodable))
			}
		}.resume()
	}

	func loadImage(imageUrl: String, completion: @escaping (Data?) -> Void) {
		guard let url = URL(string: imageUrl) else {
			completion(nil)
			return
		}

		let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)

		session.dataTask(with: request) { rawData, response, taskError in
			do {
				let data = try self.httpResponse(data: rawData, response: response)
				completion(data)
			} catch {
				completion(nil)
			}
		}.resume()
	}

	private func httpResponse(data: Data?, response: URLResponse?) throws -> Data {
		guard let httpResponse = response as? HTTPURLResponse,
			  (200..<300).contains(httpResponse.statusCode),
			  let data = data else {
			throw NetworkServiceError.network
		}
		return data
	}
}
