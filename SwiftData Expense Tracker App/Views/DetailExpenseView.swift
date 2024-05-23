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
        Form(content: {
            HStack {
                Text("Category")
                Spacer()
                Text(expense.category?.name ?? "Category Placeholder")
            }
            
            HStack {
                Text("Ammount")
                Spacer()
                Text(expense.amount.asRupiah())
            }
            
            HStack {
                Text("Notes")
                Spacer()
                Text(expense.note)
            }
            
            if let photo = expense.photo {
                Image(uiImage: UIImage(data: photo)!)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .padding(.vertical)
            }
        })
        .navigationTitle(expense.date.asFormattedString())
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        DetailExpenseView(expense: Expense(amount: 20000, 
                                    note: "Tes",
                                    date: Date.now))
    }
}
