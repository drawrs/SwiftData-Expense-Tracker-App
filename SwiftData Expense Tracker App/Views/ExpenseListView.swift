//
//  ExpenseView.swift
//  SwiftData ExpenseTracker
//
//  Created by Rizal Hilman on 17/05/24.
//

import SwiftUI
import SwiftData

extension Date {
    func asFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        return formatter.string(from: self)
    }
}

struct ExpenseListView: View {
    @Environment(\.modelContext) var modelContext
    var category: Category?
    
    @State var title: String = "Food & Beverage"
    
    var body: some View {
        List {
            if let expenses = category?.expenses {
                ForEach(expenses, id: \.self) { expense in
                    NavigationLink {
                        DetailView(expense: expense)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(expense.amount.asRupiah())
                                    .font(.headline)
                                
                                Text(expense.note)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(expense.date.asFormattedString())
                        }
                    }
                }
                .onDelete(perform: delete)
            } else {
                HStack {
                    Text("Empty")
                }
            }
            
        }
        .navigationTitle(category?.name ?? "Title placeholder")
        .navigationBarTitleDisplayMode(.large)
    }
    
    func delete(at offsets: IndexSet) {
        for i in offsets {
            if let expense = category?.expenses?[i] {
                modelContext.delete(expense)
            }
            
        }
        print("perform delete")
    }
}

#Preview {
    NavigationStack {
        ExpenseListView()
    }
}
