//
//  LoginView.swift
//  BabyMoment
//
//  Created by July universe on 10/27/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        SignInWithAppleButton(
            .signIn,
            onRequest: { request in
                let nonce = loginViewModel.randomNonceString()
                request.requestedScopes = [.email, .fullName]
                request.nonce = loginViewModel.sha256(nonce)
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    Task {
                        await loginViewModel.handleAuthorization(authResults)
                    }
                case .failure(let error):
                    print("Authorization failed: \(error.localizedDescription)")
                }
            }
        )
        .signInWithAppleButtonStyle(
            colorScheme == .dark ? .white : .black
        )
        .frame(width: 280, height: 45)
//        VStack {
//            TextField("이메일", text: Binding(
//                get: { loginViewModel.state.email },
//                set: { loginViewModel.send(action: .updateEmail($0)) }
//            ))
//            .textFieldStyle(RoundedBorderTextFieldStyle())
//            .padding()
//            
//            SecureField("비밀번호", text: Binding(
//                get: { loginViewModel.state.password },
//                set: { loginViewModel.send(action: .updatePassword($0)) }
//            ))
//            .textFieldStyle(RoundedBorderTextFieldStyle())
//            .padding()
//            
//            Button("로그인") {
//                loginViewModel.send(action: .login)
//            }
//            .buttonStyle(PlainButtonStyle())
//        }
//        .padding()
    }
}

#Preview {
    LoginView()
}
