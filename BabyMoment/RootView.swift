//
//  RootView.swift
//  BabyMoment
//
//  Created by July universe on 10/27/24.
//

import SwiftUI

struct RootView: View {
    @StateObject var loginViewModel: LoginViewModel = LoginViewModel()
    @StateObject private var errorManager = ErrorManager.shared
    @StateObject private var stateManager = StateManager.shared
    
    var body: some View {
        VStack {
            if loginViewModel.isCheckingLoginStatus {
                ProgressView()
            } else {
                MainView()
                    .environmentObject(loginViewModel)
                    .fullScreenCover(isPresented: $loginViewModel.showLoginView) {
                        NavigationView {
                            LoginView()
                                .environmentObject(loginViewModel)
                        }
                    }
//                    .fullScreenCover(isPresented: $loginViewModel.showBabyCreationView) {
//                        NavigationView {
//                            BabyCreationView()
//                                .environmentObject(loginViewModel)
//                        }
//                    }
                    .fullScreenCover(isPresented: $loginViewModel.showBabiesView) {
                        NavigationView {
                            BabiesView()
                                .environmentObject(loginViewModel)
                        }
                    }
                    .alert(item: $errorManager.errorMessage) { alertMessage in
                        Alert(
                            title: Text("Error"),
                            message: Text(alertMessage.message),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    .alert(item: $stateManager.stateMessage) { alertMessage in
                        Alert(
                            title: Text("Notice"),
                            message: Text(alertMessage.message),
                            dismissButton: .default(Text("OK"))
                        )
                    }
            }
        }
        .onAppear {
            print("RootView onAppear")
            Task {
                await loginViewModel.uuidLogin()
            }
        }
    }
}

#Preview {
    RootView()
}
