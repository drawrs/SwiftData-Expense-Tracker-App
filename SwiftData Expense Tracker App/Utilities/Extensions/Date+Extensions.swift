//
//  Date+Extensions.swift
//  SwiftData ExpenseTracker
//
//  Created by Rizal Hilman on 23/05/24.
//

import Foundation

extension Date {
    func asFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        return formatter.string(from: self)
    }
}
