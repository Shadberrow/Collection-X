//
//  LibraryViewController.swift
//  CollectionX
//
//  Created by Yevhenii on 11.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import Combine
import YVAnchor

class LibraryViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

    typealias DataSource = UICollectionViewDiffableDataSource<Section, OMDBItemFullInfo>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, OMDBItemFullInfo>

    enum Section { case main }

    private var collectionView      : UICollectionView!
    private var collectionLayout    : UICollectionViewFlowLayout!
    private var dataSource          : DataSource!
    private var snapshot            : DataSourceSnapshot!

    private var favorites: [OMDBItemFullInfo] = [] {
        didSet { updateUI(with: favorites) }
    }
    private var segmentedControl: UISegmentedControl!

    private var subscriptions = Set<AnyCancellable>()

    let segmentTextContent = [
        Text.watchlist.disabled,
        Text.favorite.disabled,
        Text.checkIn.disabled
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleSegmentChange(segmentedControl)
    }

    private func setupView() {
        view.backgroundColor = .systemBackground

        setupSubviews()
        addSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        segmentedControl = UISegmentedControl(items: segmentTextContent)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.autoresizingMask = .flexibleWidth
        segmentedControl.frame = CGRect(x: 0, y: 0, width: 400, height: 30)
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)

        let padding: CGFloat                = 12
        let minimumItemSpacing: CGFloat     = 10
        let availableWidth                  = view.bounds.width - (padding * 3) - (minimumItemSpacing * 2)
        let itemWidth                       = availableWidth / 3

        collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        collectionLayout.itemSize = CGSize(width: itemWidth, height: 4/3 * itemWidth)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.delegate = self
        collectionView.register(ItemCardCell.self, forCellWithReuseIdentifier: ItemCardCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> ItemCardCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCardCell.reuseIdentifier, for: indexPath) as! ItemCardCell
            cell.setup(withImageURLSting: item.posterUrl)
            return cell
        })
    }

    private func addSubviews() {
        navigationItem.titleView = segmentedControl

        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.fill(in: view)
    }

    private func updateUI(with items: [OMDBItemFullInfo]) {
        navigationItem.prompt = NSLocalizedString("\(items.count) items in this list", comment: "")
        updateData(for: items)
    }

    private func updateData(for items: [OMDBItemFullInfo]) {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(favorites)

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    @objc
    private func handleSegmentChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            CXPersistantManager.getAll(.bookmarked, then: setter(for: self, \.favorites))
        case 1:
            CXPersistantManager.getAll(.favorited, then: setter(for: self, \.favorites))
        case 2:
            CXPersistantManager.getAll(.checkedIn, then: setter(for: self, \.favorites))
        default: return
        }
    }

}


extension LibraryViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        let vc = CXPreviewVC(itemID: item.imdbID, posterURLString: item.posterUrl)
        vc.delegate = self
        present(vc, animated: true)
    }

}


extension LibraryViewController: CXPreviewVCDelegate {

    func previewControllerWillDismiss(_ controller: CXPreviewVC) {
        handleSegmentChange(segmentedControl)
    }

}
