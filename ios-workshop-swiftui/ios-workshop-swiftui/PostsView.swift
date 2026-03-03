//
//  PostsView.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import Dependencies
import SwiftUI

// MARK: - ViewModel

@Observable
class PostsViewModel {
    enum State {
        case idle
        case loading
        case loaded([Post])
        case failed(String)
    }

    private(set) var state: State = .idle

    // @Dependency resolves the live, preview, or test value depending on context.
    // In production this calls the real API; in Previews it returns mock data.
    @ObservationIgnored
    @Dependency(\.postService) private var postService

    func fetchPosts() async {
        state = .loading
        do {
            let posts = try await postService.fetchPosts()
            state = .loaded(posts)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}

// MARK: - Protocol

protocol PostsViewModelProtocol: Observable, AnyObject {
    var state: PostsViewModel.State { get }
    func fetchPosts() async
}

extension PostsViewModel: PostsViewModelProtocol {}

// MARK: - View

struct PostsView<ViewModel: PostsViewModelProtocol>: View {
    @State private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                Color.clear

            case .loading:
                ProgressView("Loading posts…")

            case .loaded(let posts):
                List(posts) { post in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(post.title.capitalized)
                            .font(.system(size: 15, weight: .semibold))
                        Text(post.body)
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .padding(.vertical, 4)
                }

            case .failed(let message):
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundStyle(.orange)
                    Text(message)
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    Button("Retry") {
                        Task { await viewModel.fetchPosts() }
                    }
                }
                .padding(.horizontal, 32)
            }
        }
        .navigationTitle("Posts")
        .task { await viewModel.fetchPosts() }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        // withDependencies overrides postService for this preview scope only.
        // previewValue is already set on PostService, but this shows the pattern
        // for overriding any dependency in a specific context.
        PostsView(viewModel: withDependencies {
            $0.postService = .previewValue
        } operation: {
            PostsViewModel()
        })
    }
}
