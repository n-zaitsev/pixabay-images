//
//  ImageDetails.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 10/12/2023.
//

import Foundation

struct ImageDetails: Decodable {
    let id: Int
    let webformatURL: URL
    let views: Int
    let downloads: Int
    let likes: Int
}
