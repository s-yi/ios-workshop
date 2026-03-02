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

    private let sectionLabel = SectionLabel(text: "Views Deepdive")

    private let exampleLayoutButton = ReusableButton(title: "Example in slides")
    private let layoutButton = ReusableButton(title: "More complex layout example")
    private let paginationButton = ReusableButton(title: "Recycling & Pagination example")
    private let interopButton = ReusableButton(title: "UIKit → SwiftUI Interop")
    private let assetsLocalizationLabel = SectionLabel(text: "Assets and Localization")
    private let imageButton = ReusableButton(title: "Image example")
    private let localizationButton = ReusableButton(title: "Localization example")

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
        stackView.addArrangedSubview(sectionLabel)
        stackView.addArrangedSubview(exampleLayoutButton)
        stackView.addArrangedSubview(layoutButton)
        stackView.addArrangedSubview(paginationButton)
        stackView.addArrangedSubview(interopButton)
        stackView.addArrangedSubview(assetsLocalizationLabel)
        stackView.addArrangedSubview(imageButton)
        stackView.addArrangedSubview(localizationButton)

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

