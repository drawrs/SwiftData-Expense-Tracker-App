//
//  Category.swift
//  SwiftData ExpenseTracker
//
//  Created by Rizal Hilman on 22/05/24.
//

import Foundation
import SwiftData

@Model
final class Category {
    var name: String
    
    @Relationship(deleteRule: .cascade, inverse: \Expense.category)
    var expenses: [Expense]?
    
    init(name: String) {
        self.name = name
    }
}

extension Category {
    func totalExpenses() -> Double {
        return (expenses ?? []).reduce(0) { $0 + $1.amount }
    }
    
    func expensePercentage(of totalExpenses: Double) -> String {
        let percentage = totalExpenses == 0 ? 0 : self.totalExpenses() / totalExpenses
        return String(format: "%.0f%%", percentage * 100)
    }
    
    func progressValue(for totalExpenses: Double) -> CGFloat {
        let value = totalExpenses == 0 ? 0 : self.totalExpenses() / totalExpenses
        return CGFloat(min(max(value, 0), 1))
    }
}
