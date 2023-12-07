//
//  ImagesCatalogEndpoint.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 07/12/2023.
//

import Foundation

enum ImagesCatalogEndpoint {
    case fetchImages(page: Int, query: String)
}

extension ImagesCatalogEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchImages:
            return "/api/"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .fetchImages:
            return .get
        }
    }
    
    var query: [URLQueryItem] {
        switch self {
        case let .fetchImages(page, query):
            return [URLQueryItem(name: QueryNames.key.rawValue, value: AppSettings.apiKey),
                    URLQueryItem(name: QueryNames.page.rawValue, value: String(page)),
                    URLQueryItem(name: QueryNames.q.rawValue, value: query)]
        }
    }

    private enum QueryNames: String {
        case key
        case page
        case q
    }
}
