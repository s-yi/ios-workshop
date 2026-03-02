//
//  RootView.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            ScrollView {
            VStack(spacing: 16) {
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
                Text("Assets and Localization")
                    .font(.system(size: 20, weight: .bold))
                NavigationLink(destination: LocalizationExampleView()) {
                    ReusableButton(title: "Localization example")
                }
            }
            .padding(.vertical, 32)
            }
            .navigationTitle("Root")
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
