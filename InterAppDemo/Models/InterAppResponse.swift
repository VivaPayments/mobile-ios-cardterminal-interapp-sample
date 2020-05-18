//
//  InterAppResponse.swift
//  InterAppDemo
//
//  Created by Alexandros Zattas on 27/2/20.
//  Copyright © 2020 Viva Wallet. All rights reserved.
//

import Foundation

enum Action: String {
    case sale = "sale"
    case cancel = "cancel"
    case userCancel = "User_cancel"
}

class InterAppResponse {
    
    var verificationMethod: String?
    var tipAmount: Decimal? = 0
    var message: String?
    var accountNumber: String?
    var amount: Decimal?
    var orderCode: Int?
    var rrn: String?
    var authorisationCode: String?
    var referenceNumber: String?
    var clientTransactionID: String?
    var action: Action?
    var transactionID: String?
    var cardType: String?
    var transactionDate: Date = Date()
    var tid: Int?
    var status: Bool
    var installments: Int?

    init(stringDictionary: [String: String]) {
        
        self.verificationMethod = stringDictionary["verificationMethod"]
        
        if let tip = stringDictionary["tipAmount"] {
            self.tipAmount = (Decimal(string: tip, locale: Locale.current) ?? 0)  / 100
        }
        
        self.message = stringDictionary["message"]
        
        self.accountNumber = stringDictionary["verificationMethod"]
        
        if let amount = stringDictionary["amount"] {
            self.amount = (Decimal(string: amount, locale: Locale.current) ?? 0) / 100
        }
        
        if let code = stringDictionary["orderCode"] {
            self.orderCode = Int(code)
        }
        self.rrn = stringDictionary["rrn"]
        
        self.authorisationCode = stringDictionary["authorisationCode"]
        
        self.referenceNumber = stringDictionary["referenceNumber"]
                
        if let clientTransactionID = stringDictionary["clientTransactionId"] {
            self.clientTransactionID = clientTransactionID
        }
        
        if let action = stringDictionary["action"] {
            self.action = Action(rawValue: action)
        }
        
        self.transactionID = stringDictionary["transactionId"]
        
        self.cardType = stringDictionary["cardType"]
        
        if let transactionDate: String = stringDictionary["transactionDate"], let date: Date = transactionDate.toDate() {
            self.transactionDate = date
        }
        
        if let numberOfInstallments = stringDictionary["installments"] {
            self.installments = Int(numberOfInstallments)
        }
        
        if let tid = stringDictionary["tid"] {
            self.tid = Int(tid)
        }
        
        self.status = (stringDictionary["status"] == "success") ? true : false
    }
}
