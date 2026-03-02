//
//  EquatableExampleView.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import SwiftUI

// MARK: - Child View

/// A child view that conforms to Equatable.
/// SwiftUI uses the `==` function to decide whether to re-evaluate body.
/// When `==` returns true, SwiftUI skips the body. When false, it re-evaluates.
///
/// **Try this:** Change `lhs.name == rhs.name` to `lhs.name != rhs.name` (always
/// returns false for the same name). Tap "Increment Counter" and watch
/// "ExpensiveRow body evaluated" print on every tap — even though nothing changed.
/// Change it back to `==` to see it stop.
struct ExpensiveRow: View, Equatable {
    let name: String

    static func == (lhs: ExpensiveRow, rhs: ExpensiveRow) -> Bool {
        // Returning true = SwiftUI skips body. Returning false = body re-evaluates.
        // Change == to != here to force unnecessary re-renders.
        lhs.name == rhs.name
    }

    var body: some View {
        let _ = print("  -> ExpensiveRow body evaluated")
        Text(name)
            .font(.system(size: 16, weight: .medium))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(.indigo.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Parent View

struct EquatableExampleView: View {
    @State private var counter = 0

    var body: some View {
        let _ = print("Parent body evaluated (counter: \(counter))")

        VStack(spacing: 24) {
            Text("Counter: \(counter)")
                .font(.system(size: 32, weight: .bold))

            Button("Increment Counter") {
                counter += 1
            }
            .font(.system(size: 18, weight: .semibold))

            Divider()

            // SwiftUI uses ExpensiveRow's Equatable conformance to decide
            // whether to re-render. Change == to != in the == function above
            // to see "ExpensiveRow body evaluated" print on every counter tap.
            /**
             NOTE: sometimes, after you've modified the equatable check to fail everytime, it might be glitchy where ExpensiveRow is NOT evaluated when counter is 1,
             but all subsequent incremental changes to counter should trigger the "ExpensiveRow body evaluated" log
             */
            ExpensiveRow(name: "Test")

            Spacer()
        }
        .padding(24)
        .navigationTitle("Equatable Example")
    }
}

#Preview {
    NavigationStack {
        EquatableExampleView()
    }
}
