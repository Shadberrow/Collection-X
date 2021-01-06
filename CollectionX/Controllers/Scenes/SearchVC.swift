//
//  SearchVC.swift
//  CollectionX
//
//  Created by Yevhenii on 17.06.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import YVAnchor
import Combine


//class SearchViewModel {
//
//    @Published var searchKey: String = String() { didSet { handleSearchKeyChanged() } }
//    @Published var searchItems: [OMDBItem] = [] { didSet { handleNewItemsFetched() } }
//
//    private var page: Int = 1 { didSet { search() } }
//    private var totalPages: Int = 0
//    private var isLoading: Bool = false
//    private var hasMoreToLoad: Bool = true
//
//    private var searchPublisher : AnyPublisher<OMDBSearchResponse, Error>!
//    private var newSearchPublisher : AnyPublisher<TMDBResponse, Error>!
//    private var subscriptions = Set<AnyCancellable>()
//
//    private func search() {
//        if searchKey.isEmpty || isLoading { return }
//
//        isLoading = true
//
////        searchPublisher = OMDBApi.search(.matching(query: searchKey, page: page))
//
//        newSearchPublisher = TMDApi.search(.matching(query: searchKey, page: page))
//        
//        newSearchPublisher
//            .receive(on: RunLoop.main)
//            .sink(
//                receiveCompletion: { completion in print(completion) },
//                receiveValue: { [weak self] value in
//                    guard let self = self else { return }
//                    self.totalPages = value.totalPages
//                }
//            )
//            .store(in: &subscriptions)
//        
////        searchPublisher
////            .receive(on: RunLoop.main)
////            .tryMap({ Array(Set($0.items)) })
////            .replaceError(with: [])
////            .assign(to: \SearchViewModel.searchItems, on: self)
////            .store(in: &subscriptions)
//    }
//
//    private func handleSearchKeyChanged() {
//        page = 1
//        hasMoreToLoad = true
//        search()
//    }
//
//    private func handleNewItemsFetched() {
//        isLoading = false
//
//        if searchItems.count < 10 {
//            hasMoreToLoad = false
//        }
//    }
//
//    func loadNextPage() {
//        if searchPublisher == nil { return }
//        if !hasMoreToLoad { return }
//        page += isLoading ? 0 : 1
//    }
//
//}
//
//
//class SearchVC: UIViewController, Bindable {
//
//    typealias CollectionItem        = MovieItem
//    typealias ViewModel             = SearchViewModel
//    typealias DataSource            = UICollectionViewDiffableDataSource<Section, CollectionItem>
//    typealias DataSourceSnapshot    = NSDiffableDataSourceSnapshot<Section, CollectionItem>
//
//    enum Section { case main }
//
//    var viewModel                   : SearchViewModel!
//
//    private var searchController    : UISearchController!
//    private var collectionView      : UICollectionView!
//    private var collectionLayout    : UICollectionViewLayout!
//
//    private var dataSource          : DataSource!
//    private var movies              = [CollectionItem]()
//
//    private var subscriptions       = Set<AnyCancellable>()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//    }
//
//    private func setupView() {
//        view.backgroundColor = .systemBackground
//
//        setupSubviews()
//        addSubviews()
//        setupConstraints()
//
//        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
//                                                        cellProvider: setupCollection)
//    }
//
//    private func setupSubviews() {
//        searchController = UISearchController()
//        searchController.searchBar.placeholder  = "Search for a movie or show"
//        searchController.obscuresBackgroundDuringPresentation = false
//
//        collectionLayout = CollecitonLayout.makeCollectionViewLayout()//CollecitonLayout.createThreeItemLayout(forFrame: view.bounds)
//
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
//        collectionView.register(ItemCardCell.self, forCellWithReuseIdentifier: ItemCardCell.reuseIdentifier)
//        collectionView.backgroundColor = .systemBackground
//        collectionView.keyboardDismissMode = .onDrag
//        collectionView.delegate = self
//
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
//    }
//
//    private func addSubviews() {
//        view.addSubview(collectionView)
//    }
//
//    private func setupConstraints() {
//        collectionView.fill(in: view)
//    }
//
//    func bindViewModel() {
//
//        NotificationCenter.default
//            .publisher(for: UITextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
//            .compactMap({ ($0.object as? UITextField)?.text })
//            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
//            .receive(on: RunLoop.main)
//            .assign(to: \SearchViewModel.searchKey, on: viewModel)
//            .store(in: &subscriptions)
//
////        viewModel.$searchItems.sink { [weak self] items in
////            self?.updateList(with: items)
////        }.store(in: &subscriptions)
//
//        viewModel.$searchKey.sink { [weak self] value in
//            self?.movies.removeAll()
//            self?.updateCollection(on: [])
//        }.store(in: &subscriptions)
//        
//    }
//
//    private func updateList(with items: [CollectionItem]) {
//        movies.append(contentsOf: items)
//
//        updateCollection(on: movies)
//    }
//
//    private func updateCollection(on items: [CollectionItem]) {
//        var snapshot = DataSourceSnapshot()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(items)
//
//        dataSource.apply(snapshot, animatingDifferences: true)
//    }
//
//    private func setupCollection(_ collectionView: UICollectionView, indexPath: IndexPath, item: CollectionItem) -> ItemCardCell? {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCardCell.reuseIdentifier, for: indexPath) as! ItemCardCell
//        cell.setup(withImageURLSting: item.imageUrl)
//        return cell
//    }
//
//}
//
//
//extension SearchVC: UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
////        let vc = CXPreviewVC(itemID: item, posterURLString: item.imageUrl)
////        present(vc, animated: true)
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
//            viewModel.loadNextPage()
//        }
//    }
//
//}
