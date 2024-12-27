//
//  ErrorResponse.swift
//  BabyMoment
//
//  Created by July universe on 12/28/24.
//

struct ErrorResponse: Decodable {
    let timestamp: String
    let status: Int
    let error: String
    let message: String
    let code: String
}
