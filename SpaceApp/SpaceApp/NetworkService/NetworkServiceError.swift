//
//  NetworkServiceError.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import Foundation

enum NetworkServiceError: Error {
    case urlError
    case dataError
    case networkError
    case urlParseError
    case dataImageError
    case dataParseError
}

extension NetworkServiceError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .urlError:
            return NSLocalizedString("Oops! There is something wrong with initial URL!", comment: "")
        case .dataError:
            return NSLocalizedString("Oops! There is something wrong with Data!", comment: "")
        case .networkError:
            return NSLocalizedString("Oops! Something went wrong with network!", comment: "")
        case .urlParseError:
            return NSLocalizedString("Oops! Something went wrong with parsing url!", comment: "")
        case .dataImageError:
            return NSLocalizedString("Oops! Something went wrong with Image Data!", comment: "")
        case .dataParseError:
            return NSLocalizedString("Oops! Something went wrong with parsing Data!", comment: "")
        }
    }
}
