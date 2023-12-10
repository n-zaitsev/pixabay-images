//
//  ImagesCatalogCoordinator.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 07/12/2023.
//

import UIKit

final class ImagesCatalogCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let imagesCatalogVC = ImagesCatalogViewController()
        imagesCatalogVC.onImages = { [weak navigationController] ids in
            guard let navigationController = navigationController else {
                return
            }
            let coordinator = ImagesDetailsCoordinator(navigationController: navigationController)
            coordinator.start(with: ids.map({ $0.id }))
        }
        navigationController?.pushViewController(imagesCatalogVC, animated: false)
    }
}
