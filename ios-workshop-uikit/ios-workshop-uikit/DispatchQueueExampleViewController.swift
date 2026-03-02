//
//  DispatchQueueExampleViewController.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import UIKit

/// Demonstrates the two most common DispatchQueue patterns in UIKit:
///
/// 1. DispatchQueue.global() — runs work on a background thread, keeping the
///    main thread free to handle user interaction and rendering.
/// 2. DispatchQueue.main.async — hops back to the main thread to update UI
///    after background work finishes. Updating UI off the main thread is unsafe
///    and can cause crashes or visual glitches.
///
/// The "Block Main Thread" button intentionally runs the same work on the main
/// thread to demonstrate the UI freeze — the activity indicator won't animate
/// and taps won't register until the work completes.
///
/// Note: In modern Swift code, async/await + @MainActor is the preferred
/// approach (see TaskExampleViewController), but DispatchQueue is still widely
/// used and worth understanding.
class DispatchQueueExampleViewController: UIViewController {

    // MARK: - Views

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap the button to start"
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let threadLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let startButton = ReusableButton(title: "Start Background Work")
    private let stallButton = ReusableButton(title: "Block Main Thread")

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DispatchQueue"
        view.backgroundColor = .systemBackground
        setupViews()
    }

    // MARK: - Setup

    private func setupViews() {
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)

        stallButton.translatesAutoresizingMaskIntoConstraints = false
        stallButton.addTarget(self, action: #selector(stallButtonTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [statusLabel, threadLabel, activityIndicator, startButton, stallButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
        ])
    }

    // MARK: - Actions

    @objc private func stallButtonTapped() {
        // Running heavy work directly on the main thread blocks the run loop.
        // The UI freezes completely — the activity indicator won't spin, taps
        // won't register, and the label update below won't even appear until
        // the work finishes and the run loop gets control back.
        statusLabel.text = "Blocking main thread…"
        threadLabel.text = "Main thread: \(Thread.isMainThread)"
        startButton.isEnabled = false
        stallButton.isEnabled = false
        activityIndicator.startAnimating() // won't actually animate — main thread is stalled

        Thread.sleep(forTimeInterval: 2)
        let result = (1...1_000_000).reduce(0, +)

        activityIndicator.stopAnimating()
        statusLabel.text = "Result: \(result)"
        threadLabel.text = "Main thread the whole time: \(Thread.isMainThread)"
        startButton.isEnabled = true
        stallButton.isEnabled = true
    }

    @objc private func startButtonTapped() {
        startButton.isEnabled = false
        activityIndicator.startAnimating()
        statusLabel.text = "Working in background…"
        threadLabel.text = "Main thread: \(Thread.isMainThread)"

        // Dispatch work to a background thread so the main thread stays
        // responsive (scrolling, taps, animations continue uninterrupted).
        DispatchQueue.global(qos: .userInitiated).async {
            // --- background thread ---
            let isMainDuringWork = Thread.isMainThread
            Thread.sleep(forTimeInterval: 2)
            let result = (1...1_000_000).reduce(0, +)

            // UI updates MUST happen on the main thread.
            // DispatchQueue.main.async schedules the block back on the main queue.
            DispatchQueue.main.async { [weak self] in
                // --- main thread ---
                self?.activityIndicator.stopAnimating()
                self?.statusLabel.text = "Result: \(result)"
                self?.threadLabel.text = """
                    During work — main thread: \(isMainDuringWork)
                    After update — main thread: \(Thread.isMainThread)
                    """
                self?.startButton.isEnabled = true
            }
        }
    }
}

#Preview("DispatchQueueExampleViewController") {
    UINavigationController(rootViewController: DispatchQueueExampleViewController())
}
