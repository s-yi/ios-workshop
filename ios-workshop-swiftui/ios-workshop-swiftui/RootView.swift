//
//  RootView.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var isModalPresented = false

    var body: some View {
        NavigationStack {
            ScrollView {
            VStack(spacing: 16) {
                Text("Assets and Localization")
                    .font(.system(size: 20, weight: .bold))
                NavigationLink(destination: ImageExampleView()) {
                    ReusableButton(title: "Image example")
                }
                NavigationLink(destination: LocalizationExampleView()) {
                    ReusableButton(title: "Localization example")
                }
                Text("Concurrency")
                    .font(.system(size: 20, weight: .bold))
                NavigationLink(destination: TaskExampleView()) {
                    ReusableButton(title: ".task example")
                }
                Text("ViewModel")
                    .font(.system(size: 20, weight: .bold))
                NavigationLink(destination: CounterView(viewModel: CounterViewModel())) {
                    ReusableButton(title: "Counter (MVVM)")
                }
                NavigationLink(destination: PostsView(viewModel: PostsViewModel())) {
                    ReusableButton(title: "Posts (MVVM + DI)")
                }
                Text("Views Deepdive")
                    .font(.system(size: 20, weight: .bold))
                NavigationLink(destination: ExampleLayoutView()) {
                    ReusableButton(title: "Example in slides")
                }
                NavigationLink(destination: LayoutView()) {
                    ReusableButton(title: "More complex layout example")
                }
                NavigationLink(destination: PaginationView()) {
                    ReusableButton(title: "Pagination example")
                }
                NavigationLink(destination: EquatableExampleView()) {
                    ReusableButton(title: "Equatable rendering")
                }
                NavigationLink(destination: InteropExampleView()) {
                    ReusableButton(title: "SwiftUI → UIKit Interop")
                }
                Text("Navigation")
                    .font(.system(size: 20, weight: .bold))
                // Value-based link so NavigationStackExampleView is created lazily —
                // prevents its navigationDestination(for:) modifiers from registering twice.
                NavigationLink(value: NavigationStackExampleRoute()) {
                    ReusableButton(title: "Navigation Stack")
                }
                Button {
                    isModalPresented = true
                } label: {
                    ReusableButton(title: "Modal")
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            }
            .navigationTitle("Root")
            .navigationDestination(for: NavigationStackExampleRoute.self) { _ in
                NavigationStackExampleView()
            }
        }
        .sheet(isPresented: $isModalPresented) {
            ModalView()
        }
        .onAppear {
            print("RootView appeared")
        }
        .onDisappear {
            print("RootView disappeared")
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                print("App became active again")
                break
            case .inactive:
                print("App moving to inactive")
                break
            case .background:
                print("App is now in background")
                break
            @unknown default:
                print(newPhase)
                break
            }
        }
    }
}

#Preview {
    RootView()
}
