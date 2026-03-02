//
//  ImageExampleView.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import SwiftUI

/// Demonstrates loading an image from Assets.xcassets using Image(_:)
/// and displaying it with SwiftUI layout modifiers.
struct ImageExampleView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image("ExampleImage")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Text("image_example_caption")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
        }
        .navigationTitle("image_example_title")
    }
}

#Preview {
    NavigationStack {
        ImageExampleView()
    }
}
