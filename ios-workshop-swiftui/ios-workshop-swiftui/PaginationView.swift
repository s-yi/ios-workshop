//
//  PaginationView.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import SwiftUI

// MARK: - Data Model

struct ListItem: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
}

// MARK: - Row View

/// A single row displaying a circular avatar with a number, a title, and a subtitle.
struct RowView: View {
    let item: ListItem

    var body: some View {
        HStack(spacing: 12) {
            // Numbered avatar circle
            Circle()
                .fill(.indigo.opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay {
                    Text("\(item.id + 1)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.indigo)
                }

            // Title and subtitle stacked vertically
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 16, weight: .semibold))

                Text(item.subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

// MARK: - Pagination View

/// Demonstrates infinite-scroll pagination using ScrollView + LazyVStack.
/// New pages of items are loaded when the last row appears on screen.
struct PaginationView: View {
    @State private var items: [ListItem] = []
    private let pageSize = 20
    private let maxItems = 100

    var body: some View {
        ScrollView {
            // LazyVStack only creates views as they scroll into the visible area
            LazyVStack(spacing: 8) {
                // Tip: For cells with heavy resources (e.g. images, video thumbnails),
                // use .onAppear to load them and .onDisappear to release them.
                // This keeps memory usage low in long lists since LazyVStack
                // only keeps visible views alive, but their data may persist.
                ForEach(items) { item in
                    RowView(item: item)
                        .onAppear {
                            loadMoreIfNeeded(current: item)
                            loadHeavyResources(for: item)
                        }
                        .onDisappear {
                            unloadHeavyResources(for: item)
                        }
                }
            }
        }
        .navigationTitle("Pagination")
        .onAppear {
            // Load the first page when the view appears
            if items.isEmpty {
                loadMore()
            }
        }
    }

    /// Only loads more if the currently appearing item is the last one in the list
    private func loadMoreIfNeeded(current item: ListItem) {
        guard item.id == items.last?.id else { return }
        loadMore()
    }

    // Load heavy resources like images when a cell becomes visible
    private func loadHeavyResources(for item: ListItem) {}

    // Release heavy resources when a cell scrolls off screen to free memory
    private func unloadHeavyResources(for item: ListItem) {}

    /// Appends the next page of items. Stops once maxItems is reached.
    private func loadMore() {
        let start = items.count
        guard start < maxItems else { return }
        let newItems = (start..<start + pageSize).map { index in
            ListItem(id: index, title: "Item \(index + 1)", subtitle: "Description for item \(index + 1)")
        }
        items.append(contentsOf: newItems)
    }
}

#Preview {
    NavigationStack {
        PaginationView()
    }
}
