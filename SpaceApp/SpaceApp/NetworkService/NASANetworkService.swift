//
//  NASANetworkService.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import Foundation

final class NASANetworkService: NASANetworkServiceProtocol {

    private let session: URLSession = .shared
    private let decoder = JSONDecoder()

    func getDataFromAPI(count: String, with completion: @escaping (GetNASAAPIResponse) -> Void) {
        var components = URLComponents(string: Constants.urlString)
        if count == Constants.count {
            components?.queryItems = [
                URLQueryItem(name: "count", value: Constants.count),
                URLQueryItem(name: "api_key", value: Constants.apiKey)
            ]
        } else {
            components?.queryItems = [
                URLQueryItem(name: "api_key", value: Constants.apiKey)
            ]
        }

        guard let url = components?.url else {
            completion(.failure(.urlParseError))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        session.dataTask(with: request) { rawData, responce, _ in
            do {
                guard let data = try? self.httpResponse(data: rawData, response: responce) else {
                    completion(.failure(.dataError))
                    return
                }
                let responce = try self.decoder.decode([SpacePhotoDataResponse].self, from: data)
                completion(.success(responce))
            } catch {
                completion(.failure(.dataError))
            }
        }.resume()
    }

    func loadImage(imageUrl: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: imageUrl) else {
            completion(nil)
            return
        }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)

        session.dataTask(with: request) { rawData, response, _  in
            do {
                let data = try self.httpResponse(data: rawData, response: response)
                completion(data) // .success(data)
            } catch {
                completion(nil) // completion(.failure(NetworkErrors.urlError)) return
            }
        }.resume()
    }

    private func httpResponse(data: Data?, response: URLResponse?) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode),
              let data = data else {
            throw NetworkServiceError.networkError
        }
        return data
    }
}
