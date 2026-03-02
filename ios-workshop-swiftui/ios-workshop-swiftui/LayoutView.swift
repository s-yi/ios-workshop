//
//  LayoutView.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import SwiftUI

struct LayoutView: View {
    var body: some View {
        VStack(spacing: 0) {

            // Header label — top of the screen with horizontal padding
            Text("Welcome to Layouts")
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                .padding(.horizontal, 24)

            // Card view — 16:9 aspect ratio with inner padding
            VStack(alignment: .leading, spacing: 8) {
                Text("Featured Card")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)

                Text("This card demonstrates padding, aspect ratio, and nested constraints.")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .aspectRatio(16 / 9, contentMode: .fit)
            .background(.indigo)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.top, 24)
            .padding(.horizontal, 24)

            // Horizontal row of equally sized colored boxes
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.red)
                    .frame(height: 60)

                RoundedRectangle(cornerRadius: 8)
                    .fill(.green)
                    .frame(height: 60)

                RoundedRectangle(cornerRadius: 8)
                    .fill(.blue)
                    .frame(height: 60)
            }
            .padding(.top, 32)
            .padding(.horizontal, 24)

            Spacer()

            // Footer label — pinned to the bottom
            Text("Pinned to bottom safe area")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .padding(.bottom, 16)
        }
        .navigationTitle("Layout")
    }
}

#Preview {
    NavigationStack {
        LayoutView()
    }
}
