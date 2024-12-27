//
//  LoginResponse.swift
//  BabyMoment
//
//  Created by July universe on 11/17/24.
//

struct LoginResponse: Decodable {
    let account: AccountDto
    let token: TokenDto
}
