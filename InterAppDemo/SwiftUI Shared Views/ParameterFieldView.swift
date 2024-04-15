//
//  ParameterFieldView.swift
//  InterAppDemo
//
//  Created by Alexandros Zattas on 13/2/23.
//  Copyright © 2023 Viva Wallet. All rights reserved.
//

import SwiftUI

struct ParameterFieldView: View {

    @Binding var parameter: ParameterField

    var body: some View {
        HStack {
            Text(parameter.type.description)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            TextField(
                parameter.type.description,
                text: $parameter.textFieldText
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .keyboardType(parameter.type.keyboardType)
        }
    }
}
