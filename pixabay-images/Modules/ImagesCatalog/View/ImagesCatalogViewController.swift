//
//  ImagesCatalogViewController.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 07/12/2023.
//

import UIKit

final class ImagesCatalogViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Images"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        imagesCatalogPresenter.setViewDelegate(self)
        setupConstraints()
        addGestureRecognizerToHideKeyboard()
        imagesCatalogPresenter.fetchImages(query: "")
        // TODO: Add loading indicator
    }

    private let imagesCatalogPresenter = ImagesCatalogPresenter(imagesCatalogService: ImagesCatalogService())

    private lazy var searchController: UISearchController = {
        let search = UISearchController()
        search.searchBar.placeholder = "Search..."
        search.searchBar.showsCancelButton = false
        search.searchBar.searchBarStyle = .minimal
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.delegate = self
        return search
    }()

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(150))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8

            return section
        }
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = false
        collectionView.delegate = imagesCatalogPresenter
        collectionView.dataSource = imagesCatalogPresenter
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.cellIdentifier)
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

    // TODO: Doesn't work
    private func addGestureRecognizerToHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc
    private func dismissKeyboard() {
        searchController.searchBar.endEditing(true)
    }
}

extension ImagesCatalogViewController: ImagesCatalogViewDelegate {
    func updateCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension ImagesCatalogViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        imagesCatalogPresenter.fetchImages(query: searchBar.text ?? "")
    }
}
