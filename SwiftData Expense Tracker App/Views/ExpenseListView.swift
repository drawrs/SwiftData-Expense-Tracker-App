//
//  ExpenseView.swift
//  SwiftData ExpenseTracker
//
//  Created by Rizal Hilman on 17/05/24.
//

import SwiftUI
import SwiftData

struct ExpenseListView: View {
    
    var category: Category?
    
    @State var title: String = "Food & Beverage"
    
    var body: some View {
        List {
            ForEach(0...10, id: \.self) { expense in
                NavigationLink {
                    DetailExpenseView()
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Rp 50.000")
                                .font(.headline)
                            
                            Text("Note placeholder")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("Tue, 5 May")
                    }
                }
            }
            .onDelete(perform: delete)
            
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
    }
    
    func delete(at offsets: IndexSet) {
        for i in offsets {
            
        }
    }
}

#Preview {
    NavigationStack {
        ExpenseListView()
    }
}
