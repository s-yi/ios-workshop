//
//  PostService.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import Dependencies
import Foundation

// MARK: - Model

struct Post: Codable, Identifiable, Equatable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

// MARK: - Service

/// Fetches posts from JSONPlaceholder — a free, always-on fake REST API.
/// Endpoint: GET https://jsonplaceholder.typicode.com/posts
struct PostService: Sendable {
    var fetchPosts: @Sendable () async throws -> [Post]
}

// MARK: - DependencyKey

extension PostService: DependencyKey {
    static let liveValue = PostService(
        fetchPosts: {
            let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            return try JSONDecoder().decode([Post].self, from: data)
        }
    )

    /// Returns a small set of hardcoded posts so Previews and SwiftUI
    /// canvas work without a network connection.
    static let previewValue = PostService(
        fetchPosts: {
            [
                Post(id: 1, userId: 1, title: "Hello, World!", body: "This is a preview post."),
                Post(id: 2, userId: 1, title: "Swift Dependencies", body: "Injected via DependencyValues."),
                Post(id: 3, userId: 2, title: "No network needed", body: "previewValue serves mock data."),
            ]
        }
    )
}

// MARK: - DependencyValues

extension DependencyValues {
    var postService: PostService {
        get { self[PostService.self] }
        set { self[PostService.self] = newValue }
    }
}
