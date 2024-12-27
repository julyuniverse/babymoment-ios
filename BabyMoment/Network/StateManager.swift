//
//  StateManager.swift
//  BabyMoment
//
//  Created by July universe on 11/16/24.
//

import SwiftUI
import Combine

final class StateManager: ObservableObject {
    static let shared = StateManager()
    private init() {}

    @Published var stateMessage: AlertMessage? = nil

    func showState(_ message: String) {
        DispatchQueue.main.async {
            self.stateMessage = AlertMessage(message: message)
        }
    }

    func clearState() {
        DispatchQueue.main.async {
            self.stateMessage = nil
        }
    }
}
