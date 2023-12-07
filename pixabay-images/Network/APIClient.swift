//
//  APIClient.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 07/12/2023.
//

import Foundation

protocol APIClient {
    associatedtype EndpointType: Endpoint
    func request<T: Decodable>(_ endpoint: EndpointType, responseModel: T.Type) async -> Result<T, RequestError>
}
