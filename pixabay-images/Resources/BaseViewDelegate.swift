//
//  BaseViewDelegate.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 10/12/2023.
//

import Foundation

protocol BaseViewDelegate: AnyObject {
    func setLoadingIndicator(active: Bool)
    func showError(animated: Bool, _ action: (() -> Void)?)
    func showShortError(animated: Bool)
}
