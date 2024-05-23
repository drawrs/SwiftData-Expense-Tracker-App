//
//  SwiftData_Expense_Tracker_AppApp.swift
//  SwiftData Expense Tracker App
//
//  Created by Rizal Hilman on 23/05/24.
//

import SwiftUI
import SwiftData

@main
struct SwiftData_Expense_Tracker_AppApp: App {
    var sharedModelContainer: ModelContainer = {
        let scheme = Schema([
            // entities here
            Expense.self,
            Category.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: scheme,
                                                    isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: scheme, configurations: modelConfiguration)
        } catch {
            fatalError("Could not create model container \(error)")
        }
    
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
        .modelContainer(sharedModelContainer)
    }
}
