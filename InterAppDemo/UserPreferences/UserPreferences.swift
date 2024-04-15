//
//  UserPreferences.swift
//  InterAppDemo
//
//  Created by Alexandros Zattas on 14/2/23.
//  Copyright © 2023 Viva Wallet. All rights reserved.
//

import Foundation

struct UserPreferences {
    
    static private let standard = UserDefaults.standard
    
    @UserProperty(key: .showRating, defaultValue: true)
    static var showRating: Bool
    @UserProperty(key: .showResult, defaultValue: true)
    static var showResult: Bool
    @UserProperty(key: .showReceipt, defaultValue: true)
    static var showReceipt: Bool
}
