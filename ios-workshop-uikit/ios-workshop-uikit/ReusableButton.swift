//
//  ReusableButton.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import UIKit

class ReusableButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)

        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = .systemIndigo
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 18, weight: .semibold)
            return outgoing
        }
        self.configuration = config
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
