//
//  ImagesDetailsService.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 10/12/2023.
//

import Foundation

protocol ImagesDetailsServiceProtocol: AnyObject {
    func fetchImagesDetails(id: Int) async -> Result<ImageDetailsResponse, RequestError>
}

final class ImagesDetailsService: ImagesDetailsServiceProtocol {
    private let apiClient = URLSessionAPIClient<ImagesDetailsEndpoint>()

    func fetchImagesDetails(id: Int) async -> Result<ImageDetailsResponse, RequestError> {
        await apiClient.request(.fetchImagesDetails(id: id), responseModel: ImageDetailsResponse.self)
    }
}
