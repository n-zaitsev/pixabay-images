//
//  ImagesDetailsEndpoint.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 10/12/2023.
//

import Foundation

enum ImagesDetailsEndpoint {
    case fetchImagesDetails(id: Int)
}

extension ImagesDetailsEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchImagesDetails:
            return "/api/"
        }
    }

    var method: RequestMethod {
        switch self {
        case .fetchImagesDetails:
            return .get
        }
    }

    var query: [URLQueryItem] {
        switch self {
        case let .fetchImagesDetails(id):
            let id = URLQueryItem(name: QueryNames.id.rawValue, value: String(id))
            let key = URLQueryItem(name: QueryNames.key.rawValue, value: AppSettings.apiKey)
            return [key, id]
        }
    }

    private enum QueryNames: String {
        case key
        case id
    }
}
