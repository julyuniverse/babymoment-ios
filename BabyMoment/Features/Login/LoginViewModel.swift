//
//  LoginViewModel.swift
//  BabyMoment
//
//  Created by July universe on 10/27/24.
//

import Foundation
import CryptoKit
import AuthenticationServices

class LoginViewModel: ObservableObject {
    @Published var isCheckingLoginStatus: Bool = true
    @Published var isLoggedIn: Bool = false
    @Published var showLoginView: Bool = true
    @Published var hasBaby: Bool = false
    @Published var showBabyCreationView: Bool = true
    @Published var showBabiesView: Bool = true
    
    @MainActor
    func uuidLogin() async {
        do {
            let defaults = UserDefaultsManager.shared
            let deviceInfo = DeviceInfoManager.shared.getDeviceInfo()
            let deviceUuid = deviceInfo["uuid"]!
            let deviceModel = deviceInfo["model"]!
            let systemName = deviceInfo["systemName"]!
            let systemVersion = deviceInfo["systemVersion"]!
            let uuidLoginRequest = UuidLoginRequest(deviceUuid: deviceUuid, deviceModel: deviceModel, systemName: systemName, systemVersion: systemVersion)
            let response = try await NetworkManager.shared.request(endpoint: .LOGIN_WITH_UUID, parameters: uuidLoginRequest, responseType: UuidLoginResponse.self)
            print("response: \(response)")
            defaults.deviceId = String(response.deviceId)
            if (response.account != nil) {
                isLoggedIn = true
                showLoginView = false
                if (response.baby != nil) {
                    hasBaby = true
//                    showBabyCreationView = false
                    showBabiesView = false
                }
            } else {
                isLoggedIn = false
                showLoginView = true
            }
            isCheckingLoginStatus = false
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    // Utility functions to generate nonce and hash
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
    @MainActor
    func handleAuthorization(_ authResults: ASAuthorization) async {
        guard let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential else {
            print("Invalid state: the returned authorization is not an Apple ID credential.")
            return
        }
        print("appleIDCredential: ")
        debugPrint(appleIDCredential)
        guard let idTokenData = appleIDCredential.identityToken else {
            print("Failed to fetch identity token.")
            return
        }
        print("idTokenData: ")
        debugPrint(idTokenData)
        guard let idTokenString = String(data: idTokenData, encoding: .utf8) else {
            print("Failed to decode identity token.")
            return
        }
        print("idTokenString: ")
        debugPrint(idTokenString)
        guard let authorizationCodeData = appleIDCredential.authorizationCode else {
            print("Failed to fetch authorization code.")
            return
        }
        print("authorizationCodeData: ")
        debugPrint(authorizationCodeData)
        guard let authorizationCodeString = String(data: authorizationCodeData, encoding: .utf8) else {
            print("Failed to decode authorization code.")
            return
        }
        print("authorizationCodeString: ")
        debugPrint(authorizationCodeString)
        
        // Get full name
        let fullName = appleIDCredential.fullName
        print("fullName: ")
        debugPrint(fullName ?? "")
        let firstName = fullName?.givenName
        print("firstName: ")
        debugPrint(firstName ?? "")
        let lastName = fullName?.familyName
        print("lastName: ")
        debugPrint(lastName ?? "")
        do {
            let defaults = UserDefaultsManager.shared
            // set request body
            let socialLoginRequest = SocialLoginRequest(idToken: idTokenString, provider: "apple", firstName: firstName, lastName: lastName)

            let response: LoginResponse = try await NetworkManager.shared.request(endpoint: .LOGIN_WITH_SOCIAL_PROVIDER,
                                                                        parameters: socialLoginRequest,
                                                                        responseType: LoginResponse.self)
            print("response: \(response)")
            defaults.accessToken = response.token.accessToken
            defaults.refreshToken = response.token.refreshToken
        } catch {
            print("Error creating user: \(error.localizedDescription)")
        }
//
//            // set local storage
//            defaults.set(decodedData.token.accessToken, forKey: "accessToken")
//            defaults.set(decodedData.token.refreshToken, forKey: "refreshToken")
//            defaults.set("loggedIn", forKey: "appState")
//        } catch {
//            self.hasError = true
//            if let uuidLoginError = error as? UuidLoginError {
//                self.error = uuidLoginError
//            } else {
//                self.error = .ERROR(error: error)
//            }
//        }
    }
}
