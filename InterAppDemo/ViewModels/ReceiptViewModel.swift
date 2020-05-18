//
//  ReceiptViewModel.swift
//  InterAppDemo
//
//  Created by Alexandros Zattas on 27/2/20.
//  Copyright © 2020 Viva Wallet. All rights reserved.
//

import Foundation


struct ReceiptViewModel {
    
    let transactionResult: Bool
    let amount: String?
    let cardType: String?
    let transactionType: String??
    let transactionDate: String?
    let transactionResultMessage: String?
    let installments: Int?
    let clientReferenceCode: String?

    init(response: InterAppResponse) {
        transactionResult = response.status
        amount = response.amount?.toCurrencyString()
        cardType = response.cardType
        transactionType = response.action?.rawValue.capitalized
        transactionDate = response.transactionDate.toString(withFormat: "yyyy-MM-dd")
        transactionResultMessage = response.message
        clientReferenceCode = response.clientTransactionID
        installments = response.installments
    }
}
