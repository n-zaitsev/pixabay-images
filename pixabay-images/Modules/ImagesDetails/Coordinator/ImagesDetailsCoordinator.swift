//
//  ImagesDetailsCoordinator.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 10/12/2023.
//

import UIKit

final class ImagesDetailsCoordinator: Coordinator {
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {}

    func start(with ids: [Int]) {
        let imagesDetails = ImagesDetailsViewController(ids: ids)
        navigationController?.pushViewController(imagesDetails, animated: true)
    }
}
