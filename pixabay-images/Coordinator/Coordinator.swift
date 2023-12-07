//
//  Coordinator.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 07/12/2023.
//

import UIKit

public protocol Coordinator: AnyObject {

    var navigationController: UINavigationController? { get set }

    init(navigationController: UINavigationController)

    func start()
}
