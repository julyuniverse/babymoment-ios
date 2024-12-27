//
//  UserDefaultsManager.swift
//  BabyMoment
//
//  Created by July universe on 12/21/24.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    private init() {}
    
    var deviceId: String {
        get { defaults.string(forKey: "deviceId") ?? "" }
        set { defaults.set(newValue, forKey: "deviceId") }
    }
    
    var accessToken: String {
        get { defaults.string(forKey: "accessToken") ?? "" }
        set { defaults.set(newValue, forKey: "accessToken") }
    }
    
    var refreshToken: String {
        get { defaults.string(forKey: "refreshToken") ?? "" }
        set { defaults.set(newValue, forKey: "refreshToken") }
    }
}
