//
//  BabyViewModel.swift
//  BabyMoment
//
//  Created by July universe on 12/23/24.
//

import Foundation

class BabyViewModel: ObservableObject {
    private let babyRepository: BabyRepository
    @Published var showBabyCreationView: Bool = false
    
    init(babyRepository: BabyRepository) {
        self.babyRepository = babyRepository
    }
    
    @MainActor
    func getPosts1() async {
        do {
            let response = try await NetworkManager.shared.request(endpoint: .getPosts1, responseType: PostResponse.self)
            print("getPosts1 response: \(response)")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func getPosts2() async {
        do {
            let response = try await NetworkManager.shared.request(endpoint: .getPosts1, responseType: PostResponse.self)
            print("getPosts2 response: \(response)")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createBaby(baby: BabyState) async {
        do {
            let babyCreationRequest = BabyCreationRequest(name: baby.name, gender: "M", bloodType: "A", relationshipType: "DAD")
            print(babyCreationRequest)
            let response = try await NetworkManager.shared.request(endpoint: .CREATE_BABY, parameters: babyCreationRequest, responseType: BabyResponse.self)
            let babyDto = response.baby
            let baby = Baby(babyId: babyDto.babyId, name: babyDto.name)
            babyRepository.addBaby(baby)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}
