//
//  PaginationViewController.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import UIKit

// MARK: - Data Model

struct ListItem {
    let id: Int
    let title: String
    let subtitle: String
}

// MARK: - Collection View Cell

/// A reusable cell that displays a circular avatar with a number, a title, and a subtitle.
class RowCell: UICollectionViewCell {

    static let reuseIdentifier = "RowCell"

    private let avatarLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemIndigo
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let avatarCircle: UIView = {
        let view = UIView()
        view.backgroundColor = .systemIndigo.withAlphaComponent(0.2)
        view.layer.cornerRadius = 22
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(avatarCircle)
        avatarCircle.addSubview(avatarLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            // Avatar circle: 44x44, pinned to the leading edge, vertically centered
            avatarCircle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarCircle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarCircle.widthAnchor.constraint(equalToConstant: 44),
            avatarCircle.heightAnchor.constraint(equalToConstant: 44),

            // Avatar number label: centered inside the circle
            avatarLabel.centerXAnchor.constraint(equalTo: avatarCircle.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarCircle.centerYAnchor),

            // Title: to the right of the avatar, pinned to the top of the cell
            titleLabel.leadingAnchor.constraint(equalTo: avatarCircle.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            // Subtitle: below the title, pinned to the bottom to allow self-sizing
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    func configure(with item: ListItem) {
        avatarLabel.text = "\(item.id + 1)"
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }
}

// MARK: - Pagination View Controller

/// Demonstrates infinite-scroll pagination using UICollectionView.
/// New pages of items are loaded when the user scrolls to the last visible cell.
class PaginationViewController: UIViewController {

    private var items: [ListItem] = []
    private let pageSize = 20
    private let maxItems = 100

    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Pagination"
        setupCollectionView()
        loadMore()
    }

    private func setupCollectionView() {
        // Compositional layout: single column, self-sizing rows with 8pt spacing
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(60)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            return section
        }

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RowCell.self, forCellWithReuseIdentifier: RowCell.reuseIdentifier)

        view.addSubview(collectionView)

        // Pin collection view edge-to-edge
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    /// Appends the next page of items. Stops once maxItems is reached.
    private func loadMore() {
        let start = items.count
        guard start < maxItems else { return }
        let newItems = (start..<start + pageSize).map { index in
            ListItem(id: index, title: "Item \(index + 1)", subtitle: "Description for item \(index + 1)")
        }
        items.append(contentsOf: newItems)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension PaginationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RowCell.reuseIdentifier, for: indexPath) as! RowCell
        cell.configure(with: items[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PaginationViewController: UICollectionViewDelegate {
    /// Triggers pagination when the last item is about to be displayed
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == items.count - 1 {
            loadMore()
        }
    }
}

#Preview("PaginationViewController") {
    UINavigationController(rootViewController: PaginationViewController())
}
