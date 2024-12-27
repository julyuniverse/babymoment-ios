//
//  SocialLoginRequest.swift
//  BabyMoment
//
//  Created by July universe on 11/16/24.
//

struct SocialLoginRequest: Encodable {
    let idToken: String
    let provider: String
    let firstName: String?
    let lastName: String?
}
