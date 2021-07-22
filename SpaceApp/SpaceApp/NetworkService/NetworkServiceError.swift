//
//  NetworkServiceError.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

enum NetworkServiceError: Error {
	case network
	case decodable
	case unknown
}

//import Foundation

//enum NetworkErrors: Error {
//	case urlError
//	case dataError
//	case urlParseError
//	case dataImageError
//}
//
//extension NetworkErrors: LocalizedError {
//
//	var errorDescription: String? {
//		switch self {
//		case .urlError:
//			return NSLocalizedString("Oops! There is something wrong with initial URL!", comment: "")
//		case .dataError:
//			return NSLocalizedString("Oops! There is something wrong with Data!", comment: "")
//		case .urlParseError:
//			return NSLocalizedString("Oops! Something went wrong with parsing urlString!", comment: "")
//		case .dataImageError:
//			return NSLocalizedString("Oops! Something went wrong with Image Data!", comment: "")
//		}
//	}
//}
