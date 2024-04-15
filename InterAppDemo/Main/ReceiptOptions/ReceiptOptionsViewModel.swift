//
//  ReceiptOptionsViewModel.swift
//  InterAppDemo
//
//  Created by Spyros Skordos on 10/3/22.
//  Copyright © 2022 Viva Wallet. All rights reserved.
//

import Foundation


class ReceiptOptionsViewModel: ObservableObject {
    
    let storage: UserDefaults
    
    init(storage: UserDefaults = .standard) {
        self.storage = storage
    }
}
