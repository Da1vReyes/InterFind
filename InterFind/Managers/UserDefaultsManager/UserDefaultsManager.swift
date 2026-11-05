//
//  UserDefaultsManager.swift
//  InterFind
//
//  Created by Alex Diaz on 16/11/24.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private init() { }
    
    func save(_ value: String, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func get(forKey key: String) -> String? {
        UserDefaults.standard.string(forKey: key)
    }
    
    func delete(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func setLoginDate() {
        UserDefaults.standard.set(Date(), forKey: "loginDate")
    }
    
    func getLoginDate() -> Date? {
        UserDefaults.standard.object(forKey: "loginDate") as? Date
    }
}
