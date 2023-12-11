//
//  ImagesCatalogPresenter.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 07/12/2023.
//

import UIKit

protocol ImagesCatalogViewDelegate: BaseViewDelegate {
    func updateCollectionView(needScroll: Bool)
    func setupButtons()
    func removeButtons()
}

class ImagesCatalogPresenter: NSObject {
    private let imagesCatalogService: ImagesCatalogServiceProtocol
    private weak var viewDelegate: ImagesCatalogViewDelegate?
    private var viewModel = ImagesCatalogViewModel()

    init(imagesCatalogService: ImagesCatalogServiceProtocol) {
        self.imagesCatalogService = imagesCatalogService
    }

    var selectedImages: Set<Image> {
        viewModel.selectedItems
    }

    func trashButtonDidTapped() {
        viewModel.selectedItems.removeAll()
    }

    func setViewDelegate(_ viewDelegate: ImagesCatalogViewDelegate?) {
        self.viewDelegate = viewDelegate
    }

    func fetchImages(with newQuery: String) {
        viewModel.updateQuery(newQuery)
        viewDelegate?.setLoadingIndicator(active: true)
        Task {
            let result = await imagesCatalogService.fetchImages(request: viewModel.imagesRequest)
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
            let result = await imagesCatalogService.fetchImages(request: viewModel.imagesRequest)
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedItems.insert(viewModel.images[indexPath.item])
        if viewModel.selectedItems.count > 1 {
            viewDelegate?.setupButtons()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel.selectedItems.remove(viewModel.images[indexPath.item])
        if viewModel.selectedItems.count < 2 {
            viewDelegate?.removeButtons()
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

        let isSelected = viewModel.selectedItems.contains(viewModel.images[indexPath.item])
        cell?.setup(image: viewModel.images[indexPath.item], selected: isSelected)
        if isSelected {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
        return cell ?? UICollectionViewCell()
    }
}
