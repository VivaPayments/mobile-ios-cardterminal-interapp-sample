//
//  SaleViewController.swift
//  InterAppDemo
//
//  Created by Evangelos Pittas on 23/12/19.
//  Copyright © 2019 Viva Wallet. All rights reserved.
//

import UIKit

class SaleViewController: UIViewController {
    static let viewControllerIdentifier = "SaleViewController"
    var saleRestorationModel: SaleRestorationModel?
    private var saleView: SaleView?

    override func viewDidLoad() {
        super.viewDidLoad()
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saleView = SaleView(saleRestorationModel: saleRestorationModel)
        addSubSwiftUIView(saleView, to: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Update the user activity with this product and tab selection for scene-based state restoration.
        updateUserActivity()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // This view controller is going away, no more user activity to track.
        view.window?.windowScene?.userActivity = nil
    }
    
    func update(isWaitingForResponse: Bool) {
        self.saleRestorationModel?.isWaitingForResponse = isWaitingForResponse
        self.saleView?.viewModel.isWaitingForResponse = isWaitingForResponse
    }
}


extension SaleViewController {
    
    func updateUserActivity() {
        var currentUserActivity = view.window?.windowScene?.userActivity
        if currentUserActivity == nil {
            /** Note: You must include the activityType string below in your Info.plist file under the `NSUserActivityTypes` array.
            */
            currentUserActivity = NSUserActivity(activityType: SceneDelegate.MainSceneActivityType())
        }

        /** The target content identifier is a structured way to represent data in your model.
            Set a string that identifies the content of this NSUserActivity.
            Here the userActivity's targetContentIdentifier is the product's title.
        */
        currentUserActivity?.targetContentIdentifier = "saleViewRestoration"
        
        // Add the sale to the user activity (as a coded JSON object).
        currentUserActivity?.addUserInfoEntries(
            from: [SceneDelegate.saleRestoration: saleRestorationModel?.toJSONString() ?? ""]
        )
        
        view.window?.windowScene?.userActivity = currentUserActivity
        
        // Mark this scene's session with this userActivity product identifier, so you can update the UI later.
        view.window?.windowScene?.session.userInfo = currentUserActivity?.userInfo as? [String: Any]
    }
}
