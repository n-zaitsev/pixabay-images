//
//  ImageDetailsCollectionViewCell.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 10/12/2023.
//

import UIKit
import Kingfisher

final class ImageDetailsCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(image: ImageDetails) {
        imageView.kf.setImage(with: image.webformatURL)
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private func setupConstraints() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
}
