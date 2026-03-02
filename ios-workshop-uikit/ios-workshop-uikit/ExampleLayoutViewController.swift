//
//  ExampleLayoutViewController.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import UIKit

class ExampleLayoutViewController: UIViewController {

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let button = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Example Layout"
        setupUI()
    }

    private func setupUI() {
        titleLabel.text = "Title"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)

        subtitleLabel.text = "Subtitle"
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textColor = .secondaryLabel

        button.setTitle("Button", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            UIView(),
            button
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
}

#Preview("ExampleLayoutViewController") {
    let vc = ExampleLayoutViewController()
    return UINavigationController(rootViewController: vc)
}
