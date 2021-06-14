//
//  Extensions.swift
//  InterAppDemo
//
//  Created by Alexandros Zattas on 27/2/20.
//  Copyright © 2020 Viva Wallet. All rights reserved.
//
import Foundation

extension String {
    func toDate(withFormat f: String = "yyyy-MM-dd'T'HH:mm:ss'Z'", timeZone: TimeZone? = nil) -> Date? {
        let df = DateFormatter()
        df.dateFormat = f
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = timeZone == nil ? TimeZone(abbreviation: "UTC") : timeZone
        return df.date(from: self)
    }
    
    var isAlphaNumeric: Bool {
        let regex = "^[a-zA-Z0-9]*$"
        let inputP = NSPredicate(format:"SELF MATCHES %@", regex)
        return inputP.evaluate(with: self)
    }
}

public extension Date {
    func toString(withFormat f: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ", timeZone: TimeZone? = nil, calendar: Calendar? = nil) -> String {
        let df = DateFormatter()
        df.dateFormat = f
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = timeZone == nil ? TimeZone.current : timeZone!
        df.calendar = calendar == nil ? Calendar(identifier: .gregorian) : calendar!
        return df.string(from: self)
    }
}

extension URL {
    func toStringDictionary() -> [String: String]? {
        guard let query = self.query else { return nil}
        
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            
            let key = pair.components(separatedBy: "=")[0]
            
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value.removingPercentEncoding
        }
        return queryStrings
    }
}

extension Decimal {
    func toCurrencyString() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.currencySymbol = Locale.current.currencySymbol!
        currencyFormatter.locale = Locale.current
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.minimumFractionDigits = 2
        return currencyFormatter.string(from: self as NSNumber)!
    }
}
