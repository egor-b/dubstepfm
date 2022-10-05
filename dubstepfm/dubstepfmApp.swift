//
//  dubstepfmApp.swift
//  dubstepfm
//
//  Created by Egor Bryzgalov on 9/27/22.
//

import SwiftUI

@main
struct dubstepfmApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        return true
    }
}