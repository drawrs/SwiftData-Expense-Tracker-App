//
//  Double+Extensions.swift
//  SwiftData ExpenseTracker
//
//  Created by Rizal Hilman on 23/05/24.
//

import Foundation

extension Double {
    func asRupiah() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "IDR"
        formatter.currencySymbol = "Rp"
        formatter.maximumFractionDigits = 0 // Rupiah generally does not use decimal places

        if let formattedString = formatter.string(from: NSNumber(value: self)) {
            return formattedString
        } else {
            return "Rp \(self)"
        }
    }
}
