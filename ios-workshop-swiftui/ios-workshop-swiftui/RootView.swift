//
//  RootView.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                NavigationLink(destination: ExampleLayoutView()) {
                    ReusableButton(title: "Views Deepdive - Example in slides")
                }
                NavigationLink(destination: LayoutView()) {
                    ReusableButton(title: "Views Deepdive - BONUS: More complex layout example")
                }
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
