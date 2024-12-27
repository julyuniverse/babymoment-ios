//
//  Account.swift
//  BabyMoment
//
//  Created by July universe on 11/10/24.
//

import Foundation
import SwiftData

@Model
final class Account {
    @Attribute(.unique) var accountId: Int
    
    init(accountId: Int) {
        self.accountId = accountId
    }
}
