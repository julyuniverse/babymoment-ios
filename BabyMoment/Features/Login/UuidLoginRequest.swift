//
//  UuidLoginRequest.swift
//  BabyMoment
//
//  Created by July universe on 12/3/24.
//

struct UuidLoginRequest: Encodable {
    let deviceUuid: String
    let deviceModel: String
    let systemName: String
    let systemVersion: String
}
