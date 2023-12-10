//
//  ImageDetailsResponse.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 10/12/2023.
//

import Foundation

struct ImageDetailsResponse: Decodable {
    let total: Int
    let totalHits: Int
    let hits: [ImageDetails]
}
