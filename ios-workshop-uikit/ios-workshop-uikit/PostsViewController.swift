//
//  PostsViewController.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import Combine
import Dependencies
import UIKit

// MARK: - ViewModel

class PostsViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded([Post])
        case failed(String)
    }

    @Published private(set) var state: State = .idle

    // @Dependency resolves the live, preview, or test value depending on context.
    // In production this calls the real API; in tests it can be overridden cheaply.
    @Dependency(\.postService) private var postService

    func fetchPosts() async {
        await MainActor.run { state = .loading }
        do {
            let posts = try await postService.fetchPosts()
            await MainActor.run { state = .loaded(posts) }
        } catch {
            await MainActor.run { state = .failed(error.localizedDescription) }
        }
    }
}

// MARK: - Protocol

protocol PostsViewModelProtocol: AnyObject {
    var statePublisher: AnyPublisher<PostsViewModel.State, Never> { get }
    func fetchPosts() async
}

extension PostsViewModel: PostsViewModelProtocol {
    var statePublisher: AnyPublisher<PostsViewModel.State, Never> {
        $state.eraseToAnyPublisher()
    }
}

// MARK: - ViewController

class PostsViewController: UIViewController {

    // MARK: - Dependencies

    private let viewModel: PostsViewModelProtocol
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: PostsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Views

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isHidden = true
        return tv
    }()

    private let errorView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.isHidden = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private var posts: [Post] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Posts"
        view.backgroundColor = .systemBackground
        setupViews()
        bindViewModel()
        Task { await viewModel.fetchPosts() }
    }

    // MARK: - Bindings

    private func bindViewModel() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.apply(state: state)
            }
            .store(in: &cancellables)
    }

    private func apply(state: PostsViewModel.State) {
        activityIndicator.stopAnimating()
        tableView.isHidden = true
        errorView.isHidden = true

        switch state {
        case .idle:
            break

        case .loading:
            activityIndicator.startAnimating()

        case .loaded(let posts):
            self.posts = posts
            tableView.reloadData()
            tableView.isHidden = false

        case .failed(let message):
            (errorView.arrangedSubviews.last as? UILabel)?.text = message
            errorView.isHidden = false
        }
    }

    // MARK: - Setup

    private func setupViews() {
        tableView.dataSource = self
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseID)

        let iconLabel = UILabel()
        iconLabel.text = "⚠️"
        iconLabel.font = .systemFont(ofSize: 40)

        let messageLabel = UILabel()
        messageLabel.font = .systemFont(ofSize: 15)
        messageLabel.textColor = .secondaryLabel
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center

        let retryButton = ReusableButton(title: "Retry")
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)

        errorView.addArrangedSubview(iconLabel)
        errorView.addArrangedSubview(messageLabel)
        errorView.addArrangedSubview(retryButton)

        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(errorView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
        ])
    }

    @objc private func retryTapped() {
        Task { await viewModel.fetchPosts() }
    }
}

// MARK: - UITableViewDataSource

extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseID, for: indexPath) as! PostCell
        cell.configure(with: posts[indexPath.row])
        return cell
    }
}

// MARK: - PostCell

private class PostCell: UITableViewCell {
    static let reuseID = "PostCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stack = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with post: Post) {
        titleLabel.text = post.title.capitalized
        bodyLabel.text = post.body
    }
}

// MARK: - Preview

#Preview("PostsViewController") {
    // withDependencies overrides postService for this preview scope only.
    let viewModel = withDependencies {
        $0.postService = .previewValue
    } operation: {
        PostsViewModel()
    }
    return UINavigationController(rootViewController: PostsViewController(viewModel: viewModel))
}
