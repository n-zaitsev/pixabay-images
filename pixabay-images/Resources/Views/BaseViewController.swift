//
//  BaseViewController.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 09/12/2023.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        setupErrorView()
        view.backgroundColor = .white
        super.viewDidLoad()
    }

    private lazy var alert = ActivityIndicatorViewController(title: "", message: nil, preferredStyle: .alert)
    private lazy var errorView = ErrorView()
    private lazy var shortErrorView = UIAlertController(title: "Something went wrong", message: nil, preferredStyle: .actionSheet)
    private let animationDuration: CGFloat = 0.3

    func startAnimating() {
        present(alert, animated: false)
    }

    func stopAnimating() {
        alert.dismiss(animated: true)
    }

    func showErrorView(animated: Bool = true, _ action: (() -> Void)?) {
        DispatchQueue.main.async {
            self.errorView.retryAction = action
            if animated {
                UIView.animate(withDuration: self.animationDuration) {
                    self.errorView.isHidden = false
                    self.errorView.alpha = 1.0
                }
            } else {
                self.errorView.alpha = 1.0
                self.errorView.isHidden = false
            }
        }
    }

    func hideErrorView(animated: Bool = true) {
        DispatchQueue.main.async {
            if animated {
                UIView.animate(withDuration: self.animationDuration) {
                    self.errorView.alpha = 0
                    self.errorView.isHidden = true
                }
            } else {
                self.errorView.isHidden = true
                self.errorView.alpha = 0
            }
        }
    }

    func showShortErrorView(animated: Bool = true) {
        DispatchQueue.main.async {
            self.present(self.shortErrorView, animated: animated)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.shortErrorView.dismiss(animated: animated)
            }
        }
    }


    private func setupErrorView() {
        self.errorView.alpha = 0
        errorView.isHidden = true
        view.addSubview(errorView)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension BaseViewController: BaseViewDelegate {
    func setLoadingIndicator(active: Bool) {
        DispatchQueue.main.async {
            if active {
                self.startAnimating()
            } else {
                self.stopAnimating()
            }
        }
    }
    
    func showError(animated: Bool, _ action: (() -> Void)?) {
        showErrorView(animated: animated) { [weak self] in
            self?.hideErrorView()
            action?()
        }
    }
    
    func showShortError(animated: Bool) {
        showShortErrorView(animated: animated)
    }
}
