//
//  BaseViewController.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 09/12/2023.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private lazy var alert = ActivityIndicatorViewController(title: "", message: nil, preferredStyle: .alert)

    func startAnimating() {
        present(alert, animated: true)
    }

    func stopAnimating() {
        alert.dismiss(animated: true)
    }
}
