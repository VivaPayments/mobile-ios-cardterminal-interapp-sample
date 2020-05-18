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

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
//        window?.backgroundColor = .systemBackground
        let nv = UINavigationController(rootViewController: InterAppTabViewController.instantiate())
        window?.rootViewController = nv
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
            let path = components.path,
            let params = components.queryItems else {
                print("Invalid URL or path missing")
                return false
        }
        print("Path: \(path)\nComponents: \(params)")
        
        //MARK: - Do any additional actions after parsing the data
        guard let stringDictionary = url.toStringDictionary() else { return true }
        let response: InterAppResponse = InterAppResponse(stringDictionary: stringDictionary)
        
        let receipVC = ReceiptViewController.instantiate(response: response, parameters: params)
        let nc = UINavigationController(rootViewController: receipVC)
        window?.rootViewController?.present(nc, animated: true, completion: nil)
        return true
    }
}
