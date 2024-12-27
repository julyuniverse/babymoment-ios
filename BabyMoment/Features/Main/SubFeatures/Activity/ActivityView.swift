//
//  ActivityView.swift
//  BabyMoment
//
//  Created by July universe on 10/27/24.
//

import SwiftUI
import SwiftData

struct ActivityView: View {
    @StateObject var activityViewModel: ActivityViewModel = ActivityViewModel(repository: .shared)
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(activityViewModel.activities) { activity in
                    VStack(alignment: .leading) {
                        Text(activity.title).font(.headline)
                    }
                }
                .onDelete(perform: activityViewModel.deleteActivities)
            }
            .navigationTitle("Activity")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: activityViewModel.addActivity) {
                        Label("Add Activity", systemImage: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    ActivityView()
}
