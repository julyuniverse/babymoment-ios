//
//  UuidLoginResponse.swift
//  BabyMoment
//
//  Created by July universe on 12/14/24.
//

struct UuidLoginResponse: Decodable {
    let deviceId: Int
    let account: AccountDto?
    let baby: BabyDto?
}
