//
//  ImagesCatalogEndpoint.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 07/12/2023.
//

import Foundation

enum ImagesCatalogEndpoint {
    case fetchImages(request: ImagesRequest)
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
        case let .fetchImages(request):
            let key = URLQueryItem(name: QueryNames.key.rawValue, value: AppSettings.apiKey)
            let page = URLQueryItem(name: QueryNames.page.rawValue, value: String(request.page))
            let query = URLQueryItem(name: QueryNames.q.rawValue, value: request.query)
            return [key, page, query]
        }
    }

    private enum QueryNames: String {
        case key
        case page
        case q
    }
}
