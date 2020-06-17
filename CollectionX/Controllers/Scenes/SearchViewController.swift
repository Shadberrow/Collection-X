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

    enum Section { case main }

    private var subscriptions        = Set<AnyCancellable>()
    private var items                = [OMDBItem]() { didSet { updateData(for: items) } }
    private var movies               = [OMDBItem]()
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
        searchController.obscuresBackgroundDuringPresentation = false

        collectionLayout = CollecitonLayout.createThreeItemLayout(forFrame: view.bounds)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.register(ItemCardCell.self, forCellWithReuseIdentifier: ItemCardCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.keyboardDismissMode = .onDrag

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
//        movies.append(contentsOf: items)

        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func setupDataLoader() {
        AnyCancellable(
            $searchKey
                .removeDuplicates()
                .filter({ !$0.isEmpty })
                .debounce(for: 0.5, scheduler: RunLoop.current)
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

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let heiht = scrollView.frame.size.height
//
//        if offsetY > contentHeight - heiht {
//            guard hasMoreItems, !isLoading else { return }
//            page += 1
//            searchMovie()
//        }
    }

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
