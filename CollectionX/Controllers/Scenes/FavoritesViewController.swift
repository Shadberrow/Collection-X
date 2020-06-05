//
//  FavoritesViewController.swift
//  CollectionX
//
//  Created by Yevhenii on 11.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import Combine
import YVAnchor

class FavoritesViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

    private var tableView: UITableView!
    private var favorites: [OMDBItemFullInfo] = []

    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retreiveFavorites()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground

        setupSubviews()
        addSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteItemCell.self, forCellReuseIdentifier: FavoriteItemCell.reuseIdentifier)
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        tableView.fill(in: view)
    }

    private func retreiveFavorites() {
        CXPersistantManager.getAll(.favorited, completion: { [weak self] items in
            self?.updateUI(with: items)
        })
    }

    private func updateUI(with items: [OMDBItemFullInfo]) {
        favorites = items
        DispatchQueue.main.async { self.tableView.reloadData() }
    }

}

// MARK: - Table View Data Source / Delegate

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteItemCell.reuseIdentifier, for: indexPath) as! FavoriteItemCell
        cell.setup(with: favorites[indexPath.item])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = favorites[indexPath.row]
        let vc = CXPreviewVC(itemID: item.imdbID, posterURLString: item.posterUrl)
        vc.delegate = self
        present(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 + 8 + 8
    }

}


extension FavoritesViewController: CXPreviewVCDelegate {

    func previewControllerWillDismiss(_ controller: CXPreviewVC) {
        retreiveFavorites()
    }

}
