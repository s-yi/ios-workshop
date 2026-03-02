//
//  TaskExampleViewController.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import UIKit

// MARK: - Model

enum FoodCategory: String, CaseIterable {
    case fruits = "Fruits"
    case vegetables = "Vegetables"
    case grains = "Grains"
}

/// UIKit equivalent of TaskExampleView — demonstrates async/await with Task
/// in a view controller context.
///
/// Key differences from SwiftUI's .task:
/// - UIKit has no built-in task lifecycle, so we create a Task in viewDidAppear
///   and cancel it manually in viewDidDisappear — the equivalent of .task's
///   automatic cancellation on disappear.
/// - Storing the Task in a property lets us cancel the previous one before
///   starting a new one when the category changes — equivalent to .task(id:).
/// - UIViewController is @MainActor by default (like SwiftUI's View), so
///   @State-equivalent properties (UILabel text, UIActivityIndicatorView) are
///   safe to update directly after an await without DispatchQueue.main hops.
@MainActor
class TaskExampleViewController: UIViewController {

    // MARK: - State

    private var selectedCategory: FoodCategory = .fruits {
        didSet { fetch(category: selectedCategory) }
    }

    // Holds the current in-flight fetch. Cancelling it before starting a new
    // one mirrors .task(id:)'s automatic cancel-then-restart behaviour.
    private var fetchTask: Task<Void, Never>?

    // MARK: - Views

    private let segmentedControl: UISegmentedControl = {
        let items = FoodCategory.allCases.map(\.rawValue)
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private var items: [String] = [] {
        didSet { tableView.reloadData() }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Task"
        view.backgroundColor = .systemBackground
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Start the initial fetch when the view appears — equivalent to .task { }.
        fetch(category: selectedCategory)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Cancel the in-flight task when the view disappears — equivalent to
        // the automatic cancellation SwiftUI performs for .task { }.
        fetchTask?.cancel()
    }

    // MARK: - Fetch

    private func fetch(category: FoodCategory) {
        // Cancel the previous task before starting a new one — equivalent to
        // .task(id:) cancelling the prior task when the id value changes.
        fetchTask?.cancel()

        fetchTask = Task {
            activityIndicator.startAnimating()
            tableView.isHidden = true
            items = []

            do {
                // Task.sleep throws CancellationError when fetchTask.cancel()
                // is called. Catching it skips the state updates below so
                // stale results are never applied.
                try await Task.sleep(for: .seconds(1))
                items = Self.mockItems(for: category)
            } catch {
                // CancellationError or any real error — skip update.
            }

            activityIndicator.stopAnimating()
            tableView.isHidden = false
        }
    }

    // MARK: - Setup

    private func setupViews() {
        segmentedControl.addTarget(self, action: #selector(categoryChanged), for: .valueChanged)
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        let divider = UIView()
        divider.backgroundColor = .separator
        divider.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(segmentedControl)
        view.addSubview(divider)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            divider.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),

            tableView.topAnchor.constraint(equalTo: divider.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
        ])
    }

    @objc private func categoryChanged() {
        let index = segmentedControl.selectedSegmentIndex
        selectedCategory = FoodCategory.allCases[index]
    }

    // MARK: - Data

    private static func mockItems(for category: FoodCategory) -> [String] {
        switch category {
        case .fruits:      return ["Apple", "Banana", "Mango", "Strawberry", "Pineapple", "Peach"]
        case .vegetables:  return ["Carrot", "Broccoli", "Spinach", "Pepper", "Zucchini", "Kale"]
        case .grains:      return ["Rice", "Wheat", "Oats", "Quinoa", "Barley", "Millet"]
        }
    }
}

// MARK: - UITableViewDataSource

extension TaskExampleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}

#Preview("TaskExampleViewController") {
    UINavigationController(rootViewController: TaskExampleViewController())
}
