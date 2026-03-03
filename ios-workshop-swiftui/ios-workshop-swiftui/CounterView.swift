//
//  CounterView.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import SwiftUI

// MARK: - ViewModel

/// @Observable replaces ObservableObject + @Published (available from iOS 17).
/// Any View that reads a property automatically re-renders when it changes —
/// no explicit @Published annotation needed on individual properties.
@Observable
class CounterViewModel {
    private(set) var count = 0

    func increment() { count += 1 }
    func decrement() { count -= 1 }
    func reset()     { count = 0 }
}

// MARK: - View

/// Demonstrates MVVM with @Observable in SwiftUI.
///
/// Key points:
/// - The ViewModel holds all state and business logic; the View is purely presentational.
/// - @Observable is the modern replacement for ObservableObject + @Published (iOS 17+).
/// - @State owns the ViewModel instance — it lives as long as the view does.
/// - No @StateObject, no @Published, no sink — just read properties directly.
struct CounterView: View {
    // @State owns the ViewModel. Using @State (not a plain let) ensures SwiftUI
    // manages its lifetime and doesn't recreate it on every body evaluation.
    @State private var viewModel = CounterViewModel()

    var body: some View {
        VStack(spacing: 32) {
            Text("\(viewModel.count)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .contentTransition(.numericText())
                .animation(.spring, value: viewModel.count)

            HStack(spacing: 16) {
                Button {
                    withAnimation { viewModel.decrement() }
                } label: {
                    ReusableButton(title: "−")
                }

                Button {
                    withAnimation { viewModel.increment() }
                } label: {
                    ReusableButton(title: "+")
                }
            }

            Button {
                withAnimation { viewModel.reset() }
            } label: {
                Text("Reset")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Counter")
    }
}

#Preview {
    NavigationStack {
        CounterView()
    }
}
