//
//  LoginController.swift
//  InterFind
//
//  Created by Alex Diaz on 15/11/24.
//

import Foundation

class LoginController {
    
    let codableManager: CodableManager
    
    init(codableManager: CodableManager = CodableManager()) {
        self.codableManager = codableManager
    }
    
    func login(email: String, password: String) async -> Bool {
        
        let loginResponse = await codableManager.parseLoginData(email: email, password: password)
        guard loginResponse != nil else { return false }
        do {
            
            guard let token = loginResponse?.token.data(using: .utf8) else { return false }
            
            // Guardando el token en el KeyChainManager y guardando la fecha actual para luego poder compararla.
            try KeychainManager.save(service: Constants.keychainService, account: email, password: token)
            UserDefaultsManager.shared.setLoginDate()
            guard let user = loginResponse?.user else { throw  DecoderError.invalidUserInfo }
            UserDefaultsManager.shared.save(user.name, forKey: "name")
            UserDefaultsManager.shared.save(user.email, forKey: "email")
            UserDefaultsManager.shared.save(user.id, forKey: "id")
            return true
        } catch {
            print(error)
        }
        return false
    }
    
    func signUp(name: String, email: String, password: String) async -> (Bool, Error?) {
        
        
        do {
            let signUpResponse = try await codableManager.parseSignUpData(name: name, email: email, password: password)
            guard signUpResponse != nil else { throw LocalStoreError.invalidCredentials }
            guard let token = signUpResponse?.token.data(using: .utf8) else { throw LocalStoreError.invalidCredentials }
            
            // Guardando el token en el KeyChainManager y guardando la fecha actual para luego poder compararla.
            try KeychainManager.save(service: Constants.keychainService, account: email, password: token)
            UserDefaultsManager.shared.setLoginDate()
            guard let user = signUpResponse?.user else { throw  DecoderError.invalidUserInfo }
            UserDefaultsManager.shared.save(user.name, forKey: "name")
            UserDefaultsManager.shared.save(user.email, forKey: "email")
            UserDefaultsManager.shared.save(user.id, forKey: "id")
            return (true, nil)
        } catch LocalStoreError.emailAlreadyExists {
            return (false, LocalStoreError.emailAlreadyExists)
        } catch {
            print(error)
            return (false, error)
        }
        
    }
    
    static func isLoggedIn() -> Bool {
        guard let account = UserDefaultsManager.shared.get(forKey: "email") else { return false }
        guard let _ = KeychainManager.get(service: Constants.keychainService, account: account) else { return false }
        guard let loginDate = UserDefaultsManager.shared.getLoginDate() else { return false }
        //  revisar si el usuario lleva un mes o mas registrado para mandarlo al login. 
        return Date().timeIntervalSince(loginDate) < 2_592_000
    }
    
    static func getUser() -> User? {
    
        guard let name = UserDefaultsManager.shared.get(forKey: "name") else { return nil }
        guard let email = UserDefaultsManager.shared.get(forKey: "email") else { return nil }
        guard let id = UserDefaultsManager.shared.get(forKey: "id") else { return nil }
        
           
        return User(id: id, name: name, email: email)
    }
}
