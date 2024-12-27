//
//  Baby.swift
//  BabyMoment
//
//  Created by July universe on 12/23/24.
//

import Foundation
import SwiftData

@Model
final class Baby {
    @Attribute(.unique) var babyId: Int
    var name: String
    
    init(babyId: Int, name: String) {
        self.babyId = babyId
        self.name = name
    }
}
