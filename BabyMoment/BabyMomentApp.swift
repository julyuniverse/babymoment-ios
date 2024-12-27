//
//  BabyMomentApp.swift
//  BabyMoment
//
//  Created by July universe on 10/27/24.
//

import SwiftUI
import SwiftData

@main
struct BabyMomentApp: App {    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Activity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
        }
//        .modelContainer(sharedModelContainer)
        .modelContainer(for: [Baby.self, Activity.self])
    }
}
