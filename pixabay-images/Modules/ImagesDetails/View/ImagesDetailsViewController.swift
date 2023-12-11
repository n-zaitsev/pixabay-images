//
//  ImagesDetailsViewController.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 10/12/2023.
//

import UIKit

final class ImagesDetailsViewController: BaseViewController {

    init(ids: [Int]) {
        self.imagesDetailsPresenter = ImagesDetailsPresenter(imagesDetailsService: ImagesDetailsService(), ids: ids)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        imagesDetailsPresenter.setViewDelegate(self)
        imagesDetailsPresenter.fetchImagesDetails()
        setupConstraints()
        navigationItem.title = "Details"
        super.viewDidLoad()
    }

    private let imagesDetailsPresenter: ImagesDetailsPresenter

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        return UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.orthogonalScrollingBehavior = .groupPaging

            return section
        }, configuration: configuration)
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = false
        collectionView.dataSource = imagesDetailsPresenter
        collectionView.register(ImageDetailsCollectionViewCell.self,
                                forCellWithReuseIdentifier: ImageDetailsCollectionViewCell.cellIdentifier)

        return collectionView
    }()

    private func setupConstraints() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension ImagesDetailsViewController: ImagesDetailsViewDelegate {
    func updateCollectionView() {
        self.collectionView.reloadData()
    }
}
