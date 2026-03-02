//
//  ExampleLayoutView.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import SwiftUI

struct ExampleLayoutView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Title")
                .font(.system(size: 24, weight: .bold))

            Text("Subtitle")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)

            Spacer()

            Button("Button") {}
                .font(.system(size: 18, weight: .semibold))
                .frame(maxWidth: .infinity)
        }
        .padding(24)
        .navigationTitle("Example Layout")
    }
}

#Preview {
    NavigationStack {
        ExampleLayoutView()
    }
}
