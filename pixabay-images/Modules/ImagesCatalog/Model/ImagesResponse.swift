//
//  ImagesResponse.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 07/12/2023.
//

import Foundation

struct ImagesResponse: Decodable {
    let total: Int
    let totalHits: Int
    let hits: [Image]
}
