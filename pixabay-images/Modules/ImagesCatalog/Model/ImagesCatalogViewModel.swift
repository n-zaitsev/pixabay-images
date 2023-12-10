//
//  ImagesCatalogViewModel.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 07/12/2023.
//

import Foundation

final class ImagesCatalogViewModel {
    var total: Int
    var images: [Image]
    var nextPage: Int
    var selectedItems: Set<Image>
    private(set) var query: String

    init() {
        self.total = 0
        self.images = []
        self.nextPage = 1
        self.query = ""
        self.selectedItems = []
    }

    var isLastPage: Bool {
        total == images.count && !images.isEmpty
    }

    var imagesRequest: ImagesRequest {
        ImagesRequest(page: nextPage, query: query)
    }

    func updateQuery(_ q: String) {
        guard query != q else {
            return
        }
        self.query = q
        self.total = 0
        nextPage = 1
        images.removeAll()
        selectedItems.removeAll()
    }
}
