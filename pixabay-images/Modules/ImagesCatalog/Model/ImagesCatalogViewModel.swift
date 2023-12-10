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

    init(total: Int, images: [Image], nextPage: Int) {
        self.total = total
        self.images = images
        self.nextPage = nextPage
        self.query = ""
        self.selectedItems = []
    }

    var isLastPage: Bool {
        total == images.count && !images.isEmpty
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
