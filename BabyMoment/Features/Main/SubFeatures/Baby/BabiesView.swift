//
//  BabiesView.swift
//  BabyMoment
//
//  Created by July universe on 12/23/24.
//

import SwiftUI
import SwiftData

struct BabiesView: View {
    @StateObject var babyViewModel: BabyViewModel = BabyViewModel(babyRepository: .shared)
    @Query private var babies: [Baby]
    
    var body: some View {
        VStack {
            Button("getPosts1") {
                Task {
                    await babyViewModel.getPosts1()
                }
            }
            Button("getPosts2") {
                Task {
                    await babyViewModel.getPosts2()
                }
            }
            Button("Create Baby") {
                babyViewModel.showBabyCreationView = true
            }
            VStack {
                Text("Babies")
            }
            List {
                ForEach(babies) { baby in
                    Text("Name: \(baby.name)")
                }
            }
        }
        .fullScreenCover(isPresented: $babyViewModel.showBabyCreationView) {
            BabyCreationView()
                .environmentObject(babyViewModel)
        }
    }
}

#Preview {
    BabiesView()
}
