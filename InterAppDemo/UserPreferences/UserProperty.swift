//
//  UserProperty.swift
//  InterAppDemo
//
//  Created by Alexandros Zattas on 14/2/23.
//  Copyright © 2023 Viva Wallet. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserProperty<Value> {

    let key: UserPropertyKey
    let defaultValue: Value
    var standard: UserDefaults {
        return UserDefaults.standard
    }

    public var wrappedValue: Value {
        set {
            if let val = newValue as? AnyOptional,
                val.isNil
            {
                standard.removeObject(forKey: key.rawValue)
            } else {
                standard.set(newValue, forKey: key.rawValue)
            }
            standard.synchronize()
        }
        get {
            return standard.value(forKey: key.rawValue) as? Value ?? defaultValue
        }
    }
}

extension UserProperty where Value: ExpressibleByNilLiteral {
    init(
        key: UserPropertyKey
    ) {
        self.init(key: key, defaultValue: nil)
    }
}

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}
