//
//  RootView.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
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
