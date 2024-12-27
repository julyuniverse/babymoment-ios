//
//  BabyCreationView.swift
//  BabyMoment
//
//  Created by July universe on 12/23/24.
//

import SwiftUI

struct BabyCreationView: View {
    @Environment(\.dismiss) private var dismiss
    @State var babyState: BabyState = .init()
    @EnvironmentObject var babyViewModel: BabyViewModel

    var body: some View {
        VStack {
            Button("close") { dismiss() }
            HStack {
                Text("name")
                Spacer()
            }
            TextField("name", text: $babyState.name)
                .textInputAutocapitalization(.never) // 첫 글자 자동 대문자 비활성화
                .disableAutocorrection(true) // 자동 맞춤법 비활성화
            Button("create") {
                Task {
                    await babyViewModel.createBaby(baby: babyState)
                }
            }
        }
    }
}

#Preview {
    BabyCreationView()
}
