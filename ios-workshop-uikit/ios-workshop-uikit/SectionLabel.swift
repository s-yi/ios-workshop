//
//  SectionLabel.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import UIKit

class SectionLabel: UILabel {

    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        font = .systemFont(ofSize: 20, weight: .bold)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
