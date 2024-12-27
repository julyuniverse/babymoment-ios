//
//  Activity.swift
//  BabyMoment
//
//  Created by July universe on 11/2/24.
//

import Foundation
import SwiftData

@Model
final class Activity {
    @Attribute(.unique) var id: UUID
    var title: String
    var desc: String
    var date: Date

    init(id: UUID = UUID(), title: String, desc: String, date: Date = Date()) {
        self.id = id
        self.title = title
        self.desc = desc
        self.date = date
    }
}

// Create dummy activities.
extension Activity {
    static let dummyActivities: [Activity] = [
        Activity(title: "Title1",
                 desc: "Desc1"),
        Activity(title: "Title2",
                 desc: "Desc2"),
        Activity(title: "Title3",
                 desc: "Desc3"),
        Activity(title: "Title4",
                 desc: "Desc4"),
        Activity(title: "Title5",
                 desc: "Desc5")
    ]
}
