//
//  CXPreviewVC.swift
//  CollectionX
//
//  Created by Yevhenii on 03.06.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import Combine
import YVAnchor


protocol CXPreviewVCDelegate: class {
    func previewControllerDidDismiss(_ controller: CXPreviewVC)
    func previewControllerWillDismiss(_ controller: CXPreviewVC)
}

extension CXPreviewVCDelegate {
    func previewControllerDidDismiss(_ controller: CXPreviewVC) {}
    func previewControllerWillDismiss(_ controller: CXPreviewVC) {}
}


class CXPreviewVC: UIViewController {

    enum Section {
        static let HEADER_TITLE     = 0
        static let POSTER_INFO      = 1
        static let GENRE_INFO       = 2
        static let WRITER_INFO      = 3
        static let DIRECTOR_INFO    = 4
        static let ACTORS_INFO      = 5
    }

    private var backgroundImageView     : CachedImageView!
    private var backgroundBluredView    : UIVisualEffectView!
    private var tableView               : UITableView!
    private var closeButton             : CXCloseButton!
    private var actionsView             : ActionsView!
    private var actionsViewContainer    : UIView!

//    private var itemInfo                : OMDBItemFullInfo? { didSet { self.update() } }
    private var itemInfo                : ItemInfo? { didSet { self.update() } }
    private var item: Item?
    private var subscibers              = Set<AnyCancellable>()
//    private var dataPublisher           : AnyPublisher<OMDBItemFullInfo, Error>!
    private var dataPublisher           : AnyPublisher<ItemInfo, Error>!

    @Published private var isFavorited  : Bool = false
    @Published private var isWatchlist  : Bool = false
    @Published private var isCheckedIn  : Bool = false
    private var itemStatus = ItemStatus()

    weak var delegate: CXPreviewVCDelegate?

    private(set) var id: String
    private(set) var posterUrl: String

    init(itemID: String, posterURLString: String) {
        id = itemID
        posterUrl = posterURLString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.previewControllerDidDismiss(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.previewControllerWillDismiss(self)
    }

    private func setupView() {
        view.backgroundColor = .systemBackground

//        dataPublisher = OMDBApi.search(.imdbID(id))

        setupSubviews()
        addSubviews()
        setupConstraints()

        $isFavorited
            .receive(on: RunLoop.main)
            .assign(to: \.isFavorited, on: self.actionsView)
            .store(in: &subscibers)

        $isWatchlist
            .receive(on: RunLoop.main)
            .assign(to: \.isWatchlisted, on: self.actionsView)
            .store(in: &subscibers)

        $isCheckedIn
            .receive(on: RunLoop.main)
            .assign(to: \.isCheckedIn, on: self.actionsView)
            .store(in: &subscibers)

//        itemInfo = CXPersistantManager.get(itemID: id)
        item = try? CXDataManager.getItem(forID: id)
        itemInfo = item?.info
        if let status = try? CXDataManager.getItem(forID: id)?.status {
            itemStatus  = status
            isFavorited = status.isFavorited
            isWatchlist = status.isBookmarked
            isCheckedIn = status.isCheckedIn
        }

        fetchItemInfo()
    }

    private func setupSubviews() {
        backgroundImageView = CachedImageView()
        backgroundImageView.backgroundColor = .systemTeal
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.downloadImage(stringUrl: posterUrl)

        backgroundBluredView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))

