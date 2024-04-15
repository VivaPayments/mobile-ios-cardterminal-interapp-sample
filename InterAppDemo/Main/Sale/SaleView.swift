//
//  SaleView.swift
//  InterAppDemo
//
//  Created by Alexandros Zattas on 13/2/23.
//  Copyright © 2023 Viva Wallet. All rights reserved.
//

import SwiftUI

struct SaleView: View {
 
    @ObservedObject var viewModel: SaleViewModel
    @State private var validationErrorText: String?
 
    init(saleRestorationModel: SaleRestorationModel?) {
        viewModel = SaleViewModel(saleRestorationModel: saleRestorationModel)
    }

    var body: some View {
        let showAlert = Binding<Bool>(
            get: { self.validationErrorText != nil },
            set: { _ in self.validationErrorText = nil }
        )
        NavigationView {
            VStack {
                Spacer()
                List {
                    ForEach($viewModel.saleParameters) { $param in
                        if param.type == .paymentMethod {
                            ParameterFieldViewWithMenu(
                                parameter: $param,
                                options: PaymentMethod.allCases
                            )
                        } else {
                            ParameterFieldView(
                                parameter: $param
                            )
                        }
                    }
                    Section(header: Text(viewModel.isvSaleParameters)) {
                        ForEach($viewModel.isvParameters) { $param in
                            ParameterFieldView(
                                parameter: $param
                            )
                        }
                    }
                    Button(viewModel.saleText) {
                        self.constructAndExecuteRequest()
                    }.frame(height: 50)
                    Button(viewModel.saleWithInstalmentsText) {
                        constructAndExecuteRequest(isSalewithInstalments: true)
                    }.frame(height: 50)
                    Button(viewModel.preauthText) {
                        constructAndExecuteRequest(isPreauth: true)
                    }.frame(height: 50)
                    Button(viewModel.restoreDefaultValuesText) {
                        viewModel.restoreDefaultValues()
                    }.frame(height: 50)
                }.toolbar(content: toolBarContent)
            }
            .blur(radius: viewModel.isWaitingForResponse ? 10.0 : 0.0)
            .disabled(viewModel.isWaitingForResponse)
            .alert(isPresented: showAlert) {
                Alert(
                    title: Text(viewModel.errorAlertTitleText),
                    message: Text(validationErrorText!),
                    dismissButton: .default(Text(viewModel.okText))
                )
            }
            .overlay {
                VStack {
                    ProgressView()
                    Text(viewModel.waitingForResponseText)
                    Button(viewModel.stopWaitingForResponseText) {
                        viewModel.isWaitingForResponse = false
                    }
                    .buttonStyle(.bordered)
                    .frame(height: 50)
                }
                .opacity(viewModel.isWaitingForResponse ? 1 : 0)
            }
        }
    }

    func constructAndExecuteRequest(isPreauth: Bool = false, isSalewithInstalments: Bool = false) {
        do {
            try viewModel.validateRequest(
                isPreauth: isPreauth,
                isSalewithInstalments: isSalewithInstalments
            )
            let request = viewModel.constructRequest(
                isPreauth: isPreauth,
                isSalewithInstalments: isSalewithInstalments
            )
            viewModel.executeRequest(request)
            viewModel.isWaitingForResponse = true
        } catch {
            self.validationErrorText = error as? String
        }
    }

    @ToolbarContentBuilder
    func toolBarContent() -> some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button(viewModel.doneText) {
                endTextEditing()
            }
        }
    }
    
}
