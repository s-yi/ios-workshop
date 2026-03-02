//
//  LocalizationExampleView.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import SwiftUI

/// Demonstrates string localization in SwiftUI.
///
/// `Text()` and `.navigationTitle()` accept `LocalizedStringKey` by default,
/// so strings are extracted into the String Catalog automatically on build —
/// no extra wrapping needed.
///
/// Use `String(localized:)` when you need a plain `String` outside of a
/// `Text` view, such as for accessibility labels or UIKit interop.
struct LocalizationExampleView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {

                // MARK: - Text() auto-localization

                VStack(spacing: 12) {
                    Text("text_auto_localization_section_title")
                        .font(.system(size: 20, weight: .bold))

                    // Text() uses LocalizedStringKey automatically — no wrapping needed.
                    Text("hello_world")
                        .font(.system(size: 32, weight: .bold))

                    Text("text_auto_localization_description")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                Divider()

                Button {
                    dismiss()
                } label: {
                    ReusableButton(title: String(localized: "got_it", defaultValue: "Got It"))
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
        }
        // .navigationTitle() also uses LocalizedStringKey automatically.
        .navigationTitle("localization_example_title")
    }
}

#Preview {
    NavigationStack {
        LocalizationExampleView()
    }
}
