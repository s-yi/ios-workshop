//
//  ViewController.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

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
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let assetsLocalizationLabel = SectionLabel(text: "Assets and Localization")
    private let imageButton = ReusableButton(title: "Image example")
    private let localizationButton = ReusableButton(title: "Localization example")
    private let concurrencySectionLabel = SectionLabel(text: "Concurrency")
    private let taskButton = ReusableButton(title: "Task example")
    private let dispatchQueueButton = ReusableButton(title: "DispatchQueue example")
    private let viewsDeepDiveLabel = SectionLabel(text: "Views Deepdive")

    private let exampleLayoutButton = ReusableButton(title: "Example in slides")
    private let layoutButton = ReusableButton(title: "More complex layout example")
    private let paginationButton = ReusableButton(title: "Recycling & Pagination example")
    private let interopButton = ReusableButton(title: "UIKit → SwiftUI Interop")
    private let navigationSectionLabel = SectionLabel(text: "Navigation")
    private let modalButton = ReusableButton(title: "Modal")
    private let viewModelSectionLabel = SectionLabel(text: "ViewModel")
    private let counterButton = ReusableButton(title: "Counter (MVVM)")
    private let postsButton = ReusableButton(title: "Posts (MVVM + DI)")

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("RootViewController - init")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("RootViewController - init(coder:)")
    }

    deinit {
        print("RootViewController - deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Root"
        view.backgroundColor = .systemBackground
        setupViews()
        print("RootViewController - viewDidLoad")
    }

    private func setupViews() {
        stackView.addArrangedSubview(assetsLocalizationLabel)
        stackView.addArrangedSubview(imageButton)
        stackView.addArrangedSubview(localizationButton)
        stackView.addArrangedSubview(concurrencySectionLabel)
        stackView.addArrangedSubview(taskButton)
        stackView.addArrangedSubview(dispatchQueueButton)
        stackView.addArrangedSubview(viewModelSectionLabel)
        stackView.addArrangedSubview(counterButton)
        stackView.addArrangedSubview(postsButton)
        stackView.addArrangedSubview(viewsDeepDiveLabel)
        stackView.addArrangedSubview(exampleLayoutButton)
        stackView.addArrangedSubview(layoutButton)
        stackView.addArrangedSubview(paginationButton)
        stackView.addArrangedSubview(interopButton)
        stackView.addArrangedSubview(navigationSectionLabel)
        stackView.addArrangedSubview(modalButton)

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 32),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -32),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])

        layoutButton.addTarget(self, action: #selector(layoutButtonTapped), for: .touchUpInside)
        exampleLayoutButton.addTarget(self, action: #selector(exampleLayoutButtonTapped), for: .touchUpInside)
        paginationButton.addTarget(self, action: #selector(paginationButtonTapped), for: .touchUpInside)
        interopButton.addTarget(self, action: #selector(interopButtonTapped), for: .touchUpInside)
        modalButton.addTarget(self, action: #selector(modalButtonTapped), for: .touchUpInside)
        taskButton.addTarget(self, action: #selector(taskButtonTapped), for: .touchUpInside)
        postsButton.addTarget(self, action: #selector(postsButtonTapped), for: .touchUpInside)
        counterButton.addTarget(self, action: #selector(counterButtonTapped), for: .touchUpInside)
        dispatchQueueButton.addTarget(self, action: #selector(dispatchQueueButtonTapped), for: .touchUpInside)
        imageButton.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        localizationButton.addTarget(self, action: #selector(localizationButtonTapped), for: .touchUpInside)
    }

    @objc private func layoutButtonTapped() {
        let layoutVC = LayoutViewController()
        navigationController?.pushViewController(layoutVC, animated: true)
    }

    @objc private func exampleLayoutButtonTapped() {
        let exampleVC = ExampleLayoutViewController()
        navigationController?.pushViewController(exampleVC, animated: true)
    }

    @objc private func paginationButtonTapped() {
        let paginationVC = PaginationViewController()
        navigationController?.pushViewController(paginationVC, animated: true)
    }

    @objc private func interopButtonTapped() {
        let interopVC = InteropExampleViewController()
        navigationController?.pushViewController(interopVC, animated: true)
    }

    @objc private func modalButtonTapped() {
        let modalVC = ModalViewController()
        present(modalVC, animated: true)
    }

    @objc private func taskButtonTapped() {
        let taskVC = TaskExampleViewController()
        navigationController?.pushViewController(taskVC, animated: true)
    }

    @objc private func postsButtonTapped() {
        let postsVC = PostsViewController(viewModel: PostsViewModel())
        navigationController?.pushViewController(postsVC, animated: true)
    }

    @objc private func counterButtonTapped() {
        let counterVC = CounterViewController(viewModel: CounterViewModel())
        navigationController?.pushViewController(counterVC, animated: true)
    }

    @objc private func dispatchQueueButtonTapped() {
        let dqVC = DispatchQueueExampleViewController()
        navigationController?.pushViewController(dqVC, animated: true)
    }

    @objc private func imageButtonTapped() {
        let imageVC = ImageExampleViewController()
        navigationController?.pushViewController(imageVC, animated: true)
    }

    @objc private func localizationButtonTapped() {
        let localizationVC = LocalizationExampleViewController()
        navigationController?.pushViewController(localizationVC, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("RootViewController - viewWillAppear")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("RootViewController - viewDidAppear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("RootViewController - viewWillDisappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("RootViewController - viewDidDisappear")
    }

}

