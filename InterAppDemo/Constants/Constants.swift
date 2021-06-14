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
    private static let saleAction =  "&action=sale" // Sale transaction
    private static let cancelAction = "&action=cancel" // Cancel/Refund transaction
    private static let abortAction =  "&action=abort" // Abort transaction
    private static let batchAction =  "&action=batch" // Create batch
    private static let printerSettingsAction =  "&action=set_printing_settings" // Set printer settings
    
    // Construct base interApp url string
    static private var baseUrlString: String {
        return schemeURL + callback + merchantKey + clientAppID
    }
    
    // Construct sale interApp url string
    static var saleUrlString: String {
        return baseUrlString + saleAction
    }

    // Construct cancel interApp url string
    static var cancelUrlString: String {
        return baseUrlString + cancelAction
    }
    
    // Construct abort interApp url string
    static var abortUrlString: String {
        return baseUrlString + abortAction
    }

    // Open/Close batch interApp url string
    static var batchUrlString: String {
        return baseUrlString + batchAction
    }

    // Construct end batch interApp url string
    static var printerSettingsUrlString: String {
        return baseUrlString + printerSettingsAction
    }
}
