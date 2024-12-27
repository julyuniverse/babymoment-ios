//
//  ErrorManager.swift
//  BabyMoment
//
//  Created by July universe on 11/16/24.
//

import SwiftUI
import Combine

final class ErrorManager: ObservableObject {
    static let shared = ErrorManager()
    private init() {}

    @Published var errorMessage: AlertMessage? = nil

    func showError(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = AlertMessage(message: message)
        }
    }

    func clearError() {
        DispatchQueue.main.async {
            self.errorMessage = nil
        }
    }
}
