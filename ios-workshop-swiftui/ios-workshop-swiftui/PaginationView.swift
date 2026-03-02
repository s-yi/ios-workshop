//
//  PaginationView.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import SwiftUI

struct ListItem: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
}

struct RowView: View {
    let item: ListItem

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(.indigo.opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay {
                    Text("\(item.id + 1)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.indigo)
                }

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

struct PaginationView: View {
    @State private var items: [ListItem] = []
    private let pageSize = 20
    private let maxItems = 100

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(items) { item in
                    RowView(item: item)
                        .onAppear {
                            loadMoreIfNeeded(current: item)
                        }
                }
            }
        }
        .navigationTitle("Pagination")
        .onAppear {
            if items.isEmpty {
                loadMore()
            }
        }
    }

    private func loadMoreIfNeeded(current item: ListItem) {
        guard item.id == items.last?.id else { return }
        loadMore()
    }

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
