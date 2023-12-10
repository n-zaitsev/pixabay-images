//
//  ActivityIndicatorViewController.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 09/12/2023.
//

import UIKit

final class ActivityIndicatorViewController: UIAlertController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activityIndicator.stopAnimating()
    }

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private func setupConstraints() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 100),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
