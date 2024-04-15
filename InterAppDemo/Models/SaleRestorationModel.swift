//
//  SaleRestorationModel.swift
//  InterAppDemo
//
//  Created by Chara Gkergki on 4/3/24.
//  Copyright © 2024 Viva Wallet. All rights reserved.
//

import UIKit

final class SaleRestorationModel {
    
    var parameters: [ParameterField] = ParameterType.allCases.compactMap({ type in
        return ParameterField(type: type)
    })
    var isWaitingForResponse: Bool
    
    init(_ data: [String: Any]) {
        self.parameters = (data["parameters"] as? [[String: Any]])?.compactMap { param in
            return ParameterField(
                type: ParameterType(rawValue: param["type"] as? String ?? "")!,
                textFieldText: param["textFieldText"] as? String
            )
        } ?? []
        self.isWaitingForResponse = data["isWaitingForResponse"] as? Bool ?? false
    }
    
    init(
        parameters: [ParameterField],
        isWaitingForResponse: Bool
    ) {
        self.parameters = parameters
        self.isWaitingForResponse = isWaitingForResponse
    }
    
    func toJSONString() -> String {
        let parametersJson = parameters.reduce([[String: Any]]()) { (arr, list) in
            var newArray = arr
            newArray.append(list.toJSON())
            return newArray
        }
        
        return [
            "parameters": parametersJson,
            "isWaitingForResponse": isWaitingForResponse
        ].jsonRepresantation
    }
    
}
