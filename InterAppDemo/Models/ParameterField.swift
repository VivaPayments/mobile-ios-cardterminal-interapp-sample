//
//  ParameterField.swift
//  InterAppDemo
//
//  Created by Alexandros Zattas on 13/2/23.
//  Copyright © 2023 Viva Wallet. All rights reserved.
//

import Foundation

class ParameterField: Identifiable {
    
    var type: ParameterType
    @Published var textFieldText: String
    let id = UUID()
    
    init(
        type: ParameterType,
        textFieldText: String? = nil
    ) {
        self.type = type
        self.textFieldText = textFieldText ?? type.defaultInputValue
    }
    
    func toJSON() -> [String: Any] {
        return [
            "type": type.rawValue,
            "textFieldText": textFieldText
        ]
    }
}
