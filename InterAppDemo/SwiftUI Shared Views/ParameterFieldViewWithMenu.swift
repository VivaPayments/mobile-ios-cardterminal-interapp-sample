//
//  ParameterFieldViewWithMenu.swift
//  InterAppDemo
//
//  Created by Chara Gkergki on 28/11/23.
//  Copyright © 2023 Viva Wallet. All rights reserved.
//

import SwiftUI

struct ParameterFieldViewWithMenu: View {

    @Binding var parameter: ParameterField
    let options: [PaymentMethod]
    
    var body: some View {
        HStack {
            Text(parameter.type.description)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            Menu {
                ForEach(
                    options,
                    id: \.self
                ) { option in
                    Button {
                        parameter.textFieldText = option.rawValue
                    } label: {
                        Text(option.rawValue)
                    }
                }
            } label: {
                Text(parameter.textFieldText)
                    .foregroundStyle(Color("menuTextColor"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
