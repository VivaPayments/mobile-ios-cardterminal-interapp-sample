//
//  Constants.swift
//  InterAppDemo
//
//  Created by Alexandros Zattas on 23/11/20.
//  Copyright © 2020 Viva Wallet. All rights reserved.
//

import Foundation

struct Constants {
    static let schemeURL = "vivapayclient://pay/v1" // The Viva's custom URL scheme, the host and the version.
    static let callback = "?callback=interapp-callback" // The URI callback that will handle the result.
    static let merchantKey = "&merchantKey=SG23323424EXS3" // The merchant's key.
    static let clientAppID = "&appId=com.vivawallet.InterAppDemo" // The client app id.
    static let saleAction =  "&action=sale" // Sale transaction
    static let cancelAction =  "&action=cancel" // Sale transaction
    static let abortAction =  "&action=abort" // Abort transaction
}
