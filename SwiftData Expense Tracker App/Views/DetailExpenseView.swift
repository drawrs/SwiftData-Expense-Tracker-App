//
//  DetailView.swift
//  SwiftData ExpenseTracker
//
//  Created by Rizal Hilman on 17/05/24.
//

import SwiftUI

struct DetailExpenseView: View {
    
    var expense: Expense
    
    var body: some View {
        Form {
            Section(header: Text("Expense Details")) {
                DetailRow(label: "Category", value: expense.category?.name ?? "Category Placeholder")
                DetailRow(label: "Amount", value: expense.amount.asRupiah())
                DetailRow(label: "Notes", value: expense.note)
            }
            
            if let photoData = expense.photo, let uiImage = UIImage(data: photoData) {
                Section(header: Text("Receipt Photo")) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .padding(.vertical, 10)
                }
            }
        }
        .navigationTitle(expense.date.asFormattedString())
        .navigationBarTitleDisplayMode(.large)
    }
}

struct DetailRow: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}



#Preview {
    NavigationStack {
        DetailExpenseView(expense: Expense(amount: 20000,
                                           note: "Tes",
                                           date: Date.now))
    }
}
