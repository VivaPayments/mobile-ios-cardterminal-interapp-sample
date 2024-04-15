//
//  SaleViewModel.swift
//  InterAppDemo
//
//  Created by Alexandros Zattas on 13/2/23.
//  Copyright © 2023 Viva Wallet. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class SaleViewModel: ObservableObject {

    let doneText = "Done"
    let saleText = "SALE"
    let saleWithInstalmentsText = "SALE WITH INSTALMENTS"
    let preauthText = "PREAUTH"
    let okText = "OK"
    let isvSaleParameters = "ISV SALE PARAMETERS"
    let errorAlertTitleText = "Error"
    let restoreDefaultValuesText = "Restore default field values"
    let waitingForResponseText = "Waiting for response..."
    let stopWaitingForResponseText = "Stop waiting"
    var subscriptions = Set<AnyCancellable>()
    
    init(saleRestorationModel: SaleRestorationModel?) {
        self.saleParameters = saleRestorationModel?.parameters.filter { !$0.type.isISVRelated } ??  ParameterType.allCases.compactMap({ type in
            guard !type.isISVRelated else {
                return nil
            }
            return ParameterField(type: type)
        })
        self.isvParameters = saleRestorationModel?.parameters.filter { $0.type.isISVRelated } ?? ParameterType.allCases.compactMap({ type in
            guard type.isISVRelated else {
                return nil
            }
            return ParameterField(type: type)
        })
        
        self.isWaitingForResponse = saleRestorationModel?.isWaitingForResponse ?? false
        
        parameters.forEach {
            $0.$textFieldText
                .removeDuplicates()
                .dropFirst()
                .sink(receiveValue: { _ in
                    self.objectWillChange.send()
                    self.performSceneUpdates()
                })
                .store(in: &subscriptions)
        }
        
        $isWaitingForResponse
            .removeDuplicates()
            .dropFirst()
            .sink(receiveValue: { newValue in
                self.performSceneUpdates(isWaitingForResponse: newValue)
            })
            .store(in: &subscriptions)
    }
    
    deinit {
        subscriptions.removeAll()
    }

    var parameters: [ParameterField] {
        return saleParameters + isvParameters
    }

    @Published var saleParameters: [ParameterField]
    
    @Published var isvParameters: [ParameterField]
    
    @Published var isWaitingForResponse: Bool

    private var showReceiptParameter: String {
        return String(
            format: "&%@=%@",
            UserPropertyKey.showReceipt.rawValue,
            String(describing: UserPreferences.showReceipt)
        )
    }
    
    private var showResultParameter: String {
        return String(
            format: "&%@=%@",
            UserPropertyKey.showResult.rawValue,
            String(describing: UserPreferences.showResult)
        )
    }
    
    private var showRatingParameter: String {
        return String(
            format: "&%@=%@",
            UserPropertyKey.showRating.rawValue,
            String(describing: UserPreferences.showRating)
        )
    }
    
    func restoreState(for request: String?) {
        guard
            let request,
            !request.isEmpty
        else {
            return
        }
        let fieldsdictionary = request
            .components(separatedBy: "&")
            .reduce(
                into: [String: String]()
            ) { aggregate, element in
                let elements = element.components(separatedBy: "=")
                aggregate[elements[0]] = elements[1]
        }
                
        for (index, param) in parameters.enumerated() {
            parameters[index].textFieldText = fieldsdictionary[param.type.rawValue] ?? ""
        }
    }

    func constructAndExecuteRequest(
        isPreauth: Bool = false,
        isSalewithInstalments: Bool = false
    ) -> String {
        var saleActionURL = isPreauth ? Constants.preauthUrlString : Constants.saleUrlString

        parameters.forEach {
            if !$0.textFieldText.isEmpty {
                saleActionURL.append(String(format: "&%@=%@", $0.type.rawValue, $0.textFieldText.replacingOccurrences(of: " ", with: "_")))
            }
        }
        saleActionURL.append(showRatingParameter)
        saleActionURL.append(showResultParameter)
        saleActionURL.append(showReceiptParameter)
        saleActionURL.append(
            String(format: "&%@=%@", "withInstallments", String(describing: isSalewithInstalments))
        )

        executeRequest(saleActionURL)
        return saleActionURL
    }
    
    func constructRequest(
        isPreauth: Bool = false,
        isSalewithInstalments: Bool = false
    ) -> String {
        var saleActionURL = isPreauth ? Constants.preauthUrlString : Constants.saleUrlString

        parameters.forEach {
            if !$0.textFieldText.isEmpty {
                saleActionURL.append(String(format: "&%@=%@", $0.type.rawValue, $0.textFieldText.replacingOccurrences(of: " ", with: "_")))
            }
        }
        saleActionURL.append(showRatingParameter)
        saleActionURL.append(showResultParameter)
        saleActionURL.append(showReceiptParameter)
        saleActionURL.append(
            String(format: "&%@=%@", "withInstallments", String(describing: isSalewithInstalments))
        )
        return saleActionURL
    }
    
    func executeRequest(_ request: String) {
        (UIApplication.shared.delegate as? AppDelegate)?.performInterAppRequest(
            request: request
        )
    }

    func validateRequest(
        isPreauth: Bool,
        isSalewithInstalments: Bool
    ) throws {
        guard
            parameters.contains(where: { $0.type == .amount && (($0.textFieldText.toInt ?? 0) > 0) }
            )
        else {
            throw "Please enter a valid sale amount"
        }

        if (parameters.first(where: { $0.type == .tipAmount })?.textFieldText.toInt ?? 0) > 0,
            isPreauth || isSalewithInstalments
        {
            throw "Can not apply tip to an instalments or preauth sale"
        }

        if parameters.contains(where: {
            $0.type == .isvClientId && !$0.textFieldText.isEmpty
                && $0.type == .isvClientSecret && !$0.textFieldText.isEmpty
                && $0.type == .isvAmount && (($0.textFieldText.toInt ?? 0) > 0)
        }) {
            throw "ISV client Id, ISV client secret and ISV amount are required for an ISV sale"
        }
    }
    
    func restoreDefaultValues() {
        for (index, param) in parameters.enumerated() {
            parameters[index].textFieldText = param.type.defaultInputValue
        }
    }
    
    private func performSceneUpdates(isWaitingForResponse: Bool? = nil) {
        let scenes = UIApplication.shared.connectedScenes
        
        let filteredScenes = scenes.filter { scene in
            if let userInfo = scene.session.userInfo {
                if let mainSceneDelegate = scene.delegate as? SceneDelegate {
                    
                    let restorationSale = SaleRestorationModel(
                        parameters: parameters,
                        isWaitingForResponse: isWaitingForResponse ?? self.isWaitingForResponse
                    )
                    mainSceneDelegate.updateScene(with: restorationSale)
                }
            }
            
            return true
        }
    }
}
