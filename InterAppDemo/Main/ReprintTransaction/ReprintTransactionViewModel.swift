//
//  ReprintTransactionViewModel.swift
//  InterAppDemo
//
//  Created by Spyros Skordos on 14/6/22.
//  Copyright © 2022 Viva Wallet. All rights reserved.
//

import Foundation
import UIKit

class ReprintTransactionViewModel:ObservableObject {
    @Published var orderCode = ""
    @Published var sendWithoutTransactionOrderId = false
    var currentRequest: String {
        var reprintTransactionURL = Constants.reprintTransacionUrlString
        if !sendWithoutTransactionOrderId {
            reprintTransactionURL += "&orderCode=\(orderCode)"
        }
        return reprintTransactionURL
    }
    
    func reprint() {
        (UIApplication.shared.delegate as? AppDelegate)?.performInterAppRequest(
            request: currentRequest)
    }
    
}
