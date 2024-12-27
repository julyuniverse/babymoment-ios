//
//  MainView.swift
//  BabyMoment
//
//  Created by July universe on 10/27/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        TabView {
            Tab("활동", systemImage: "flame.fill") {
                ActivityView()
            }
            .badge(2)
            Tab("패턴", systemImage: "square.grid.2x2.fill") {
                PatternView()
            }
            .badge(2)
            Tab("설정", systemImage: "gearshape.fill") {
                SettingsView()
            }
            .badge(2)
        }
        .opacity(loginViewModel.isLoggedIn && loginViewModel.hasBaby ? 1 : 0) // 로그인되지 않으면 투명하게 설정
//        .overlay(
//            Group {
//                if loginViewModel.state.isLoggedIn {
//                    Button(action: {
//                        loginViewModel.send(action: .logout)
//                    }) {
//                        Text("로그아웃")
//                            .foregroundColor(.blue)
//                    }
//                    .padding()
//                }
//            },
//            alignment: .topTrailing
//        )
        .onAppear {
            print("MainView onAppear")
        }
    }
}

#Preview {
    MainView()
}
