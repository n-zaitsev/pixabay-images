//
//  ImagesCatalogViewController.swift
//  pixabay-images
//
//  Created by Nikita Zaitsev on 07/12/2023.
//

import UIKit

protocol ImagesCatalogViewControllerDelegate: AnyObject {
    func trashButtonDidTapped()
    var selectedImages: Set<Image> { get }
}

final class ImagesCatalogViewController: BaseViewController {

    override func viewDidLoad() {
        setupConstraints()
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Images"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        presenterDelegate = imagesCatalogPresenter
        imagesCatalogPresenter.setViewDelegate(self)
        addGestureRecognizerToHideKeyboard()
        imagesCatalogPresenter.fetchImages(with: "")
    }

    var onImages: ((Set<Image>) -> Void)?

    private let imagesCatalogPresenter = ImagesCatalogPresenter(imagesCatalogService: ImagesCatalogService())
    private weak var presenterDelegate: ImagesCatalogViewControllerDelegate?

    private lazy var cancelSelectionButton = UIBarButtonItem(title: "Clear choice",
                                                             style: .done,
                                                             target: self,
                                                             action: #selector(clearImages))

    private lazy var onSelectedImagesButton = UIBarButtonItem(title: "Show images",
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(showImages))

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
            group.interItemSpacing = .fixed(8)
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
        collectionView.allowsMultipleSelection = true
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

    private func addGestureRecognizerToHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc
    private func dismissKeyboard() {
        searchController.searchBar.endEditing(true)
    }

    @objc
    private func clearImages() {
        presenterDelegate?.trashButtonDidTapped()
        navigationItem.leftBarButtonItem = nil
        collectionView.reloadData()
    }

    @objc
    private func showImages() {
        guard let images = presenterDelegate?.selectedImages else {
            return
        }
        onImages?(images)
    }
}

extension ImagesCatalogViewController: ImagesCatalogViewDelegate {
    func updateCollectionView(needScroll: Bool) {
        self.collectionView.reloadData()
        if needScroll {
            self.collectionView.setContentOffset(.zero, animated: false)
        }
    }

    func setLoadingIndicator(active: Bool) {
        DispatchQueue.main.async {
            if active {
                self.startAnimating()
            } else {
                self.stopAnimating()
            }
        }
    }

    func showError(animated: Bool, _ action: (() -> Void)?) {
        showErrorView(animated: animated) { [weak self] in
            self?.hideErrorView()
            action?()
        }
    }

    func showShortError(animated: Bool) {
        showShortErrorView(animated: animated)
    }

    func setupButtons() {
        navigationItem.leftBarButtonItem = cancelSelectionButton
        navigationItem.rightBarButtonItem = onSelectedImagesButton
    }

    func removeButtons() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
    }
}

extension ImagesCatalogViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        imagesCatalogPresenter.fetchImages(with: searchBar.text ?? "")
    }

    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let totalCharacters = (searchBar.text?.appending(text).count ?? 0) - range.length
        return totalCharacters <= 100
    }
}
