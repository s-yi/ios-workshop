//
//  ModalView.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import SwiftUI

struct ModalView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("Modal Screen")
                .font(.system(size: 28, weight: .bold))

            Text("Presented modally using .sheet()")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button {
                dismiss()
            } label: {
                ReusableButton(title: "Dismiss")
            }
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    ModalView()
}
