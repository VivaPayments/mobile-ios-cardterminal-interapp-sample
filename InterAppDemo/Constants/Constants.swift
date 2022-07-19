//
//  Constants.swift
//  InterAppDemo
//
//  Created by Alexandros Zat on 1/3/21.
//  Copyright © 2021 Viva Wallet. All rights reserved.
//

import Foundation

struct Constants {

    private static let schemeURL = "vivapayclient://pay/v1" // The Viva's custom URL scheme, the host and the version.
    private static let callback = "?callback=interapp-callback" // The URI callback that will handle the result.
    private static let merchantKey = "&merchantKey=SG23323424EXS3" // The merchant's key.
    private static let clientAppID = "&appId=com.vivawallet.InterAppDemo" // The client app id.
    private static let saleAction = "&action=sale" // Sale transaction
    private static let activateAction = "&action=activatePos"
    private static let cancelAction = "&action=cancel" // Cancel/Refund transaction
    private static let abortAction =  "&action=abort" // Abort transaction
    private static let batchAction =  "&action=batch" // Create batch
    private static let setPrintingSettingsAction =  "&action=set_printing_settings" // Set printing settings
    private static let getPrintingSettingsAction =  "&action=getPrintingSettings" // Get printing settings
    private static let sendLogsAction = "&action=sendLogs"

    private static let reprintTransactionAction = "&action=reprintTransaction"


    // Construct base interApp url string
    static private var baseUrlString: String {
        var url = schemeURL
        if UserDefaults.standard.value(forKey:
                SettingsViewController.SettingsKeys.sendEmptyCallback.rawValue)
            as? Bool != true {
            url += callback
        }
        url += merchantKey
        if UserDefaults.standard.value(forKey:
                SettingsViewController.SettingsKeys.sendEmptyAppId.rawValue)
            as? Bool != true {
            url += clientAppID
        }
        return url
    }
    
    static var reprintTransacionUrlString: String {
        return UserDefaults.standard.value(forKey:
                SettingsViewController.SettingsKeys.sendEmptyAction.rawValue)
        as? Bool != true ?
        baseUrlString + reprintTransactionAction:
            baseUrlString
    }
    
    static private var activationBaseUrlString: String {
        var url = schemeURL
        if UserDefaults.standard.value(forKey:
                SettingsViewController.SettingsKeys.sendEmptyCallback.rawValue)
            as? Bool != true {
            url += callback
        }
        if UserDefaults.standard.value(forKey:
                SettingsViewController.SettingsKeys.sendEmptyAppId.rawValue)
            as? Bool != true {
            url += clientAppID
        }
        return url
    }

    // Construct activate interApp url string
    static var saleUrlString: String {
        return UserDefaults.standard.value(forKey:
                SettingsViewController.SettingsKeys.sendEmptyAction.rawValue)
        as? Bool != true ?
        baseUrlString + saleAction:
            baseUrlString

    }
    
    // Construct sale interApp url string
    static var activateUrlString: String {
        return UserDefaults.standard.value(forKey:
                SettingsViewController.SettingsKeys.sendEmptyAction.rawValue)
        as? Bool != true ?
        activationBaseUrlString + activateAction:
        activationBaseUrlString

    }

    // Construct cancel interApp url string
    static var cancelUrlString: String {
        return UserDefaults.standard.value(forKey:
                SettingsViewController.SettingsKeys.sendEmptyAction.rawValue)
        as? Bool != true ?
        baseUrlString + cancelAction:
            baseUrlString
    }

    // Construct abort interApp url string
    static var abortUrlString: String {
        return UserDefaults.standard.value(forKey:
                SettingsViewController.SettingsKeys.sendEmptyAction.rawValue)
        as? Bool != true ?
        baseUrlString + abortAction:
            baseUrlString
    }

    // Open/Close batch interApp url string
    static var batchUrlString: String {
        return UserDefaults.standard.value(forKey:
                SettingsViewController.SettingsKeys.sendEmptyAction.rawValue)
        as? Bool != true ?
        baseUrlString + batchAction:
            baseUrlString
    }

    // Construct set printer settings url string
    static var setPrintingSettingsUrlString: String {
        return UserDefaults.standard.value(forKey:
                SettingsViewController.SettingsKeys.sendEmptyAction.rawValue)
        as? Bool != true ?
        baseUrlString + setPrintingSettingsAction:
            baseUrlString
    }
    
    // Construct get printer settings url string
    static var getPrintingSettingsUrlString: String {
        return UserDefaults.standard.value(forKey:
                SettingsViewController.SettingsKeys.sendEmptyAction.rawValue)
        as? Bool != true ?
        baseUrlString + getPrintingSettingsAction:
            baseUrlString
    }

    
    static var sendLogsUrlString: String {
        return baseUrlString + sendLogsAction
    }
}
