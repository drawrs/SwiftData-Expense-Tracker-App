//
//  ContentView.swift
//  SwiftData ExpenseTracker
//
//  Created by Rizal Hilman on 17/05/24.
//

import SwiftUI


struct ContentView: View {
        
    @State var isEntryFormPresented: Bool = false
    @State var isCategoryInputPresented: Bool = false
    @State var isEditCategoryInputPresented: Bool = false
    
    @State var categoryName: String = ""
    @State var totalExpenses: Double = 0
    
    var body: some View {
        NavigationStack {
            List {
                totalSpendingSection
                topSpendingSection
            }
            .listStyle(.insetGrouped)
            .sheet(isPresented: $isCategoryInputPresented) {
                CategoryInputView(categoryName: $categoryName) {
                    saveCategory()
                }
            }
            .sheet(isPresented: $isEditCategoryInputPresented) {
                CategoryInputView(categoryName: $categoryName) {
                    saveEditCategory()
                }
            }
            .onAppear {
                calculateTotalExpenses()
            }
        }
    }
    
    private var totalSpendingSection: some View {
        Section {
            VStack {
                Text("Total Spending")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Text("Rp 17.000.000")
                    .font(.largeTitle)
                    .padding(5)
                
                Button(action: {
                    isEntryFormPresented.toggle()
                }) {
                    Label("Record Expense", systemImage: "square.and.pencil")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .sheet(isPresented: $isEntryFormPresented, onDismiss: calculateTotalExpenses) {
                    EntryExpenseView(isPresented: $isEntryFormPresented)
                }
            }
            .padding(.vertical)
        }
    }
    
    private var topSpendingSection: some View {
        Section {
            ForEach(0...10, id: \.self) { category in
                NavigationLink(destination: ExpenseListView()) {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(category)")
                                    .font(.headline)
                                Text("Rp 200.000")
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("100 %")
                                .font(.headline)
                        }
                        ProgressView(value: 1)
                    }
                }
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button {
                        
                        isEditCategoryInputPresented.toggle()
                    } label: {
                        Text("Edit")
                    }
                    .tint(.blue)
                }
            }
            .onDelete(perform: delete)
        } header: {
            HStack {
                Text("Top Spending")
                    .font(.headline)
                Spacer()
                Button(action: {
                    categoryName = ""
                    isCategoryInputPresented.toggle()
                }) {
                    Label("New category", systemImage: "plus")
                        .font(.subheadline)
                }
            }
        }
    }
    
    private func calculateTotalExpenses() {
        
    }
    
    private func delete(at offsets: IndexSet) {
        for i in offsets {
            
        }
    }
    
    private func saveCategory() {
        print("perform save")
        categoryName = ""
    }
    
    private func saveEditCategory() {
        print("perform edit")
        
    }
}

#Preview {
    ContentView()
}
