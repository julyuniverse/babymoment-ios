//
//  DeviceInfoManager.swift
//  BabyMoment
//
//  Created by July universe on 12/14/24.
//

import UIKit
import Security

class DeviceInfoManager {
    static let shared = DeviceInfoManager()
    private let key = "com.benection.BabyMoment" // 고유 식별 키

    func getDeviceInfo() -> [String: String] {
        let device = UIDevice.current
        var info: [String: String] = [:]
        info["uuid"] = getOrCreateDeviceUuid()
        info["model"] = device.model // 디바이스 모델 (예: "iPhone")
        info["systemName"] = device.systemName // ios 이름 (예: "iOS")
        info["systemVersion"] = device.systemVersion // ios 버전 (예: "18.0")
        return info
    }

    private func getOrCreateDeviceUuid() -> String {
        if let existingUuid = retrieveDeviceUuid() {
            return existingUuid
        } else {
            let newUuid = UUID().uuidString
            storeDeviceUuid(newUuid)
            return newUuid
        }
    }

    private func storeDeviceUuid(_ uuid: String) {
        guard let data = uuid.data(using: .utf8) else { return }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary) // 기존 데이터 삭제
        SecItemAdd(query as CFDictionary, nil)
    }

    private func retrieveDeviceUuid() -> String? {
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
