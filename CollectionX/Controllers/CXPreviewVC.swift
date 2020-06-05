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

    private var backgroundImageView     : CachedImageView!
    private var backgroundBluredView    : UIVisualEffectView!
    private var tableView               : UITableView!
    private var closeButton             : CXCloseButton!
    private var actionsView             : ActionsView!
    private var actionsViewContainer    : UIView!

    private var titleLabel              : UILabel!
    private var subtitleLabel           : UILabel!

    private var itemInfo                : OMDBItemFullInfo? { didSet { self.update() } }
    private var subscibers              = Set<AnyCancellable>()
    private var dataPublisher           : AnyPublisher<OMDBItemFullInfo, Error>!

    @Published private var isFavorited  : Bool = false
    @Published private var isWatchlist  : Bool = false
    @Published private var isCheckedIn  : Bool = false

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

        dataPublisher = OMDBApi.search(endpoint: .imdbID(id))

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

        if let status = CXPersistantManager.status(forItem: id) {
            isFavorited = status.isFavorited
            isWatchlist = status.isBookmarked
            isCheckedIn = status.isCheckedIn
            itemInfo = CXPersistantManager.get(itemID: id)
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

        titleLabel = UILabel()
        titleLabel.text = "Loading..."
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.clipsToBounds = false

        subtitleLabel = UILabel()
        subtitleLabel.text = "Loading..."
        subtitleLabel.textColor = .label
        subtitleLabel.numberOfLines = 1
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(ItemPosterInfoCell.self, forCellReuseIdentifier: ItemPosterInfoCell.reuseIdentifier)
        tableView.register(ItemInfoCell.self, forCellReuseIdentifier: ItemInfoCell.reuseIdentifier)
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
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
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

        tableView.pin(.top, to: subtitleLabel.bottom, constant: 8)
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
        actionsView.height(45)

        titleLabel.pin(.top, to: view.top, constant: 16)
        titleLabel.pin(.leading, to: view.leading, constant: 16)
        titleLabel.pin(.trailing, to: closeButton.leading, constant: 8)

        subtitleLabel.pin(.leading, to: titleLabel.leading)
        subtitleLabel.pin(.trailing, to: titleLabel.trailing)
        subtitleLabel.pin(.top, to: titleLabel.bottom)
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
        print(itemInfo)
        titleLabel.text = itemInfo.title
        subtitleLabel.text = "\(itemInfo.prettyYear)   \(itemInfo.rated)   \(itemInfo.prettyRuntime)"
        tableView.reloadData()
    }

}


extension CXPreviewVC: ActionsViewDelegate {

    func actionViewFavoriteDidTapped() {
        guard let itemInfo = itemInfo else { return }
        let newState = !isFavorited
        CXPersistantManager.set(status: .favorited, forItem: itemInfo, newState: newState) { self.isFavorited = newState }
    }

    func actionViewWatchlistDidTapped() {
        guard let itemInfo = itemInfo else { return }
        let newState = !isWatchlist
        CXPersistantManager.set(status: .checkedIn, forItem: itemInfo, newState: false) { self.isCheckedIn = false }
        CXPersistantManager.set(status: .bookmarked, forItem: itemInfo, newState: newState) { self.isWatchlist = newState }
    }

    func actionViewCheckInDidTapped() {
        guard let itemInfo = itemInfo else { return }
        let newState = !isCheckedIn
        CXPersistantManager.set(status: .bookmarked, forItem: itemInfo, newState: false) { self.isWatchlist = false }
        CXPersistantManager.set(status: .checkedIn, forItem: itemInfo, newState: newState) { self.isCheckedIn = newState }
    }

}


extension CXPreviewVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 + 1 + 1 + 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemInfoCell.reuseIdentifier, for: indexPath) as! ItemInfoCell
            cell.setup(title: "Genre", description: itemInfo?.genre ?? "N/A")
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemPosterInfoCell.reuseIdentifier, for: indexPath) as! ItemPosterInfoCell
            cell.setup(forItemInfo: itemInfo)
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemInfoCell.reuseIdentifier, for: indexPath) as! ItemInfoCell
            cell.setup(title: "Writer", description: itemInfo?.writer ?? "N/A")
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemInfoCell.reuseIdentifier, for: indexPath) as! ItemInfoCell
            cell.setup(title: "Director", description: itemInfo?.director ?? "N/A")
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemInfoCell.reuseIdentifier, for: indexPath) as! ItemInfoCell
            cell.setup(title: "Actors", description: itemInfo?.actors ?? "N/A")
            return cell
        } else { return UITableViewCell() }
    }

}
