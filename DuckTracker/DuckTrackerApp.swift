//
//  DuckTrackerApp.swift
//  DuckTracker
//
//  Created by Roman Rozinko on 24.07.23.
//

import SwiftUI

@main
struct DuckTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
