//
//  ImagesCatalogPresenter.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 07/12/2023.
//

import UIKit

protocol ImagesCatalogViewDelegate: AnyObject {
    func updateCollectionView(needScroll: Bool)
    func setLoadingIndicator(active: Bool)
    func showError(animated: Bool, _ action: (() -> Void)?)
    func showShortError(animated: Bool)
}

class ImagesCatalogPresenter: NSObject {
    private let imagesCatalogService: ImagesCatalogServiceProtocol
    private weak var viewDelegate: ImagesCatalogViewDelegate?
    private var viewModel = ImagesCatalogViewModel(total: 0, images: [], nextPage: 1)

    init(imagesCatalogService: ImagesCatalogServiceProtocol) {
        self.imagesCatalogService = imagesCatalogService
    }

    func setViewDelegate(_ viewDelegate: ImagesCatalogViewDelegate?) {
        self.viewDelegate = viewDelegate
    }

    func fetchImages(with newQuery: String) {
        viewModel.updateQuery(newQuery)
        viewDelegate?.setLoadingIndicator(active: true)
        Task {
            let result = await imagesCatalogService.fetchImages(page: viewModel.nextPage, query: viewModel.query)
            switch result {
            case .success(let success):
                viewModel.total = success.total
                viewModel.images = success.hits
                DispatchQueue.main.sync {
                    self.viewDelegate?.updateCollectionView(needScroll: true)
                }
                self.viewModel.nextPage += 1
            case .failure:
                viewDelegate?.showError(animated: true, { [weak self] in
                    self?.fetchImages(with: newQuery)
                })
            }
            viewDelegate?.setLoadingIndicator(active: false)
        }
    }

    func fetchImagesWithNextPage() {
        guard !viewModel.isLastPage else {
            return
        }
        Task {
            let result = await imagesCatalogService.fetchImages(page: viewModel.nextPage, query: viewModel.query)
            switch result {
            case .success(let success):
                viewModel.total = success.total
                viewModel.images.append(contentsOf: success.hits)
                DispatchQueue.main.async {
                    self.viewDelegate?.updateCollectionView(needScroll: false)
                }
                self.viewModel.nextPage += 1
            case .failure:
                viewDelegate?.showShortError(animated: true)
            }
        }
    }
}

extension ImagesCatalogPresenter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.images.count - 1 {
            fetchImagesWithNextPage()
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
