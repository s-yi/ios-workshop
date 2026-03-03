//
//  CounterViewController.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import UIKit
import Combine

// MARK: - Protocol

/// Defines the interface between CounterViewController and its ViewModel.
/// Exposes count as an AnyPublisher rather than @Published directly —
/// protocols cannot carry property wrappers, so the concrete implementation
/// erases its @Published property to AnyPublisher at the boundary.
protocol CounterViewModelProtocol: AnyObject {
    var countPublisher: AnyPublisher<Int, Never> { get }
    func increment()
    func decrement()
    func reset()
}

// MARK: - ViewModel

/// The ViewModel exposes state as @Published properties.
/// Any subscriber (the ViewController) receives a new value on the main thread
/// via .receive(on: DispatchQueue.main) and updates the UI accordingly.
class CounterViewModel: ObservableObject, CounterViewModelProtocol {
    @Published private(set) var count = 0

    // Erases the @Published projected value to the protocol's AnyPublisher type.
    var countPublisher: AnyPublisher<Int, Never> { $count.eraseToAnyPublisher() }

    func increment() { count += 1 }
    func decrement() { count -= 1 }
    func reset()     { count = 0 }
}

// MARK: - ViewController

/// Demonstrates MVVM with Combine and protocol-based injection in UIKit.
///
/// Key points:
/// - CounterViewController depends on CounterViewModelProtocol, not the concrete
///   class — making it testable and swappable without changing the ViewController.
/// - The ViewModel is injected through the initializer (constructor injection).
/// - @Published + sink replaces manual delegation or callbacks.
/// - Subscriptions are stored in a Set<AnyCancellable> and automatically
///   cancelled when the ViewController is deallocated.
/// - .receive(on: DispatchQueue.main) ensures UI updates happen on the main thread
///   even if the publisher emits from a background thread.
class CounterViewController: UIViewController {

    // MARK: - Dependencies

    private let viewModel: CounterViewModelProtocol
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: CounterViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Views

    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 72, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let decrementButton = ReusableButton(title: "−")
    private let incrementButton = ReusableButton(title: "+")

    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.tintColor = .secondaryLabel
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Counter"
        view.backgroundColor = .systemBackground
        setupViews()
        bindViewModel()
    }

    // MARK: - Bindings

    private func bindViewModel() {
        // sink receives a new value every time count changes and updates the label.
        // .receive(on:) ensures this runs on the main thread.
        // The AnyCancellable is stored so the subscription lives as long as the VC.
        viewModel.countPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] count in
                self?.countLabel.text = "\(count)"
            }
            .store(in: &cancellables)
    }

    // MARK: - Setup

    private func setupViews() {
        decrementButton.translatesAutoresizingMaskIntoConstraints = false
        incrementButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false

        decrementButton.addTarget(self, action: #selector(decrementTapped), for: .touchUpInside)
        incrementButton.addTarget(self, action: #selector(incrementTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)

        let buttonRow = UIStackView(arrangedSubviews: [decrementButton, incrementButton])
        buttonRow.spacing = 16
        buttonRow.alignment = .center

        let stack = UIStackView(arrangedSubviews: [countLabel, buttonRow, resetButton])
        stack.axis = .vertical
        stack.spacing = 24
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

    @objc private func incrementTapped() { viewModel.increment() }
    @objc private func decrementTapped() { viewModel.decrement() }
    @objc private func resetTapped()     { viewModel.reset() }
}

#Preview("CounterViewController") {
    UINavigationController(rootViewController: CounterViewController(viewModel: CounterViewModel()))
}
