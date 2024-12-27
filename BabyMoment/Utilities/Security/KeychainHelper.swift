//
//  KeychainHelper.swift
//  BabyMoment
//
//  Created by July universe on 11/24/24.
//

import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()
    private let key = "com.benection.BabyMoment" // 고유 식별 키

    var getOrCreateDeviceUUID: String {
        if let existingUUID = retrieveDeviceUUID() {
            return existingUUID
        } else {
            let newUUID = UUID().uuidString
            storeDeviceUUID(newUUID)
            return newUUID
        }
    }

    private func storeDeviceUUID(_ uuid: String) {
        guard let data = uuid.data(using: .utf8) else { return }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary) // 기존 데이터 삭제
        SecItemAdd(query as CFDictionary, nil)
    }

    private func retrieveDeviceUUID() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var data: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &data)
        if status == errSecSuccess, let data = data as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
