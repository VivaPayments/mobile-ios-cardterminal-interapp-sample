//
//  PaymentMethod.swift
//  InterAppDemo
//
//  Created by Chara Gkergki on 28/11/23.
//  Copyright © 2023 Viva Wallet. All rights reserved.
//

import Foundation

enum PaymentMethod: String, CaseIterable {
    case cardPresent = "CardPresent"
    case moto = "MOTO"
    case qrDefault = "QrDefault"
    case qrPayconic = "Payconiq"
    case aliPay = "AliPay"
    case paypal = "Paypal"
    case klarna = "Klarna"
}
