//
//  NavigationStackExampleView.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import SwiftUI

// MARK: - Route

/// Used as a NavigationLink value so RootView navigates here lazily,
/// preventing navigationDestination(for:) from being registered twice.
struct NavigationStackExampleRoute: Hashable {}

// MARK: - Models

struct Fruit: Hashable {
    let name: String
    let emoji: String
    let color: Color
}

struct Vegetable: Hashable {
    let name: String
    let emoji: String
    let fact: String
}

// MARK: - List screen

/// Demonstrates value-based navigation inside an existing NavigationStack:
/// - NavigationLink(value:) pushes any Hashable value onto the enclosing stack
/// - Each navigationDestination(for:) handles a specific type independently,
///   so Fruit and Vegetable each render a completely different detail view
///
/// Note: no nested NavigationStack here — navigationDestination(for:) registers
/// destinations against the nearest enclosing NavigationStack in the hierarchy.
struct NavigationStackExampleView: View {

    private let fruits: [Fruit] = [
        Fruit(name: "Strawberry", emoji: "🍓", color: .red),
        Fruit(name: "Blueberry",  emoji: "🫐", color: .blue),
        Fruit(name: "Lime",       emoji: "🍋‍🟩", color: .green),
        Fruit(name: "Mango",      emoji: "🥭", color: .orange),
        Fruit(name: "Grape",      emoji: "🍇", color: .purple),
    ]

    private let vegetables: [Vegetable] = [
        Vegetable(name: "Carrot",   emoji: "🥕", fact: "Carrots were originally purple, not orange."),
        Vegetable(name: "Broccoli", emoji: "🥦", fact: "Broccoli is a human-engineered vegetable from wild cabbage."),
        Vegetable(name: "Corn",     emoji: "🌽", fact: "Corn is the most produced grain crop in the world."),
        Vegetable(name: "Pepper",   emoji: "🫑", fact: "Bell peppers have more vitamin C than oranges."),
    ]

    var body: some View {
        List {
            Section("Fruits") {
                ForEach(fruits, id: \.name) { fruit in
                    NavigationLink(value: fruit) {
                        Label(fruit.name, systemImage: "circle.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(fruit.color, fruit.color)
                    }
                }
            }
            Section("Vegetables") {
                ForEach(vegetables, id: \.name) { vegetable in
                    NavigationLink(value: vegetable) {
                        Label(vegetable.name, systemImage: "leaf.fill")
                            .foregroundStyle(.green)
                    }
                }
            }
        }
        .navigationTitle("Food")
        // Each navigationDestination(for:) handles one type independently.
        .navigationDestination(for: Fruit.self) { fruit in
            FruitDetailView(fruit: fruit)
        }
        .navigationDestination(for: Vegetable.self) { vegetable in
            VegetableDetailView(vegetable: vegetable)
        }
    }
}

// MARK: - Fruit detail screen

struct FruitDetailView: View {
    let fruit: Fruit

    var body: some View {
        ZStack {
            fruit.color.opacity(0.1).ignoresSafeArea()
            VStack(spacing: 16) {
                Text(fruit.emoji)
                    .font(.system(size: 80))
                Text(fruit.name)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(fruit.color)
            }
        }
        .navigationTitle(fruit.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Vegetable detail screen

struct VegetableDetailView: View {
    let vegetable: Vegetable

    var body: some View {
        VStack(spacing: 24) {
            Text(vegetable.emoji)
                .font(.system(size: 80))
            Text(vegetable.name)
                .font(.system(size: 36, weight: .bold))
            VStack(spacing: 8) {
                Text("Did you know?")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
                Text(vegetable.fact)
                    .font(.system(size: 17))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 24)
        }
        .navigationTitle(vegetable.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Previews

#Preview("NavigationStackExampleView") {
    NavigationStack {
        NavigationStackExampleView()
    }
}

#Preview("FruitDetailView") {
    NavigationStack {
        FruitDetailView(fruit: Fruit(name: "Mango", emoji: "🥭", color: .orange))
    }
}

#Preview("VegetableDetailView") {
    NavigationStack {
        VegetableDetailView(vegetable: Vegetable(name: "Carrot", emoji: "🥕", fact: "Carrots were originally purple, not orange."))
    }
}
