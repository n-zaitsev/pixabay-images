//
//  ImagesCatalogViewModel.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 07/12/2023.
//

import Foundation

final class ImagesCatalogViewModel {
    var images: [Image]
    var nextPage: Int

    private(set) var query: String

    init(images: [Image], nextPage: Int) {
        self.images = images
        self.nextPage = nextPage
        self.query = ""
    }

    func updateQuery(_ q: String) {
        guard query != q else {
            return
        }
        self.query = q
        nextPage = 1
        images.removeAll()
    }
}
