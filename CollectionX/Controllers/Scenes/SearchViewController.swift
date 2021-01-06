//
//  SearchViewController.swift
//  CollectionX
//
//  Created by Yevhenii Veretennikov on 07.11.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    private let viewModel           : SearchViewModelProtocol
    private var searchController    : UISearchController!
    private var collectionView      : UICollectionView!
    private var collectionLayout    : UICollectionViewLayout!
    
    private var movies              = [APISearchItem]()
    private var subscriptions       = Set<AnyCancellable>()
    
    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        setupSubviews()
        addSubviews()
        setupConstraints()
        
        searchController.searchBar.searchTextField
            .addTarget(self, action: #selector(handleSearch), for: .editingChanged)
        
        viewModel.dataPublisher.sink { [weak self] items in
            self?.process(items)
        }.store(in: &subscriptions)
    }
    
    private func setupSubviews() {
        searchController = UISearchController()
        searchController.searchBar.placeholder = "Search for a movie or show"
        searchController.obscuresBackgroundDuringPresentation = false
        
        collectionLayout = CollecitonLayout.makeCollectionViewLayout()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.register(ItemCardCell.self, forCellWithReuseIdentifier: ItemCardCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        collectionView.dataSource = self

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let top = collectionView.topAnchor.constraint(equalTo: view.topAnchor)
        let bottom = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let leading = collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        NSLayoutConstraint.activate([ top, bottom, leading, trailing ])
    }
    
    @objc
    func handleSearch(_ sender: UITextField) {
        guard let text = sender.text else { return }
        movies.removeAll()
        viewModel.search(key: text)
    }
    
    private func updateColletion() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func process(_ items: [APISearchItem]) {
        movies.append(contentsOf: items)
        updateColletion()
    }
}


extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCardCell.reuseIdentifier, for: indexPath) as! ItemCardCell
        cell.setup(with: movies[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(movies[indexPath.item].imdbID, movies[indexPath.item].poster)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
            viewModel.searchNextPage()
        }
    }
    
}
