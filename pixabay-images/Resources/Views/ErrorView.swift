//
//  ErrorView.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 10/12/2023.
//

import UIKit

final class ErrorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var retryAction: (() -> Void)?

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Ooops, something went wrong..."
        return titleLabel
    }()



    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Try again", for: .normal)
        button.addTarget(self, action: #selector(retry), for: .touchUpInside)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 10
        return button
    }()

    private func setupConstraints() {
        addSubview(titleLabel)
        addSubview(retryButton)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.heightAnchor.constraint(equalToConstant: 56),
            retryButton.widthAnchor.constraint(equalToConstant: 280),
            retryButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            retryButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    @objc
    private func retry() {
        retryAction?()
    }

}
