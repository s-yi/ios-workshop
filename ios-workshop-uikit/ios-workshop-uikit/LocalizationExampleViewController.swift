//
//  LocalizationExampleViewController.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import UIKit

/// Demonstrates string localization in UIKit.
/// All user-visible strings are wrapped in String(localized:) so Xcode
/// extracts them into the String Catalog at build time. To add a new
/// language, open Localizable.xcstrings in Xcode and click "+" to add a locale.
class LocalizationExampleViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        return sv
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // String(localized:) works in stored property initializers too.
    private let sectionLabel = SectionLabel(text: String(localized: "localized_examples_section_title", defaultValue: "String(localized:) Examples"))

    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let actionButton = ReusableButton(title: String(localized: "got_it", defaultValue: "Got It"))

    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localized: "localization_example_title", defaultValue: "Localization Example")
        view.backgroundColor = .systemBackground
        setupViews()
    }

    private func setupViews() {
        greetingLabel.text = String(localized: "hello_world", defaultValue: "Hello, World!")
        descriptionLabel.text = String(localized: "localized_examples_description", defaultValue: "Use String(localized:) to wrap UIKit strings. Xcode extracts them into the String Catalog at build time, and you can add translations for any locale.")
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)

        stackView.addArrangedSubview(sectionLabel)
        stackView.addArrangedSubview(greetingLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(actionButton)

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 32),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -32),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -24),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])
    }

    @objc private func actionButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

#Preview("LocalizationExampleViewController") {
    UINavigationController(rootViewController: LocalizationExampleViewController())
}
