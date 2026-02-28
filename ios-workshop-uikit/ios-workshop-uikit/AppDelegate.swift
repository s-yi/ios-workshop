//
//  AppDelegate.swift
//  Copyright © 2026 DoorDash. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("didFinishLaunchingWithOptions")
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // App became active again - wont fire because this is a modern project using a SceneDelegate
        print("applicationDidBecomeActive")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // App moving to inactive - wont fire because this is a modern project using a SceneDelegate
        print("applicationWillResignActive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // App is now in background - wont fire because this is a modern project using a SceneDelegate
        print("applicationDidEnterBackground")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // App coming back from background - wont fire because this is a modern project using a SceneDelegate
        print("applicationWillEnterForeground")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

