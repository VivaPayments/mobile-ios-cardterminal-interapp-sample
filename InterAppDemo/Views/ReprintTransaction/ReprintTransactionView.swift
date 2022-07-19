//
//  ReprintTransactionView.swift
//  InterAppDemo
//
//  Created by Spyros Skordos on 14/6/22.
//  Copyright © 2022 Viva Wallet. All rights reserved.
//

import SwiftUI

struct ReprintTransactionView: View {
    @ObservedObject var viewModel = ReprintTransactionViewModel()
    var body: some View {
        UITextField.appearance().clearButtonMode = .whileEditing

        return VStack {
            Text("Reprint Transaction")
            Form {
                transactionOrderCodeSection
                currentRequestToSentSection
            }.toolbar {
                toolBarContent()
            }

            reprintButton

        }
    }

    var reprintButton: some View {
        Button(action: {
            viewModel.reprint()
        }) {
            Text("Reprint Transaction")
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity)
        }
        .buttonStyle(PrimaryButtonStyle())
        .padding()
    }

    var transactionOrderCodeSection: some View {
        Section(header: Text("Enter transaction order code")) {
            TextField("Enter transaction order code", text: $viewModel.orderCode)
            Toggle("Send without transaction order code ", isOn: $viewModel.sendWithoutTransactionOrderId)
        }
    }

    var currentRequestToSentSection: some View {
        Section(
            header:
                Text("Current request to send")
        ) {
            Text(viewModel.currentRequest)
                .contextMenu {
                    Button(action: {
                        UIPasteboard.general.string = viewModel.currentRequest
                    }) {
                        Text("Copy to clipboard")
                        Image(systemName: "doc.on.doc")
                    }
                }
        }
    }
    @ToolbarContentBuilder
    func toolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            Button("Done") {
                endTextEditing()
            }
        }
    }
}

struct ReprintTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ReprintTransactionView()
    }
}
