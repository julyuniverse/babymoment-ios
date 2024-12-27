//
//  ApiEndpoint.swift
//  BabyMoment
//
//  Created by July universe on 11/16/24.
//

enum ApiEndpoint {
    case getPosts1
    case getPosts2
    case LOGIN_WITH_UUID
    case LOGIN_WITH_SOCIAL_PROVIDER
    case REISSUE_TOKEN
    case CREATE_BABY
    case getUsers
    case getComments(postID: Int)
    case createUser
    
    var path: String {
        switch self {
        case .getPosts1:
            return "/v1/posts/1"
        case .getPosts2:
            return "/v1/posts/2"
        case .LOGIN_WITH_UUID:
            return "/v1/auth/login/uuid"
        case .LOGIN_WITH_SOCIAL_PROVIDER:
            return "/v1/auth/login/social"
        case .REISSUE_TOKEN:
            return "/v1/auth/token/reissue"
        case .CREATE_BABY:
            return "/v1/babies"
        case .getUsers:
            return "/users"
        case .getComments(let postID):
            return "/posts/\(postID)/comments"
        case .createUser:
            return "/users"
        }
    }
    
    var method: String {
        switch self {
        case .LOGIN_WITH_UUID, .LOGIN_WITH_SOCIAL_PROVIDER, .REISSUE_TOKEN, .CREATE_BABY:
            return "POST"
        case .getPosts1, .getPosts2, .getUsers:
            return "GET"
        case .getComments:
            return "POST"
        case .createUser:
            return "PUT"
        }
    }
}
