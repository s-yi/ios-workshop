//
//  ImageExampleViewController.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import UIKit

/// Demonstrates loading an image from Assets.xcassets using UIImage(named:)
/// and displaying it in a UIImageView.
class ImageExampleViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        return sv
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let imageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "ExampleImage"))
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localized: "image_example_title", defaultValue: "Image Example")
        view.backgroundColor = .systemBackground
        setupViews()
    }

    private func setupViews() {
        captionLabel.text = String(localized: "image_example_caption", defaultValue: "Loaded from Assets.xcassets using UIImage(named:)")

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(captionLabel)

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -24),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 2.0 / 3.0),
        ])
    }
}

#Preview("ImageExampleViewController") {
    UINavigationController(rootViewController: ImageExampleViewController())
}
