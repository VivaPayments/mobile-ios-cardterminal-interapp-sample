//
//  SceneDelegate.swift
//  InterAppDemo
//
//  Created by Chara Gkergki on 20/2/24.
//  Copyright © 2024 Viva Wallet. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    static let saleRestoration = "saleRestoration"
    
    // Activity type for restoring this scene (loaded from the plist).
    static let MainSceneActivityType = { () -> String in
        // Load the activity type from the Info.plist.
        let activityTypes = Bundle.main.infoDictionary?["NSUserActivityTypes"] as? [String]
        return activityTypes![0]
    }
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity,
            configure(
                window: window,
                session: session,
                with: userActivity
            )
        {
            // Remember this activity for later when this app quits or suspends.
            scene.userActivity = userActivity
            
            /** Set the title for this scene to allow the system to differentiate multiple scenes for the user.
                If set to nil or an empty string, the system doesn't display a title.
            */
            scene.title = userActivity.title
            session.userInfo = userActivity.userInfo as? [String: Any]
        } else if let windowScene = scene as? UIWindowScene {
            Task { @MainActor in
                self.window = UIWindow(windowScene: windowScene)
                let mainNavigationController = UINavigationController(
                    rootViewController: InterAppTabViewController.instantiate()
                )
                self.window!.rootViewController = mainNavigationController
                self.window!.makeKeyAndVisible()
            }
        }
        
        if let url = connectionOptions.urlContexts.first?.url {
            handle(url: url)
        }
    }
    
    func configure(
        window: UIWindow?,
        session: UISceneSession,
        with activity: NSUserActivity
    ) -> Bool {
        var succeeded = false
        
        if activity.activityType == SceneDelegate.MainSceneActivityType() {
            let tabBarController = InterAppTabViewController.instantiate()
            guard let saleViewController =
                    tabBarController.viewControllers?.first as? SaleViewController else { return false }

            if let userInfo = activity.userInfo {
                // Decode the user activity request identifier from the userInfo.
                if 
                    let restorationData = userInfo[SceneDelegate.saleRestoration] as? String,
                    let dict = restorationData.convertToDictionary()
                {
                    saleViewController.saleRestorationModel = SaleRestorationModel(dict)
                }
                
                // Push the detail view controller for the user activity product.
                if let navigationController = window?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(tabBarController, animated: false)
                }
                
                succeeded = true
            }
        } else {
            // The incoming userActivity is not recognizable here.
        }
        
        return succeeded
    }
    
    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        guard let url = URLContexts.first?.url else {
            return
        }
        handle(url: url)
    }
    
    private func handle(url: URL) {
        print("Response URL\n:", url)
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
            let path = components.path,
            let params = components.queryItems
        else {
            print("Invalid URL or path missing")
            return
        }
        print("Path: \(path)\nComponents: \(params)")
        
        Task { @MainActor in
            RequestInterceptor.showRequestResult(
                url: url,
                queryItems: params
            )
        }
    }
    
    /** Use this delegate when the scene moves from an active state to an inactive state, on window close, or in iOS enter background.
        This may occur due to temporary interruptions (for example, an incoming phone call).
    */
    func sceneWillResignActive(_ scene: UIScene) {
        
        if let userActivity = window?.windowScene?.userActivity {
            userActivity.resignCurrent()
        }
    }
    
    /** Use this delegate when the scene "has moved" from an inactive state to an active state.
        Also use it to restart any tasks that the system paused (or didn't start) when the scene was inactive.
        The system calls this delegate every time a scene becomes active so set up your scene UI here.
    */
    func sceneDidBecomeActive(_ scene: UIScene) {
        if let userActivity = window?.windowScene?.userActivity {
            userActivity.becomeCurrent()
        }
    }
    
    // MARK: - Window Scene

    /** This is the NSUserActivity that you use to restore state when the Scene reconnects.
        It can be the same activity that you use for handoff or spotlight, or it can be a separate activity
        with a different activity type and/or userInfo.
     
        This object must be lightweight. You should store the key information about what the user was doing last.
     
        After the system calls this function, and before it saves the activity in the restoration file, if the returned NSUserActivity has a
        delegate (NSUserActivityDelegate), the function userActivityWillSave calls that delegate. Additionally, if any UIResponders have the activity
        set as their userActivity property, the system calls the UIResponder updateUserActivityState function to update the activity.
        This happens synchronously and ensures that the system has filled in all the information for the activity before saving it.
     */
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        // Offer the user activity for this scene.

        // Check whether the SaleViewController is showing.
        if let rootViewController = window?.rootViewController as? UINavigationController,
           let tabBarController = rootViewController.topViewController as? InterAppTabViewController,
           let presentedViewController = tabBarController.viewControllers?.first as? SaleViewController
        {
                presentedViewController.updateUserActivity()
        }

        return scene.userActivity
    }
    
    
    func updateScene(with saleRestoration: SaleRestorationModel) {
        if let rootViewController = window?.rootViewController as? UINavigationController,
           let tabBarController = rootViewController.topViewController as? InterAppTabViewController,
           let presentedViewController = tabBarController.viewControllers?.first as? SaleViewController
        {
            presentedViewController.saleRestorationModel = saleRestoration
        }
    }

}
