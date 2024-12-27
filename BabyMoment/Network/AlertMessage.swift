//
//  AlertMessage.swift
//  BabyMoment
//
//  Created by July universe on 11/16/24.
//

import Foundation

struct AlertMessage: Identifiable {
    let id = UUID() // 각 메시지에 고유 ID를 부여
    let message: String
}
