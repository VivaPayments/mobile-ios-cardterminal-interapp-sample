//
//  AuthenticateViewModel.swift
//  InterAppDemo
//
//  Created by Spyros Skordos on 14/3/22.
//  Copyright © 2022 Viva Wallet. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

class ActivationPOSViewModel: ObservableObject {
    @Published var apikey = ""
    @Published var apiSecret = ""
    @Published var sourceId = ""
    @Published var activateMoto = false
    @Published var activateSmartCheckout = false
    @Published var pinCode = ""
    @Published var sendEmptyPinCode = false
    @Published var sendWithoutApiKey = false
    @Published var sendWithoutApiSecret = false
    var currentRequest: String {

        // construct cancel action url
        var activateActionURL = Constants.activateUrlString  //  vivapayclient://pay/v1&appId=com.example.myapp&action=activatePos&apikey=qwerty123456&apiSecret=qwerty123456&sourceID=qwerty123456&callback=mycallbackscheme://result
        if !(sendWithoutApiKey) {
            activateActionURL += "&apikey=\(apikey)"
        }
        if !(sendWithoutApiSecret) {
            activateActionURL += "&apiSecret=\(apiSecret)"
        }
        if sourceId.isEmpty == false {
            activateActionURL += "&sourceID=\(sourceId)"
        }
        if pinCode.isEmpty == false || sendEmptyPinCode {
            activateActionURL += "&pinCode=\(pinCode)"
        }

        return activateActionURL

    }

    func activate() {
        (UIApplication.shared.delegate as? AppDelegate)?.performInterAppRequest(
            request: currentRequest)
    }

}


