//
//  AuthenticateView.swift
//  InterAppDemo
//
//  Created by Spyros Skordos on 11/3/22.
//  Copyright © 2022 Viva Wallet. All rights reserved.
//

import SwiftUI

struct ActivationPOSView: View {
    @ObservedObject var viewModel = ActivationPOSViewModel()

    var body: some View {
        UITextField.appearance().clearButtonMode = .whileEditing

        return VStack {
            Text("Activate POS APP via an intent")
            Form {
                credentialsSection
                activationCodeSection
                optionalParamsSection
                currentRequestToSentSection
            }.toolbar {
                toolBarContent()
            }
            getActivationCode
            activateButton

        }

    }

    var optionalParamsSection: some View {
        Section(header: Text("Optional parameters")) {
            TextField("Enter SourceID", text: $viewModel.sourceId)

            Picker("Activate Moto", selection: $viewModel.selectedMotoPickerValue) {
                ForEach(viewModel.optionsForPicker, id: \.self) {
                    Text($0)
                }
            }

            Picker("Activate QR Codes", selection: $viewModel.selectedQRCodesPickerValue) {
                ForEach(viewModel.optionsForPicker, id: \.self) {
                    Text($0)
                }
            }
            Picker(
                "Disable Manual Amount Entry",
                selection: $viewModel.selectedDisableManualAmountEntryPickerValue
            ) {
                ForEach(viewModel.optionsForPicker, id: \.self) {
                    Text($0)
                }
            }
            Picker(
                "Force card presentment for refunds",
                selection: $viewModel.forceCardPresentmentForRefundPickerValue
            ) {
                ForEach(viewModel.optionsForPicker, id: \.self) {
                    Text($0)
                }
            }
            TextField("Enter PinCode", text: $viewModel.pinCode)
            Picker("Lock Refund", selection: $viewModel.lockRefundPickerValue) {
                ForEach(viewModel.optionsForPicker, id: \.self) {
                    Text($0)
                }
            }
            Picker("Lock Transactions List", selection: $viewModel.lockTransactionsListPickerValue)
            {
                ForEach(viewModel.optionsForPicker, id: \.self) {
                    Text($0)
                }
            }

            Picker("Lock Moto", selection: $viewModel.lockMotoPickerValue) {
                ForEach(viewModel.optionsForPicker, id: \.self) {
                    Text($0)
                }
            }
            Picker("Lock Preauth", selection: $viewModel.lockPreauthPickerValue) {
                ForEach(viewModel.optionsForPicker, id: \.self) {
                    Text($0)
                }
            }

        }
    }

    var credentialsSection: some View {
        Section(header: Text("Activate with credentials")) {
            TextField("Enter ApiKey", text: $viewModel.apikey)
            TextField("Enter ApiSecret", text: $viewModel.apiSecret)
        }
    }

    var activationCodeSection: some View {
        Section(header: Text("Activate with activation code")) {
            TextField("Enter Activation Code", text: $viewModel.activationCode)
        }
    }

    var setupSection: some View {
        Section(header: Text("Set up parameters")) {
            Toggle("Activate MOTO", isOn: $viewModel.activateMoto)
            Toggle("Activate Smart Checkout", isOn: $viewModel.activateSmartCheckout)
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
                }  .fixedSize(horizontal: false, vertical: true)
        }
    }

    var activateButton: some View {
        Button(action: {
            viewModel.activate()
        }) {
            Text("Activate POS App").frame(minWidth: 0, maxWidth: .infinity)
        }.buttonStyle(PrimaryButtonStyle()).padding()
    }
    var getActivationCode: some View {
        Button(action: {
            viewModel.getActivationCode()
        }) {
            Text("Get Activation Code").frame(minWidth: 0, maxWidth: .infinity)
        }.buttonStyle(PrimaryButtonStyle()).padding()
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

struct AuthenticateView_Previews: PreviewProvider {
    static var previews: some View {
        ActivationPOSView()
    }
}
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(5)
            .foregroundColor(.blue)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.blue, lineWidth: 1.5)
            )
    }
}
