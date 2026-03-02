//
//  InteropExampleView.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import SwiftUI
import UIKit

// MARK: - A UIKit view controller to embed inside SwiftUI

/// A simple UIKit counter view controller built programmatically.
class EmbeddedUIKitViewController: UIViewController {

    private var counter = 0

    private let counterLabel: UILabel = {
        let label = UILabel()
        label.text = "Counter: 0"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let incrementButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Increment"
        config.baseBackgroundColor = .systemIndigo
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        return UIButton(configuration: config)
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "I'm a UIKit View"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo.withAlphaComponent(0.1)

        let stack = UIStackView(arrangedSubviews: [titleLabel, counterLabel, incrementButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        incrementButton.addTarget(self, action: #selector(incrementTapped), for: .touchUpInside)
    }

    @objc private func incrementTapped() {
        counter += 1
        counterLabel.text = "Counter: \(counter)"
    }
}

// MARK: - UIViewControllerRepresentable wrapper

/// Wraps a UIKit view controller so it can be used in SwiftUI.
/// Implement makeUIViewController to create it and updateUIViewController
/// to push data from SwiftUI into UIKit (unused here).
struct UIKitViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> EmbeddedUIKitViewController {
        EmbeddedUIKitViewController()
    }

    func updateUIViewController(_ uiViewController: EmbeddedUIKitViewController, context: Context) {}
}

// MARK: - SwiftUI interop screen

/// Demonstrates embedding a UIKit view controller inside SwiftUI
/// using UIViewControllerRepresentable.
struct InteropExampleView: View {
    var body: some View {
        UIKitViewControllerWrapper()
            .navigationTitle("SwiftUI → UIKit")
    }
}

#Preview {
    NavigationStack {
        InteropExampleView()
    }
}
