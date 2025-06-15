//
//  StartUpApp.swift
//  StartUp
//
//  Created by 冯子航 on 6/15/25.
//

import SwiftUI

@main
struct StartUpApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        DispatchQueue.main.async {
            if let window = NSApplication.shared.windows.first {
                window.toggleFullScreen(nil)
            }
        }
    }
}
