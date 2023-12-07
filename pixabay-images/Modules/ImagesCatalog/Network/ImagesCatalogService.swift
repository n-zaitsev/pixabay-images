//
//  ImagesCatalogService.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 07/12/2023.
//

import Foundation

protocol ImagesCatalogServiceProtocol: AnyObject {
    func fetchImages(page: Int, query: String) async -> Result<ImagesResponse, RequestError>
}

final class ImagesCatalogService: ImagesCatalogServiceProtocol {
    private let apiClient = URLSessionAPIClient<ImagesCatalogEndpoint>()

    func fetchImages(page: Int, query: String) async -> Result<ImagesResponse, RequestError> {
        await apiClient.request(.fetchImages(page: page, query: query), responseModel: ImagesResponse.self)
    }
}
