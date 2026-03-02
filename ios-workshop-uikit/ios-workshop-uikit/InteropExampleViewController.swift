//
//  InteropExampleViewController.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import UIKit
import SwiftUI

// MARK: - A SwiftUI view to embed inside UIKit

struct EmbeddedSwiftUIView: View {
    @State private var counter = 0

    var body: some View {
        VStack(spacing: 16) {
            Text("I'm a SwiftUI View")
                .font(.system(size: 20, weight: .bold))

            Text("Counter: \(counter)")
                .font(.system(size: 32, weight: .bold))

            Button("Increment") {
                counter += 1
            }
            .font(.system(size: 18, weight: .semibold))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.indigo.opacity(0.1))
    }
}

// MARK: - UIKit ViewController hosting a SwiftUI view

/// Demonstrates embedding a SwiftUI view inside a UIKit view controller
/// using UIHostingController. Add the hosting controller as a child VC
/// and pin its view to fill the parent.
class InteropExampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "UIKit → SwiftUI"

        let hostingController = UIHostingController(rootView: EmbeddedSwiftUIView())
        addChild(hostingController)
        view.addSubview(hostingController.view)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        hostingController.didMove(toParent: self)
    }
}

#Preview("InteropExampleViewController") {
    UINavigationController(rootViewController: InteropExampleViewController())
}
