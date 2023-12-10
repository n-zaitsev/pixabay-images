//
//  ImagesCatalogService.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 07/12/2023.
//

import Foundation

protocol ImagesCatalogServiceProtocol: AnyObject {
    func fetchImages(request: ImagesRequest) async -> Result<ImagesResponse, RequestError>
}

final class ImagesCatalogService: ImagesCatalogServiceProtocol {
    private let apiClient = URLSessionAPIClient<ImagesCatalogEndpoint>()

    func fetchImages(request: ImagesRequest) async -> Result<ImagesResponse, RequestError> {
        await apiClient.request(.fetchImages(request: request), responseModel: ImagesResponse.self)
    }
}
