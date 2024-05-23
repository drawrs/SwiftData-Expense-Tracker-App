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
    
    @State private var selectedCategoryID: Int?
    @State private var amount: Double = 0
    @State private var notes: String = ""
    @State private var date: Date = Date.now
    
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedImageData: Data?
    
    // For preview
    @State private var images: [UIImage] = []
    
    var body: some View {
        NavigationStack {
            Form {
                categoryPickerSection
                amountSection
                notesSection
                datePickerSection
                photoPickerSection
                imagesSection
            }
            .navigationTitle("Entry Expenses")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        isPresented.toggle()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented.toggle()
                    }
                }
            }
        }
    }
    
    private var categoryPickerSection: some View {
        Section {
            Picker("Category", selection: $selectedCategoryID) {
                Text("Choose category").tag(nil as Int?)
                ForEach(categories) { category in
                    Text(category.name).tag(category.id.hashValue as Int?)
                }
            }
            .pickerStyle(.navigationLink)
        }
    }
    
    private var amountSection: some View {
        Section {
            HStack {
                Text("Amount")
                Spacer()
                TextField("Amount:", value: $amount, format: .currency(code: "IDR"))
                    .keyboardType(.numberPad)
            }
        }
    }
    
    private var notesSection: some View {
        Section {
            HStack {
                Text("Notes")
                Spacer()
                TextField("Expense note", text: $notes)
            }
        }
    }
    
    private var datePickerSection: some View {
        Section {
            DatePicker("Expenses Date", selection: $date, displayedComponents: .date)
        }
    }
    
    private var photoPickerSection: some View {
        Section {
            PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 1, matching: .images) {
                Label("Select a photo", systemImage: "photo")
            }
            .onChange(of: selectedPhotos) {
                convertToImages()
            }
        }
    }
    
    private var imagesSection: some View {
        Section {
            ForEach(images, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .padding(.vertical)
            }
        }
    }
    
    private func save() {
        guard let category = categories.first(where: { $0.id.hashValue == selectedCategoryID }) else { return }
        
        let expense = Expense(amount: amount, note: notes, date: date)
        expense.photo = selectedImageData
        expense.category = category
        modelContext.insert(expense)
        print("saved!")
    }
    
    private func convertToImages() {
        images.removeAll()
        
        for eachPhotoItem in selectedPhotos {
            Task {
                if let imageData = try? await eachPhotoItem.loadTransferable(type: Data.self) {
                    selectedImageData = imageData
                    if let image = UIImage(data: imageData) {
                        images.append(image)
                    }
                }
            }
        }
    }
}


#Preview {
    EntryExpenseView(isPresented: .constant(true))
}
