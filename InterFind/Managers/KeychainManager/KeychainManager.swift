//
//  KeychainManager.swift
//  InterFind
//
//  Created by Alex Diaz on 16/11/24.
//

import Foundation

class KeychainManager {
    
    enum KeychainError: Error {
        case itemNotFound
        case unknownError(OSStatus)
    }
    
    // MARK: - Save
    static func save(service: String, account: String, password: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: password as AnyObject,
        ]
        
        // Try to add the item
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            // Update it if it already exists
            let attributesToUpdate: [String: AnyObject] = [
                kSecValueData as String: password as AnyObject
            ]
            let searchQuery: [String: AnyObject] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service as AnyObject,
                kSecAttrAccount as String: account as AnyObject
            ]
            let updateStatus = SecItemUpdate(searchQuery as CFDictionary, attributesToUpdate as CFDictionary)
            
            guard updateStatus == errSecSuccess else {
                throw KeychainError.unknownError(updateStatus)
            }
        } else if status != errSecSuccess {
            throw KeychainError.unknownError(status)
        }
    }
    
    // MARK: - Get
    static func get(service: String, account: String) -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            print("Keychain read failed: \(status)")
            return nil
        }
        
        return result as? Data
    }
    
    // MARK: - Delete
    static func delete(service: String, account: String) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknownError(status)
        }
    }
}
