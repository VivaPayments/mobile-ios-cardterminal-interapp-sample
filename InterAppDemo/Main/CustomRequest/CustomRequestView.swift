//
//  CustomRequestView.swift
//  InterAppDemo
//
//  Created by Spyros Skordos on 1/4/22.
//  Copyright © 2022 Viva Wallet. All rights reserved.
//

import SwiftUI

struct CustomRequestView: View {
    @ObservedObject var viewModel = CustomRequestViewModel()
    var body: some View {
        VStack {
            TextEditor(text: $viewModel.customRequest)
            Spacer()
            Button(action: {
                UIApplication.shared.endEditing()
            }) {
                Text("Done").frame(minWidth: 0, maxWidth: .infinity)

            }.buttonStyle(PrimaryButtonStyle())
            Button(action: {
                viewModel.clear()
            }) {
                Text("Clear Request").frame(minWidth: 0, maxWidth: .infinity)

            }.buttonStyle(PrimaryButtonStyle())
            Button(action: {
                viewModel.sendRequest()
            }) {
                Text("Send Request").frame(minWidth: 0, maxWidth: .infinity)

            }.buttonStyle(PrimaryButtonStyle())
        }.padding()
    }
}

struct CustomRequestView_Previews: PreviewProvider {
    static var previews: some View {
        CustomRequestView()
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
