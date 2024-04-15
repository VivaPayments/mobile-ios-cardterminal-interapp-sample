//
//  ViewExtension.swift
//  InterAppDemo
//
//  Created by Spyros Skordos on 14/3/22.
//  Copyright © 2022 Viva Wallet. All rights reserved.
//

import SwiftUI

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil)
    }
}
