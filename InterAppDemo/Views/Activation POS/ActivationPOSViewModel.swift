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
    @Published var activationCode = ""
    @Published var sourceId = ""
    @Published var activateMoto = false
    @Published var activateSmartCheckout = false
    @Published var pinCode = ""
    @Published var lockRefundPickerValue = "-"
    @Published var lockTransactionsListPickerValue = "-"
    @Published var lockMotoPickerValue = "-"
    @Published var lockPreauthPickerValue = "-"
    @Published var lockCapturePickerValue = "-"

    @Published var selectedMotoPickerValue = "-"
    @Published var selectedQRCodesPickerValue = "-"
    @Published var selectedDisableManualAmountEntryPickerValue = "-"
    @Published var forceCardPresentmentForRefundPickerValue = "-"

    var optionsForPicker = ["-", "true", "false"]
    var currentRequest: String {

        // construct cancel action url
        var activateActionURL = Constants.activateUrlString  //  vivapayclient://pay/v1&appId=com.example.myapp&action=activatePos&apikey=qwerty123456&apiSecret=qwerty123456&sourceID=qwerty123456&callback=mycallbackscheme://result
        if !apikey.isEmpty {
            activateActionURL += "&apikey=\(apikey)"
        }
        
        if !apiSecret.isEmpty {
            activateActionURL += "&apiSecret=\(apiSecret)"
        }
        
        if !activationCode.isEmpty {
            activateActionURL += "&activationCode=\(activationCode)"
        }

        if sourceId.isEmpty == false {
            activateActionURL += "&sourceID=\(sourceId)"
        }
        
        if pinCode.isEmpty == false {
            activateActionURL += "&pinCode=\(pinCode)"
        }
        
        if selectedMotoPickerValue != "-" {
            activateActionURL += "&activateMoto=\(selectedMotoPickerValue)"
        }

        if selectedQRCodesPickerValue != "-" {
            activateActionURL +=
                "&activateQRCodes=\(selectedQRCodesPickerValue)"
        }
        
        if selectedDisableManualAmountEntryPickerValue != "-" {
            activateActionURL +=
                "&disableManualAmountEntry=\(selectedDisableManualAmountEntryPickerValue)"
        }
        
        if lockRefundPickerValue != "-" {
            activateActionURL += "&lockRefund=\(lockRefundPickerValue)"
        }
        
        if lockTransactionsListPickerValue != "-" {
            activateActionURL += "&lockTransactionsList=\(lockTransactionsListPickerValue)"
        }
        
        if lockMotoPickerValue != "-" {
            activateActionURL += "&lockMoto=\(lockMotoPickerValue)"
        }

        if lockPreauthPickerValue != "-" {
            activateActionURL += "&lockPreauth=\(lockPreauthPickerValue)"
        }
        
        if lockCapturePickerValue != "-" {
            activateActionURL += "&lockCapture=\(lockCapturePickerValue)"
        }
        
        if forceCardPresentmentForRefundPickerValue != "-" {
            activateActionURL += "&forceCardPresentmentForRefund=\(forceCardPresentmentForRefundPickerValue)"
        }
        return activateActionURL

    }

    func activate() {
        (UIApplication.shared.delegate as? AppDelegate)?.performInterAppRequest(
            request: currentRequest
        )
    }

    func getActivationCode() {
        let request = Constants.getActivationCodeUrlString
        (UIApplication.shared.delegate as? AppDelegate)?.performInterAppRequest(
            request: request
        )
    }

}
