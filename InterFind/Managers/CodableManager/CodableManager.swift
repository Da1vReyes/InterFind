//
//  CodableManager.swift
//  InterFind
//
//  Created by Alex Diaz on 9/11/24.
//  InterFind: now reads and writes local data through LocalStore.
//

import Foundation

final class CodableManager {

    private let store: LocalStore

    init(store: LocalStore = .shared) {
        self.store = store
    }

    func parseDataToInternships() async -> [InternshipModel] {
        store.loadInternships()
    }

    func parseLoginData(email: String, password: String) async -> LoginResponse? {
        do {
            return try store.login(email: email, password: password)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func parseSignUpData(name: String, email: String, password: String) async throws -> LoginResponse? {
        try store.register(name: name, email: email, password: password)
    }
}
