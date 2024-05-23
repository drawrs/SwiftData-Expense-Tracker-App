//
//  ContentView.swift
//  SwiftData ExpenseTracker
//
//  Created by Rizal Hilman on 17/05/24.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Query(sort: \Category.name, order: .forward) var categories: [Category]
        @Environment(\.modelContext) var modelContext
        
        @State var isEntryFormPresented: Bool = false
        @State var isCategoryInputPresented: Bool = false
        @State var isEditCategoryInputPresented: Bool = false
        
        @State var categoryName: String = ""
        @State var totalExpenses: Double = 0
        @State var selectedCategory: Category?
    
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
                Text(totalExpenses.asRupiah())
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
                .sheet(isPresented: $isEntryFormPresented) {
                    EntryExpenseView(isPresented: $isEntryFormPresented)
                }
            }
            .padding(.vertical)
        }
    }
    
    private var topSpendingSection: some View {
        Section {
            ForEach(categories, id: \.self) { category in
                NavigationLink(destination: ExpenseListView(category: category)) {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(category.name)
                                    .font(.headline)
                                Text(category.totalExpenses().asRupiah())
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(category.expensePercentage(of: totalExpenses))
                                .font(.headline)
                        }
                        ProgressView(value: category.progressValue(for: totalExpenses))
                            .onAppear {
                                print(CGFloat(category.totalExpenses() / totalExpenses))
                            }
                    }
                }
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button {
                        selectedCategory = category
                        categoryName = category.name
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
        totalExpenses = categories.reduce(0) { $0 + $1.totalExpenses() }
    }
    
    private func delete(at offsets: IndexSet) {
        for i in offsets {
            let category = categories[i]
            modelContext.delete(category)
            print("deleted!")
        }
    }
    
    private func saveCategory() {
        print("perform save")
        let category = Category(name: categoryName)
        modelContext.insert(category)
        categoryName = ""
        print("saved!")
    }
    
    private func saveEditCategory() {
        print("perform edit")
        if let category = selectedCategory {
            category.name = categoryName
            do {
                try modelContext.save()
                print("Updated!")
            } catch {
                print("Failed to update: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ContentView()
}
