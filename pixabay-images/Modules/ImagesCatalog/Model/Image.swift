//
//  Image.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 07/12/2023.
//

import Foundation

struct Image: Decodable {
    let id: Int
    let previewURL: URL
}

extension Image: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
