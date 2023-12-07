//
//  UICollectionViewCell+cellIdentifier.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 07/12/2023.
//

import UIKit

extension UICollectionViewCell {
    static var cellIdentifier: String {
        String(describing: Self.self)
    }
}
