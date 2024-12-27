//
//  BabyCreationRequest.swift
//  BabyMoment
//
//  Created by July universe on 12/25/24.
//

import Foundation

struct BabyCreationRequest: Encodable {
    let accountId: Int = 1
    let name: String
    let birthday: Date = Date()
    let gender: String
    let bloodType: String
    let relationshipType: String
}
