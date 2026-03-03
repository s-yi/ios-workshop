//
//  CounterView.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import SwiftUI

// MARK: - Protocol

/// Defines the interface between CounterView and its ViewModel.
/// Conforming to Observable means SwiftUI will automatically track property
/// accesses in the view body and re-render when they change.
protocol CounterViewModelProtocol: Observable, AnyObject {
    var count: Int { get }
    func increment()
    func decrement()
    func reset()
}

// MARK: - ViewModel

/// @Observable replaces ObservableObject + @Published (available from iOS 17).
/// Any View that reads a property automatically re-renders when it changes —
/// no explicit @Published annotation needed on individual properties.
@Observable
class CounterViewModel: CounterViewModelProtocol {
    private(set) var count = 0

    func increment() { count += 1 }
    func decrement() { count -= 1 }
    func reset()     { count = 0 }
}

// MARK: - View

/// Demonstrates MVVM with @Observable and protocol-based injection in SwiftUI.
///
/// Key points:
/// - CounterView is generic over any CounterViewModelProtocol, making it
///   testable and swappable without changing the view.
/// - The ViewModel is injected through the initializer (constructor injection).
/// - @State wraps the injected instance so SwiftUI manages its lifetime.
/// - Because ViewModel conforms to Observable, SwiftUI automatically tracks
///   which properties are read in body and re-renders on changes.
struct CounterView<ViewModel: CounterViewModelProtocol>: View {
    @State private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

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
        CounterView(viewModel: CounterViewModel())
    }
}
