//
//  ImagesDetailsPresenter.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 10/12/2023.
//

import UIKit

protocol ImagesDetailsViewDelegate: BaseViewDelegate {
    func updateCollectionView()
}

final class ImagesDetailsPresenter: NSObject {
    private let imagesDetailsService: ImagesDetailsServiceProtocol
    private weak var viewDelegate: ImagesDetailsViewDelegate?
    private var viewModel: ImagesDetailsViewModel

    init(imagesDetailsService: ImagesDetailsServiceProtocol, ids: [Int]) {
        self.imagesDetailsService = imagesDetailsService
        self.viewModel = ImagesDetailsViewModel(ids: ids, images: [])
    }

    func setViewDelegate(_ viewDelegate: ImagesDetailsViewDelegate?) {
        self.viewDelegate = viewDelegate
    }

    func fetchImagesDetails() {
        viewDelegate?.setLoadingIndicator(active: true)
        Task {
            viewModel.images = await withTaskGroup(of: Result<ImageDetailsResponse, RequestError>.self, returning: [ImageDetails].self, body: { group in
                for id in viewModel.ids {
                    group.addTask { await self.imagesDetailsService.fetchImagesDetails(id: id) }
                }

                var images = [ImageDetails]()
                for await result in group {
                    switch result {
                    case let .success(success):
                        images.append(contentsOf: success.hits)
                    case .failure:
                        group.cancelAll()
                        viewDelegate?.showError(animated: true, { [weak self] in
                            self?.fetchImagesDetails()
                        })
                    }
                }
                return images
            })
            DispatchQueue.main.async {
                self.viewDelegate?.updateCollectionView()
            }
            viewDelegate?.setLoadingIndicator(active: false)
        }
    }
}

extension ImagesDetailsPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageDetailsCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? ImageDetailsCollectionViewCell
        cell?.setup(image: viewModel.images[indexPath.item])
        return cell ?? UICollectionViewCell()
    }
}
