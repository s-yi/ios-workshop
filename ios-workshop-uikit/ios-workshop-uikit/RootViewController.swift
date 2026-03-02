//
//  ViewController.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let layoutButton = ReusableButton(title: "Go to Layout")

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
        stackView.addArrangedSubview(layoutButton)
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        layoutButton.addTarget(self, action: #selector(layoutButtonTapped), for: .touchUpInside)
    }

    @objc private func layoutButtonTapped() {
        let layoutVC = LayoutViewController()
        navigationController?.pushViewController(layoutVC, animated: true)
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

