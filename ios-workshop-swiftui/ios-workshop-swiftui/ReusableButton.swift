//
//  ReusableButton.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import SwiftUI

struct ReusableButton: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(.indigo)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ReusableButton(title: "Preview Button")
}
