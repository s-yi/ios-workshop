//
//  TaskExampleView.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import SwiftUI

// MARK: - Model

enum FoodCategory: String, CaseIterable {
    case fruits = "Fruits"
    case vegetables = "Vegetables"
    case grains = "Grains"
}

// MARK: - View

/// Demonstrates the .task modifier for async work tied to a view's lifecycle.
///
/// Key behaviours shown:
/// - .task { } runs once when the view appears and is automatically cancelled
///   when the view disappears — no manual onAppear/onDisappear cleanup needed.
/// - .task(id:) { } re-runs every time the id value changes, and cancels the
///   previous in-flight task before starting a new one (cooperative cancellation).
/// - Wrapping the await in do-catch handles CancellationError (thrown when the
///   task is cancelled) without letting it propagate out of the non-throwing closure.
struct TaskExampleView: View {

    @State private var selectedCategory = FoodCategory.fruits
    @State private var items: [String] = []
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 0) {
            Picker("Category", selection: $selectedCategory) {
                ForEach(FoodCategory.allCases, id: \.self) { category in
                    Text(category.rawValue).tag(category)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            Divider()

            if isLoading {
                Spacer()
                ProgressView("Fetching \(selectedCategory.rawValue)…")
                Spacer()
            } else {
                List(items, id: \.self) { item in
                    Text(item)
                }
            }
        }
        .navigationTitle("Task")
        .navigationBarTitleDisplayMode(.inline)
        // .task(id:) fires on appear and again whenever selectedCategory changes.
        // The previous task is cancelled before the new one starts, so a fast
        // category switch won't apply a stale result from an earlier fetch.
        .task(id: selectedCategory) {
            isLoading = true
            items = []

            do {
                // Task.sleep throws CancellationError when the task is cancelled
                // (e.g. user switched category). Catching it skips the state
                // updates below, so stale results are never applied.
                try await Task.sleep(for: .seconds(1))
                items = Self.mockItems(for: selectedCategory)
                isLoading = false
            } catch {
                isLoading = false
            }
        }
    }

    private static func mockItems(for category: FoodCategory) -> [String] {
        switch category {
        case .fruits:      return ["Apple", "Banana", "Mango", "Strawberry", "Pineapple", "Peach"]
        case .vegetables:  return ["Carrot", "Broccoli", "Spinach", "Pepper", "Zucchini", "Kale"]
        case .grains:      return ["Rice", "Wheat", "Oats", "Quinoa", "Barley", "Millet"]
        }
    }
}

#Preview {
    NavigationStack {
        TaskExampleView()
    }
}
