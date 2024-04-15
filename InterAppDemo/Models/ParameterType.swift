//
//  ParameterType.swift
//  InterAppDemo
//
//  Created by Alexandros Zattas on 13/2/23.
//  Copyright © 2023 Viva Wallet. All rights reserved.
//

import UIKit

enum ParameterType: String, CaseIterable {

    case amount
    case tipAmount
    case preferredInstallments
    case clientTransactionId
    case paymentMethod
    case isvAmount = "ISV_amount"
    case isvClientId = "ISV_clientId"
    case isvClientSecret = "ISV_clientSecret"
    case isvSourceCode = "ISV_sourceCode"
    case isvMerchantId = "ISV_merchantId"
    case isvMerchantSourceCode = "ISV_merchantSourceCode"
    case isvCustomerTrns = "ISV_customerTrns"

    var description: String {
        switch self {
        case .amount,
            .isvAmount:
            return "Amount (in cents)"
        case .tipAmount:
            return "Tip amount (in cents)"
        case .preferredInstallments:
            return "Instalments"
        case .clientTransactionId:
            return "Client transaction ID"
        case .isvClientId:
            return "Client ID"
        case .isvClientSecret:
            return "Client secret"
        case .isvSourceCode:
            return "Source code"
        case .isvMerchantId:
            return "Merchant ID"
        case .isvMerchantSourceCode:
            return "Merchant source code"
        case .isvCustomerTrns:
            return "Customer trns"
        case .paymentMethod:
            return "Payment Method"
        }
    }

    var keyboardType: UIKeyboardType {
        switch self {
        case .amount,
            .tipAmount,
            .isvAmount,
            .preferredInstallments:
            return .numberPad
        default:
            return .default
        }
    }

    var defaultInputValue: String {
        switch self {
        case .isvClientId:
            return "auyf99x03sachvn3f5ogldykz8214c2o4vl8cvvs97p19.apps.vivapayments.com"
        case .isvClientSecret:
            return "Vk8ZcKr5Lyep4J0yBDby65Z3zpGjHL"
        case .isvMerchantId:
            return "86756505-53bd-4e33-abcf-c65370fc6759"
        case .paymentMethod:
            return PaymentMethod.cardPresent.rawValue
        default:
            return ""
        }
    }

    var isISVRelated: Bool {
        switch self {
        case .isvClientId,
            .isvClientSecret,
            .isvMerchantId,
            .isvMerchantSourceCode,
            .isvSourceCode,
            .isvAmount,
            .isvCustomerTrns:
            return true
        default:
            return false
        }
    }
}
