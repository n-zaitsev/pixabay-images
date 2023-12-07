//
//  ImagesCatalogPresenter.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 07/12/2023.
//

import UIKit

protocol ImagesCatalogViewDelegate: AnyObject {
    func updateCollectionView()
}

class ImagesCatalogPresenter: NSObject {
    private let imagesCatalogService: ImagesCatalogServiceProtocol
    private weak var viewDelegate: ImagesCatalogViewDelegate?
    private var viewModel = ImagesCatalogViewModel(images: [], nextPage: 1)

    init(imagesCatalogService: ImagesCatalogServiceProtocol) {
        self.imagesCatalogService = imagesCatalogService
    }

    func setViewDelegate(_ viewDelegate: ImagesCatalogViewDelegate?) {
        self.viewDelegate = viewDelegate
    }

    func fetchImages(query: String) {
        viewModel.updateQuery(query)
        Task {
            let result = await imagesCatalogService.fetchImages(page: viewModel.nextPage, query: viewModel.query)
            switch result {
            case .success(let success):
                viewModel.images.append(contentsOf: success.hits)
                self.viewDelegate?.updateCollectionView()
                self.viewModel.nextPage += 1
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

extension ImagesCatalogPresenter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.images.count - 1 {
            fetchImages(query: viewModel.query)
        }
    }
}

extension ImagesCatalogPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? ImageCollectionViewCell
        cell?.setup(image: viewModel.images[indexPath.item])
        return cell ?? UICollectionViewCell()
    }
}
