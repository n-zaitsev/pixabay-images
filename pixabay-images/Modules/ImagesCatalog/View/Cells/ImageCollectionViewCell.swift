//
//  ImageCollectionViewCell.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 07/12/2023.
//

import UIKit
import Kingfisher

final class ImageCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet {
            setBackground()
        }
    }

    func setup(image: Image, selected: Bool) {
        imageView.kf.setImage(with: image.previewURL)
        isSelected = selected
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private func setupConstraints() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    private func setBackground() {
        if isSelected {
            contentView.backgroundColor = .link
        } else{
            contentView.backgroundColor = .white
        }
    }
}
