//
//  EntryExpenseView.swift
//  SwiftData ExpenseTracker
//
//  Created by Rizal Hilman on 22/05/24.
//

import SwiftUI
import PhotosUI
import SwiftData

struct EntryExpenseView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Category.name, order: .forward) var categories: [Category]
    
    @Binding var isPresented: Bool
    @State var category: Int = 0
    @State var amount: Double = 0
    @State var notes: String = ""
    @State var date: Date = Date.now
    
    @State var selectedPhotos: [PhotosPickerItem] = []
    @State var selectedImageData: Data?
    
    @State var images = [UIImage]()
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Category", selection: $category) {
                    Text("Choose category").tag(0)
                    ForEach(categories, id: \.self) { category in
                        Text("\(category.name)").tag(category.id.hashValue)
                    }
                }
                .pickerStyle(.navigationLink)
                
                HStack {
                    Text("Amount")
                    Spacer()
                    
                    TextField("Amount:", value: $amount, format: .currency(code: "IDR"))
                        .keyboardType(.numberPad)
                }
                
                HStack {
                    Text("Notes:")
                    Spacer()
                    TextField(text: $notes) {
                        Text("expense note.")
                    }
                }
                
                DatePicker("Expenses Date", selection: $date, displayedComponents: .date)
                
                PhotosPicker(selection: $selectedPhotos,
                             maxSelectionCount: 1,
                             selectionBehavior: .ordered,
                             matching: .images) {
                    Label("Select a photo", systemImage: "photo")
                }
                             .onChange(of: selectedPhotos) { oldValue, newValue in
                                 print("changedd!")
                                 convertToImages()
                             }
                
                
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        .padding(.vertical)
                }
                
            }
            .navigationTitle("Entry Expenses")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem {
                    Button(action: {
                        save()
                        isPresented.toggle()
                    }, label: {
                        Text("Save")
                    })
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isPresented.toggle()
                    }, label: {
                        Text("Cancel")
                    })
                }
            })
        }
    }
    
    private func save() {
        let expense = Expense(amount: amount, note: notes, date: date)
        expense.photo = selectedImageData
        expense.category = categories.filter { $0.id.hashValue == category }.first
        modelContext.insert(expense)
    }
    
    private func convertToImages() {
        images.removeAll()
        
        if !selectedPhotos.isEmpty {
            selectedPhotos.forEach { eachPhotoItem in
                Task {
                    if let imageData = try? await eachPhotoItem.loadTransferable(type: Data.self) {
                        self.selectedImageData = imageData // for saving to SwiftData
                        
                        // For user image preview
                        if let image = UIImage(data: imageData) {
                            images.append(image)
                        }
                    }
                }
            }
        }
    }
    
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "IDR"
        formatter.currencySymbol = "Rp"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = "."
        formatter.usesGroupingSeparator = true
        return formatter
    }
}


#Preview {
    EntryExpenseView(isPresented: .constant(true))
}
