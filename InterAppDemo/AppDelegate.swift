//
//  AppDelegate.swift
//  InterAppDemo
//
//  Created by Evangelos Pittas on 17/12/19.
//  Copyright © 2019 Viva Wallet. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return true
    }

    func performInterAppRequest(request: String) {
        guard let url = URL(string: request) else { return }  // url with constructed parameters
        UIApplication.shared.open(url) { (result) in
            print("InterApp Request URL:\n", url)
            if result {
                // The URL was delivered successfully!
            }
        }
    }
    
    func application(
        _ application: UIApplication,
        shouldSaveSecureApplicationState coder: NSCoder
    ) -> Bool {
        return true
    }
    
    func application(
        _ application: UIApplication,
        shouldRestoreSecureApplicationState coder: NSCoder
    ) -> Bool {
        return true
    }
    
}

// MARK: - UISceneSession Lifecycle

extension AppDelegate {
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
}
