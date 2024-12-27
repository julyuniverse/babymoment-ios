//
//  BabyRepository.swift
//  BabyMoment
//
//  Created by July universe on 12/23/24.
//

import Foundation
import SwiftData

class BabyRepository {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = BabyRepository()
    
    @MainActor
    init() {
        modelContainer = try! ModelContainer(for: Baby.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        modelContext = modelContainer.mainContext
    }
    
    func addBaby(_ baby: Baby) {
        modelContext.insert(baby)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func deleteActivity(_ baby: Baby) {
        modelContext.delete(baby)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func deleteActivities(at offsets: IndexSet, from babies: [Baby]) {
        for index in offsets {
            modelContext.delete(babies[index])
        }
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