        closeButton = CXCloseButton()
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)

        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(ItemPosterInfoCell.self, forCellReuseIdentifier: ItemPosterInfoCell.reuseIdentifier)
        tableView.register(ItemInfoCell.self, forCellReuseIdentifier: ItemInfoCell.reuseIdentifier)
        tableView.register(ItemTitleInfo.self, forCellReuseIdentifier: ItemTitleInfo.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension

        actionsView = ActionsView()
        actionsView.delegate = self

        actionsViewContainer = UIView()
        actionsViewContainer.backgroundColor = .systemGroupedBackground
        actionsViewContainer.layer.cornerRadius = 18
        actionsViewContainer.layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
        actionsViewContainer.layer.shadowRadius = 5
        actionsViewContainer.layer.shadowOpacity = 0.4
        actionsViewContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    private func addSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(backgroundBluredView)
        view.addSubview(tableView)
        view.addSubview(actionsViewContainer)
        actionsViewContainer.addSubview(actionsView)

        view.addSubview(closeButton)
    }

    private func setupConstraints() {
        backgroundImageView.fill(in: view)
        backgroundBluredView.fill(in: backgroundImageView)

        closeButton.pin(.top, to: view.top, constant: 8.5)
        closeButton.pin(.trailing, to: view.trailing, constant: 8.5)
        closeButton.square(45)

        tableView.pin(.top, to: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        tableView.pin(.bottom, to: actionsViewContainer.top, constant: 0)
        tableView.pin(.leading, to: view.leading)
        tableView.pin(.trailing, to: view.trailing)

        actionsViewContainer.pin(.top, to: actionsView.top, constant: -16)
        actionsViewContainer.pin(.leading, to: view.leading)
        actionsViewContainer.pin(.trailing, to: view.trailing)
        actionsViewContainer.pin(.bottom, to: view.bottom)

        actionsView.pin(.leading, to: view.leading, constant: 16)
        actionsView.pin(.trailing, to: view.trailing, constant: 16)
        actionsView.pin(.bottom, to: view.safeAreaLayoutGuide.bottomAnchor, constant: 16)
        actionsView.height(35)
    }

    @objc
    private func closeScreen() { dismiss(animated: true) }

    private func fetchItemInfo() {
        dataPublisher
            .receive(on: RunLoop.main)
            .compactMap({ $0 })
            .replaceError(with: .none)
            .assign(to: \.itemInfo, on: self)
            .store(in: &subscibers)
    }

    private func update() {
        guard let itemInfo = itemInfo else { return }
        item = Item(itemInfo)
        tableView.reloadData()
    }

    private func updateRating(value: Int) {
        guard let itemInfo = itemInfo else { return }
        itemStatus.userRating = value
        try? CXDataManager.set(rating: value, forItem: itemInfo)
    }

}


extension CXPreviewVC: ActionsViewDelegate {

    func actionViewFavoriteDidTapped() {
        guard let itemInfo = itemInfo else { return }
        let newState = !isFavorited
//        CXPersistantManager.set(status: .favorited, forItem: itemInfo, newState: newState) { self.isFavorited = newState }
        try? CXDataManager.set(status: .favorited(newState), forItem: itemInfo)
        isFavorited = newState
    }

    func actionViewWatchlistDidTapped() {
        guard let itemInfo = itemInfo else { return }
        let newState = !isWatchlist
//        CXPersistantManager.set(status: .checkedIn, forItem: itemInfo, newState: false) { self.isCheckedIn = false }
//        CXPersistantManager.set(status: .bookmarked, forItem: itemInfo, newState: newState) { self.isWatchlist = newState }
        try? CXDataManager.set(status: .checkedIn(false), forItem: itemInfo)
        try? CXDataManager.set(status: .bookmarked(newState), forItem: itemInfo)
        isCheckedIn = false
        isWatchlist = newState
    }

    func actionViewCheckInDidTapped() {
        guard let itemInfo = itemInfo else { return }
        let newState = !isCheckedIn
        try? CXDataManager.set(status: .bookmarked(false), forItem: itemInfo)
        try? CXDataManager.set(status: .checkedIn(newState), forItem: itemInfo)
        isWatchlist = false
        isCheckedIn = newState
    }

}


extension CXPreviewVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        // Need to consider this as separate enum
        return 2 + 1 + 1 + 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Section.HEADER_TITLE {
            guard let itemInfo = itemInfo else { return ItemTitleInfo() }
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemTitleInfo.reuseIdentifier, for: indexPath) as! ItemTitleInfo
            cell.setup(title: itemInfo.title, subtitle: itemInfo.prettySubinfo)
            return cell
        } else if indexPath.section == Section.POSTER_INFO {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemPosterInfoCell.reuseIdentifier, for: indexPath) as! ItemPosterInfoCell
            cell.setup(forItemInfo: item)
            cell.ratingDidUpdated = updateRating
            return cell
        } else if indexPath.section == Section.GENRE_INFO {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemInfoCell.reuseIdentifier, for: indexPath) as! ItemInfoCell
            cell.setup(title: "Genre", description: itemInfo?.genre ?? "N/A")
            return cell
        } else if indexPath.section == Section.WRITER_INFO {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemInfoCell.reuseIdentifier, for: indexPath) as! ItemInfoCell
            cell.setup(title: "Writer", description: itemInfo?.writer ?? "N/A")
            return cell
        } else if indexPath.section == Section.DIRECTOR_INFO {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemInfoCell.reuseIdentifier, for: indexPath) as! ItemInfoCell
            cell.setup(title: "Director", description: itemInfo?.director ?? "N/A")
            return cell
        } else if indexPath.section == Section.ACTORS_INFO {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemInfoCell.reuseIdentifier, for: indexPath) as! ItemInfoCell
            cell.setup(title: "Actors", description: itemInfo?.actors ?? "N/A")
            return cell
        } else { return UITableViewCell() }
    }

}
