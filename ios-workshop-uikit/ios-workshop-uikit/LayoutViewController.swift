//
//  LayoutViewController.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import UIKit

class LayoutViewController: UIViewController {

    // MARK: - Header

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Layouts"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Card view with fixed aspect ratio

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemIndigo
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let cardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Featured Card"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cardSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "This card demonstrates padding, aspect ratio, and nested constraints."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white.withAlphaComponent(0.8)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Horizontal row of colored boxes

    private let redBox: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let greenBox: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let blueBox: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Bottom pinned label

    private let footerLabel: UILabel = {
        let label = UILabel()
        label.text = "Pinned to bottom safe area"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Layout"
        setupViews()
    }

    // MARK: - Layout Setup

    private func setupViews() {
        view.addSubview(headerLabel)
        view.addSubview(cardView)
        cardView.addSubview(cardTitleLabel)
        cardView.addSubview(cardSubtitleLabel)
        view.addSubview(redBox)
        view.addSubview(greenBox)
        view.addSubview(blueBox)
        view.addSubview(footerLabel)

        NSLayoutConstraint.activate([

            // -- Header label --
            // Pin to top safe area with 20pt padding, stretch horizontally with 24pt margins
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            // -- Card view --
            // Positioned 24pt below header, with horizontal margins of 24pt
            cardView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            // 16:9 aspect ratio — height is 9/16 of width
            cardView.heightAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 9.0 / 16.0),

            // -- Card title (inside card) --
            // Pinned to top-leading corner of card with 16pt insets
            cardTitleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            cardTitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            cardTitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            // -- Card subtitle (inside card) --
            // Below the title with 8pt spacing, same horizontal padding, pinned to bottom
            cardSubtitleLabel.topAnchor.constraint(equalTo: cardTitleLabel.bottomAnchor, constant: 8),
            cardSubtitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            cardSubtitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            // -- Colored boxes row --
            // All three boxes are 32pt below the card, same height (60pt), and equally spaced
            redBox.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 32),
            redBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            redBox.heightAnchor.constraint(equalToConstant: 60),

            greenBox.topAnchor.constraint(equalTo: redBox.topAnchor),
            greenBox.leadingAnchor.constraint(equalTo: redBox.trailingAnchor, constant: 12),
            greenBox.heightAnchor.constraint(equalToConstant: 60),
            // Equal width to redBox — all three boxes share the same width
            greenBox.widthAnchor.constraint(equalTo: redBox.widthAnchor),

            blueBox.topAnchor.constraint(equalTo: redBox.topAnchor),
            blueBox.leadingAnchor.constraint(equalTo: greenBox.trailingAnchor, constant: 12),
            blueBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            blueBox.heightAnchor.constraint(equalToConstant: 60),
            // Equal width to redBox — ensures all three boxes divide the space evenly
            blueBox.widthAnchor.constraint(equalTo: redBox.widthAnchor),

            // -- Footer label --
            // Pinned to bottom safe area, centered horizontally
            footerLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            footerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}

#Preview("LayoutViewController") {
    let vc = LayoutViewController()
    return UINavigationController(rootViewController: vc)
}
