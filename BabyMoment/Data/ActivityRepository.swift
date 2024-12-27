//
//  ActivityRepository.swift
//  BabyMoment
//
//  Created by July universe on 11/2/24.
//

import Foundation
import SwiftData

class ActivityRepository {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = ActivityRepository()
    
    @MainActor
    private init() {
        // Change isStoredInMemoryOnly to false if you would like to see the data persistance after kill/exit the app
        modelContainer = try! ModelContainer(for: Activity.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        modelContext = modelContainer.mainContext
    }
    
    func fetchActivities() -> [Activity] {
        do {
            return try modelContext.fetch(FetchDescriptor<Activity>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func addActivity(_ activity: Activity) {
        modelContext.insert(activity)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func deleteActivity(_ activity: Activity) {
        modelContext.delete(activity)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func deleteActivities(at offsets: IndexSet, from activities: [Activity]) {
        for index in offsets {
            modelContext.delete(activities[index])
        }
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
