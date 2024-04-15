//
//  CustomRequestViewModel.swift
//  InterAppDemo
//
//  Created by Spyros Skordos on 1/4/22.
//  Copyright © 2022 Viva Wallet. All rights reserved.
//

import Foundation
import UIKit
class CustomRequestViewModel: ObservableObject {
    @Published var customRequest = "Enter Request"

    func sendRequest() {
        (UIApplication.shared.delegate as? AppDelegate)?.performInterAppRequest(
            request: customRequest)
    }
    
    func clear() {
        customRequest = ""
    }
}
