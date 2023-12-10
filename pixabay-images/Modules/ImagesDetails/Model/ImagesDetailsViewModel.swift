//
//  ImagesDetailsViewModel.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 10/12/2023.
//

import Foundation

final class ImagesDetailsViewModel {
    var ids: [Int]
    var images: [ImageDetails]

    init(ids: [Int], images: [ImageDetails]) {
        self.ids = ids
        self.images = images
    }
}
