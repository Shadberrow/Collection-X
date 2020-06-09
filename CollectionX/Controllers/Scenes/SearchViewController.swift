//
//  SearchViewController.swift
//  CollectionX
//
//  Created by Yevhenii on 11.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import Combine
import YVAnchor

class SearchViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Section, OMDBItem>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, OMDBItem>

    enum Section {
        case main
    }

    private var subscriptions        = Set<AnyCancellable>()
    private var items                = [OMDBItem]() { didSet { updateData(for: items) } }
    @Published private var searchKey = ""

    private var searchController    : UISearchController!
    private var collectionView      : UICollectionView!
    private var collectionLayout    : UICollectionViewFlowLayout!
    private var dataSource          : DataSource!
    private var snapshot            : DataSourceSnapshot!
    private var searchPublisher     : AnyPublisher<OMDBSearchResponse, Error>!

    private var isStatusBarHidden   = false
    private var expandedCell        : ItemCardCell?

    private var page                : Int = 1
    private var hasMoreFollowers    : Bool = true
    private var isSearching         : Bool = false
    private var isLoading           : Bool = false

    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        searchController.searchBar.text = "Green"

    }

    private func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground

        setupSubviews()
        addSubviews()
        setupConstraints()

        setupDataLoader()
    }

    private func setupSubviews() {
        searchController = UISearchController()
        searchController.searchResultsUpdater   = self
        searchController.searchBar.placeholder  = "Search for a movie"

        let padding: CGFloat                = 12
        let minimumItemSpacing: CGFloat     = 10
        let availableWidth                  = view.bounds.width - (padding * 2) - (minimumItemSpacing * 1)
        let itemWidth                       = availableWidth / 2

        collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        collectionLayout.itemSize = CGSize(width: itemWidth, height: 4/3 * itemWidth)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.register(ItemCardCell.self, forCellWithReuseIdentifier: ItemCardCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> ItemCardCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCardCell.reuseIdentifier, for: indexPath) as! ItemCardCell
            cell.setup(withImageURLSting: item.poster)
            return cell
        })

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func addSubviews() {
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.fill(in: view)
    }

    private func updateData(for items: [OMDBItem]) {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)

        dataSource.apply(snapshot, animatingDifferences: true)

        isSearching = false
    }

    private func setupDataLoader() {
        AnyCancellable(
            $searchKey
                .removeDuplicates()
                .filter({ !$0.isEmpty })
                .debounce(for: 0.3, scheduler: RunLoop.current)
                .sink(receiveValue: { [weak self] _ in self?.searchMovie() }))
            .store(in: &subscriptions)
    }

    private func searchMovie() {
        searchPublisher = OMDBApi.search(.matching(query: searchKey, page: page))

        searchPublisher
            .receive(on: RunLoop.main)
            .tryMap({ Array(Set($0.items)) })
            .replaceError(with: [])
            .assign(to: \.items, on: self)
            .store(in: &subscriptions)
    }

}


extension SearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }
        searchKey = searchText
    }

}


extension SearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        let vc = CXPreviewVC(itemID: item.imdbID, posterURLString: item.poster)
        present(vc, animated: true)
    }

}


extension SearchViewController: RCardsCollectionLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width + 45, height: collectionView.frame.width)
    }

}
