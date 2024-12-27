//
//  ActivityViewModel.swift
//  BabyMoment
//
//  Created by July universe on 11/2/24.
//

import Foundation
import Combine

class ActivityViewModel: ObservableObject {
    @Published var activities: [Activity] = []
    private let repository: ActivityRepository
    
    init(repository: ActivityRepository) {
        self.repository = repository
        
        // Add dummy activities to the SwiftData to see if fetching data is works.
        let dummyActivities = Activity.dummyActivities
        for activity in dummyActivities {
            repository.addActivity(activity)
        }
        activities = repository.fetchActivities()
    }
    
    func addActivity() {
        let activity = Activity(title: "Title!",
                                desc: "Desc")
        repository.addActivity(activity)
        
        // Manually fetch the latest activities after add new activity.
        activities = repository.fetchActivities()
    }
    
    func deleteActivity(_ activity: Activity) {
        repository.deleteActivity(activity)
        activities = repository.fetchActivities()
    }
    
    func deleteActivities(at offsets: IndexSet) {
        // Delete activities based on the given offsets
        repository.deleteActivities(at: offsets, from: activities)
        
        // Refresh the activities list after deletion
        activities = repository.fetchActivities()
    }
}
